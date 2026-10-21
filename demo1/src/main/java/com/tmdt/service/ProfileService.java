package com.tmdt.service;

import com.tmdt.dao.UserDAO;
import com.tmdt.model.User;
import com.tmdt.util.DBConnection;
import com.tmdt.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Business logic for editing the logged-in user's own profile.
 * Only full name, phone and default address can be changed here
 * (email / role / status / verification are never touched).
 */
public final class ProfileService {

    private static final Logger LOG = LoggerFactory.getLogger(ProfileService.class);
    private static final UserDAO USER_DAO = new UserDAO();

    public static final String MSG_SAVED = "Đã lưu thay đổi.";
    private static final String MSG_PHONE_TAKEN = "Số điện thoại này đã được sử dụng cho một tài khoản khác.";
    private static final int MAX_ADDRESS_LENGTH = 300; // users.default_address is VARCHAR(300)

    public enum UpdateStatus { SUCCESS, VALIDATION_ERROR, NOT_FOUND, SYSTEM_ERROR }

    /** `user` is the updated user on SUCCESS, null otherwise. */
    public record UpdateOutcome(UpdateStatus status, Map<String, String> fieldErrors, User user) {
    }

    /** Returns the user, or null when it no longer exists. */
    public User load(int userId) throws SQLException {
        return USER_DAO.findById(userId).orElse(null);
    }

    public UpdateOutcome update(int userId, String fullName, String phone, String defaultAddress) {
        Map<String, String> errors = new LinkedHashMap<>();

        String name = fullName == null ? null : fullName.trim();
        String normPhone = ValidationUtil.normalizePhone(phone);
        String address = defaultAddress == null ? "" : defaultAddress.trim();

        if (!ValidationUtil.isValidFullName(name)) {
            errors.put("fullName", "Vui lòng nhập họ và tên (tối đa 100 ký tự).");
        }
        if (!ValidationUtil.isValidVnPhone(normPhone)) {
            errors.put("phone", "Số điện thoại chưa hợp lệ (10 số, bắt đầu bằng 0, ví dụ 0901234567).");
        }
        if (address.length() > MAX_ADDRESS_LENGTH) {
            errors.put("defaultAddress", "Địa chỉ tối đa " + MAX_ADDRESS_LENGTH + " ký tự.");
        }
        if (!errors.isEmpty()) {
            return new UpdateOutcome(UpdateStatus.VALIDATION_ERROR, errors, null);
        }

        String addressOrNull = address.isEmpty() ? null : address;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<User> current = USER_DAO.findById(conn, userId);
                if (current.isEmpty()) {
                    conn.rollback();
                    return new UpdateOutcome(UpdateStatus.NOT_FOUND, Map.of(), null);
                }

                // users.phone has no UNIQUE constraint yet: best-effort duplicate check.
                Optional<User> owner = USER_DAO.findByPhone(conn, normPhone);
                if (owner.isPresent() && owner.get().getUserId() != userId) {
                    conn.rollback();
                    errors.put("phone", MSG_PHONE_TAKEN);
                    return new UpdateOutcome(UpdateStatus.VALIDATION_ERROR, errors, null);
                }

                USER_DAO.updateProfile(conn, userId, name, normPhone, addressOrNull);
                conn.commit();

                User user = current.get();
                user.setFullName(name);
                user.setPhone(normPhone);
                user.setDefaultAddress(addressOrNull);
                LOG.info("Profile updated userId={}", userId);
                return new UpdateOutcome(UpdateStatus.SUCCESS, Map.of(), user);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            // Only possible once a UNIQUE index exists on phone.
            LOG.debug("Duplicate key while updating profile: {}", e.getMessage());
            errors.put("phone", MSG_PHONE_TAKEN);
            return new UpdateOutcome(UpdateStatus.VALIDATION_ERROR, errors, null);
        } catch (SQLException e) {
            LOG.error("Profile update DB failure userId={}", userId, e);
            return new UpdateOutcome(UpdateStatus.SYSTEM_ERROR, Map.of(), null);
        }
    }
}
