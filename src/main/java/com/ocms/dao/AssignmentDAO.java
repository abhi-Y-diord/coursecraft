package com.ocms.dao;

import com.ocms.model.Assignment;
import com.ocms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAO {

    public Assignment getById(int assignmentId) {
        String sql = "SELECT a.*, c.course_code, c.title AS course_title FROM assignments a " +
                     "JOIN courses c ON a.course_id = c.course_id WHERE a.assignment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapAssignment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Assignment> getByCourse(int courseId) {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.*, c.course_code, c.title AS course_title FROM assignments a " +
                     "JOIN courses c ON a.course_id = c.course_id WHERE a.course_id = ? ORDER BY a.due_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAssignment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Assignment> getUpcomingForStudent(int studentId, int limit) {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.*, c.course_code, c.title AS course_title FROM assignments a " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN enrollments e ON c.course_id = e.course_id " +
                     "LEFT JOIN submissions sub ON a.assignment_id = sub.assignment_id AND sub.student_id = ? " +
                     "WHERE e.student_id = ? AND e.status = 'ACTIVE' AND sub.submission_id IS NULL " +
                     "ORDER BY a.due_date ASC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, studentId);
            stmt.setInt(3, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAssignment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(Assignment assignment) {
        String sql = "INSERT INTO assignments (course_id, title, description, due_date, max_marks, week_no) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, assignment.getCourseId());
            stmt.setString(2, assignment.getTitle());
            stmt.setString(3, assignment.getDescription());
            stmt.setDate(4, assignment.getDueDate());
            stmt.setInt(5, assignment.getMaxMarks() > 0 ? assignment.getMaxMarks() : 100);
            stmt.setInt(6, assignment.getWeekNo() > 0 ? assignment.getWeekNo() : 1);

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) assignment.setAssignmentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Assignment assignment) {
        String sql = "UPDATE assignments SET title = ?, description = ?, due_date = ?, max_marks = ?, week_no = ? WHERE assignment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, assignment.getTitle());
            stmt.setString(2, assignment.getDescription());
            stmt.setDate(3, assignment.getDueDate());
            stmt.setInt(4, assignment.getMaxMarks());
            stmt.setInt(5, assignment.getWeekNo());
            stmt.setInt(6, assignment.getAssignmentId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int assignmentId) {
        String sql = "DELETE FROM assignments WHERE assignment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Assignment mapAssignment(ResultSet rs) throws SQLException {
        Assignment a = new Assignment();
        a.setAssignmentId(rs.getInt("assignment_id"));
        a.setCourseId(rs.getInt("course_id"));
        a.setCourseCode(rs.getString("course_code"));
        a.setCourseTitle(rs.getString("course_title"));
        a.setTitle(rs.getString("title"));
        a.setDescription(rs.getString("description"));
        a.setDueDate(rs.getDate("due_date"));
        a.setMaxMarks(rs.getInt("max_marks"));
        a.setWeekNo(rs.getInt("week_no"));
        return a;
    }
}
