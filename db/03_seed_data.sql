-- CourseCraft Realistic Seed Data
-- Passwords for all demo accounts:
-- admin@coursecraft.edu -> admin123
-- meera.iyer@coursecraft.edu -> faculty123
-- rahul.deshmukh@coursecraft.edu -> faculty123
-- imran.shaikh@coursecraft.edu -> faculty123
-- ananya.gupta@coursecraft.edu -> student123
-- karan.mehta@coursecraft.edu -> student123
-- sneha.patil@coursecraft.edu -> student123
-- rohit.verma@coursecraft.edu -> student123
-- vikram.singh@coursecraft.edu -> student123

USE course_management;

-- 1. Users
INSERT INTO users (user_id, name, email, password, role, status, phone, created_at) VALUES
(1, 'System Administrator', 'admin@coursecraft.edu', '$2a$10$ptfhLv.rilBjsS6E7VnNT.XskhVOkbS62tVQNYHsHQLkd0eRTQmjK', 'ADMIN', 'ACTIVE', '9876543210', '2026-01-10 09:00:00'),
(2, 'Dr. Meera Iyer', 'meera.iyer@coursecraft.edu', '$2a$10$TCw2hQQyVaUdQKzqvnwlOOjxv1nTT5wGcwWufbAG4oP/f1i10a1AC', 'FACULTY', 'ACTIVE', '9876543211', '2026-01-12 10:00:00'),
(3, 'Prof. Rahul Deshmukh', 'rahul.deshmukh@coursecraft.edu', '$2a$10$TCw2hQQyVaUdQKzqvnwlOOjxv1nTT5wGcwWufbAG4oP/f1i10a1AC', 'FACULTY', 'ACTIVE', '9876543212', '2026-01-14 11:30:00'),
(4, 'Imran Shaikh', 'imran.shaikh@coursecraft.edu', '$2a$10$TCw2hQQyVaUdQKzqvnwlOOjxv1nTT5wGcwWufbAG4oP/f1i10a1AC', 'FACULTY', 'PENDING', '9876543213', '2026-10-01 14:20:00'),
(5, 'Ananya Gupta', 'ananya.gupta@coursecraft.edu', '$2a$10$GhJH3.nStVZo7Qzh0gnCN.di3eN8zx3mlNjfPc4BHrwVCs5T4sKbe', 'STUDENT', 'ACTIVE', '9876543214', '2026-01-15 08:30:00'),
(6, 'Karan Mehta', 'karan.mehta@coursecraft.edu', '$2a$10$GhJH3.nStVZo7Qzh0gnCN.di3eN8zx3mlNjfPc4BHrwVCs5T4sKbe', 'STUDENT', 'ACTIVE', '9876543215', '2026-01-16 09:15:00'),
(7, 'Sneha Patil', 'sneha.patil@coursecraft.edu', '$2a$10$GhJH3.nStVZo7Qzh0gnCN.di3eN8zx3mlNjfPc4BHrwVCs5T4sKbe', 'STUDENT', 'ACTIVE', '9876543216', '2026-01-17 10:45:00'),
(8, 'Rohit Verma', 'rohit.verma@coursecraft.edu', '$2a$10$GhJH3.nStVZo7Qzh0gnCN.di3eN8zx3mlNjfPc4BHrwVCs5T4sKbe', 'STUDENT', 'ACTIVE', '9876543217', '2026-01-18 11:00:00'),
(9, 'Vikram Singh', 'vikram.singh@coursecraft.edu', '$2a$10$GhJH3.nStVZo7Qzh0gnCN.di3eN8zx3mlNjfPc4BHrwVCs5T4sKbe', 'STUDENT', 'ACTIVE', '9876543218', '2026-01-19 13:20:00');

-- 2. Categories
INSERT INTO categories (category_id, name) VALUES
(1, 'Core Computer Science'),
(2, 'Artificial Intelligence'),
(3, 'Mathematics'),
(4, 'Humanities'),
(5, 'Electives');

