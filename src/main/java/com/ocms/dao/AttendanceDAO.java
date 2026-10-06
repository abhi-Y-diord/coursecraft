package com.ocms.dao;

import com.ocms.model.Attendance;
import com.ocms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    public boolean markAttendance(int courseId, Date sessionDate, int studentId, String status) {
        String checkSql = "SELECT attendance_id FROM attendance WHERE course_id = ? AND student_id = ? AND session_date = ?";
        try (Connection conn = DBConnection.getConnection()) {
            Integer existingId = null;
            try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
                stmt.setInt(1, courseId);
                stmt.setInt(2, studentId);
                stmt.setDate(3, sessionDate);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) existingId = rs.getInt(1);
                }
            }

            if (existingId != null) {
                String updateSql = "UPDATE attendance SET status = ? WHERE attendance_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                    stmt.setString(1, status);
                    stmt.setInt(2, existingId);
                    return stmt.executeUpdate() > 0;
                }
            } else {
                String insertSql = "INSERT INTO attendance (course_id, student_id, session_date, status) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setInt(1, courseId);
                    stmt.setInt(2, studentId);
                    stmt.setDate(3, sessionDate);
                    stmt.setString(4, status);
                    return stmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Attendance> getByCourseAndDate(int courseId, Date sessionDate) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*, c.course_code, c.title AS course_title, u.name AS student_name " +
                     "FROM attendance a " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON a.student_id = u.user_id " +
                     "WHERE a.course_id = ? AND a.session_date = ? ORDER BY u.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            stmt.setDate(2, sessionDate);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAttendance(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Attendance> getByStudentAndCourse(int studentId, int courseId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*, c.course_code, c.title AS course_title, u.name AS student_name " +
                     "FROM attendance a " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON a.student_id = u.user_id " +
                     "WHERE a.student_id = ? AND a.course_id = ? ORDER BY a.session_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAttendance(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getPercentage(int courseId, int studentId) {
        String sql = "SELECT COUNT(*) AS total, SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) AS present " +
                     "FROM attendance WHERE course_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            stmt.setInt(2, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    int present = rs.getInt("present");
                    if (total == 0) return 100.0;
                    return (double) present / total * 100.0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 100.0;
    }

    public List<Date> getSessionDatesForCourse(int courseId) {
        List<Date> dates = new ArrayList<>();
        String sql = "SELECT DISTINCT session_date FROM attendance WHERE course_id = ? ORDER BY session_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    dates.add(rs.getDate("session_date"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dates;
    }

    public double getAverageAttendanceForCourse(int courseId) {
        String sql = "SELECT COUNT(*) AS total, SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) AS present " +
                     "FROM attendance WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    int present = rs.getInt("present");
                    if (total == 0) return 0.0;
                    return (double) present / total * 100.0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Attendance mapAttendance(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setAttendanceId(rs.getInt("attendance_id"));
        a.setCourseId(rs.getInt("course_id"));
        a.setCourseCode(rs.getString("course_code"));
        a.setCourseTitle(rs.getString("course_title"));
        a.setStudentId(rs.getInt("student_id"));
        a.setStudentName(rs.getString("student_name"));
        a.setSessionDate(rs.getDate("session_date"));
        a.setStatus(rs.getString("status"));
        return a;
    }
}
