package com.ocms.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Submission {
    private int submissionId;
    private int assignmentId;
    private String assignmentTitle;
    private Date dueDate;
    private int maxMarks;
    private int courseId;
    private String courseCode;
    private String courseTitle;
    private int studentId;
    private String studentName;
    private String studentEmail;
    private String filePath;
    private Timestamp submittedOn;
    private Integer marksObtained;
    private String feedback;

    public Submission() {}

    public int getSubmissionId() { return submissionId; }
    public void setSubmissionId(int submissionId) { this.submissionId = submissionId; }

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }

    public String getAssignmentTitle() { return assignmentTitle; }
    public void setAssignmentTitle(String assignmentTitle) { this.assignmentTitle = assignmentTitle; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public int getMaxMarks() { return maxMarks; }
    public void setMaxMarks(int maxMarks) { this.maxMarks = maxMarks; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public Timestamp getSubmittedOn() { return submittedOn; }
    public void setSubmittedOn(Timestamp submittedOn) { this.submittedOn = submittedOn; }

    public Integer getMarksObtained() { return marksObtained; }
    public void setMarksObtained(Integer marksObtained) { this.marksObtained = marksObtained; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public boolean isGraded() { return marksObtained != null; }

    public boolean isLate() {
        if (submittedOn == null || dueDate == null) return false;
        // Compare date part of submittedOn with dueDate
        return submittedOn.getTime() > (dueDate.getTime() + 86400000L); // 24 hrs grace window for due date
    }
}
