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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/course")
public class StudentCourseServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
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

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/student/catalog");
            return;
        }

        int courseId = Integer.parseInt(idStr);
        Course course = courseDAO.getById(courseId);
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found.");
            return;
        }

        boolean enrolled = enrollmentDAO.isEnrolled(user.getUserId(), courseId);

        request.setAttribute("course", course);
        request.setAttribute("enrolled", enrolled);

        if (enrolled) {
            List<Material> materials = materialDAO.getByCourse(courseId);
            List<Assignment> assignments = assignmentDAO.getByCourse(courseId);
            List<Submission> mySubmissions = submissionDAO.getByStudentAndCourse(user.getUserId(), courseId);
            List<Attendance> myAttendance = attendanceDAO.getByStudentAndCourse(user.getUserId(), courseId);
            double attendancePct = attendanceDAO.getPercentage(courseId, user.getUserId());
            List<Announcement> announcements = announcementDAO.getCourseAnnouncements(courseId);

            Map<Integer, Submission> subMap = new HashMap<>();
            for (Submission s : mySubmissions) {
                subMap.put(s.getAssignmentId(), s);
            }

            request.setAttribute("materials", materials);
            request.setAttribute("assignments", assignments);
            request.setAttribute("subMap", subMap);
            request.setAttribute("myAttendance", myAttendance);
            request.setAttribute("attendancePct", attendancePct);
            request.setAttribute("announcements", announcements);
        }

        request.getRequestDispatcher("/student/courseView.jsp").forward(request, response);
    }
}
