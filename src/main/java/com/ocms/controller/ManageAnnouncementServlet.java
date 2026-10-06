package com.ocms.controller;

import com.ocms.dao.AnnouncementDAO;
import com.ocms.dao.CourseDAO;
import com.ocms.model.Announcement;
import com.ocms.model.Course;
import com.ocms.model.User;
import com.ocms.util.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/announcements")
public class ManageAnnouncementServlet extends HttpServlet {

    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        int page = 1;
        int pageSize = 10;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {}

        int offset = (page - 1) * pageSize;
        List<Announcement> list = announcementDAO.getAllAnnouncements(offset, pageSize);
        int total = announcementDAO.countAllAnnouncements();

        if (user != null && "FACULTY".equals(user.getRole())) {
            List<Course> facultyCourses = courseDAO.getByFaculty(user.getUserId());
            request.setAttribute("courses", facultyCourses);
        } else {
            request.setAttribute("courses", courseDAO.search(null, null, null, null, null, "code_asc", 0, 100));
        }

        request.setAttribute("pageObj", new Page<>(list, page, pageSize, total));
        request.setAttribute("baseUrl", request.getContextPath() + "/admin/announcements");
        request.getRequestDispatcher("/admin/announcements.jsp").forward(request, response);
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

        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            String courseIdStr = request.getParameter("courseId");

            if (title == null || title.isBlank() || message == null || message.isBlank()) {
                request.setAttribute("errorMessage", "Title and message are required.");
                doGet(request, response);
                return;
            }

            Announcement a = new Announcement();
            a.setTitle(title.trim());
            a.setMessage(message.trim());
            a.setPostedBy(user.getUserId());

            if (courseIdStr != null && !courseIdStr.isBlank()) {
                a.setCourseId(Integer.parseInt(courseIdStr));
            } else {
                a.setCourseId(null); // Global
            }

            if (announcementDAO.insert(a)) {
                request.setAttribute("successMessage", "Announcement posted.");
            } else {
                request.setAttribute("errorMessage", "Failed to post announcement.");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int announcementId = Integer.parseInt(request.getParameter("announcementId"));
            if (announcementDAO.delete(announcementId)) {
                request.setAttribute("successMessage", "Announcement deleted.");
            } else {
                request.setAttribute("errorMessage", "Failed to delete announcement.");
            }
        } else if ("dismiss".equalsIgnoreCase(action)) {
            int announcementId = Integer.parseInt(request.getParameter("announcementId"));
            announcementDAO.dismiss(user.getUserId(), announcementId);
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/");
            return;
        }

        doGet(request, response);
    }
}
