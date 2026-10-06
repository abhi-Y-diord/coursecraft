-- CourseCraft Additive UI/UX Enhancements Schema
USE course_management;

ALTER TABLE courses ADD COLUMN course_code VARCHAR(10) UNIQUE AFTER course_id;
ALTER TABLE materials ADD COLUMN type ENUM('FILE', 'LINK') DEFAULT 'FILE' AFTER title;
ALTER TABLE materials ADD COLUMN week_no INT DEFAULT 1 AFTER type;
ALTER TABLE assignments ADD COLUMN week_no INT DEFAULT 1 AFTER due_date;
ALTER TABLE users ADD COLUMN last_login TIMESTAMP NULL AFTER created_at;

CREATE TABLE IF NOT EXISTS announcement_dismissals (
    user_id INT NOT NULL,
    announcement_id INT NOT NULL,
    PRIMARY KEY (user_id, announcement_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (announcement_id) REFERENCES announcements(announcement_id) ON DELETE CASCADE
);

CREATE INDEX idx_enroll_course ON enrollments(course_id, status);
CREATE INDEX idx_sub_assign ON submissions(assignment_id, student_id);
CREATE INDEX idx_att_course_day ON attendance(course_id, session_date);
