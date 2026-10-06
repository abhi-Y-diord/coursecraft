package com.ocms.dao;

import com.ocms.model.Submission;
import com.ocms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubmissionDAO {

    public Submission getById(int submissionId) {
        String sql = "SELECT s.*, a.title AS assignment_title, a.due_date, a.max_marks, a.course_id, " +
                     "c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM submissions s " +
                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "WHERE s.submission_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, submissionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapSubmission(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Submission getByAssignmentAndStudent(int assignmentId, int studentId) {
        String sql = "SELECT s.*, a.title AS assignment_title, a.due_date, a.max_marks, a.course_id, " +
                     "c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM submissions s " +
                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "WHERE s.assignment_id = ? AND s.student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignmentId);
            stmt.setInt(2, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapSubmission(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertOrUpdate(Submission submission) {
        Submission existing = getByAssignmentAndStudent(submission.getAssignmentId(), submission.getStudentId());
        if (existing != null) {
            String sql = "UPDATE submissions SET file_path = ?, submitted_on = CURRENT_TIMESTAMP WHERE submission_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, submission.getFilePath());
                stmt.setInt(2, existing.getSubmissionId());
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        } else {
            String sql = "INSERT INTO submissions (assignment_id, student_id, file_path) VALUES (?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, submission.getAssignmentId());
                stmt.setInt(2, submission.getStudentId());
                stmt.setString(3, submission.getFilePath());
                int affected = stmt.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                        if (rs.next()) submission.setSubmissionId(rs.getInt(1));
                    }
                    return true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        }
    }

    public boolean updateGrade(int submissionId, int marksObtained, String feedback) {
        String sql = "UPDATE submissions SET marks_obtained = ?, feedback = ? WHERE submission_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, marksObtained);
            stmt.setString(2, feedback);
            stmt.setInt(3, submissionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Submission> getUngradedForFaculty(int facultyId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, a.title AS assignment_title, a.due_date, a.max_marks, a.course_id, " +
                     "c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM submissions s " +
                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "WHERE c.faculty_id = ? AND s.marks_obtained IS NULL " +
                     "ORDER BY s.submitted_on ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, facultyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubmission(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Submission> getByAssignment(int assignmentId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, a.title AS assignment_title, a.due_date, a.max_marks, a.course_id, " +
                     "c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM submissions s " +
                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "WHERE s.assignment_id = ? ORDER BY u.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubmission(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Submission> getRecentGradedForStudent(int studentId, int limit) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, a.title AS assignment_title, a.due_date, a.max_marks, a.course_id, " +
                     "c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM submissions s " +
                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "WHERE s.student_id = ? AND s.marks_obtained IS NOT NULL " +
                     "ORDER BY s.submitted_on DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubmission(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Submission> getByCourse(int courseId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, a.title AS assignment_title, a.due_date, a.max_marks, a.course_id, " +
                     "c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM submissions s " +
                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "WHERE c.course_id = ? ORDER BY s.submitted_on DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubmission(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Submission> getByStudentAndCourse(int studentId, int courseId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.*, a.title AS assignment_title, a.due_date, a.max_marks, a.course_id, " +
                     "c.course_code, c.title AS course_title, u.name AS student_name, u.email AS student_email " +
                     "FROM submissions s " +
                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                     "JOIN courses c ON a.course_id = c.course_id " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "WHERE s.student_id = ? AND c.course_id = ? ORDER BY a.due_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubmission(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Submission mapSubmission(ResultSet rs) throws SQLException {
        Submission s = new Submission();
        s.setSubmissionId(rs.getInt("submission_id"));
        s.setAssignmentId(rs.getInt("assignment_id"));
        s.setAssignmentTitle(rs.getString("assignment_title"));
        s.setDueDate(rs.getDate("due_date"));
        s.setMaxMarks(rs.getInt("max_marks"));
        s.setCourseId(rs.getInt("course_id"));
        s.setCourseCode(rs.getString("course_code"));
        s.setCourseTitle(rs.getString("course_title"));
        s.setStudentId(rs.getInt("student_id"));
        s.setStudentName(rs.getString("student_name"));
        s.setStudentEmail(rs.getString("student_email"));
        s.setFilePath(rs.getString("file_path"));
        s.setSubmittedOn(rs.getTimestamp("submitted_on"));
        int m = rs.getInt("marks_obtained");
        if (!rs.wasNull()) s.setMarksObtained(m);
        s.setFeedback(rs.getString("feedback"));
        return s;
    }
}
