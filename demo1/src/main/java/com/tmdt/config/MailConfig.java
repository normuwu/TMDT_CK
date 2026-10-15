package com.tmdt.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Loads mail.properties from the classpath. Defaults keep the app buildable
 * and runnable without SMTP: mail.enabled=false — verification / reset links
 * are only logged (tagged "DEV ONLY").
 * mail.properties is gitignored; copy mail.properties.example and fill secrets
 * locally. Nothing here is hardcoded per environmen.
 *
 * mail.properties fields: mail.enabled, mail.smtp.host, mail.smtp.port,
 * mail.smtp.username, mail.smtp.password, mail.from, mail.from.name,
 * app.base-url.
 */
public final class MailConfig {

    private static final Properties PROPS = new Properties();

    public final boolean mailEnabled;
    public final String smtpHost;
    public final int smtpPort;
    public final String smtpUsername;
    public final String smtpPassword;
    public final String fromAddress;
    public final String fromName;
    public final String baseUrl;

    private MailConfig(Properties p) {
        this.mailEnabled = Boolean.parseBoolean(p.getProperty("mail.enabled", "false"));
        this.smtpHost = p.getProperty("mail.smtp.host", "smtp.gmail.com");
        this.smtpPort = Integer.parseInt(p.getProperty("mail.smtp.port", "587"));
        this.smtpUsername = p.getProperty("mail.smtp.username", "");
        this.smtpPassword = p.getProperty("mail.smtp.password", "");
        this.fromAddress = p.getProperty("mail.from", "no-reply@printkraft.local");
        this.fromName = p.getProperty("mail.from.name", "PrintKraft");
        this.baseUrl = p.getProperty("app.base-url", "http://localhost:8080/tmdt");
    }

    static {
        try (InputStream in = MailConfig.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (in != null) {
                PROPS.load(in);
            }
            // Missing file is fine: dev-mode defaults apply (no SMTP needed).
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private static volatile MailConfig instance;

    public static MailConfig get() {
        MailConfig local = instance;
        if (local == null) {
            synchronized (MailConfig.class) {
                if (instance == null) {
                    instance = new MailConfig(PROPS);
                }
                local = instance;
            }
        }
        return local;
    }

    private MailConfig() {
        throw new AssertionError();
    }
}
