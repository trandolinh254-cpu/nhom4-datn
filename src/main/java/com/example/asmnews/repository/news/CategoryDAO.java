package com.example.asmnews.repository.news;






import com.example.asmnews.entity.news.Category;
import com.example.asmnews.util.DatabaseUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class cho Category
 * Thực hiện các thao tác CRUD với bảng Categories
 */
public class CategoryDAO {

    /**
     * Lấy tất cả categories
     * 
     * @return List<Category>
     */
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT CategoryId, Name FROM Categories ORDER BY Name";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getString("CategoryId"));
                category.setName(rs.getString("Name"));
                categories.add(category);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách categories: " + e.getMessage());
        }

        return categories;
    }

    /**
     * Tìm category theo ID
     * 
     * @param id ID của category
     * @return Category hoặc null nếu không tìm thấy
     */
    public Category findById(String id) {
        String sql = "SELECT CategoryId, Name FROM Categories WHERE CategoryId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Category category = new Category();
                category.setId(rs.getString("CategoryId"));
                category.setName(rs.getString("Name"));
                return category;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm category theo ID: " + e.getMessage());
        }

        return null;
    }

    /**
     * Thêm category mới
     * 
     * @param category Category cần thêm
     * @return true nếu thành công
     */
    public boolean insert(Category category) {
        String sql = "INSERT INTO Categories (CategoryId, Name) VALUES (?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getId());
            ps.setString(2, category.getName());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm category: " + e.getMessage());
            return false;
        }
    }

    /**
     * Cập nhật category
     * 
     * @param category Category cần cập nhật
     * @return true nếu thành công
     */
    public boolean update(Category category) {
        String sql = "UPDATE Categories SET Name = ? WHERE CategoryId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getId());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật category: " + e.getMessage());
            return false;
        }
    }

    /**
     * Xóa category
     * 
     * @param id ID của category cần xóa
     * @return true nếu thành công
     */
    public boolean delete(String id) {
        String sql = "DELETE FROM Categories WHERE CategoryId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa category: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kiểm tra category có tồn tại không
     * 
     * @param id ID cần kiểm tra
     * @return true nếu tồn tại
     */
    public boolean exists(String id) {
        String sql = "SELECT COUNT(*) FROM Categories WHERE CategoryId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra category tồn tại: " + e.getMessage());
        }

        return false;
    }

    // : Thêm hàm đếm số lượng bài viết theo chuyên mục (Cho biểu đồ tròn)
    public java.util.Map<String, Integer> getNewsCountByCategory() {
        java.util.Map<String, Integer> map = new java.util.HashMap<>();
        String sql = "SELECT c.Name as CategoryName, COUNT(n.NewsId) as TotalNews " +
                     "FROM Categories c " +
                     "LEFT JOIN News n ON c.CategoryId = n.CategoryId " +
                     "GROUP BY c.Name";
                     
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                map.put(rs.getString("CategoryName"), rs.getInt("TotalNews"));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm bài viết theo chuyên mục: " + e.getMessage());
        }
        return map;
    }
}
