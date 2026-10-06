package com.ocms.controller;

import com.ocms.dao.EnrollmentDAO;
import com.ocms.model.Enrollment;
import com.ocms.util.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/enrollments")
public class ManageEnrollmentServlet extends HttpServlet {

    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String status = request.getParameter("status");
        int page = 1;
        int pageSize = 10;

        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {}

        int offset = (page - 1) * pageSize;
        List<Enrollment> list = enrollmentDAO.searchEnrollments(q, status, offset, pageSize);
        int total = enrollmentDAO.countSearchEnrollments(q, status);

        request.setAttribute("pageObj", new Page<>(list, page, pageSize, total));
        request.setAttribute("baseUrl", request.getContextPath() + "/admin/enrollments");
        request.getRequestDispatcher("/admin/manageEnrollments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equalsIgnoreCase(action)) {
            int enrollmentId = Integer.parseInt(request.getParameter("enrollmentId"));
            String status = request.getParameter("status");

            if (enrollmentDAO.updateStatus(enrollmentId, status)) {
                request.setAttribute("successMessage", "Enrollment status updated.");
            } else {
                request.setAttribute("errorMessage", "Failed to update enrollment status.");
            }
        }
        doGet(request, response);
    }
}
