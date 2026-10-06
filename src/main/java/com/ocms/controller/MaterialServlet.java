package com.ocms.controller;

import com.ocms.dao.MaterialDAO;
import com.ocms.model.Material;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/faculty/material")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 100   // 100MB
)
public class MaterialServlet extends HttpServlet {

    private final MaterialDAO materialDAO = new MaterialDAO();

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        if ("add".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String type = request.getParameter("type"); // FILE or LINK
            String weekStr = request.getParameter("weekNo");
            int weekNo = (weekStr != null && !weekStr.isBlank()) ? Integer.parseInt(weekStr) : 1;

            if (title == null || title.isBlank()) {
                request.setAttribute("errorMessage", "Title is required.");
                response.sendRedirect(request.getContextPath() + "/faculty/course?id=" + courseId + "&tab=classwork");
                return;
            }

            Material material = new Material();
            material.setCourseId(courseId);
            material.setTitle(title.trim());
            material.setType(type != null ? type : "FILE");
            material.setWeekNo(weekNo);

            if ("LINK".equalsIgnoreCase(type)) {
                String linkUrl = request.getParameter("linkUrl");
                material.setFilePath(linkUrl != null ? linkUrl.trim() : "");
            } else {
                Part filePart = request.getPart("file");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalName;
                    File destFile = new File(getUploadDir(), savedFileName);
                    filePart.write(destFile.getAbsolutePath());
                    material.setFilePath(savedFileName);
                }
            }

            materialDAO.insert(material);
        } else if ("delete".equalsIgnoreCase(action)) {
            int materialId = Integer.parseInt(request.getParameter("materialId"));
            materialDAO.delete(materialId);
        }

        response.sendRedirect(request.getContextPath() + "/faculty/course?id=" + courseId + "&tab=classwork");
    }
}
