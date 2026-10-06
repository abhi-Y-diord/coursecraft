package com.ocms.controller;

import com.ocms.dao.CategoryDAO;
import com.ocms.dao.CourseDAO;
import com.ocms.dao.UserDAO;
import com.ocms.model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/courses")
public class ManageCourseServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String catStr = request.getParameter("cat");
        Integer catId = null;
        if (catStr != null && !catStr.isBlank()) {
            try { catId = Integer.parseInt(catStr); } catch (NumberFormatException e) {}
        }

        int page = 1;
        int pageSize = 10;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {}

        List<Integer> catList = (catId != null) ? List.of(catId) : null;
        int offset = (page - 1) * pageSize;

        List<Course> courses = courseDAO.search(q, catList, null, null, null, "code_asc", offset, pageSize);
        int total = courseDAO.countSearch(q, catList, null, null, null);

        request.setAttribute("courses", courses);
        request.setAttribute("categories", categoryDAO.getAll());
        request.setAttribute("facultyList", userDAO.getByRole("FACULTY"));

        request.setAttribute("pageObj", new com.ocms.util.Page<>(courses, page, pageSize, total));
        request.setAttribute("baseUrl", request.getContextPath() + "/admin/courses");
        request.getRequestDispatcher("/admin/manageCourses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)) {
            String courseCode = request.getParameter("courseCode");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String catStr = request.getParameter("categoryId");
            String facStr = request.getParameter("facultyId");
            String capStr = request.getParameter("capacity");
            String durStr = request.getParameter("durationWeeks");

            if (courseCode == null || courseCode.isBlank() || title == null || title.isBlank()) {
                request.setAttribute("errorMessage", "Course code and title are required.");
                doGet(request, response);
                return;
            }

            Course course = new Course();
            course.setCourseCode(courseCode.trim().toUpperCase());
            course.setTitle(title.trim());
            course.setDescription(description != null ? description.trim() : "");
            
            if (catStr != null && !catStr.isBlank()) course.setCategoryId(Integer.parseInt(catStr));
            if (facStr != null && !facStr.isBlank()) course.setFacultyId(Integer.parseInt(facStr));
            course.setCapacity(capStr != null && !capStr.isBlank() ? Integer.parseInt(capStr) : 30);
            course.setDurationWeeks(durStr != null && !durStr.isBlank() ? Integer.parseInt(durStr) : 8);

            if ("add".equalsIgnoreCase(action)) {
                if (courseDAO.getByCode(course.getCourseCode()) != null) {
                    request.setAttribute("errorMessage", "Course code " + course.getCourseCode() + " already exists.");
                } else if (courseDAO.insert(course)) {
                    request.setAttribute("successMessage", "Course " + course.getCourseCode() + " created.");
                } else {
                    request.setAttribute("errorMessage", "Failed to create course.");
                }
            } else {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                course.setCourseId(courseId);
                if (courseDAO.update(course)) {
                    request.setAttribute("successMessage", "Course " + course.getCourseCode() + " updated.");
                } else {
                    request.setAttribute("errorMessage", "Failed to update course.");
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            if (courseDAO.delete(courseId)) {
                request.setAttribute("successMessage", "Course deleted.");
            } else {
                request.setAttribute("errorMessage", "Cannot delete course with active enrollments.");
            }
        }

        doGet(request, response);
    }
}
