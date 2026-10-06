package com.ocms.controller;

import com.ocms.dao.AnnouncementDAO;
import com.ocms.dao.AssignmentDAO;
import com.ocms.dao.EnrollmentDAO;
import com.ocms.dao.SubmissionDAO;
import com.ocms.model.Announcement;
import com.ocms.model.Assignment;
import com.ocms.model.Enrollment;
import com.ocms.model.Submission;
import com.ocms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = user.getUserId();

        List<Assignment> dueSoonList = assignmentDAO.getUpcomingForStudent(studentId, 5);
        List<Enrollment> myEnrollments = enrollmentDAO.getByStudent(studentId);
        List<Submission> recentGraded = submissionDAO.getRecentGradedForStudent(studentId, 5);
        List<Announcement> announcements = announcementDAO.getForStudent(studentId, 5);

        Map<Integer, Integer> progressMap = new HashMap<>();
        for (Enrollment e : myEnrollments) {
            int pct = enrollmentDAO.getCourseProgressPercentage(studentId, e.getCourseId());
            progressMap.put(e.getCourseId(), pct);
        }

        request.setAttribute("dueSoonList", dueSoonList);
        request.setAttribute("myEnrollments", myEnrollments);
        request.setAttribute("progressMap", progressMap);
        request.setAttribute("recentGraded", recentGraded);
        request.setAttribute("announcements", announcements);

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}
