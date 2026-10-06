package com.ocms.controller;

import com.ocms.dao.AttendanceDAO;
import com.ocms.dao.CourseDAO;
import com.ocms.dao.EnrollmentDAO;
import com.ocms.model.Attendance;
import com.ocms.model.Course;
import com.ocms.model.Enrollment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        String export = request.getParameter("export");
        String q = request.getParameter("q");
        String status = request.getParameter("status");

        if ("csv".equalsIgnoreCase(export)) {
            response.setContentType("text/csv;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"coursecraft_report.csv\"");
            PrintWriter out = response.getWriter();

            if ("attendance".equalsIgnoreCase(type)) {
                out.println("Attendance ID,Course Code,Course Title,Student ID,Student Name,Session Date,Status");
                // For demo, list enrollments/attendance
                List<Enrollment> list = enrollmentDAO.searchEnrollments(q, status, 0, 1000);
                for (Enrollment e : list) {
                    List<Attendance> atts = attendanceDAO.getByStudentAndCourse(e.getStudentId(), e.getCourseId());
                    for (Attendance a : atts) {
                        out.printf("%d,\"%s\",\"%s\",%d,\"%s\",%s,%s\n",
                            a.getAttendanceId(), a.getCourseCode(), a.getCourseTitle(),
                            a.getStudentId(), a.getStudentName(), a.getSessionDate(), a.getStatus());
                    }
                }
            } else { // enrollment
                out.println("Enrollment ID,Student Name,Student Email,Course Code,Course Title,Enrolled Date,Status");
                List<Enrollment> list = enrollmentDAO.searchEnrollments(q, status, 0, 1000);
                for (Enrollment e : list) {
                    out.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",%s,%s\n",
                        e.getEnrollmentId(), e.getStudentName(), e.getStudentEmail(),
                        e.getCourseCode(), e.getCourseTitle(), e.getEnrolledOn(), e.getStatus());
                }
            }
            out.flush();
            return;
        }

        List<Enrollment> enrollments = enrollmentDAO.searchEnrollments(q, status, 0, 50);
        request.setAttribute("enrollments", enrollments);
        request.setAttribute("courses", courseDAO.search(null, null, null, null, null, "code_asc", 0, 100));

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
