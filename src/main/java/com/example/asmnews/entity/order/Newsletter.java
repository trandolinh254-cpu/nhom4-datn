package com.example.asmnews.entity.order;






/**
 * Entity class cho bảng Newsletters
 * Đại diện cho đăng ký nhận tin qua email
 */
public class Newsletter {
    private String email;
    private Boolean enabled; // true: Còn hiệu lực, false: Đã hủy

    // Constructor mặc định
    public Newsletter() {
        this.enabled = true;
    }

    // Constructor có tham số
    public Newsletter(String email, Boolean enabled) {
        this.email = email;
        this.enabled = enabled != null ? enabled : true;
    }

    // Getter và Setter
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

    // Phương thức tiện ích
    public boolean isActive() {
        return enabled != null && enabled;
    }

    public String getStatusText() {
        return isActive() ? "Đang hoạt động" : "Đã hủy";
    }

    @Override
    public String toString() {
        return "Newsletter{" +
                "email='" + email + '\'' +
                ", enabled=" + enabled +
                '}';
    }
}
