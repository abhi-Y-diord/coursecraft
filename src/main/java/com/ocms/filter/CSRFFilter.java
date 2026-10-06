package com.ocms.filter;

import com.ocms.util.CSRFUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class CSRFFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Always generate / refresh token so ${sessionScope.csrfToken} is available in JSPs
        CSRFUtil.getToken(request);

        String method = request.getMethod();
        if ("POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method)) {
            String path = request.getRequestURI().substring(request.getContextPath().length());
            // Allow login & register with or without token (handled in LoginServlet)
            if (!path.equals("/login") && !path.equals("/register")) {
                if (!CSRFUtil.validateToken(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token.");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }
}
