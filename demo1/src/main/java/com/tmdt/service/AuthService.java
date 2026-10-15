package com.tmdt.service;

import com.tmdt.config.MailConfig;
import com.tmdt.dao.UserDAO;
import com.tmdt.dao.UserTokenDAO;
import com.tmdt.model.TokenType;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;
import com.tmdt.model.UserToken;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.util.DBConnection;
import com.tmdt.util.EmailUtil;
import com.tmdt.util.LoginRateLimiter;
import com.tmdt.util.PasswordUtil;
import com.tmdt.util.TokenUtil;
import com.tmdt.util.ValidationUtil;
import com.tmdt.util.Views;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * All AUTH business logic. Servlets only parse requests / build responses.
 * Database rule: user + token creation happens inside ONE transaction
 * (connection handed to the DAOs; the service owns commit/rollback).
 * User-visible messages are in Vietnamese; logs stay in English and never
 * contain passwords or raw tokens.
 */
public final class AuthService {

    private static final Logger LOG = LoggerFactory.getLogger(AuthService.class);

    private static final UserDAO USER_DAO = new UserDAO();
    private static final UserTokenDAO TOKEN_DAO = new UserTokenDAO();

    /** Shared per-key cooldown store (resend verification, forgot password). */
    private static final class CooldownMap {
        private final long cooldownMs;
        private final ConcurrentHashMap<String, Long> lastAttempt = new ConcurrentHashMap<>();

        private CooldownMap(long cooldownMs) {
            this.cooldownMs = cooldownMs;
        }

        /** Returns false when the key is still cooling down. */
        private boolean tryAcquire(String key) {
            long now = System.currentTimeMillis();
            Long last = lastAttempt.get(key);
            if (last != null && now - last < cooldownMs) {
                return false;
            }
            lastAttempt.put(key, now);
            return true;
        }

        private void prune() {
            long threshold = System.currentTimeMillis() - 10 * cooldownMs;
            Iterator<Map.Entry<String, Long>> it = lastAttempt.entrySet().iterator();
            while (it.hasNext()) {
                if (it.next().getValue() < threshold) {
                    it.remove();
                }
            }
        }
    }

    private static final CooldownMap RESEND_COOLDOWN = new CooldownMap(60_000L);
    private static final CooldownMap RESET_COOLDOWN = new CooldownMap(60_000L);

    // Messages used by several flows keep a single source of truth.
    public static final String MSG_REGISTER_SUCCESS =
            "Đã tạo tài khoản. Kiểm tra email để xác minh.";
    public static final String MSG_RESEND_GENERIC =
            "Nếu tài khoản tồn tại và chưa xác minh, chúng tôi vừa gửi lại email xác minh.";
    public static final String MSG_RESET_SUCCESS =
            "Đặt lại mật khẩu thành công. Vui lòng đăng nhập.";
    private static final String MSG_EMAIL_TAKEN =
            "Email này đã được sử dụng cho một tài khoản khác.";

    /** Stateless service: safe to create per servlet, all state is static. */
    public AuthService() {
    }

    // ------------------------------------------------------------------
    // Registration
    // ------------------------------------------------------------------

    public record RegisterOutcome(boolean success, Map<String, String> fieldErrors) {
    }

    public RegisterOutcome register(String fullName, String email, String phone,
                                    String password, String confirmPassword, boolean agreeTerms) {
        Map<String, String> errors = new LinkedHashMap<>();

        String normEmail = ValidationUtil.normalizeEmail(email);
        String normPhone = ValidationUtil.normalizePhone(phone);

        if (!ValidationUtil.isValidFullName(fullName)) {
            errors.put("fullName", "Vui lòng nhập họ và tên (tối đa 100 ký tự).");
        }
        if (!ValidationUtil.isValidEmail(normEmail)) {
            errors.put("email", "Email chưa đúng định dạng.");
        }
        if (!ValidationUtil.isValidVnPhone(normPhone)) {
            errors.put("phone", "Số điện thoại chưa hợp lệ (10 số, bắt đầu bằng 0, ví dụ 0901234567).");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            errors.put("password", "Mật khẩu tối thiểu 8 ký tự (tối đa 72 bytes).");
        }
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            errors.put("confirmPassword", "Mật khẩu nhập lại không khớp.");
        }
        if (!agreeTerms) {
            errors.put("agreeTerms", "Bạn cần đồng ý với Điều khoản sử dụng để tiếp tục.");
        }
        if (!errors.isEmpty()) {
            return new RegisterOutcome(false, errors);
        }

