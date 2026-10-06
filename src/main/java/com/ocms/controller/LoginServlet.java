package com.ocms.controller;

import com.ocms.dao.UserDAO;
import com.ocms.model.User;
import com.ocms.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectToDashboard(request, response, user.getRole());
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getByEmail(email.trim().toLowerCase());
        if (user == null || !PasswordUtil.checkPassword(password, user.getPassword())) {
            request.setAttribute("errorMessage", "Invalid email address or password.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if ("PENDING".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("errorMessage", "Your faculty account is pending administrator approval.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if ("DISABLED".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("errorMessage", "Your account has been disabled. Please contact system support.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        userDAO.updateLastLogin(user.getUserId());

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
        session.removeAttribute("redirectAfterLogin");

        if (redirectAfterLogin != null && !redirectAfterLogin.isBlank()) {
            response.sendRedirect(redirectAfterLogin);
        } else {
            redirectToDashboard(request, response, user.getRole());
        }
    }

    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, String role)
            throws IOException {
        if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if ("FACULTY".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }
}
