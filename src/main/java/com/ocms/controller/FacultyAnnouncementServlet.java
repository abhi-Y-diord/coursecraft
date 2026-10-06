package com.ocms.controller;

import com.ocms.dao.AnnouncementDAO;
import com.ocms.dao.CourseDAO;
import com.ocms.model.Announcement;
import com.ocms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/faculty/announcement")
public class FacultyAnnouncementServlet extends HttpServlet {

    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        String redirectTo = request.getParameter("redirectUrl");
        if (redirectTo == null || redirectTo.isBlank()) {
            redirectTo = request.getContextPath() + "/faculty/dashboard";
        }

        if ("add".equalsIgnoreCase(action)) {
            String title   = request.getParameter("title");
            String message = request.getParameter("message");
            String cidStr  = request.getParameter("courseId");

            if (title == null || title.isBlank() || message == null || message.isBlank()) {
                response.sendRedirect(redirectTo);
                return;
            }

            Announcement a = new Announcement();
            a.setTitle(title.trim());
            a.setMessage(message.trim());
            a.setPostedBy(user.getUserId());
            if (cidStr != null && !cidStr.isBlank()) {
                int cid = Integer.parseInt(cidStr);
                // Security: verify faculty owns this course
                if (courseDAO.getById(cid) != null) {
                    a.setCourseId(cid);
                }
            }
            announcementDAO.insert(a);

        } else if ("delete".equalsIgnoreCase(action)) {
            int aid = Integer.parseInt(request.getParameter("announcementId"));
            Announcement existing = announcementDAO.getById(aid);
            if (existing != null && existing.getPostedBy() == user.getUserId()) {
                announcementDAO.delete(aid);
            }
        }

        response.sendRedirect(redirectTo);
    }
}