        // Duplicate pre-checks inside the same transaction as the insert.
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                if (!USER_DAO.findByEmail(conn, normEmail).isEmpty()) {
                    errors.put("email", MSG_EMAIL_TAKEN);
                } else if (normPhone != null && !USER_DAO.findByPhone(conn, normPhone).isEmpty()) {
                    // phone has no UNIQUE constraint yet; best-effort check.
                    errors.put("phone", "Số điện thoại này đã được sử dụng cho một tài khoản khác.");
                }
                if (!errors.isEmpty()) {
                    conn.rollback();
                    return new RegisterOutcome(false, errors);
                }

                User user = new User();
                user.setEmail(normEmail);
                user.setPasswordHash(PasswordUtil.hash(password));
                user.setFullName(fullName.trim());
                user.setPhone(normPhone);
                user.setRole(Role.CUSTOMER);
                user.setEmailVerified(false);   // must verify the email first
                user.setStatus(UserStatus.ACTIVE);
                USER_DAO.insert(conn, user);

                String rawToken = TokenUtil.generateRawToken();
                String tokenHash = TokenUtil.sha256Hex(rawToken);
                UserToken token = new UserToken();
                token.setUserId(user.getUserId());
                token.setTokenCode(tokenHash);
                token.setTokenType(TokenType.EMAIL_VERIFICATION);
                token.setExpiresAt(LocalDateTime.now().plus(TokenType.EMAIL_VERIFICATION.ttl()));
                TOKEN_DAO.insert(conn, token);

                conn.commit();

                String link = MailConfig.get().baseUrl
                        + Views.VERIFY_EMAIL_URL + "?token=" + rawToken;
                EmailUtil.sendVerificationEmail(normEmail, user.getFullName(), link);

