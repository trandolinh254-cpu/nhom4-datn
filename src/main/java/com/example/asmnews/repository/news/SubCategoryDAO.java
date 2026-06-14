package com.example.asmnews.repository.news;

import com.example.asmnews.entity.news.SubCategory;
import com.example.asmnews.util.DatabaseUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class cho SubCategory.
 * Thực hiện CRUD đơn giản với bảng SubCategories.
 */
public class SubCategoryDAO {

    public SubCategoryDAO() {
        createTableIfMissing();
        seedDefaultSubCategories();
    }

    /**
     * Tạo bảng nếu database cũ chưa có bảng danh mục con.
     */
    private void createTableIfMissing() {
        String sql = "CREATE TABLE IF NOT EXISTS SubCategories (" +
                "SubCategoryId INT AUTO_INCREMENT PRIMARY KEY, " +
                "CategoryId VARCHAR(50) NOT NULL, " +
                "Name VARCHAR(255) NOT NULL, " +
                "UNIQUE KEY UK_SubCategories_Category_Name (CategoryId, Name), " +
                "CONSTRAINT FK_SubCategories_Categories FOREIGN KEY (CategoryId) " +
                "REFERENCES Categories(CategoryId) ON DELETE CASCADE" +
                ")";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo bảng SubCategories: " + e.getMessage());
        }
    }

    /**
     * Nạp danh mục con mặc định để giữ menu cũ sau khi chuyển sang dữ liệu DB.
     */
    private void seedDefaultSubCategories() {
        String sql = "INSERT IGNORE INTO SubCategories (CategoryId, Name) VALUES " +
                "('TECH', 'Thị trường'), ('TECH', 'Chuyển đổi số'), ('TECH', 'An ninh mạng'), ('TECH', 'AI - Trí tuệ nhân tạo'), " +
                "('SPORT', 'Bóng đá'), ('SPORT', 'Tennis'), ('SPORT', 'Esports'), ('SPORT', 'Bóng rổ'), " +
                "('ENTERTAINMENT', 'Âm nhạc'), ('ENTERTAINMENT', 'Phim ảnh'), ('ENTERTAINMENT', 'Showbiz'), ('ENTERTAINMENT', 'Thời trang'), " +
                "('BUSINESS', 'Chứng khoán'), ('BUSINESS', 'Bất động sản'), ('BUSINESS', 'Khởi nghiệp'), " +
                "('HEALTH', 'Dinh dưỡng'), ('HEALTH', 'Y tế'), ('HEALTH', 'Làm đẹp')";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi khi nạp danh mục con mặc định: " + e.getMessage());
        }
    }

    public List<SubCategory> findAll() {
        List<SubCategory> subCategories = new ArrayList<>();
        String sql = "SELECT SubCategoryId, CategoryId, Name FROM SubCategories ORDER BY CategoryId, Name";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                subCategories.add(mapResultSetToSubCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách danh mục con: " + e.getMessage());
        }

        return subCategories;
    }

    public List<SubCategory> findByCategoryId(String categoryId) {
        List<SubCategory> subCategories = new ArrayList<>();
        String sql = "SELECT SubCategoryId, CategoryId, Name FROM SubCategories WHERE CategoryId = ? ORDER BY Name";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    subCategories.add(mapResultSetToSubCategory(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh mục con theo chuyên mục: " + e.getMessage());
        }

        return subCategories;
    }

    public boolean insert(SubCategory subCategory) {
        String sql = "INSERT INTO SubCategories (CategoryId, Name) VALUES (?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subCategory.getCategoryId());
            ps.setString(2, subCategory.getName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm danh mục con: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM SubCategories WHERE SubCategoryId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa danh mục con: " + e.getMessage());
            return false;
        }
    }

    public boolean exists(String categoryId, String name) {
        String sql = "SELECT COUNT(*) FROM SubCategories WHERE CategoryId = ? AND Name = ?";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryId);
            ps.setString(2, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra danh mục con: " + e.getMessage());
            return false;
        }
    }

    private SubCategory mapResultSetToSubCategory(ResultSet rs) throws SQLException {
        SubCategory subCategory = new SubCategory();
        subCategory.setId(rs.getInt("SubCategoryId"));
        subCategory.setCategoryId(rs.getString("CategoryId"));
        subCategory.setName(rs.getString("Name"));
        return subCategory;
    }
}
