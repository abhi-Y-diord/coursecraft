package com.ocms.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.UUID;

public class CSRFUtil {
    private static final String CSRF_TOKEN_ATTR = "csrfToken";

    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (token == null) {
            token = UUID.randomUUID().toString();
            session.setAttribute(CSRF_TOKEN_ATTR, token);
        }
        return token;
    }

    public static boolean validateToken(HttpServletRequest request) {
        String requestToken = request.getParameter("csrfToken");
        if (requestToken == null || requestToken.isBlank()) {
            requestToken = request.getHeader("X-CSRF-Token");
        }
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
