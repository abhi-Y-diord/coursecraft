package com.ocms.controller;

import com.ocms.dao.AssignmentDAO;
import com.ocms.dao.SubmissionDAO;
import com.ocms.model.Assignment;
import com.ocms.model.Submission;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/faculty/grading")
public class GradingServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String assignmentIdStr = request.getParameter("assignmentId");
        if (assignmentIdStr == null || assignmentIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            return;
        }

        int assignmentId = Integer.parseInt(assignmentIdStr);
        Assignment assignment = assignmentDAO.getById(assignmentId);
        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Assignment not found.");
            return;
        }

        List<Submission> submissions = submissionDAO.getByAssignment(assignmentId);

        String studentIdStr = request.getParameter("studentId");
        Submission currentSubmission = null;

        if (studentIdStr != null && !studentIdStr.isBlank()) {
            int studentId = Integer.parseInt(studentIdStr);
            for (Submission s : submissions) {
                if (s.getStudentId() == studentId) {
                    currentSubmission = s;
                    break;
                }
            }
        }
        if (currentSubmission == null && !submissions.isEmpty()) {
            currentSubmission = submissions.get(0);
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("submissions", submissions);
        request.setAttribute("currentSubmission", currentSubmission);

        request.getRequestDispatcher("/faculty/grading.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int submissionId = Integer.parseInt(request.getParameter("submissionId"));
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        int marks = Integer.parseInt(request.getParameter("marksObtained"));
        String feedback = request.getParameter("feedback");
        String nextStudentId = request.getParameter("nextStudentId");

        submissionDAO.updateGrade(submissionId, marks, feedback);

        if (nextStudentId != null && !nextStudentId.isBlank() && !nextStudentId.equals("0")) {
            response.sendRedirect(request.getContextPath() + "/faculty/grading?assignmentId=" + assignmentId + "&studentId=" + nextStudentId + "&saved=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/faculty/grading?assignmentId=" + assignmentId + "&submissionId=" + submissionId + "&saved=true");
        }
    }
}
