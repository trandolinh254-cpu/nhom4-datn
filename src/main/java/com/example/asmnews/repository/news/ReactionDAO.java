package com.example.asmnews.repository.news;






// [NOTE_CHO_BẠN]: Hãy đảm bảo import đúng file DatabaseUtils của bạn
import com.example.asmnews.util.DatabaseUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
 

/**
 * Data Access Object xử lý lượt Thích/Không thích (Reactions)
 */
public class ReactionDAO {

    /**
     * Đếm số lượng Thích (type=1) hoặc Không thích (type=0) của một bài báo
     */
    public int countReactions(String newsId, int type) {
        String sql = "SELECT COUNT(*) FROM Reactions WHERE NewsId = ? AND Type = ?";
        int count = 0;

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newsId);
            stmt.setInt(2, type);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm số lượng Reaction: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    /**
     * Thêm mới hoặc Cập nhật lượt Thích/Không thích (Upsert Logic)
     */
    public boolean upsertReaction(String userId, String newsId, int type) {
        // 1. Kiểm tra xem người dùng đã từng react bài này chưa
        String checkSql = "SELECT Type FROM Reactions WHERE UserId = ? AND NewsId = ?";
        String updateSql = "UPDATE Reactions SET Type = ?, CreatedDate = NOW() WHERE UserId = ? AND NewsId = ?";
        String insertSql = "INSERT INTO Reactions (UserId, NewsId, Type) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, userId);
            checkStmt.setString(2, newsId);

            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    // [ĐÃ TỒN TẠI]: Cập nhật lại (Ví dụ: Từ Thích -> Không thích)
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, type);
                        updateStmt.setString(2, userId);
                        updateStmt.setString(3, newsId);
                        return updateStmt.executeUpdate() > 0;
                    }
                } else {
                    // [CHƯA TỒN TẠI]: Thêm mới
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setString(1, userId);
                        insertStmt.setString(2, newsId);
                        insertStmt.setInt(3, type);
                        return insertStmt.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi Upsert Reaction: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
