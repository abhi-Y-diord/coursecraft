package com.ocms.model;

import java.sql.Timestamp;

public class Announcement {
    private int announcementId;
    private Integer courseId;
    private String courseCode;
    private String courseTitle;
    private int postedBy;
    private String postedByName;
    private String title;
    private String message;
    private Timestamp postedOn;

    public Announcement() {}

    public int getAnnouncementId() { return announcementId; }
    public void setAnnouncementId(int announcementId) { this.announcementId = announcementId; }

    public Integer getCourseId() { return courseId; }
    public void setCourseId(Integer courseId) { this.courseId = courseId; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }

    public int getPostedBy() { return postedBy; }
    public void setPostedBy(int postedBy) { this.postedBy = postedBy; }

    public String getPostedByName() { return postedByName; }
    public void setPostedByName(String postedByName) { this.postedByName = postedByName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getPostedOn() { return postedOn; }
    public void setPostedOn(Timestamp postedOn) { this.postedOn = postedOn; }

    public boolean isGlobal() { return courseId == null || courseId == 0; }
}
