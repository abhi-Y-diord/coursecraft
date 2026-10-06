package com.ocms.dao;

import com.ocms.model.Enrollment;
import com.ocms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDAO {

    public boolean enrollIfSeatAvailable(int studentId, int courseId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Lock course row and read capacity
            String lockCourseSql = "SELECT capacity FROM courses WHERE course_id = ? FOR UPDATE";
            int capacity = 0;
            try (PreparedStatement stmt = conn.prepareStatement(lockCourseSql)) {
                stmt.setInt(1, courseId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        capacity = rs.getInt("capacity");
                    } else {
                        conn.rollback();
                        return false; // Course does not exist
                    }
                }
            }

            // 2. Count active enrollments
            String countSql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ? AND status = 'ACTIVE'";
            int activeCount = 0;
            try (PreparedStatement stmt = conn.prepareStatement(countSql)) {
                stmt.setInt(1, courseId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        activeCount = rs.getInt(1);
                    }
                }
            }

            if (activeCount >= capacity) {
                conn.rollback();
                return false; // Course is full
            }

            // 3. Insert enrollment
            String insertSql = "INSERT INTO enrollments (student_id, course_id, status) VALUES (?, ?, 'ACTIVE')";
            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                stmt.setInt(1, studentId);
                stmt.setInt(2, courseId);
                stmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            // Unique key constraint violation means already enrolled
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {}
            }
        }
    }

    public boolean isEnrolled(int studentId, int courseId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND course_id = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int enrollmentId, String status) {
        String sql = "UPDATE enrollments SET status = ? WHERE enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, enrollmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean dropEnrollment(int studentId, int courseId) {
        String sql = "UPDATE enrollments SET status = 'DROPPED' WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Enrollment> getByStudent(int studentId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM enrollments e " +
                     "JOIN courses c ON e.course_id = c.course_id " +
                     "JOIN users u ON e.student_id = u.user_id " +
                     "WHERE e.student_id = ? AND e.status != 'DROPPED' ORDER BY e.enrolled_on DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapEnrollment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Enrollment> getByCourse(int courseId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM enrollments e " +
                     "JOIN courses c ON e.course_id = c.course_id " +
                     "JOIN users u ON e.student_id = u.user_id " +
                     "WHERE e.course_id = ? AND e.status != 'DROPPED' ORDER BY u.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapEnrollment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Enrollment> searchEnrollments(String keyword, String status, int offset, int limit) {
        List<Enrollment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT e.*, c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
            "FROM enrollments e " +
            "JOIN courses c ON e.course_id = c.course_id " +
            "JOIN users u ON e.student_id = u.user_id WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank()) {
            sql.append(" AND e.status = ?");
            params.add(status);
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (u.name LIKE ? OR u.email LIKE ? OR c.course_code LIKE ? OR c.title LIKE ?)");
            String k = "%" + keyword + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
        }

        sql.append(" ORDER BY e.enrollment_id DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapEnrollment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countSearchEnrollments(String keyword, String status) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM enrollments e " +
            "JOIN courses c ON e.course_id = c.course_id " +
            "JOIN users u ON e.student_id = u.user_id WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank()) {
            sql.append(" AND e.status = ?");
            params.add(status);
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (u.name LIKE ? OR u.email LIKE ? OR c.course_code LIKE ? OR c.title LIKE ?)");
            String k = "%" + keyword + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countActiveEnrollments() {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getCourseProgressPercentage(int studentId, int courseId) {
        // Progress = submitted assignments / total assignments for course
        String sqlTotal = "SELECT COUNT(*) FROM assignments WHERE course_id = ?";
        String sqlSubmitted = "SELECT COUNT(DISTINCT s.assignment_id) FROM submissions s " +
                              "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                              "WHERE a.course_id = ? AND s.student_id = ?";
        int total = 0;
        int submitted = 0;
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(sqlTotal)) {
                stmt.setInt(1, courseId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) total = rs.getInt(1);
                }
            }
            if (total == 0) return 0;
            try (PreparedStatement stmt = conn.prepareStatement(sqlSubmitted)) {
                stmt.setInt(1, courseId);
                stmt.setInt(2, studentId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) submitted = rs.getInt(1);
                }
            }
            return (int) Math.round(((double) submitted / total) * 100);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Enrollment mapEnrollment(ResultSet rs) throws SQLException {
        Enrollment e = new Enrollment();
        e.setEnrollmentId(rs.getInt("enrollment_id"));
        e.setStudentId(rs.getInt("student_id"));
        e.setStudentName(rs.getString("student_name"));
        e.setStudentEmail(rs.getString("student_email"));
        e.setCourseId(rs.getInt("course_id"));
        e.setCourseCode(rs.getString("course_code"));
        e.setCourseTitle(rs.getString("course_title"));
        e.setEnrolledOn(rs.getTimestamp("enrolled_on"));
        e.setStatus(rs.getString("status"));
        return e;
    }
}
