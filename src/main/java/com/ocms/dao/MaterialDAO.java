package com.ocms.dao;

import com.ocms.model.Material;
import com.ocms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaterialDAO {

    public Material getById(int materialId) {
        String sql = "SELECT * FROM materials WHERE material_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, materialId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapMaterial(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Material> getByCourse(int courseId) {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM materials WHERE course_id = ? ORDER BY week_no ASC, material_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMaterial(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(Material material) {
        String sql = "INSERT INTO materials (course_id, title, type, week_no, file_path) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, material.getCourseId());
            stmt.setString(2, material.getTitle());
            stmt.setString(3, material.getType() != null ? material.getType() : "FILE");
            stmt.setInt(4, material.getWeekNo() > 0 ? material.getWeekNo() : 1);
            stmt.setString(5, material.getFilePath());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) material.setMaterialId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int materialId) {
        String sql = "DELETE FROM materials WHERE material_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, materialId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Material mapMaterial(ResultSet rs) throws SQLException {
        Material m = new Material();
        m.setMaterialId(rs.getInt("material_id"));
        m.setCourseId(rs.getInt("course_id"));
        m.setTitle(rs.getString("title"));
        m.setType(rs.getString("type"));
        m.setWeekNo(rs.getInt("week_no"));
        m.setFilePath(rs.getString("file_path"));
        m.setUploadedOn(rs.getTimestamp("uploaded_on"));
        return m;
    }
}
