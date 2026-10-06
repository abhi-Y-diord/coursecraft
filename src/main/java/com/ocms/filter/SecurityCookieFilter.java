package com.ocms.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

import java.io.IOException;

@WebFilter("/*")
public class SecurityCookieFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        boolean isSecure = request.isSecure() || "https".equalsIgnoreCase(request.getHeader("X-Forwarded-Proto"));

        HttpServletResponseWrapper responseWrapper = new HttpServletResponseWrapper(response) {
            @Override
            public void addHeader(String name, String value) {
                if ("Set-Cookie".equalsIgnoreCase(name)) {
                    value = formatCookie(value, isSecure);
                }
                super.addHeader(name, value);
            }

            @Override
            public void setHeader(String name, String value) {
                if ("Set-Cookie".equalsIgnoreCase(name)) {
                    value = formatCookie(value, isSecure);
                }
                super.setHeader(name, value);
            }
        };

        chain.doFilter(request, responseWrapper);
    }

    private String formatCookie(String cookieHeader, boolean isSecure) {
        if (cookieHeader == null) return cookieHeader;
        if (!cookieHeader.toLowerCase().contains("httponly")) {
            cookieHeader += "; HttpOnly";
        }
        if (!cookieHeader.toLowerCase().contains("samesite")) {
            cookieHeader += "; SameSite=Lax";
        }
        if (isSecure && !cookieHeader.toLowerCase().contains("secure")) {
            cookieHeader += "; Secure";
        }
        return cookieHeader;
    }
}
