package com.ocms.model;

import java.sql.Timestamp;

public class Material {
    private int materialId;
    private int courseId;
    private String title;
    private String type; // FILE or LINK
    private int weekNo;
    private String filePath;
    private Timestamp uploadedOn;

    public Material() {}

    public int getMaterialId() { return materialId; }
    public void setMaterialId(int materialId) { this.materialId = materialId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getWeekNo() { return weekNo; }
    public void setWeekNo(int weekNo) { this.weekNo = weekNo; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public Timestamp getUploadedOn() { return uploadedOn; }
    public void setUploadedOn(Timestamp uploadedOn) { this.uploadedOn = uploadedOn; }
}
