package com.tmdt.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final HikariDataSource dataSource;

    static {
        Properties props = new Properties();
        try (InputStream in = DBConnection.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (in == null) {
                throw new IllegalStateException("Không tìm thấy db.properties trong src/main/resources");
            }
            props.load(in);
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }

        String host = props.getProperty("db.host", "localhost");
        String port = props.getProperty("db.port", "3306");
        String name = props.getProperty("db.name");
        String option = props.getProperty("db.option", "");

        String url = "jdbc:mysql://" + host + ":" + port + "/" + name
                + (option.isBlank() ? "" : "?" + option);

        HikariConfig config = new HikariConfig();
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setJdbcUrl(url);
        config.setUsername(props.getProperty("db.username", "root"));
        config.setPassword(props.getProperty("db.password", ""));
        config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.maxSize", "10")));
        config.setMinimumIdle(Integer.parseInt(props.getProperty("db.pool.minIdle", "2")));

        config.setPoolName("PrintKraftPool");
        // Fail fast: chờ tối đa 3s rồi báo lỗi thay vì treo request 30s khi DB chết.
        config.setConnectionTimeout(3_000);
        config.setValidationTimeout(1_500);
        config.setIdleTimeout(600_000);          // 10 phút
        // Phải nhỏ hơn wait_timeout của MySQL (mặc định 8h), nếu không sẽ gặp
        // "Communications link failure" khi MySQL đóng connection trước pool.
        config.setMaxLifetime(1_800_000);        // 30 phút
        // CHỈ dùng khi dev: connection giữ > 20s sẽ bị log kèm stack trace.
        // Đặt về 0 khi chạy thật để tránh log giả khi tải cao.
        config.setLeakDetectionThreshold(20_000);

        // Tái sử dụng PreparedStatement ở tầng driver.
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("rewriteBatchedStatements", "true");

        dataSource = new HikariDataSource(config);
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /** Gọi khi ứng dụng dừng (ví dụ trong ServletContextListener). */
    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}