-- 3. Courses
INSERT INTO courses (course_id, course_code, title, description, category_id, faculty_id, capacity, duration_weeks, created_at) VALUES
(1, 'CS201', 'Data Structures and Algorithms', 'Fundamental algorithms, linear data structures, trees, graphs, hashing, and complexity analysis.', 1, 2, 30, 8, '2026-02-01 10:00:00'),
(2, 'CS305', 'Database Management Systems', 'Relational data model, SQL, normalization, indexing, transaction processing, and concurrency control.', 1, 3, 30, 10, '2026-02-02 10:00:00'),
(3, 'CS312', 'Operating Systems', 'Process management, memory allocation, storage subsystems, concurrency synchronization, and distributed filesystems.', 1, 2, 25, 12, '2026-02-03 10:00:00'),
(4, 'AI301', 'Machine Learning Fundamentals', 'Supervised and unsupervised learning, regression models, classification algorithms, evaluation metrics, and neural nets.', 2, 3, 5, 10, '2026-02-04 10:00:00'),
(5, 'MA204', 'Probability and Statistics', 'Random variables, probability distributions, hypothesis testing, confidence intervals, and regression analysis.', 3, 2, 40, 8, '2026-02-05 10:00:00'),
(6, 'HS101', 'Technical Communication', 'Written and oral communication techniques for software engineering, technical documentation, and project presentations.', 4, 3, 50, 6, '2026-02-06 10:00:00'),
(7, 'CS402', 'Computer Networks', 'OSI model, TCP/IP stack, socket programming, routing algorithms, wireless networks, and network security.', 1, NULL, 35, 8, '2026-02-07 10:00:00'),
(8, 'AI405', 'Deep Learning', 'Deep neural networks, convolutional networks for vision, recurrent architectures, and transformer models.', 2, 3, 20, 10, '2026-02-08 10:00:00');

-- 4. Enrollments
-- Note: AI301 capacity is 5. We enroll 5 students so it becomes FULL.
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_on, status) VALUES
(1, 5, 1, '2026-02-10 09:00:00', 'ACTIVE'),
(2, 6, 1, '2026-02-10 09:15:00', 'ACTIVE'),
(3, 7, 1, '2026-02-10 10:00:00', 'ACTIVE'),
(4, 8, 1, '2026-02-10 11:00:00', 'ACTIVE'),

(5, 5, 2, '2026-02-11 09:30:00', 'ACTIVE'),
(6, 6, 2, '2026-02-11 10:15:00', 'ACTIVE'),
(7, 7, 2, '2026-02-11 11:00:00', 'ACTIVE'),

(8, 5, 4, '2026-02-12 08:00:00', 'ACTIVE'),
(9, 6, 4, '2026-02-12 08:05:00', 'ACTIVE'),
(10, 7, 4, '2026-02-12 08:10:00', 'ACTIVE'),
(11, 8, 4, '2026-02-12 08:15:00', 'ACTIVE'),
(12, 9, 4, '2026-02-12 08:20:00', 'ACTIVE'),

(13, 8, 5, '2026-02-13 14:00:00', 'ACTIVE'),
(14, 9, 5, '2026-02-13 15:00:00', 'ACTIVE');

-- 5. Materials
INSERT INTO materials (material_id, course_id, title, type, week_no, file_path, uploaded_on) VALUES
(1, 1, 'Syllabus and Course Overview', 'FILE', 1, 'uploads/cs201_syllabus.pdf', '2026-02-15 10:00:00'),
(2, 1, 'Lecture 1 Notes: Arrays and Linked Lists', 'FILE', 1, 'uploads/cs201_lec1.pdf', '2026-02-16 11:00:00'),
(3, 1, 'Visualizing Binary Search Trees', 'LINK', 2, 'https://visualgo.net/en/bst', '2026-02-20 09:30:00'),
(4, 2, 'Relational Algebra Reference Guide', 'FILE', 1, 'uploads/cs305_rel_alg.pdf', '2026-02-18 14:00:00'),
(5, 4, 'Introduction to Supervised Learning', 'FILE', 1, 'uploads/ai301_intro.pdf', '2026-02-19 16:00:00');

