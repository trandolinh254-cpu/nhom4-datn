package com.example.asmnews.repository.news;






import com.example.asmnews.entity.news.Comment;
import com.example.asmnews.util.DatabaseUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class commentDAO {

    public List<Comment> findByNewsId(String newsId) {
        Map<Integer, Comment> parentMap = new LinkedHashMap<>();
        List<Comment> allReplies = new ArrayList<>();

        String sql = "SELECT c.CommentId, c.Content, c.CreatedDate, c.UserId, c.NewsId, "
                + "IFNULL(c.ParentId, 0) AS ParentId, u.Fullname AS UserFullName "
                + "FROM Comments c "
                + "INNER JOIN Users u ON c.UserId = u.UserId "
                + "WHERE c.NewsId = ? "
                + "ORDER BY IFNULL(c.ParentId, 0) ASC, c.CreatedDate ASC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newsId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setId(rs.getInt("CommentId"));
                    comment.setContent(rs.getString("Content"));

                    Timestamp timestamp = rs.getTimestamp("CreatedDate");
                    if (timestamp != null) {
                        comment.setCreatedDate(new java.util.Date(timestamp.getTime()));
                    }

                    comment.setUserId(rs.getString("UserId"));
                    comment.setNewsId(rs.getString("NewsId"));
                    comment.setParentId(rs.getInt("ParentId"));
                    comment.setUserFullName(rs.getString("UserFullName"));

                    if (comment.getParentId() == 0) {
                        parentMap.put(comment.getId(), comment);
                    } else {
                        allReplies.add(comment);
                    }
                }
            }

            // Gán replies vào comment cha
            for (Comment reply : allReplies) {
                Comment parent = parentMap.get(reply.getParentId());
                if (parent != null) {
                    parent.getReplies().add(reply);
                }
            }

        } catch (SQLException e) {
            // Nếu cột ParentId chưa tồn tại -> fallback query cũ không có ParentId
            System.err.println("Lỗi load Comments (thử fallback): " + e.getMessage());
            return findByNewsIdFallback(newsId);
        }

        return new ArrayList<>(parentMap.values());
    }

    /** Fallback: query không dùng ParentId (dùng khi cột ParentId chưa có trong DB) */
    private List<Comment> findByNewsIdFallback(String newsId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT c.CommentId, c.Content, c.CreatedDate, c.UserId, c.NewsId, u.Fullname AS UserFullName "
                + "FROM Comments c "
                + "INNER JOIN Users u ON c.UserId = u.UserId "
                + "WHERE c.NewsId = ? "
                + "ORDER BY c.CreatedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newsId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setId(rs.getInt("CommentId"));
                    comment.setContent(rs.getString("Content"));
                    Timestamp ts = rs.getTimestamp("CreatedDate");
                    if (ts != null) comment.setCreatedDate(new java.util.Date(ts.getTime()));
                    comment.setUserId(rs.getString("UserId"));
                    comment.setNewsId(rs.getString("NewsId"));
                    comment.setUserFullName(rs.getString("UserFullName"));
                    list.add(comment);
                }
            }
        } catch (SQLException e2) {
            System.err.println("Lỗi fallback Comments: " + e2.getMessage());
        }
        return list;
    }


    public boolean insert(Comment comment) {
        String sql = "INSERT INTO Comments (Content, UserId, NewsId) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, comment.getContent());
            stmt.setString(2, comment.getUserId());
            stmt.setString(3, comment.getNewsId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi insert Comment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Thêm bình luận reply (có parentId)
     */
    public boolean insertReply(Comment comment) {
        String sql = "INSERT INTO Comments (Content, UserId, NewsId, ParentId) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, comment.getContent());
            stmt.setString(2, comment.getUserId());
            stmt.setString(3, comment.getNewsId());
            stmt.setInt(4, comment.getParentId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi insert Reply: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public int countByNewsId(String newsId) {
        String sql = "SELECT COUNT(*) FROM Comments WHERE NewsId = ?";
        int count = 0;
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newsId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm số lượng Comment: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    // [TÍNH NĂNG MỚI]: Cập nhật nội dung bình luận
    public boolean update(int commentId, String userId, String newContent) {
        String sql = "UPDATE Comments SET Content = ? WHERE CommentId = ? AND UserId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newContent);
            stmt.setInt(2, commentId);
            stmt.setString(3, userId); // Bắt buộc đúng chủ nhân mới được sửa

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi update Comment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Tăng số lượt báo cáo của một bình luận lên 1
     */
    public boolean reportComment(int commentId) {
        String sql = "UPDATE Comments SET ReportCount = IFNULL(ReportCount, 0) + 1 WHERE CommentId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, commentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa bình luận (Dành cho Admin)
     */
    public boolean delete(int commentId) {
        String sql = "DELETE FROM Comments WHERE CommentId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, commentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy tất cả bình luận cho trang Admin (Xếp bình luận bị Report nhiều lên đầu)
     */
    public List<Comment> findAllForAdmin() {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT CommentId, c.Content, c.CreatedDate, c.UserId, c.NewsId, IFNULL(c.ReportCount, 0) as ReportCount, "
                +
                "u.Fullname AS UserFullName, n.Title AS NewsTitle " +
                "FROM Comments c " +
                "INNER JOIN Users u ON c.UserId = u.UserId " +
                "INNER JOIN News n ON c.NewsId = n.NewsId " +
                "ORDER BY c.ReportCount DESC, c.CreatedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("CommentId"));
                comment.setContent(rs.getString("Content"));
                comment.setCreatedDate(rs.getTimestamp("CreatedDate"));
                comment.setUserFullName(rs.getString("UserFullName"));
                comment.setNewsTitle(rs.getString("NewsTitle"));
                comment.setReportCount(rs.getInt("ReportCount"));
                list.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
