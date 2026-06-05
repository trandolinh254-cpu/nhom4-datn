package com.example.asmnews.entity.order;






import java.util.Date;

/**
 * Entity đại diện cho đơn đặt báo
 * Lưu thông tin loại báo, gói thời gian, người nhận và trạng thái đơn
 */
public class Order {

    private int id;
    private String userId; // ID người đặt (nếu đã đăng nhập)
    private String newspaperType; // "print" hoặc "digital"
    private String packageDuration; // "3_months", "6_months", "12_months"
    private String fullName; // Họ tên người nhận
    private String phone; // Số điện thoại
    private String email; // Email
    private String city; // Tỉnh/Thành phố
    private String district; // Quận/Huyện
    private String ward; // Phường/Xã
    private String addressDetail; // Địa chỉ chi tiết
    private String note; // Ghi chú
    private int totalAmount; // Tổng tiền (VNĐ)
    private String status; // "pending", "confirmed", "cancelled"
    private Date createdDate; // Ngày tạo đơn
    
    // Thêm cho Premium
    private Date startDate; 
    private Date endDate;

    // === Constructor mặc định ===
    public Order() {
        this.status = "pending";
        this.createdDate = new Date();
    }

    // === Constructor đầy đủ ===
    public Order(String newspaperType, String packageDuration, String fullName,
            String phone, String email, String city, String district,
            String ward, String addressDetail, String note) {
        this();
        this.newspaperType = newspaperType;
        this.packageDuration = packageDuration;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.city = city;
        this.district = district;
        this.ward = ward;
        this.addressDetail = addressDetail;
        this.note = note;
        // Tự động tính tổng tiền dựa trên gói
        this.totalAmount = calculateAmount(packageDuration);
    }

    /**
     * Tính tổng tiền dựa trên gói thời gian
     * 
     * @param duration Gói thời gian: 3_months, 6_months, 12_months
     * @return Tổng tiền (VNĐ)
     */
    public static int calculateAmount(String duration) {
        if (duration == null)
            return 0;
        switch (duration) {
            case "3_months":
                return 250000;
            case "6_months":
                return 480000;
            case "12_months":
                return 900000;
            case "lifetime": // // FIX
                return 990000; // // FIX
            default:
                return 0;
        }
    }

    /**
     * Lấy tên hiển thị của gói thời gian
     */
    public String getPackageDisplayName() {
        if (packageDuration == null)
            return "";
        switch (packageDuration) {
            case "3_months":
                return "3 Tháng";
            case "6_months":
                return "6 Tháng";
            case "12_months":
                return "12 Tháng";
            case "lifetime": // // FIX
                return "Trọn Đời"; // // FIX
            default:
                return packageDuration;
        }
    }

    /**
     * Lấy tên hiển thị loại báo
     */
    public String getNewspaperDisplayName() {
        return "Báo Điện tử Premium";
    }

    // === Getter / Setter ===
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

    public String getNewspaperType() {
        return newspaperType;
    }

    public void setNewspaperType(String newspaperType) {
        this.newspaperType = newspaperType;
    }

    public String getPackageDuration() {
        return packageDuration;
    }

    public void setPackageDuration(String packageDuration) {
        this.packageDuration = packageDuration;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
