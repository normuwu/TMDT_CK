package com.tmdt.filter;

import com.tmdt.util.TokenUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * CSRF protection. Creates the session token lazily (JSPs read ${csrfToken}).
 * Every POST must carry the same token; mismatch -> 403 with a generic
 * Vietnamese message. Comparison is constant-time.
 * <p>
 * Static resources are skipped so plain asset requests never create sessions:
 * /assets/*, /img/* and the legacy demo folders are excluded here.
 * Ordering is declared in web.xml (after EncodingFilter, before AuthFilter).
 */
public class CsrfFilter implements Filter {

    public static final String PARAM = "csrfToken";

    private static final String HEADER_NAME = "X-Requested-With";
    private static final String[] SKIP_PREFIXES = {"/assets/", "/img/"};

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String path = request.getRequestURI().substring(request.getContextPath().length());

        for (String skip : SKIP_PREFIXES) {
            if (path.startsWith(skip)) {
                chain.doFilter(req, res);
                return;
            }
        }

        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(PARAM);
        if (token == null) {
            token = TokenUtil.generateRawToken();
            session.setAttribute(PARAM, token);
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Same-origin forms carry the token in the form field; AJAX may send
            // it in the X-Requested-With header instead.
            String sentParam = request.getParameter(PARAM);
            String sentHeader = request.getHeader(HEADER_NAME);
            boolean valid = TokenUtil.constantTimeEquals(sentParam, token)
                    || TokenUtil.constantTimeEquals(sentHeader, token);
            if (!valid) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Phiên làm việc đã hết hạn, vui lòng thử lại.");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
