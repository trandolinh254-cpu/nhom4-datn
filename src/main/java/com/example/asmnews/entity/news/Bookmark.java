package com.example.asmnews.entity.news;

import java.util.Date;

/**
 * Thực thể Bookmark đại diện cho bài viết được lưu bởi độc giả để đọc sau
 * Đáp ứng yêu cầu RQ27
 */
public class Bookmark {
    private String userId;      // ID của độc giả lưu bài viết -- FIX
    private String newsId;      // ID của bài viết được lưu -- FIX
    private Date createdDate;   // Ngày lưu bài viết -- FIX

    // Constructor không tham số -- FIX
    public Bookmark() {
        this.createdDate = new Date();
    }

    // Constructor đầy đủ tham số -- FIX
    public Bookmark(String userId, String newsId, Date createdDate) {
        this.userId = userId;
        this.newsId = newsId;
        this.createdDate = createdDate != null ? createdDate : new Date();
    }

    // --- Getters & Setters --- -- FIX
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getNewsId() {
        return newsId;
    }

    public void setNewsId(String newsId) {
        this.newsId = newsId;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
