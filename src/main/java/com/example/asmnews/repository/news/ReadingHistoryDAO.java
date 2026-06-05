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
 * Lớp ReadingHistoryDAO quản lý lịch sử bài viết đã đọc của độc giả
 * Đáp ứng yêu cầu RQ25 (Tối đa 50 bài viết gần nhất, có nút xóa lịch sử)
 */
public class ReadingHistoryDAO {

    public ReadingHistoryDAO() { // // FIX
        createTableIfNotExists(); // // FIX
    } // // FIX

    private void createTableIfNotExists() { // // FIX
        String sql = "CREATE TABLE IF NOT EXISTS ReadingHistory (" + // // FIX
                     "    UserId VARCHAR(100)," + // // FIX
                     "    NewsId VARCHAR(100)," + // // FIX
                     "    ReadDate DATETIME DEFAULT CURRENT_TIMESTAMP," + // // FIX
                     "    PRIMARY KEY (UserId, NewsId)," + // // FIX
                     "    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE," + // // FIX
                     "    FOREIGN KEY (NewsId) REFERENCES News(NewsId) ON DELETE CASCADE" + // // FIX
                     ")"; // // FIX
        try (Connection conn = DatabaseUtils.getConnection(); // // FIX
             PreparedStatement ps = conn.prepareStatement(sql)) { // // FIX
            ps.executeUpdate(); // // FIX
        } catch (SQLException e) { // // FIX
            System.err.println("Lỗi tự tạo bảng ReadingHistory: " + e.getMessage()); // // FIX
        } // // FIX
    } // // FIX

    /**
     * Ghi nhận lịch sử đọc tin của người dùng.
     * Nếu bài viết đã có trong lịch sử thì cập nhật lại thời gian đọc gần nhất.
     * Giới hạn lịch sử lưu tối đa 50 bài gần nhất cho một user.
     * -- FIX
     */
    public boolean addRecord(String userId, String newsId) {
        String checkSql = "SELECT COUNT(*) FROM ReadingHistory WHERE UserId = ? AND NewsId = ?";
        String insertSql = "INSERT INTO ReadingHistory (UserId, NewsId, ReadDate) VALUES (?, ?, CURRENT_TIMESTAMP)";
        String updateSql = "UPDATE ReadingHistory SET ReadDate = CURRENT_TIMESTAMP WHERE UserId = ? AND NewsId = ?";
        
        try (Connection conn = DatabaseUtils.getConnection()) {
            conn.setAutoCommit(false); // Sử dụng Transaction để an toàn dữ liệu -- FIX
            
            boolean exists = false;
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setString(1, userId);
                psCheck.setString(2, newsId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        exists = rs.getInt(1) > 0;
                    }
                }
            }
            
            boolean success;
            if (exists) {
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setString(1, userId);
                    psUpdate.setString(2, newsId);
                    success = psUpdate.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setString(1, userId);
                    psInsert.setString(2, newsId);
                    success = psInsert.executeUpdate() > 0;
                }
            }
            
            if (success) {
                // Giới hạn tối đa 50 bài viết: Xóa các bản ghi cũ vượt quá 50 -- FIX
                String limitSql = "DELETE FROM ReadingHistory WHERE UserId = ? AND NewsId NOT IN (" +
                                  "SELECT NewsId FROM (" +
                                  "SELECT NewsId FROM ReadingHistory WHERE UserId = ? ORDER BY ReadDate DESC LIMIT 50" +
                                  ") AS temp)";
                try (PreparedStatement psLimit = conn.prepareStatement(limitSql)) {
                    psLimit.setString(1, userId);
                    psLimit.setString(2, userId);
                    psLimit.executeUpdate();
                }
                
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi ghi nhận lịch sử đọc bài viết: " + e.getMessage());
            return false;
        }
    }

    /**
     * Lấy danh sách 50 bài viết đã đọc gần đây nhất
     * -- FIX
     */
    public List<News> findByUserId(String userId) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT n.NewsId, n.Title, n.Image, n.PostedDate, n.CategoryId, r.ReadDate " +
                     "FROM ReadingHistory r " +
                     "INNER JOIN News n ON r.NewsId = n.NewsId " +
                     "WHERE r.UserId = ? " + // // FIX (Loại bỏ cột n.IsDeleted không tồn tại)
                     "ORDER BY r.ReadDate DESC LIMIT 50";
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
            System.err.println("Lỗi khi lấy lịch sử đọc tin: " + e.getMessage());
        }
        return list;
    }

    /**
     * Xóa sạch lịch sử đọc tin của người dùng
     * -- FIX
     */
    public boolean clearAll(String userId) {
        String sql = "DELETE FROM ReadingHistory WHERE UserId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa sạch lịch sử đọc tin: " + e.getMessage());
            return false;
        }
    }
}
