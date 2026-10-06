package com.ocms.controller;

import com.ocms.dao.AttendanceDAO;
import com.ocms.dao.CourseDAO;
import com.ocms.dao.EnrollmentDAO;
import com.ocms.model.Attendance;
import com.ocms.model.Course;
import com.ocms.model.Enrollment;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/faculty/attendance")
public class FacultyAttendanceServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
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

        List<Course> myCourses = courseDAO.getByFaculty(user.getUserId());
        String courseIdStr = request.getParameter("courseId");
        
        Course currentCourse = null;
        if (courseIdStr != null && !courseIdStr.isBlank()) {
            int cid = Integer.parseInt(courseIdStr);
            for (Course c : myCourses) {
                if (c.getCourseId() == cid) {
                    currentCourse = c;
                    break;
                }
            }
        }
        if (currentCourse == null && !myCourses.isEmpty()) {
            currentCourse = myCourses.get(0);
        }

        String dateStr = request.getParameter("date");
        Date sessionDate = (dateStr != null && !dateStr.isBlank()) ? Date.valueOf(dateStr) : Date.valueOf(LocalDate.now());

        if (currentCourse != null) {
            List<Enrollment> enrolledStudents = enrollmentDAO.getByCourse(currentCourse.getCourseId());
            List<Attendance> existingAtt = attendanceDAO.getByCourseAndDate(currentCourse.getCourseId(), sessionDate);
            List<Date> pastDates = attendanceDAO.getSessionDatesForCourse(currentCourse.getCourseId());

            request.setAttribute("currentCourse", currentCourse);
            request.setAttribute("enrolledStudents", enrolledStudents);
            request.setAttribute("existingAtt", existingAtt);
            request.setAttribute("pastDates", pastDates);
        }

        request.setAttribute("myCourses", myCourses);
        request.setAttribute("sessionDate", sessionDate);

        request.getRequestDispatcher("/faculty/attendance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Date sessionDate = Date.valueOf(request.getParameter("sessionDate"));

        String[] studentIds = request.getParameterValues("studentId");
        if (studentIds != null) {
            for (String sidStr : studentIds) {
                int studentId = Integer.parseInt(sidStr);
                String status = request.getParameter("status_" + studentId);
                if (status == null || status.isBlank()) status = "ABSENT";

                attendanceDAO.markAttendance(courseId, sessionDate, studentId, status);
            }
        }

        request.setAttribute("successMessage", "Attendance saved for " + sessionDate);
        doGet(request, response);
    }
}
