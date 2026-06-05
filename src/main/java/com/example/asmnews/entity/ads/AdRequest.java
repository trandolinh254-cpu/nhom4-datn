package com.example.asmnews.entity.ads;

import java.util.Date;

/**
 * Lớp đại diện cho Yêu cầu/Đơn đặt hàng Quảng Cáo của Khách hàng.
 * Tương ứng với bảng 'ad_requests' trong Database.
 */
public class AdRequest {
    private int id;
    private String userId; // ID Khách hàng đặt đơn
    private int positionId; // ID Vị trí được chọn
    private String campaignName; // Tên chiến dịch
    private Date startDate; // Ngày bắt đầu
    private String duration; // Thời lượng chạy
    private String targetUrl; // Link Landing Page
    private String driveUrl; // Link Drive file thiết kế

    // Thông tin thanh toán & liên hệ
    private String contactName;
    private String phone;
    private String email;
    private String companyName;
    private String billingAddress;

    private double totalPrice; // Tổng tiền
    private String status; // Trạng thái đơn (PENDING, APPROVED...)
    private Date createdAt; // Thời gian tạo đơn

    private Date endDate;
    private String imageUrl;
    private Integer approvedBy;

    public AdRequest(Date endDate, String imageUrl, Integer approvedBy) {
        this.endDate = endDate;
        this.imageUrl = imageUrl;
        this.approvedBy = approvedBy;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    // 1. Empty Constructor
    public AdRequest() {
    }

    // 2. Full Constructor
    public AdRequest(int id, String userId, int positionId, String campaignName, Date startDate, String duration,
            String targetUrl, String driveUrl, String contactName, String phone, String email,
            String companyName, String billingAddress, double totalPrice, String status, Date createdAt) {
        this.id = id;
        this.userId = userId;
        this.positionId = positionId;
        this.campaignName = campaignName;
        this.startDate = startDate;
        this.duration = duration;
        this.targetUrl = targetUrl;
        this.driveUrl = driveUrl;
        this.contactName = contactName;
        this.phone = phone;
        this.email = email;
        this.companyName = companyName;
        this.billingAddress = billingAddress;
        this.totalPrice = totalPrice;
        this.status = status;
        this.createdAt = createdAt;
    }

    // 3. Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getPositionId() {
        return positionId;
    }

    public void setPositionId(int positionId) {
        this.positionId = positionId;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public void setCampaignName(String campaignName) {
        this.campaignName = campaignName;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getTargetUrl() {
        return targetUrl;
    }

    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }

    public String getDriveUrl() {
        return driveUrl;
    }

    public void setDriveUrl(String driveUrl) {
        this.driveUrl = driveUrl;
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getBillingAddress() {
        return billingAddress;
    }

    public void setBillingAddress(String billingAddress) {
        this.billingAddress = billingAddress;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}