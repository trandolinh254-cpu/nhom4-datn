package com.example.asmnews.entity.auth;






import java.util.Date;

/**
 * Entity class cho bảng Users
 * Đại diện cho người dùng (Quản trị viên, Phóng viên, Độc giả)
 */
public class User {
    // [NOTE_CHO_BẠN]: Đổi giá trị ở đây nếu DB của bạn quy ước số khác.
    // Dùng Integer để mapping cực nhanh với kiểu TINYINT trong MySQL/SQL Server.
    public static final int ROLE_REPORTER = 0; // Thay thế cho false cũ
    public static final int ROLE_ADMIN = 1; // Thay thế cho true cũ
    public static final int ROLE_READER = 2; // Vai trò mới thêm vào

    private String id;
    private String password;
    private String fullname;
    private Date birthday;
    private Boolean gender;
    private String mobile;
    private String email;

    // [SỬA DÒNG NÀY]: Đổi từ Boolean sang Integer
    private Integer role;
    private boolean isActive = true;

    private String avatar;

    // Các trường mới phục vụ Bút danh, Tiểu sử, Khóa tài khoản do sai mật khẩu
    private String penName;
    private String bio;
    private Integer failedLoginAttempts = 0;
    private Date lockoutTime;


    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public User() {
    }

    // [SỬA DÒNG NÀY]: Cập nhật tham số constructor Integer role
    public User(String id, String password, String fullname, Date birthday,
            Boolean gender, String mobile, String email, Integer role) {
        this.id = id;
        this.password = password;
        this.fullname = fullname;
        this.birthday = birthday;
        this.gender = gender;
        this.mobile = mobile;
        this.email = email;
        this.role = role;
        this.isActive = true;
    }

    // --- Các Getters/Setters giữ nguyên (ẩn đi cho gọn) ---
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // [SỬA DÒNG NÀY]: Cập nhật getter/setter cho role
    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }

    // --- Phương thức tiện ích (Helper Methods) ---

    // Kiểm tra null an toàn trước khi so sánh (Security & Null Safety)
    public boolean isAdmin() {
        return role != null && role == ROLE_ADMIN;
    }

    public boolean isReporter() {
        return role != null && role == ROLE_REPORTER;
    }

    // [THÊM MỚI]: Hàm kiểm tra độc giả
    public boolean isReader() {
        return role != null && role == ROLE_READER;
    }

    public String getGenderText() {
        if (gender == null)
            return "Không xác định";
        return gender ? "Nam" : "Nữ";
    }

    // [SỬA DÒNG NÀY]: Dùng switch-case để code Clean và dễ mở rộng (Open/Closed
    // Principle)
    public String getRoleText() {
        if (role == null)
            return "Không xác định";
        switch (role) {
            case ROLE_ADMIN:
                return "Quản trị viên";
            case ROLE_REPORTER:
                return "Phóng viên";
            case ROLE_READER:
                return "Độc giả";
            default:
                return "Không xác định";
        }
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", fullname='" + fullname + '\'' +
                ", email='" + email + '\'' +
                ", role=" + getRoleText() +
                '}';
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getPenName() {
        return penName;
    }

    public void setPenName(String penName) {
        this.penName = penName;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public Integer getFailedLoginAttempts() {
        return failedLoginAttempts;
    }

    public void setFailedLoginAttempts(Integer failedLoginAttempts) {
        this.failedLoginAttempts = failedLoginAttempts != null ? failedLoginAttempts : 0;
    }

    public Date getLockoutTime() {
        return lockoutTime;
    }

    public void setLockoutTime(Date lockoutTime) {
        this.lockoutTime = lockoutTime;
    }
}

