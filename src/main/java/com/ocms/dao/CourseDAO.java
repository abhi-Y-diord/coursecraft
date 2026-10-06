package com.ocms.dao;

import com.ocms.model.Course;
import com.ocms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    public Course getById(int courseId) {
        String sql = "SELECT c.*, cat.name AS category_name, u.name AS faculty_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.category_id " +
                     "LEFT JOIN users u ON c.faculty_id = u.user_id " +
                     "WHERE c.course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapCourse(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Course getByCode(String courseCode) {
        String sql = "SELECT c.*, cat.name AS category_name, u.name AS faculty_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.category_id " +
                     "LEFT JOIN users u ON c.faculty_id = u.user_id " +
                     "WHERE c.course_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, courseCode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapCourse(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Course course) {
        String sql = "INSERT INTO courses (course_code, title, description, category_id, faculty_id, capacity, duration_weeks, thumbnail_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getTitle());
            stmt.setString(3, course.getDescription());
            if (course.getCategoryId() != null) stmt.setInt(4, course.getCategoryId());
            else stmt.setNull(4, Types.INTEGER);
            if (course.getFacultyId() != null) stmt.setInt(5, course.getFacultyId());
            else stmt.setNull(5, Types.INTEGER);
            stmt.setInt(6, course.getCapacity());
            stmt.setInt(7, course.getDurationWeeks());
            stmt.setString(8, course.getThumbnailUrl());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        course.setCourseId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Course course) {
        String sql = "UPDATE courses SET course_code = ?, title = ?, description = ?, category_id = ?, faculty_id = ?, capacity = ?, duration_weeks = ?, thumbnail_url = ? WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getTitle());
            stmt.setString(3, course.getDescription());
            if (course.getCategoryId() != null) stmt.setInt(4, course.getCategoryId());
            else stmt.setNull(4, Types.INTEGER);
            if (course.getFacultyId() != null) stmt.setInt(5, course.getFacultyId());
            else stmt.setNull(5, Types.INTEGER);
            stmt.setInt(6, course.getCapacity());
            stmt.setInt(7, course.getDurationWeeks());
            stmt.setString(8, course.getThumbnailUrl());
            stmt.setInt(9, course.getCourseId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int courseId) {
        String sql = "DELETE FROM courses WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Course> getByFaculty(int facultyId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, cat.name AS category_name, u.name AS faculty_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.category_id " +
                     "LEFT JOIN users u ON c.faculty_id = u.user_id " +
                     "WHERE c.faculty_id = ? ORDER BY c.course_code ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, facultyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapCourse(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Course> getOpenCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, cat.name AS category_name, u.name AS faculty_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.category_id " +
                     "LEFT JOIN users u ON c.faculty_id = u.user_id " +
                     "HAVING (c.capacity - enrolled_count) > 0 " +
                     "ORDER BY c.course_code ASC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                courses.add(mapCourse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Course> search(String keyword, List<Integer> categoryIds, Integer minWeeks, Integer maxWeeks, String availability, String sort, int offset, int limit) {
        List<Course> courses = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, cat.name AS category_name, u.name AS faculty_name, " +
            "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
            "FROM courses c " +
            "LEFT JOIN categories cat ON c.category_id = cat.category_id " +
            "LEFT JOIN users u ON c.faculty_id = u.user_id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (c.title LIKE ? OR c.course_code LIKE ? OR c.description LIKE ?)");
            String k = "%" + keyword + "%";
            params.add(k);
            params.add(k);
            params.add(k);
        }

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND c.category_id IN (");
            for (int i = 0; i < categoryIds.size(); i++) {
                sql.append(i == 0 ? "?" : ", ?");
                params.add(categoryIds.get(i));
            }
            sql.append(")");
        }

        if (minWeeks != null && minWeeks > 0) {
            sql.append(" AND c.duration_weeks >= ?");
            params.add(minWeeks);
        }

        if (maxWeeks != null && maxWeeks > 0) {
            sql.append(" AND c.duration_weeks <= ?");
            params.add(maxWeeks);
        }

        if ("open".equalsIgnoreCase(availability)) {
            sql.append(" HAVING (c.capacity - enrolled_count) > 0");
        } else if ("full".equalsIgnoreCase(availability)) {
            sql.append(" HAVING (c.capacity - enrolled_count) <= 0");
        }

        // Whitelisted sorting
        if ("title_asc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY c.title ASC");
        } else if ("seats_desc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY (c.capacity - enrolled_count) DESC");
        } else if ("duration_asc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY c.duration_weeks ASC");
        } else {
            sql.append(" ORDER BY c.course_code ASC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapCourse(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public int countSearch(String keyword, List<Integer> categoryIds, Integer minWeeks, Integer maxWeeks, String availability) {
        StringBuilder sql = new StringBuilder(
            "SELECT c.course_id, c.capacity, " +
            "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
            "FROM courses c WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (c.title LIKE ? OR c.course_code LIKE ? OR c.description LIKE ?)");
            String k = "%" + keyword + "%";
            params.add(k);
            params.add(k);
            params.add(k);
        }

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND c.category_id IN (");
            for (int i = 0; i < categoryIds.size(); i++) {
                sql.append(i == 0 ? "?" : ", ?");
                params.add(categoryIds.get(i));
            }
            sql.append(")");
        }

        if (minWeeks != null && minWeeks > 0) {
            sql.append(" AND c.duration_weeks >= ?");
            params.add(minWeeks);
        }

        if (maxWeeks != null && maxWeeks > 0) {
            sql.append(" AND c.duration_weeks <= ?");
            params.add(maxWeeks);
        }

        if ("open".equalsIgnoreCase(availability)) {
            sql.append(" HAVING (c.capacity - enrolled_count) > 0");
        } else if ("full".equalsIgnoreCase(availability)) {
            sql.append(" HAVING (c.capacity - enrolled_count) <= 0");
        }

        String wrapSql = "SELECT COUNT(*) FROM (" + sql.toString() + ") AS count_tbl";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(wrapSql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM courses";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Course> getUnassignedCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, cat.name AS category_name, NULL AS faculty_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
                     "FROM courses c LEFT JOIN categories cat ON c.category_id = cat.category_id " +
                     "WHERE c.faculty_id IS NULL ORDER BY c.course_code ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                courses.add(mapCourse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Course> getFullCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, cat.name AS category_name, u.name AS faculty_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'ACTIVE') AS enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.category_id " +
                     "LEFT JOIN users u ON c.faculty_id = u.user_id " +
                     "HAVING enrolled_count >= c.capacity ORDER BY c.course_code ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                courses.add(mapCourse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    private Course mapCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setCourseCode(rs.getString("course_code"));
        course.setTitle(rs.getString("title"));
        course.setDescription(rs.getString("description"));
        int catId = rs.getInt("category_id");
        if (!rs.wasNull()) course.setCategoryId(catId);
        course.setCategoryName(rs.getString("category_name"));
        int facId = rs.getInt("faculty_id");
        if (!rs.wasNull()) course.setFacultyId(facId);
        course.setFacultyName(rs.getString("faculty_name"));
        course.setCapacity(rs.getInt("capacity"));
        course.setDurationWeeks(rs.getInt("duration_weeks"));
        course.setThumbnailUrl(rs.getString("thumbnail_url"));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        course.setEnrolledCount(rs.getInt("enrolled_count"));
        return course;
    }
}
