package com.ocms.controller;

import com.ocms.dao.AssignmentDAO;
import com.ocms.dao.SubmissionDAO;
import com.ocms.model.Assignment;
import com.ocms.model.Submission;
import com.ocms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/student/submission")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class StudentSubmissionServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    private String getUploadDir() {
        String uploadDir = System.getenv("UPLOAD_DIR");
        if (uploadDir == null || uploadDir.isBlank()) {
            uploadDir = System.getProperty("user.home") + File.separator + "coursecraft_uploads";
        }
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();
        return dir.getAbsolutePath();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String assignmentIdStr = request.getParameter("assignmentId");
        if (assignmentIdStr == null || assignmentIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        int assignmentId = Integer.parseInt(assignmentIdStr);
        Assignment assignment = assignmentDAO.getById(assignmentId);
        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Assignment not found.");
            return;
        }

        Submission submission = submissionDAO.getByAssignmentAndStudent(assignmentId, user.getUserId());

        request.setAttribute("assignment", assignment);
        request.setAttribute("submission", submission);

        request.getRequestDispatcher("/student/submission.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        Part filePart = request.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("errorMessage", "Please select a file to submit.");
            doGet(request, response);
            return;
        }

        String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String savedFileName = UUID.randomUUID().toString() + "_" + originalName;
        File destFile = new File(getUploadDir(), savedFileName);
        filePart.write(destFile.getAbsolutePath());

        Submission sub = new Submission();
        sub.setAssignmentId(assignmentId);
        sub.setStudentId(user.getUserId());
        sub.setFilePath(savedFileName);

        if (submissionDAO.insertOrUpdate(sub)) {
            request.setAttribute("successMessage", "Assignment submitted successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to submit assignment.");
        }

        doGet(request, response);
    }
}
