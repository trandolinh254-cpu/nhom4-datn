package com.example.asmnews.repository.news;

import com.example.asmnews.util.DatabaseUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp FollowDAO quản lý truy xuất dữ liệu cho bảng Follows (Theo dõi tác giả)
 * Đáp ứng yêu cầu RQ22
 */
public class FollowDAO {

    public FollowDAO() { // // FIX
        createTableIfNotExists(); // // FIX
    } // // FIX

    private void createTableIfNotExists() { // // FIX
        String sql = "CREATE TABLE IF NOT EXISTS Follows (" + // // FIX
                     "    FollowerId VARCHAR(100)," + // // FIX
                     "    AuthorId VARCHAR(100)," + // // FIX
                     "    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP," + // // FIX
                     "    PRIMARY KEY (FollowerId, AuthorId)," + // // FIX
                     "    FOREIGN KEY (FollowerId) REFERENCES Users(UserId) ON DELETE CASCADE," + // // FIX
                     "    FOREIGN KEY (AuthorId) REFERENCES Users(UserId) ON DELETE CASCADE" + // // FIX
                     ")"; // // FIX
        try (Connection conn = DatabaseUtils.getConnection(); // // FIX
             PreparedStatement ps = conn.prepareStatement(sql)) { // // FIX
            ps.executeUpdate(); // // FIX
        } catch (SQLException e) { // // FIX
            System.err.println("Lỗi tự tạo bảng Follows: " + e.getMessage()); // // FIX
        } // // FIX
    } // // FIX

    /**
     * Thực hiện theo dõi một tác giả
     * -- FIX
     */
    public boolean follow(String followerId, String authorId) {
        String sql = "INSERT INTO Follows (FollowerId, AuthorId) VALUES (?, ?)";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, followerId);
            ps.setString(2, authorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi thực hiện follow tác giả: " + e.getMessage());
            return false;
        }
    }

    /**
     * Hủy theo dõi một tác giả
     * -- FIX
     */
    public boolean unfollow(String followerId, String authorId) {
        String sql = "DELETE FROM Follows WHERE FollowerId = ? AND AuthorId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, followerId);
            ps.setString(2, authorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi hủy follow tác giả: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kiểm tra độc giả đã theo dõi tác giả này chưa
     * -- FIX
     */
    public boolean isFollowing(String followerId, String authorId) {
        String sql = "SELECT COUNT(*) FROM Follows WHERE FollowerId = ? AND AuthorId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, followerId);
            ps.setString(2, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra follow: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy danh sách địa chỉ email của độc giả đang theo dõi một tác giả cụ thể
     * -- FIX
     */
    public List<String> getFollowerEmails(String authorId) {
        List<String> emails = new ArrayList<>();
        String sql = "SELECT u.Email FROM Follows f INNER JOIN Users u ON f.FollowerId = u.UserId WHERE f.AuthorId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String email = rs.getString("Email");
                    if (email != null && !email.trim().isEmpty()) {
                        emails.add(email);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách email người theo dõi: " + e.getMessage());
        }
        return emails;
    }

    /**
     * Lấy danh sách các tác giả đang được theo dõi bởi một độc giả
     * -- FIX
     */
    public List<com.example.asmnews.entity.auth.User> getFollowingAuthors(String followerId) { // // FIX
        List<com.example.asmnews.entity.auth.User> authors = new ArrayList<>(); // // FIX
        String sql = "SELECT u.UserId, u.Fullname, u.Email, u.Avatar, u.PenName, u.Bio " + // // FIX
                     "FROM Follows f INNER JOIN Users u ON f.AuthorId = u.UserId WHERE f.FollowerId = ?"; // // FIX
        try (Connection conn = DatabaseUtils.getConnection(); // // FIX
             PreparedStatement ps = conn.prepareStatement(sql)) { // // FIX
            ps.setString(1, followerId); // // FIX
            try (ResultSet rs = ps.executeQuery()) { // // FIX
                while (rs.next()) { // // FIX
                    com.example.asmnews.entity.auth.User author = new com.example.asmnews.entity.auth.User(); // // FIX
                    author.setId(rs.getString("UserId")); // // FIX
                    author.setFullname(rs.getString("Fullname")); // // FIX
                    author.setEmail(rs.getString("Email")); // // FIX
                    author.setAvatar(rs.getString("Avatar")); // // FIX
                    author.setPenName(rs.getString("PenName")); // // FIX
                    author.setBio(rs.getString("Bio")); // // FIX
                    authors.add(author); // // FIX
                } // // FIX
            } // // FIX
        } catch (SQLException e) { // // FIX
            System.err.println("Lỗi khi lấy danh sách tác giả đang theo dõi: " + e.getMessage()); // // FIX
        } // // FIX
        return authors; // // FIX
    } // // FIX
}
