package com.example.asmnews.entity.news;

import java.util.Date;

/**
 * Thực thể Follow đại diện cho mối quan hệ theo dõi giữa Độc giả và Nhà báo (Phóng viên)
 * Đáp ứng yêu cầu RQ22
 */
public class Follow {
    private String followerId; // ID của độc giả theo dõi -- FIX
    private String authorId;   // ID của tác giả/nhà báo được theo dõi -- FIX
    private Date createdDate;  // Ngày bắt đầu theo dõi -- FIX

    // Constructor không tham số -- FIX
    public Follow() {
        this.createdDate = new Date();
    }

    // Constructor đầy đủ tham số -- FIX
    public Follow(String followerId, String authorId, Date createdDate) {
        this.followerId = followerId;
        this.authorId = authorId;
        this.createdDate = createdDate != null ? createdDate : new Date();
    }

    // --- Getters & Setters --- -- FIX
    public String getFollowerId() {
        return followerId;
    }

    public void setFollowerId(String followerId) {
        this.followerId = followerId;
    }

    public String getAuthorId() {
        return authorId;
    }

    public void setAuthorId(String authorId) {
        this.authorId = authorId;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
