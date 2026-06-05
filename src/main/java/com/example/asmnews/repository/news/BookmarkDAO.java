package com.example.asmnews.repository.news;

import com.example.asmnews.entity.news.News;
import com.example.asmnews.util.DatabaseUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp BookmarkDAO quản lý lưu bài viết (Bookmark) cho độc giả
 * Đáp ứng yêu cầu RQ27
 */
public class BookmarkDAO {

    public BookmarkDAO() { // // FIX
        createTableIfNotExists(); // // FIX
    } // // FIX

    private void createTableIfNotExists() { // // FIX
        String sql = "CREATE TABLE IF NOT EXISTS Bookmarks (" + // // FIX
                     "    UserId VARCHAR(100)," + // // FIX
                     "    NewsId VARCHAR(100)," + // // FIX
                     "    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP," + // // FIX
                     "    PRIMARY KEY (UserId, NewsId)," + // // FIX
                     "    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE," + // // FIX
                     "    FOREIGN KEY (NewsId) REFERENCES News(NewsId) ON DELETE CASCADE" + // // FIX
                     ")"; // // FIX
        try (Connection conn = DatabaseUtils.getConnection(); // // FIX
             PreparedStatement ps = conn.prepareStatement(sql)) { // // FIX
            ps.executeUpdate(); // // FIX
        } catch (SQLException e) { // // FIX
            System.err.println("Lỗi tự tạo bảng Bookmarks: " + e.getMessage()); // // FIX
        } // // FIX
    } // // FIX

    /**
     * Lưu bài viết
     * -- FIX
     */
    public boolean bookmark(String userId, String newsId) {
        String sql = "INSERT INTO Bookmarks (UserId, NewsId) VALUES (?, ?)";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setString(2, newsId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi bookmark bài viết: " + e.getMessage());
            return false;
        }
    }

    /**
     * Bỏ lưu bài viết
     * -- FIX
     */
    public boolean unbookmark(String userId, String newsId) {
        String sql = "DELETE FROM Bookmarks WHERE UserId = ? AND NewsId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setString(2, newsId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi hủy bookmark bài viết: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kiểm tra bài viết đã được độc giả này lưu chưa
     * -- FIX
     */
    public boolean isBookmarked(String userId, String newsId) {
        String sql = "SELECT COUNT(*) FROM Bookmarks WHERE UserId = ? AND NewsId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setString(2, newsId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra bookmark: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy danh sách tin tức đã lưu của độc giả
     * -- FIX
     */
    public List<News> findByUserId(String userId) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT n.NewsId, n.Title, n.Image, n.PostedDate, n.CategoryId, b.CreatedDate " +
                     "FROM Bookmarks b " +
                     "INNER JOIN News n ON b.NewsId = n.NewsId " +
                     "WHERE b.UserId = ? " + // // FIX (Loại bỏ cột n.IsDeleted không tồn tại)
                     "ORDER BY b.CreatedDate DESC";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News news = new News();
                    news.setId(rs.getString("NewsId"));
                    news.setTitle(rs.getString("Title"));
                    news.setImage(rs.getString("Image"));
                    
                    Timestamp ts = rs.getTimestamp("PostedDate");
                    if (ts != null) {
                        news.setPostedDate(new java.util.Date(ts.getTime()));
                    }
                    news.setCategoryId(rs.getString("CategoryId"));
                    list.add(news);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách bookmark: " + e.getMessage());
        }
        return list;
    }
}
