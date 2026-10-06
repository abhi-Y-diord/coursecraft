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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User updated = userDAO.getById(user.getUserId());
        if (updated != null) session.setAttribute("user", updated);

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");

            if (name == null || name.isBlank()) {
                request.setAttribute("errorMessage", "Name cannot be empty.");
            } else if (userDAO.updateProfile(user.getUserId(), name.trim(), phone != null ? phone.trim() : "")) {
                user.setName(name.trim());
                user.setPhone(phone != null ? phone.trim() : "");
                session.setAttribute("user", user);
                request.setAttribute("successMessage", "Profile updated.");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile.");
            }
        } else if ("changePassword".equalsIgnoreCase(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User fresh = userDAO.getById(user.getUserId());

            if (!PasswordUtil.checkPassword(currentPassword, fresh.getPassword())) {
                request.setAttribute("errorMessage", "Current password is incorrect.");
            } else if (newPassword == null || newPassword.isBlank() || newPassword.length() < 6) {
                request.setAttribute("errorMessage", "New password must be at least 6 characters long.");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "New passwords do not match.");
            } else if (userDAO.updatePassword(user.getUserId(), PasswordUtil.hashPassword(newPassword))) {
                request.setAttribute("successMessage", "Password changed successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to update password.");
            }
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
