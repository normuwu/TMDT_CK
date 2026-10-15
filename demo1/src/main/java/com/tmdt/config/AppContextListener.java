package com.tmdt.config;

import com.tmdt.util.DBConnection;
import com.tmdt.util.EmailUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Closes the HikariCP pool and the mail executor when the app stops
 * (Tomcat shutdown / redeploy) so no threads or connections leak.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger LOG = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        EmailUtil.shutdown();
        DBConnection.close();
        LOG.info("Application resources closed (mail executor, HikariCP)");
    }
}
