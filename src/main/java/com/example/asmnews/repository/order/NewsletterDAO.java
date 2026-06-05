package com.example.asmnews.repository.order;






import com.example.asmnews.entity.order.Newsletter;
import com.example.asmnews.util.DatabaseUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class cho Newsletter
 * Thực hiện các thao tác CRUD với bảng Newsletters
 */
public class NewsletterDAO {

    /**
     * Lấy tất cả newsletters
     * 
     * @return List<Newsletter>
     */
    public List<Newsletter> findAll() {
        List<Newsletter> newsletters = new ArrayList<>();
        String sql = "SELECT Email, Enabled FROM Newsletters ORDER BY Email";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Newsletter newsletter = new Newsletter();
                newsletter.setEmail(rs.getString("Email"));
                newsletter.setEnabled(rs.getBoolean("Enabled"));
                newsletters.add(newsletter);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách newsletters: " + e.getMessage());
        }

        return newsletters;
    }

    /**
     * Lấy danh sách newsletters đang hoạt động
     * 
     * @return List<Newsletter>
     */
    public List<Newsletter> findActive() {
        List<Newsletter> newsletters = new ArrayList<>();
        String sql = "SELECT Email, Enabled FROM Newsletters WHERE Enabled = 1 ORDER BY Email";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Newsletter newsletter = new Newsletter();
                newsletter.setEmail(rs.getString("Email"));
                newsletter.setEnabled(rs.getBoolean("Enabled"));
                newsletters.add(newsletter);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách newsletters hoạt động: " + e.getMessage());
        }

        return newsletters;
    }

    /**
     * Tìm newsletter theo email
     * 
     * @param email Email cần tìm
     * @return Newsletter hoặc null nếu không tìm thấy
     */
    public Newsletter findByEmail(String email) {
        String sql = "SELECT Email, Enabled FROM Newsletters WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Newsletter newsletter = new Newsletter();
                newsletter.setEmail(rs.getString("Email"));
                newsletter.setEnabled(rs.getBoolean("Enabled"));
                return newsletter;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm newsletter theo email: " + e.getMessage());
        }

        return null;
    }

    /**
     * Đăng ký newsletter mới
     * 
     * @param newsletter Newsletter cần thêm
     * @return true nếu thành công
     */
    public boolean subscribe(Newsletter newsletter) {
        String sql = "INSERT INTO Newsletters (Email, Enabled) VALUES (?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newsletter.getEmail());
            ps.setBoolean(2, newsletter.getEnabled());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi đăng ký newsletter: " + e.getMessage());
            return false;
        }
    }

    /**
     * Đăng ký newsletter với email (enabled = true)
     * 
     * @param email Email đăng ký
     * @return true nếu thành công
     */
    public boolean subscribe(String email) {
        Newsletter newsletter = new Newsletter(email, true);
        return subscribe(newsletter);
    }

    /**
     * Cập nhật trạng thái newsletter
     * 
     * @param newsletter Newsletter cần cập nhật
     * @return true nếu thành công
     */
    public boolean update(Newsletter newsletter) {
        String sql = "UPDATE Newsletters SET Enabled = ? WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, newsletter.getEnabled());
            ps.setString(2, newsletter.getEmail());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật newsletter: " + e.getMessage());
            return false;
        }
    }

    /**
     * Hủy đăng ký newsletter
     * 
     * @param email Email cần hủy
     * @return true nếu thành công
     */
    public boolean unsubscribe(String email) {
        String sql = "UPDATE Newsletters SET Enabled = 0 WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi hủy đăng ký newsletter: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kích hoạt lại newsletter
     * 
     * @param email Email cần kích hoạt
     * @return true nếu thành công
     */
    public boolean reactivate(String email) {
        String sql = "UPDATE Newsletters SET Enabled = 1 WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi kích hoạt newsletter: " + e.getMessage());
            return false;
        }
    }

    /**
     * Xóa newsletter hoàn toàn
     * 
     * @param email Email cần xóa
     * @return true nếu thành công
     */
    public boolean delete(String email) {
        String sql = "DELETE FROM Newsletters WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa newsletter: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kiểm tra email đã đăng ký newsletter chưa
     * 
     * @param email Email cần kiểm tra
     * @return true nếu đã đăng ký
     */
    public boolean exists(String email) {
        String sql = "SELECT COUNT(*) FROM Newsletters WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra newsletter tồn tại: " + e.getMessage());
        }

        return false;
    }

    /**
     * Kiểm tra email đã đăng ký và đang hoạt động
     * 
     * @param email Email cần kiểm tra
     * @return true nếu đang hoạt động
     */
    public boolean isActive(String email) {
        String sql = "SELECT COUNT(*) FROM Newsletters WHERE Email = ? AND Enabled = 1";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra newsletter hoạt động: " + e.getMessage());
        }

        return false;
    }

    /**
     * Đếm số lượng newsletter đang hoạt động
     * 
     * @return Số lượng newsletter hoạt động
     */
    public int countActive() {
        String sql = "SELECT COUNT(*) FROM Newsletters WHERE Enabled = 1";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm newsletter hoạt động: " + e.getMessage());
        }

        return 0;
    }
}
