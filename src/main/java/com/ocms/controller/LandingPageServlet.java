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
import java.util.List;

@WebServlet("")
public class LandingPageServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect logged-in users to their dashboard
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null) {
            switch (user.getRole()) {
                case "ADMIN"   -> response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                case "FACULTY" -> response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
                default        -> response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }
            return;
        }

        request.setAttribute("openCourses", courseDAO.getOpenCourses());

        List<Announcement> globals = announcementDAO.getLatestGlobalAnnouncement();
        if (!globals.isEmpty()) {
            request.setAttribute("globalAnnouncement", globals.get(0));
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
