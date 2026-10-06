package com.ocms.controller;

import com.ocms.dao.*;
import com.ocms.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/faculty/course")
public class FacultyCourseServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            return;
        }

        int courseId = Integer.parseInt(idStr);
        Course course = courseDAO.getById(courseId);

        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found.");
            return;
        }

        request.setAttribute("course", course);
        request.setAttribute("materials", materialDAO.getByCourse(courseId));
        request.setAttribute("assignments", assignmentDAO.getByCourse(courseId));
        request.setAttribute("enrollments", enrollmentDAO.getByCourse(courseId));
        request.setAttribute("announcements", announcementDAO.getCourseAnnouncements(courseId));
        request.setAttribute("submissions", submissionDAO.getByCourse(courseId));

        request.getRequestDispatcher("/faculty/courseWorkspace.jsp").forward(request, response);
    }
}
