package com.ocms.controller;

import com.ocms.dao.CategoryDAO;
import com.ocms.dao.CourseDAO;
import com.ocms.model.Category;
import com.ocms.model.Course;
import com.ocms.util.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/student/catalog")
public class CatalogServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String catStr = request.getParameter("cat");
        String availability = request.getParameter("avail");
        String sort = request.getParameter("sort");

        List<Integer> categoryIds = new ArrayList<>();
        if (catStr != null && !catStr.isBlank()) {
            try { categoryIds.add(Integer.parseInt(catStr)); } catch (NumberFormatException e) {}
        }

        int page = 1;
        int pageSize = 6;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {}

        int offset = (page - 1) * pageSize;
        List<Course> courses = courseDAO.search(q, categoryIds.isEmpty() ? null : categoryIds, null, null, availability, sort, offset, pageSize);
        int total = courseDAO.countSearch(q, categoryIds.isEmpty() ? null : categoryIds, null, null, availability);

        List<Category> categories = categoryDAO.getAll();

        request.setAttribute("courses", courses);
        request.setAttribute("categories", categories);
        request.setAttribute("pageObj", new Page<>(courses, page, pageSize, total));
        request.setAttribute("baseUrl", request.getContextPath() + "/student/catalog");

        request.getRequestDispatcher("/student/catalog.jsp").forward(request, response);
    }
}
