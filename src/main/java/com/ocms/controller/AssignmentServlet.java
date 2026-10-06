package com.ocms.controller;

import com.ocms.dao.AssignmentDAO;
import com.ocms.model.Assignment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/faculty/assignment")
public class AssignmentServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        if ("add".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDateStr = request.getParameter("dueDate");
            String maxMarksStr = request.getParameter("maxMarks");
            String weekStr = request.getParameter("weekNo");

            if (title == null || title.isBlank() || dueDateStr == null || dueDateStr.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/faculty/course?id=" + courseId + "&tab=classwork");
                return;
            }

            Assignment a = new Assignment();
            a.setCourseId(courseId);
            a.setTitle(title.trim());
            a.setDescription(description != null ? description.trim() : "");
            a.setDueDate(Date.valueOf(dueDateStr));
            a.setMaxMarks(maxMarksStr != null && !maxMarksStr.isBlank() ? Integer.parseInt(maxMarksStr) : 100);
            a.setWeekNo(weekStr != null && !weekStr.isBlank() ? Integer.parseInt(weekStr) : 1);

            if ("add".equalsIgnoreCase(action)) {
                assignmentDAO.insert(a);
            } else {
                a.setAssignmentId(Integer.parseInt(request.getParameter("assignmentId")));
                assignmentDAO.update(a);
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            assignmentDAO.delete(assignmentId);
        }

        response.sendRedirect(request.getContextPath() + "/faculty/course?id=" + courseId + "&tab=classwork");
    }
}