-- 6. Assignments
INSERT INTO assignments (assignment_id, course_id, title, description, due_date, max_marks, week_no) VALUES
(1, 1, 'Assignment 1: Linked List Operations', 'Implement a doubly linked list with insertion, deletion, and reverse operations in Java.', '2026-09-15', 100, 1),
(2, 1, 'Assignment 2: Binary Search Tree Balancing', 'Implement AVL tree insertion and rotation logic. Measure depth before and after balancing.', '2026-10-15', 100, 3),
(3, 2, 'Assignment 1: SQL Schema Design and Queries', 'Design a schema for a library management system and write complex SQL queries using JOINs and GROUP BY.', '2026-09-20', 100, 2),
(4, 4, 'Assignment 1: Linear Regression from Scratch', 'Implement gradient descent for simple linear regression without using external ML libraries.', '2026-10-20', 100, 2);

-- 7. Submissions
INSERT INTO submissions (submission_id, assignment_id, student_id, file_path, submitted_on, marks_obtained, feedback) VALUES
-- Assignment 1 (CS201): Graded submissions
(1, 1, 5, 'uploads/sub_ananya_assign1.pdf', '2026-09-14 18:30:00', 92, 'Good approach; edge case for empty list is missing.'),
(2, 1, 6, 'uploads/sub_karan_assign1.pdf', '2026-09-14 20:15:00', 85, 'Well structured implementation. Consider optimizing node pointer updates.'),
-- Assignment 1 (CS201): Ungraded submission
(3, 1, 7, 'uploads/sub_sneha_assign1.pdf', '2026-09-15 11:00:00', NULL, NULL),

-- Assignment 3 (CS305): Ungraded submission
(4, 3, 5, 'uploads/sub_ananya_sql.pdf', '2026-09-19 22:00:00', NULL, NULL),
(5, 3, 6, 'uploads/sub_karan_sql.pdf', '2026-09-20 09:45:00', 90, 'Exemplary query formatting and correct constraint definitions.');

-- 8. Attendance
INSERT INTO attendance (attendance_id, course_id, student_id, session_date, status) VALUES
(1, 1, 5, '2026-09-01', 'PRESENT'),
(2, 1, 6, '2026-09-01', 'PRESENT'),
(3, 1, 7, '2026-09-01', 'ABSENT'),
(4, 1, 8, '2026-09-01', 'PRESENT'),

(5, 1, 5, '2026-09-08', 'PRESENT'),
(6, 1, 6, '2026-09-08', 'PRESENT'),
(7, 1, 7, '2026-09-08', 'PRESENT'),
(8, 1, 8, '2026-09-08', 'ABSENT'),

(9, 2, 5, '2026-09-05', 'PRESENT'),
(10, 2, 6, '2026-09-05', 'PRESENT'),
(11, 2, 7, '2026-09-05', 'PRESENT');

-- 9. Announcements
INSERT INTO announcements (announcement_id, course_id, posted_by, title, message, posted_on) VALUES
(1, NULL, 1, 'Mid-semester Examination Schedule', 'Mid-semester examination schedule has been published. Check individual course pages for specific room allocations.', '2026-09-25 10:00:00'),
(2, NULL, 1, 'Library Service Hours Update', 'The central library will remain open until 22:00 during the examination period.', '2026-09-28 09:00:00'),
(3, 1, 2, 'Lab Session Rescheduled', 'The Data Structures lab session scheduled for Friday has been moved to Thursday at 14:00 in Computer Lab 3.', '2026-09-29 11:30:00'),
(4, 2, 3, 'Guest Lecture on Distributed Databases', 'Join us on 15 October for an online guest lecture on distributed transactions by Dr. S. Rao.', '2026-10-02 15:00:00');
