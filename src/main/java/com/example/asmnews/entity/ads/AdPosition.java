package com.example.asmnews.entity.ads;

/**
 * Lớp đại diện cho Cấu hình Vị trí & Bảng giá Quảng cáo.
 * Tương ứng với bảng 'ad_positions' trong Database.
 */
public class AdPosition {
    private int id;
    private String platform; // 'ONLINE' hoặc 'PRINT'
    private String name; // Tên vị trí hiển thị
    private String sizeDesc; // Mô tả kích thước
    private double basePrice; // Đơn giá chuẩn
    private String status; // Trạng thái hoạt động

    // 1. Empty Constructor (Dành cho truy vấn DB)
    public AdPosition() {
    }

    // 2. Full Constructor
    public AdPosition(int id, String platform, String name, String sizeDesc, double basePrice, String status) {
        this.id = id;
        this.platform = platform;
        this.name = name;
        this.sizeDesc = sizeDesc;
        this.basePrice = basePrice;
        this.status = status;
    }

    // 3. Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSizeDesc() {
        return sizeDesc;
    }

    public void setSizeDesc(String sizeDesc) {
        this.sizeDesc = sizeDesc;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}