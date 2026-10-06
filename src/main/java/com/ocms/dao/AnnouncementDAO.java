package com.ocms.dao;

import com.ocms.model.Announcement;
import com.ocms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {

    public Announcement getById(int announcementId) {
        String sql = "SELECT a.*, c.course_code, c.title AS course_title, u.name AS posted_by_name " +
                     "FROM announcements a " +
                     "LEFT JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON a.posted_by = u.user_id WHERE a.announcement_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, announcementId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapAnnouncement(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Announcement> getGlobalAnnouncements() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, NULL AS course_code, NULL AS course_title, u.name AS posted_by_name " +
                     "FROM announcements a JOIN users u ON a.posted_by = u.user_id " +
                     "WHERE a.course_id IS NULL ORDER BY a.posted_on DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapAnnouncement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Announcement> getLatestGlobalAnnouncement() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, NULL AS course_code, NULL AS course_title, u.name AS posted_by_name " +
                     "FROM announcements a JOIN users u ON a.posted_by = u.user_id " +
                     "WHERE a.course_id IS NULL ORDER BY a.posted_on DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapAnnouncement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Announcement> getCourseAnnouncements(int courseId) {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, c.course_code, c.title AS course_title, u.name AS posted_by_name " +
                     "FROM announcements a " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON a.posted_by = u.user_id " +
                     "WHERE a.course_id = ? ORDER BY a.posted_on DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAnnouncement(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Announcement> getForStudent(int studentId, int limit) {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, c.course_code, c.title AS course_title, u.name AS posted_by_name " +
                     "FROM announcements a " +
                     "LEFT JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON a.posted_by = u.user_id " +
                     "LEFT JOIN announcement_dismissals ad ON a.announcement_id = ad.announcement_id AND ad.user_id = ? " +
                     "WHERE ad.user_id IS NULL AND (a.course_id IS NULL OR a.course_id IN (" +
                     "  SELECT course_id FROM enrollments WHERE student_id = ? AND status = 'ACTIVE'" +
                     ")) ORDER BY a.posted_on DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, studentId);
            stmt.setInt(3, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAnnouncement(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Announcement> getAllAnnouncements(int offset, int limit) {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, c.course_code, c.title AS course_title, u.name AS posted_by_name " +
                     "FROM announcements a " +
                     "LEFT JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON a.posted_by = u.user_id " +
                     "ORDER BY a.posted_on DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAnnouncement(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAllAnnouncements() {
        String sql = "SELECT COUNT(*) FROM announcements";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean insert(Announcement a) {
        String sql = "INSERT INTO announcements (course_id, posted_by, title, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (a.getCourseId() != null && a.getCourseId() > 0) stmt.setInt(1, a.getCourseId());
            else stmt.setNull(1, Types.INTEGER);
            stmt.setInt(2, a.getPostedBy());
            stmt.setString(3, a.getTitle());
            stmt.setString(4, a.getMessage());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) a.setAnnouncementId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean dismiss(int userId, int announcementId) {
        String sql = "INSERT IGNORE INTO announcement_dismissals (user_id, announcement_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, announcementId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int announcementId) {
        String sql = "DELETE FROM announcements WHERE announcement_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, announcementId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Announcement mapAnnouncement(ResultSet rs) throws SQLException {
        Announcement a = new Announcement();
        a.setAnnouncementId(rs.getInt("announcement_id"));
        int cid = rs.getInt("course_id");
        if (!rs.wasNull()) a.setCourseId(cid);
        a.setCourseCode(rs.getString("course_code"));
        a.setCourseTitle(rs.getString("course_title"));
        a.setPostedBy(rs.getInt("posted_by"));
        a.setPostedByName(rs.getString("posted_by_name"));
        a.setTitle(rs.getString("title"));
        a.setMessage(rs.getString("message"));
        a.setPostedOn(rs.getTimestamp("posted_on"));
        return a;
    }
}
