package com.ocms.controller;

import com.ocms.dao.UserDAO;
import com.ocms.model.User;
import com.ocms.util.Page;
import com.ocms.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/faculty")
public class ManageFacultyServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String status = request.getParameter("status");
        int page = 1;
        int pageSize = 10;

        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            if (request.getParameter("pageSize") != null) pageSize = Integer.parseInt(request.getParameter("pageSize"));
        } catch (NumberFormatException e) {}

        int offset = (page - 1) * pageSize;
        List<User> facultyList = userDAO.searchUsers("FACULTY", status, q, offset, pageSize);
        int total = userDAO.countSearchUsers("FACULTY", status, q);

        Page<User> pageObj = new Page<>(facultyList, page, pageSize, total);

        request.setAttribute("pageObj", pageObj);
        request.setAttribute("baseUrl", request.getContextPath() + "/admin/faculty");
        request.getRequestDispatcher("/admin/manageFaculty.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            if (name == null || name.isBlank() || email == null || email.isBlank() || password == null || password.isBlank()) {
                request.setAttribute("errorMessage", "Name, email, and password are required.");
                doGet(request, response);
                return;
            }

            email = email.trim().toLowerCase();
            if (userDAO.getByEmail(email) != null) {
                request.setAttribute("errorMessage", "An account with this email already exists.");
                doGet(request, response);
                return;
            }

            User user = new User();
            user.setName(name.trim());
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setPhone(phone != null ? phone.trim() : "");
            user.setRole("FACULTY");
            user.setStatus("ACTIVE");

            if (userDAO.insert(user)) {
                request.setAttribute("successMessage", "Faculty account created.");
            } else {
                request.setAttribute("errorMessage", "Failed to create faculty account.");
            }
        } else if ("updateStatus".equalsIgnoreCase(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status");

            if (userDAO.updateStatus(userId, status)) {
                request.setAttribute("successMessage", "Faculty status updated.");
            } else {
                request.setAttribute("errorMessage", "Failed to update status.");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if (userDAO.delete(userId)) {
                request.setAttribute("successMessage", "Faculty account deleted.");
            } else {
                request.setAttribute("errorMessage", "Cannot delete faculty member with active course assignments.");
            }
        }

        doGet(request, response);
    }
}