                LOG.info("User registered and verification email queued (not sending failure breaks the registration) userId={}", user.getUserId());
                return new RegisterOutcome(true, Map.of());
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            // Error 1062 — the UNIQUE index currently lives on email; return
            // the same duplicate message as the pre-check (anti-enumeration).
            LOG.debug("Duplicate key while registering: {}", e.getMessage());
            errors.put("email", MSG_EMAIL_TAKEN);
            return new RegisterOutcome(false, errors);
        } catch (SQLException e) {
            LOG.error("Registration DB failure", e);
            // "system" is not a real field: RegisterServlet shows it as the
            // general banner (request attribute "error"), not next to a field.
            errors.put("system", "Hệ thống bận, vui lòng thử lại sau.");
            return new RegisterOutcome(false, errors);
        }
    }

    // ------------------------------------------------------------------
    // Login (POST /login) — identifier is EMAIL ONLY in this phase
    // (phone login was dropped by user decision; may be added later)
    // ------------------------------------------------------------------

    public enum LoginStatus { THROTTLED, WRONG_CREDENTIALS, LOCKED, NOT_VERIFIED, SUCCESS }

    public record LoginOutcome(LoginStatus status, SessionUser user) {
    }

    /** Compared against when the account does not exist, so the response
     *  time does not reveal whether an account is registered. */
    private static final String DUMMY_BCRYPT_HASH = PasswordUtil.hash("printkraft-dummy-password");

    /**
     * @param throttleKey identifier|IP key used by the brute-force limiter
     */
    public LoginOutcome login(String identifier, String password, String throttleKey) {
        if (throttleKey != null && LoginRateLimiter.isBlocked(throttleKey)) {
            return new LoginOutcome(LoginStatus.THROTTLED, null);
        }

        String email = ValidationUtil.normalizeEmail(identifier);
        if (email == null || email.isBlank()
                || password == null || password.isBlank()) {
            return new LoginOutcome(LoginStatus.WRONG_CREDENTIALS, null);
        }

        try {
            Optional<User> found = USER_DAO.findByEmail(email);
            if (found.isEmpty()) {
                // Burn the same bcrypt work to keep timing identical.
                PasswordUtil.verify(password, DUMMY_BCRYPT_HASH);
                LoginRateLimiter.recordFailure(throttleKey);
                return new LoginOutcome(LoginStatus.WRONG_CREDENTIALS, null);
            }
            User user = found.get();

            if (!PasswordUtil.verify(password, user.getPasswordHash())) {
                LoginRateLimiter.recordFailure(throttleKey);
                return new LoginOutcome(LoginStatus.WRONG_CREDENTIALS, null);
            }

            // Password is correct — only NOW check the account state so the
            // error messages do not leak which accounts exist.
            if (user.getStatus() == UserStatus.LOCKED) {
                return new LoginOutcome(LoginStatus.LOCKED, null);
            }
            if (!user.isEmailVerified()) {
                return new LoginOutcome(LoginStatus.NOT_VERIFIED, null);
            }

            LoginRateLimiter.reset(throttleKey);
            SessionUser sessionUser = new SessionUser(
                    user.getUserId(), user.getEmail(), user.getFullName(), user.getRole());
            return new LoginOutcome(LoginStatus.SUCCESS, sessionUser);
        } catch (SQLException e) {
            LOG.error("Login DB failure", e);
            return new LoginOutcome(LoginStatus.WRONG_CREDENTIALS, null);
        }
    }

    // ------------------------------------------------------------------
    // Email verification (GET /verify-email?token=...)
    // ------------------------------------------------------------------

    public record VerifyOutcome(boolean verified) {
    }

    public VerifyOutcome verifyEmail(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            return new VerifyOutcome(false);
        }
        String tokenHash = TokenUtil.sha256Hex(rawToken);
        Optional<UserToken> found;
        try {
            found = TOKEN_DAO.findValidByCode(tokenHash, TokenType.EMAIL_VERIFICATION);
            if (found.isEmpty()) {
                return new VerifyOutcome(false);
            }
            UserToken token = found.get();
            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    TOKEN_DAO.markUsed(conn, token.getTokenId());
                    USER_DAO.setEmailVerified(conn, token.getUserId(), true);
                    conn.commit();
                    LOG.info("Email verified successfully userId={}", token.getUserId());
                    return new VerifyOutcome(true);
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                }
            }
        } catch (SQLException e) {
            LOG.error("Email verification DB failure", e);
            return new VerifyOutcome(false);
        }
    }

    // ------------------------------------------------------------------
    // Resend verification email (POST /resend-verification)
    // ------------------------------------------------------------------

    /** Always handled silently: peripherals outside this class must show only MSG_RESEND_GENERIC. */
    public void resendVerification(String identifier) {
        String email = ValidationUtil.normalizeEmail(identifier);
        if (email == null || email.isBlank()) {
            return; // generic message shown anyway
        }

        RESEND_PRUNE();

        try {
            Optional<User> user = USER_DAO.findByEmail(email);
            if (user.isEmpty() || user.get().isEmailVerified()) {
                return; // nothing to do; message stays generic
            }

            if (!RESEND_COOLDOWN.tryAcquire(email)) {
                LOG.info("Resend cooldown active for a not-yet-verified account");
                return; // silently blocked, per spec
            }

            String rawToken = TokenUtil.generateRawToken();
            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    TOKEN_DAO.invalidateUnused(conn, user.get().getUserId(), TokenType.EMAIL_VERIFICATION);
                    UserToken token = new UserToken();
                    token.setUserId(user.get().getUserId());
                    token.setTokenCode(TokenUtil.sha256Hex(rawToken));
                    token.setTokenType(TokenType.EMAIL_VERIFICATION);
                    token.setExpiresAt(LocalDateTime.now().plus(TokenType.EMAIL_VERIFICATION.ttl()));
                    TOKEN_DAO.insert(conn, token);
                    conn.commit();
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                }
            }

            String link = MailConfig.get().baseUrl
                    + Views.VERIFY_EMAIL_URL + "?token=" + rawToken;
            EmailUtil.sendVerificationEmail(email, user.get().getFullName(), link);
            LOG.info("Resent verification email for a not-yet-verified account");
        } catch (SQLException e) {
            LOG.error("Resend verification DB failure", e);
            // user still sees MSG_RESEND_GENERIC from the servlet
        }
    }

    // ------------------------------------------------------------------
    // Remember me (phase 6) — cookie carries the RAW token, DB the hash
    // ------------------------------------------------------------------

    public record AutoLoginResult(SessionUser user, String newRawToken) {
    }

    /**
     * Called right after a successful login when "remember" was checked.
     * Invalidates any old unused REMEMBER_ME token, stores a fresh hash.
     * Returns the raw token for the cookie, or null when the write failed
     * (login itself is never blocked by remember-me problems).
     */
    public String createRememberToken(int userId) {
        String rawToken = TokenUtil.generateRawToken();
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                TOKEN_DAO.invalidateUnused(conn, userId, TokenType.REMEMBER_ME);
                UserToken token = new UserToken();
                token.setUserId(userId);
                token.setTokenCode(TokenUtil.sha256Hex(rawToken));
                token.setTokenType(TokenType.REMEMBER_ME);
                token.setExpiresAt(LocalDateTime.now().plus(TokenType.REMEMBER_ME.ttl()));
                TOKEN_DAO.insert(conn, token);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.error("Remember-me token creation failed", e);
            return null; // no cookie this time; log in still worked
        }
        return rawToken;
    }

    /**
     * AuthFilter auto-login: validate the remembered raw token (hash lookup),
     * then ROTATE — old token marked used, new token stored, and the new raw
     * token goes back into the refreshed cookie. Only ACTIVE + verified users
     * are auto-logged in; anything else clears the claim silently.
     */
    public Optional<AutoLoginResult> loginWithRememberToken(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            return Optional.empty();
        }
        try {
            Optional<UserToken> found =
                    TOKEN_DAO.findValidByCode(TokenUtil.sha256Hex(rawToken), TokenType.REMEMBER_ME);
            if (found.isEmpty()) {
                return Optional.empty();
            }
            UserToken old = found.get();

            Optional<User> userOpt = USER_DAO.findById(old.getUserId());
            if (userOpt.isEmpty()
                    || userOpt.get().getStatus() != UserStatus.ACTIVE
                    || !userOpt.get().isEmailVerified()) {
                return Optional.empty();
            }

            String newRawToken = TokenUtil.generateRawToken();
            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    TOKEN_DAO.markUsed(conn, old.getTokenId());
                    UserToken next = new UserToken();
                    next.setUserId(old.getUserId());
                    next.setTokenCode(TokenUtil.sha256Hex(newRawToken));
                    next.setTokenType(TokenType.REMEMBER_ME);
                    next.setExpiresAt(LocalDateTime.now().plus(TokenType.REMEMBER_ME.ttl()));
                    TOKEN_DAO.insert(conn, next);
                    conn.commit();
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                }
            }

            User user = userOpt.get();
            return Optional.of(new AutoLoginResult(
                    new SessionUser(user.getUserId(), user.getEmail(), user.getFullName(), user.getRole()),
                    newRawToken));
        } catch (SQLException e) {
            LOG.error("Remember-me auto-login failed", e);
            return Optional.empty();
        }
    }

    /** Logout / password reset: kill every unused REMEMBER_ME token. */
    public void revokeRememberTokens(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            TOKEN_DAO.invalidateUnused(conn, userId, TokenType.REMEMBER_ME);
        } catch (SQLException e) {
            LOG.error("Remember-me revoke failed", e);
        }
    }

    // ------------------------------------------------------------------
    // Forgot password (POST /forgot-password) — always silent to the user
    // ------------------------------------------------------------------

    /**
     * Kicks off a PASSWORD_RESET flow when the account exists AND is already
     * email-verified (otherwise the owner still sees nothing different).
     * 60s cooldown per email, silently skipped; mail is sent asynchronously.
     */
    public void requestPasswordReset(String identifier) {
        String email = ValidationUtil.normalizeEmail(identifier);
        if (!ValidationUtil.isValidEmail(email)) {
            return; // caller shows the same 'sent' screen regardless
        }
        RESEND_PRUNE();
        try {
            if (!RESET_COOLDOWN.tryAcquire(email)) {
                LOG.info("Password reset cooldown active for an email");
                return; // silently blocked, still 'sent=true' for the user
            }

            Optional<User> found = USER_DAO.findByEmail(email);
            if (found.isEmpty() || !found.get().isEmailVerified()) {
                return;
            }
            User user = found.get();

            String rawToken = TokenUtil.generateRawToken();
            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    TOKEN_DAO.invalidateUnused(conn, user.getUserId(), TokenType.PASSWORD_RESET);
                    UserToken token = new UserToken();
                    token.setUserId(user.getUserId());
                    token.setTokenCode(TokenUtil.sha256Hex(rawToken));
                    token.setTokenType(TokenType.PASSWORD_RESET);
                    token.setExpiresAt(LocalDateTime.now().plus(TokenType.PASSWORD_RESET.ttl()));
                    TOKEN_DAO.insert(conn, token);
                    conn.commit();
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                }
            }

            String link = MailConfig.get().baseUrl
                    + Views.RESET_PASSWORD_URL + "?token=" + rawToken;
            EmailUtil.sendPasswordResetEmail(email, user.getFullName(), link);
            LOG.info("Password reset email queued for a verified account");
        } catch (SQLException e) {
            LOG.error("Forgot password DB failure", e);
        }
    }

    private void RESEND_PRUNE() {
        RESEND_COOLDOWN.prune();
        RESET_COOLDOWN.prune();
    }

    // ------------------------------------------------------------------
    // Reset password (GET/POST /reset-password?token=...)
    // ------------------------------------------------------------------

    public enum ResetStatus { TOKEN_INVALID, VALIDATION_ERROR, SYSTEM_ERROR, SUCCESS }

    public record ResetOutcome(ResetStatus status, Map<String, String> fieldErrors) {
    }

    /** GET: only checks whether the reset form may be shown. */
    public boolean hasValidResetToken(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            return false;
        }
        try {
            return TOKEN_DAO.findValidByCode(TokenUtil.sha256Hex(rawToken), TokenType.PASSWORD_RESET).isPresent();
        } catch (SQLException e) {
            LOG.error("Reset token lookup failure", e);
            return false;
        }
    }

    /**
     * POST: one transaction marks the token used, updates the password hash
     * and kills every REMEMBER_ME token of the user (GĐ 6 will create those).
     */
    public ResetOutcome resetPassword(String rawToken, String newPassword, String confirmNewPassword) {
        if (rawToken == null || rawToken.isBlank()) {
            return new ResetOutcome(ResetStatus.TOKEN_INVALID, Map.of());
        }

        Optional<UserToken> found;
        try {
            found = TOKEN_DAO.findValidByCode(TokenUtil.sha256Hex(rawToken), TokenType.PASSWORD_RESET);
        } catch (SQLException e) {
            LOG.error("Reset password lookup failure", e);
            return new ResetOutcome(ResetStatus.SYSTEM_ERROR, Map.of());
        }
        if (found.isEmpty()) {
            return new ResetOutcome(ResetStatus.TOKEN_INVALID, Map.of());
        }
        UserToken token = found.get();

        Map<String, String> errors = new LinkedHashMap<>();
        if (!ValidationUtil.isValidPassword(newPassword)) {
            errors.put("newPassword", "Mật khẩu tối thiểu 8 ký tự (tối đa 72 bytes).");
        }
        if (confirmNewPassword == null || !confirmNewPassword.equals(newPassword)) {
            errors.put("confirmNewPassword", "Mật khẩu nhập lại không khớp.");
        }
        if (!errors.isEmpty()) {
            return new ResetOutcome(ResetStatus.VALIDATION_ERROR, errors);
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                USER_DAO.updatePasswordHash(conn, token.getUserId(), PasswordUtil.hash(newPassword));
                TOKEN_DAO.markUsed(conn, token.getTokenId());
                TOKEN_DAO.invalidateUnused(conn, token.getUserId(), TokenType.REMEMBER_ME);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.error("Reset password DB failure", e);
            return new ResetOutcome(ResetStatus.SYSTEM_ERROR, Map.of());
        }
        return new ResetOutcome(ResetStatus.SUCCESS, Map.of());
    }
}
