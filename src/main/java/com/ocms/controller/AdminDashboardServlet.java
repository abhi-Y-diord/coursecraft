package com.ocms.controller;

import com.ocms.dao.CourseDAO;
import com.ocms.dao.EnrollmentDAO;
import com.ocms.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("totalStudents", userDAO.countByRole("STUDENT"));
        request.setAttribute("totalFaculty", userDAO.countByRole("FACULTY"));
        request.setAttribute("totalCourses", courseDAO.countAll());
        request.setAttribute("activeEnrollments", enrollmentDAO.countActiveEnrollments());

        request.setAttribute("pendingFaculty", userDAO.getPendingFaculty());
        request.setAttribute("fullCourses", courseDAO.getFullCourses());
        request.setAttribute("unassignedCourses", courseDAO.getUnassignedCourses());
        request.setAttribute("recentEnrollments", enrollmentDAO.searchEnrollments(null, null, 0, 5));

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
