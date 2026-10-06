package com.ocms.controller;

import com.ocms.dao.AttendanceDAO;
import com.ocms.dao.CourseDAO;
import com.ocms.dao.SubmissionDAO;
import com.ocms.model.Course;
import com.ocms.model.Submission;
import com.ocms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/faculty/dashboard")
public class FacultyDashboardServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Submission> ungradedSubmissions = submissionDAO.getUngradedForFaculty(user.getUserId());
        List<Course> myCourses = courseDAO.getByFaculty(user.getUserId());

        request.setAttribute("ungradedSubmissions", ungradedSubmissions);
        request.setAttribute("myCourses", myCourses);
        request.setAttribute("todayDate", Date.valueOf(LocalDate.now()));

        request.getRequestDispatcher("/faculty/dashboard.jsp").forward(request, response);
    }
}
