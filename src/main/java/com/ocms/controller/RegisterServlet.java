package com.ocms.controller;

import com.ocms.dao.UserDAO;
import com.ocms.model.User;
import com.ocms.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        if (name == null || name.isBlank() || email == null || email.isBlank() ||
            password == null || password.isBlank() || role == null || role.isBlank()) {
            request.setAttribute("errorMessage", "All required fields must be filled.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        email = email.trim().toLowerCase();
        if (userDAO.getByEmail(email) != null) {
            request.setAttribute("errorMessage", "An account with this email address already exists.");
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        String targetRole = "FACULTY".equalsIgnoreCase(role) ? "FACULTY" : "STUDENT";
        String status = "FACULTY".equals(targetRole) ? "PENDING" : "ACTIVE";

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setPhone(phone != null ? phone.trim() : "");
        user.setRole(targetRole);
        user.setStatus(status);

        if (userDAO.insert(user)) {
            if ("PENDING".equals(status)) {
                request.setAttribute("infoMessage", "Registration submitted. Faculty accounts require administrator approval before sign in.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("successMessage", "Account created successfully. You may now sign in.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
