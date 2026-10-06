package com.ocms.filter;

import com.ocms.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/faculty/*", "/student/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String uri = request.getRequestURI();
            String query = request.getQueryString();
            String fullTarget = uri + (query != null ? "?" + query : "");
            
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("redirectAfterLogin", fullTarget);
            newSession.setAttribute("errorMessage", "Session expired. Please sign in to continue.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("PENDING".equalsIgnoreCase(user.getStatus())) {
            session.invalidate();
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("errorMessage", "Your account is pending admin approval.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("DISABLED".equalsIgnoreCase(user.getStatus())) {
            session.invalidate();
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("errorMessage", "Your account has been disabled.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getRequestURI().substring(request.getContextPath().length());
        String role = user.getRole();

        if (path.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin rights required.");
            return;
        }

        if (path.startsWith("/faculty") && !"FACULTY".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Faculty rights required.");
            return;
        }

        if (path.startsWith("/student") && !"STUDENT".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Student rights required.");
            return;
        }

        chain.doFilter(request, response);
    }
}
