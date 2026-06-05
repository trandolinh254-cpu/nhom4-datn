package com.example.asmnews.repository.auth;






import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.asmnews.entity.auth.User;
import com.example.asmnews.util.DatabaseUtils;

/**
 * DAO class cho User
 * Thực hiện các thao tác CRUD với bảng Users
 */
public class UserDAO {

    /**
     * Lấy tất cả users
     * * @return List<User>
     */
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        // : Thêm Avatar vào câu SELECT
        String sql = "SELECT UserId, Password, Fullname, Birthday, Gender, Mobile, Email, Role, IsActive, Avatar " +
                "FROM Users ORDER BY Fullname";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách users: " + e.getMessage());
        }
        return users;
    }

    /**
     * Tìm user theo ID
     * * @param id ID của user
     * 
     * @return User hoặc null nếu không tìm thấy
     */
    public User findById(String id) {
        // : Thêm IsActive, Avatar vào câu SELECT
        String sql = "SELECT UserId, Password, Fullname, Birthday, Gender, Mobile, Email, Role, IsActive, Avatar " +
                "FROM Users WHERE UserId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo ID: " + e.getMessage());
        }

        return null;
    }

    /**
     * Tìm user theo email
     * * @param email Email của user
     * 
     * @return User hoặc null nếu không tìm thấy
     */
    public User findByEmail(String email) {
        // : Thêm IsActive, Avatar vào câu SELECT
        String sql = "SELECT UserId, Password, Fullname, Birthday, Gender, Mobile, Email, Role, IsActive, Avatar " +
                "FROM Users WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo email: " + e.getMessage());
        }

        return null;
    }

    /**
     * Đăng nhập user
     * * @param id ID đăng nhập
     * 
     * @param password Mật khẩu
     * @return User nếu đăng nhập thành công, null nếu thất bại
     */
    public User login(String id, String password) {
        // : Thêm Avatar vào câu SELECT (QUAN TRỌNG NHẤT ĐỂ KHÔNG BỊ MẤT ẢNH KHI ĐĂNG
        // NHẬP)
        String sql = "SELECT UserId, Password, Fullname, Birthday, Gender, Mobile, Email, Role, IsActive, Avatar " +
                "FROM Users WHERE UserId = ? AND Password = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đăng nhập: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy danh sách phóng viên
     * * @return List<User> chỉ chứa phóng viên
     */
    public List<User> findReporters() {
        List<User> reporters = new ArrayList<>();
        // : Thêm IsActive, Avatar vào câu SELECT
        String sql = "SELECT UserId, Password, Fullname, Birthday, Gender, Mobile, Email, Role, IsActive, Avatar " +
                "FROM Users WHERE Role = 0 ORDER BY Fullname";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                reporters.add(user);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách phóng viên: " + e.getMessage());
        }

        return reporters;
    }

    public boolean insert(User user) {
        // FIX: Thêm cột IsActive vào câu INSERT để tránh lỗi NOT NULL
        String sql = "INSERT INTO Users (UserId, Password, Fullname, Birthday, Gender, Mobile, Email, Role, IsActive) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getId());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullname());
            ps.setDate(4, user.getBirthday() != null ? new java.sql.Date(user.getBirthday().getTime()) : null);
            ps.setObject(5, user.getGender());
            ps.setString(6, user.getMobile());
            ps.setString(7, user.getEmail());
            ps.setInt(8, user.getRole());
            ps.setBoolean(9, true); // FIX: Mặc định user mới là active

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm user: " + e.getMessage());
            e.printStackTrace(); // FIX: In stack trace để debug
            return false;
        }
    }

    public boolean update(User user) {
        // FIX: Đổi WHERE Id thành WHERE UserId
        String sql = "UPDATE Users SET Password = ?, Fullname = ?, Birthday = ?, Gender = ?, " +
                "Mobile = ?, Email = ?, Role = ? WHERE UserId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getPassword());
            ps.setString(2, user.getFullname());
            ps.setDate(3, user.getBirthday() != null ? new java.sql.Date(user.getBirthday().getTime()) : null);
            ps.setObject(4, user.getGender());
            ps.setString(5, user.getMobile());
            ps.setString(6, user.getEmail());
            ps.setInt(7, user.getRole());
            ps.setString(8, user.getId());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật user: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(String id) {
        String sql = "DELETE FROM Users WHERE UserId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa user: " + e.getMessage());
            return false;
        }
    }

    public boolean exists(String id) {
        // FIX: Đổi WHERE Id thành WHERE UserId
        String sql = "SELECT COUNT(*) FROM Users WHERE UserId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra user tồn tại: " + e.getMessage());
        }

        return false;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra email tồn tại: " + e.getMessage());
        }

        return false;
    }

    /**
     * Map ResultSet thành User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getString("UserId"));
        user.setPassword(rs.getString("Password"));
        user.setFullname(rs.getString("Fullname"));
        user.setBirthday(rs.getDate("Birthday"));

        Object gender = rs.getObject("Gender");
        user.setGender(gender != null ? (Boolean) gender : null);

        user.setMobile(rs.getString("Mobile"));
        user.setEmail(rs.getString("Email"));
        user.setRole(rs.getInt("Role"));

        try {
            user.setActive(rs.getBoolean("IsActive"));
        } catch (SQLException e) {
            user.setActive(true);
        }

        // Đọc thông tin Avatar từ Database
        try {
            user.setAvatar(rs.getString("Avatar"));
        } catch (SQLException e) {
            // Bỏ qua nếu query không lấy cột Avatar
        }

        return user;
    }

    public boolean changePassword(String userId, String oldPassword, String newPassword) {
        // FIX: Đổi Id thành UserId
        String checkSql = "SELECT UserId FROM Users WHERE UserId = ? AND Password = ?";
        String updateSql = "UPDATE Users SET Password = ? WHERE UserId = ?";

        try (Connection conn = DatabaseUtils.getConnection()) {
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, userId);
                checkStmt.setString(2, oldPassword);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next())
                        return false;
                }
            }
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, newPassword);
                updateStmt.setString(2, userId);
                return updateStmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean resetPassword(String userId, String email, String newPassword) {
        // FIX: Đổi Id thành UserId
        String checkSql = "SELECT UserId FROM Users WHERE UserId = ? AND Email = ?";
        String updateSql = "UPDATE Users SET Password = ? WHERE UserId = ?";

        try (Connection conn = DatabaseUtils.getConnection()) {
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, userId);
                checkStmt.setString(2, email);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next())
                        return false;
                }
            }
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, newPassword);
                updateStmt.setString(2, userId);
                return updateStmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleStatus(String userId, boolean isActive) {
        // FIX: Đổi WHERE Id thành WHERE UserId
        String sql = "UPDATE Users SET IsActive = ? WHERE UserId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, isActive);
            stmt.setString(2, userId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi đổi trạng thái User: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật Avatar cho User
     */
    public boolean updateAvatar(String userId, String avatarFileName) {
        // FIX: Đổi WHERE Id thành WHERE UserId
        String sql = "UPDATE Users SET Avatar = ? WHERE UserId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, avatarFileName);
            stmt.setString(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật Avatar: " + e.getMessage());
            return false;
        }
    }

    // FIX: Hàm cập nhật mật khẩu mới dựa vào Email
    public boolean updatePasswordByEmail(String email, String newPassword) {
        // Lưu ý: Đảm bảo tên bảng là Users và các cột Password, Email viết đúng như trong DB của bạn
        String sql = "UPDATE Users SET Password = ? WHERE Email = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, newPassword);
            ps.setString(2, email);
            
            // ExecuteUpdate trả về số dòng bị ảnh hưởng, > 0 nghĩa là update thành công
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
