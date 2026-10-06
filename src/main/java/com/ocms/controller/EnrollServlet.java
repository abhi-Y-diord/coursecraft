package com.ocms.controller;

import com.ocms.dao.EnrollmentDAO;
import com.ocms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/student/enroll")
public class EnrollServlet extends HttpServlet {

    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"STUDENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int studentId = user.getUserId();

        if (enrollmentDAO.enrollIfSeatAvailable(studentId, courseId)) {
            session.setAttribute("successMessage", "Enrolled successfully in course.");
            response.sendRedirect(request.getContextPath() + "/student/course?id=" + courseId);
        } else {
            session.setAttribute("errorMessage", "Enrollment failed. Course is full or you are already enrolled.");
            response.sendRedirect(request.getContextPath() + "/student/course?id=" + courseId);
        }
    }
}
