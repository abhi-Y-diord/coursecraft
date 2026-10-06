package com.ocms.controller;

import com.ocms.dao.AttendanceDAO;
import com.ocms.dao.EnrollmentDAO;
import com.ocms.model.Attendance;
import com.ocms.model.Enrollment;
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

@WebServlet("/student/attendance")
public class StudentAttendanceServlet extends HttpServlet {

    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
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

        int studentId = user.getUserId();
        List<Enrollment> enrollments = enrollmentDAO.getByStudent(studentId);

        Map<Integer, Double> percentageMap = new HashMap<>();
        Map<Integer, List<Attendance>> attendanceLogsMap = new HashMap<>();

        for (Enrollment e : enrollments) {
            double pct = attendanceDAO.getPercentage(e.getCourseId(), studentId);
            percentageMap.put(e.getCourseId(), pct);

            List<Attendance> logs = attendanceDAO.getByStudentAndCourse(studentId, e.getCourseId());
            attendanceLogsMap.put(e.getCourseId(), logs);
        }

        request.setAttribute("enrollments", enrollments);
        request.setAttribute("percentageMap", percentageMap);
        request.setAttribute("attendanceLogsMap", attendanceLogsMap);

        request.getRequestDispatcher("/student/myAttendance.jsp").forward(request, response);
    }
}
