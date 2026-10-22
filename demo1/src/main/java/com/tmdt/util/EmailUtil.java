package com.tmdt.util;

import com.tmdt.config.MailConfig;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Sends auth emails asynchronously (1 thread) so mail failures never block
 * or break registration / reset flows. When mail.enabled=false the links are
 * ONLY logged, prefixed with "DEV ONLY" — never send real SMTP in dev mode.
 * Call shutdown() from the ServletContextListener.
 */
public final class EmailUtil {

    private static final Logger LOG = LoggerFactory.getLogger(EmailUtil.class);

    private static final ExecutorService EXECUTOR = Executors.newSingleThreadExecutor(r -> {
        Thread t = new Thread(r, "mail-sender");
        t.setDaemon(true);
        return t;
    });

    private EmailUtil() {
    }

    /** EMAIL_VERIFICATION: link valid 24h. */
    public static void sendVerificationEmail(String toEmail, String fullName, String verifyLink) {
        Map<String, String> model = new LinkedHashMap<>();
        model.put("title", "Xác minh email PrintKraft");
        model.put("heading", "Xác minh email của bạn");
        model.put("intro", "Chào " + escape(fullName) + ", hãy xác minh email để kích hoạt tài khoản PrintKraft.");
        model.put("ctaText", "Xác minh ngay");
        model.put("expiry", "Liên kết có hiệu lực trong <b>24 giờ</b>. Nếu hết hạn, hãy đăng nhập và yêu cầu gửi lại email xác minh.");
        sendAsync("Xác minh email PrintKraft", toEmail, verifyLink, model);
    }

    /** PASSWORD_RESET: link valid 30 minutes (matches the UI copy). */
    public static void sendPasswordResetEmail(String toEmail, String fullName, String resetLink) {
        Map<String, String> model = new LinkedHashMap<>();
        model.put("title", "Đặt lại mật khẩu PrintKraft");
        model.put("heading", "Đặt lại mật khẩu của bạn");
        model.put("intro", "Chào " + escape(fullName) + ", chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản này.");
        model.put("ctaText", "Đặt lại mật khẩu");
        model.put("expiry", "Liên kết có hiệu lực trong <b>30 phút</b>. Nếu bạn không yêu cầu, hãy bỏ qua email này.");
        sendAsync("Đặt lại mật khẩu PrintKraft", toEmail, resetLink, model);
    }

    private static void sendAsync(String subject, String toEmail, String link, Map<String, String> model) {
        EXECUTOR.execute(() -> {
            try {
                MailConfig cfg = MailConfig.get();
                if (!cfg.mailEnabled) {
                    // The ONLY place allowed to log token-bearing links. Tagged DEV ONLY.
                    LOG.warn("DEV ONLY - Mail disabled. {} | to: {} | link: {}", subject, toEmail, link);
                    return;
                }
                send(subject, toEmail, link, model, cfg);
                LOG.info("Mail sent: '{}' to {}", subject, toEmail);
            } catch (Exception e) {
                // Registration/reset must not fail because of mail problems.
                LOG.error("Failed to send mail '{}' to {}", subject, toEmail, e);
            }
        });
    }

    private static void send(String subject, String toEmail, String link, Map<String, String> model, MailConfig cfg)
            throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", cfg.smtpHost);
        props.put("mail.smtp.port", cfg.smtpPort);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(cfg.smtpUsername, cfg.smtpPassword);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(cfg.fromAddress, false));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail, false));
        message.setSubject(subject, "UTF-8");

        String text = model.get("intro") + "\n\n" + link + "\n\nLiên kết có thời hạn như mô tả trong email HTML.";
        String html = buildHtml(model, link, cfg);

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(text, "UTF-8");
        MimeBodyPart htmlPart = new MimeBodyPart();
        htmlPart.setContent(html, "text/html; charset=UTF-8");

        Multipart multipart = new MimeMultipart("alternative");
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(htmlPart);
        message.setContent(multipart);
        Transport.send(message);
    }

    private static String buildHtml(Map<String, String> model, String link, MailConfig cfg) {
        return "<div style=\"font-family:Arial,sans-serif;max-width:520px;margin:0 auto\">"
                + "<h2 style=\"color:#111\">" + model.get("heading") + "</h2>"
                + "<p style=\"color:#333\">" + model.get("intro") + "</p>"
                + "<p><a href=\"" + link + "\" style=\"display:inline-block;background:#111;color:#fff;"
                + "padding:12px 24px;border-radius:8px;text-decoration:none\">" + model.get("ctaText") + "</a></p>"
                + "<p style=\"color:#666;font-size:13px\">" + link.replace("&", "&amp;") + "</p>"
                + "<p style=\"color:#666;font-size:13px\">" + model.get("expiry") + "</p>"
                + "<p style=\"color:#999;font-size:12px\">PrintKraft — " + cfg.fromName + "</p>"
                + "</div>";
    }

    private static String escape(String s) {
        return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    /** Graceful stop; called from AppContextListener.contextDestroyed. */
    public static void shutdown() {
        EXECUTOR.shutdown();
        try {
            EXECUTOR.awaitTermination(5, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
