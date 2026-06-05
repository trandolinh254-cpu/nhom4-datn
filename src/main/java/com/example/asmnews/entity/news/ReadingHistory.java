package com.example.asmnews.entity.news;

import java.util.Date;

/**
 * Thực thể ReadingHistory đại diện cho lịch sử bài viết đã đọc của độc giả
 * Đáp ứng yêu cầu RQ25 (Lưu trữ tối đa 50 bài viết gần nhất)
 */
public class ReadingHistory {
    private String userId;   // ID của độc giả đã đọc -- FIX
    private String newsId;   // ID của bài viết đã đọc -- FIX
    private Date readDate;   // Thời gian đọc bài viết -- FIX

    // Constructor không tham số -- FIX
    public ReadingHistory() {
        this.readDate = new Date();
    }

    // Constructor đầy đủ tham số -- FIX
    public ReadingHistory(String userId, String newsId, Date readDate) {
        this.userId = userId;
        this.newsId = newsId;
        this.readDate = readDate != null ? readDate : new Date();
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

    public Date getReadDate() {
        return readDate;
    }

    public void setReadDate(Date readDate) {
        this.readDate = readDate;
    }
}
