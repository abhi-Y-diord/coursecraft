package com.ocms.controller;

import com.ocms.dao.AssignmentDAO;
import com.ocms.dao.EnrollmentDAO;
import com.ocms.dao.SubmissionDAO;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/grades")
public class StudentGradesServlet extends HttpServlet {

    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
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

        int studentId = user.getUserId();
        List<Enrollment> enrollments = enrollmentDAO.getByStudent(studentId);

        Map<Integer, List<Assignment>> courseAssignmentsMap = new HashMap<>();
        Map<Integer, Map<Integer, Submission>> courseSubmissionsMap = new HashMap<>();

        for (Enrollment e : enrollments) {
            List<Assignment> asList = assignmentDAO.getByCourse(e.getCourseId());
            courseAssignmentsMap.put(e.getCourseId(), asList);

            List<Submission> subList = submissionDAO.getByStudentAndCourse(studentId, e.getCourseId());
            Map<Integer, Submission> map = new HashMap<>();
            for (Submission s : subList) {
                map.put(s.getAssignmentId(), s);
            }
            courseSubmissionsMap.put(e.getCourseId(), map);
        }

        request.setAttribute("enrollments", enrollments);
        request.setAttribute("courseAssignmentsMap", courseAssignmentsMap);
        request.setAttribute("courseSubmissionsMap", courseSubmissionsMap);

        request.getRequestDispatcher("/student/myGrades.jsp").forward(request, response);
    }
}
