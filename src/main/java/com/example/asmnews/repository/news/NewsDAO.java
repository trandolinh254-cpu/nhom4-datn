package com.example.asmnews.repository.news;






import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.asmnews.entity.news.News;
import com.example.asmnews.util.DatabaseUtils;

/**
 * DAO class cho News
 * Thực hiện các thao tác CRUD với bảng News
 */
public class NewsDAO {

    /**
     * Lấy tất cả tin tức với thông tin category và author
     * 
     * @return List<News>
     */
    public List<News> findAll() {
        List<News> newsList = new ArrayList<>();
        // : Thêm n.Status vào câu SELECT
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "ORDER BY n.PostedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách tin tức: " + e.getMessage());
        }
        return newsList;
    }

    // : THÊM MỚI HÀM NÀY DÀNH RIÊNG CHO ĐỘC GIẢ (Chỉ lấy bài đã duyệt)
    public List<News> findAllApproved() {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Status = 1 " +
                "ORDER BY n.PostedDate DESC LIMIT 100";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách tin tức đã duyệt: " + e.getMessage());
        }
        return newsList;
    }

    public List<News> findHomeNews() {
        List<News> newsList = new ArrayList<>();
        // : Thêm n.Status vào SELECT và n.Status = 1 vào WHERE
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Home = 1 AND n.Status = 1 " +
                "ORDER BY n.PostedDate DESC LIMIT 15";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tin tức trang chủ: " + e.getMessage());
        }
        return newsList;
    }

    public List<News> findTop5MostViewed() {
        List<News> newsList = new ArrayList<>();
        // : Thêm n.Status vào SELECT và WHERE n.Status = 1
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Status = 1 " +
                "ORDER BY n.ViewCount DESC LIMIT 5";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy top 5 tin được xem nhiều: " + e.getMessage());
        }
        return newsList;
    }

    // : Hàm lấy Top 5 bài viết có lượt xem cao nhất
    public List<News> findTopViewedNews() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT n.*, c.Name as CategoryName, u.Fullname as AuthorName " +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Status = 1 " +
                "ORDER BY n.ViewCount DESC LIMIT 5";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy top 5 tin đọc nhiều: " + e.getMessage());
        }
        return list;
    }

    public List<News> findTop5Latest() {
        List<News> newsList = new ArrayList<>();
        // : Thêm n.Status vào SELECT và WHERE n.Status = 1
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Status = 1 " +
                "ORDER BY n.PostedDate DESC LIMIT 5";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy 5 tin mới nhất: " + e.getMessage());
        }
        return newsList;
    }

    public List<News> findByCategory(String categoryId) {
        List<News> newsList = new ArrayList<>();
        // : Thêm n.Status vào SELECT và AND n.Status = 1 vào WHERE
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.CategoryId = ? AND n.Status = 1 " +
                "ORDER BY n.PostedDate DESC LIMIT 50";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm tin theo category: " + e.getMessage());
        }
        return newsList;
    }

    public List<News> findByAuthor(String authorId) {
        List<News> newsList = new ArrayList<>();
        // : Thêm n.Status vào SELECT (Bỏ qua WHERE n.Status = 1 vì Admin/Tác giả cần
        // xem hết)
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Author = ? " +
                "ORDER BY n.PostedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, authorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm tin theo author: " + e.getMessage());
        }
        return newsList;
    }

    public News findById(String id) {
        // : Thêm n.Status vào SELECT
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.NewsId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToNews(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm tin theo ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Thêm tin tức mới
     * 
     * @param news News cần thêm
     * @return true nếu thành công
     */
    public boolean insert(News news) {
        String sql = "INSERT INTO News (NewsId, Title, Content, Image, PostedDate, Author, ViewCount, CategoryId, Home, SubCategory) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, news.getId());
            ps.setString(2, news.getTitle());
            ps.setString(3, news.getContent());
            ps.setString(4, news.getImage());
            ps.setDate(5, new java.sql.Date(news.getPostedDate().getTime()));
            ps.setString(6, news.getAuthor());
            ps.setInt(7, news.getViewCount());
            ps.setString(8, news.getCategoryId());
            ps.setBoolean(9, news.getHome());
            ps.setString(10, news.getSubCategory());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm tin tức: " + e.getMessage());
            return false;
        }
    }

    /**
     * Cập nhật tin tức
     * 
     * @param news News cần cập nhật
     * @return true nếu thành công
     */
    public boolean update(News news) {
        String sql = "UPDATE News SET Title = ?, Content = ?, Image = ?, PostedDate = ?, " +
                "Author = ?, ViewCount = ?, CategoryId = ?, Home = ?, SubCategory = ? WHERE NewsId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, news.getTitle());
            ps.setString(2, news.getContent());
            ps.setString(3, news.getImage());
            ps.setDate(4, new java.sql.Date(news.getPostedDate().getTime()));
            ps.setString(5, news.getAuthor());
            ps.setInt(6, news.getViewCount());
            ps.setString(7, news.getCategoryId());
            ps.setBoolean(8, news.getHome());
            ps.setString(9, news.getSubCategory());
            ps.setString(10, news.getId());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật tin tức: " + e.getMessage());
            return false;
        }
    }

    /**
     * Cập nhật lượt xem
     * 
     * @param id ID của tin tức
     * @return true nếu thành công
     */
    public boolean updateViewCount(String id) {
        String sql = "UPDATE News SET ViewCount = ViewCount + 1 WHERE NewsId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật lượt xem: " + e.getMessage());
            return false;
        }
    }

    /**
     * Xóa tin tức
     * 
     * @param id ID của tin tức cần xóa
     * @return true nếu thành công
     */
    public boolean delete(String id) {
        String sql = "DELETE FROM News WHERE NewsId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa tin tức: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kiểm tra tin tức có tồn tại không
     * 
     * @param id ID cần kiểm tra
     * @return true nếu tồn tại
     */
    public boolean exists(String id) {
        String sql = "SELECT COUNT(*) FROM News WHERE NewsId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra tin tức tồn tại: " + e.getMessage());
        }

        return false;
    }

    // : Thêm hàm lọc tin tức theo CẢ Category và SubCategory
    public List<News> findByCategoryAndSubCategory(String categoryId, String subCategory) {
        List<News> newsList = new ArrayList<>();
        // Nhớ đảm bảo câu lệnh này có n.SubCategory ở phần SELECT
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.CategoryId = ? AND n.SubCategory = ? AND n.Status = 1 " +
                "ORDER BY n.PostedDate DESC LIMIT 50";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryId);
            ps.setString(2, subCategory); // Lọc chính xác theo mục con (VD: Bóng đá)
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm tin theo danh mục con: " + e.getMessage());
        }
        return newsList;
    }

    /**
     * Map ResultSet thành News object
     * 
     * @param rs ResultSet
     * @return News
     * @throws SQLException
     */
    private News mapResultSetToNews(ResultSet rs) throws SQLException {
        News news = new News();
        news.setId(rs.getString("NewsId"));
        news.setTitle(rs.getString("Title"));
        news.setContent(rs.getString("Content"));
        news.setImage(rs.getString("Image"));
        news.setPostedDate(rs.getDate("PostedDate"));
        news.setAuthor(rs.getString("Author"));
        news.setViewCount(rs.getInt("ViewCount"));
        news.setCategoryId(rs.getString("CategoryId"));
        news.setHome(rs.getBoolean("Home"));

        // Thông tin join
        news.setCategoryName(rs.getString("CategoryName"));
        news.setAuthorName(rs.getString("AuthorName"));

        // : Lấy dữ liệu Status từ Database lên
        news.setStatus(rs.getInt("Status"));

        // : Đọc dữ liệu SubCategory từ Database lên
        try {
            news.setSubCategory(rs.getString("SubCategory"));
        } catch (SQLException e) {
            // Bỏ qua nếu câu query cũ chưa có cột này
        }

        return news;
    }

    // : Thêm hàm cập nhật trạng thái bài viết dành cho Admin
    public boolean updateStatus(String id, int status) {
        String sql = "UPDATE News SET Status = ? WHERE NewsId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, status);
            stmt.setString(2, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật trạng thái bài viết: " + e.getMessage());
            return false;
        }
    }

    // : Thêm hàm tìm kiếm tin tức theo từ khóa (Chỉ lấy bài đã duyệt Status = 1)
    public List<News> searchByKeyword(String keyword) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName "
                +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Status = 1 AND (n.Title LIKE ? OR n.Content LIKE ?) " +
                "ORDER BY n.PostedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm tin tức: " + e.getMessage());
        }
        return newsList;
    }

    // : Hàm tìm kiếm nhanh cho Auto-complete (Gợi ý)
    public List<News> searchForSuggestion(String keyword, int limit) {
        List<News> newsList = new ArrayList<>();
        // Tìm kiếm giới hạn số lượng, ưu tiên theo Ngày đăng mới nhất
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName " +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Status = 1 AND (n.Title LIKE ? OR n.Content LIKE ?) " +
                "ORDER BY n.PostedDate DESC LIMIT " + limit;

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm gợi ý tin tức: " + e.getMessage());
        }
        return newsList;
    }

    // : Hàm duyệt hàng loạt tất cả các bài viết đang chờ (Status = 0)
    public boolean approveAllPendingNews() {
        String sql = "UPDATE News SET Status = 1 WHERE Status = 0 OR Status IS NULL";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi duyệt tất cả bài viết: " + e.getMessage());
            return false;
        }
    }

    // --- Bổ sung vào bên trong hàm mapResultSetToNews(ResultSet rs) hiện có của
    // bạn ---
    // news.setStatus(rs.getInt("Status")); // : Map cột Status từ DB lên object

    // : Thêm hàm updateComment theo chuẩn Principal Engineer
    public boolean updateComment(String id, String content) {
        // : Đảm bảo tên bảng là 'Comments' (hoặc tên bảng bạn đặt) và bỏ cột lạ gây lỗi
        // SQL
        String sql = "UPDATE Comments SET Content = ? WHERE CommentId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, content);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM News";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm số lượng tin tức: " + e.getMessage());
        }
        return 0;
    }
    /**
     * Lấy danh sách tin tức theo phân trang (Admin)
     */
    public List<News> findAllWithPagination(int offset, int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName " +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "ORDER BY n.PostedDate DESC " +
                "LIMIT ?, ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách tin tức có phân trang: " + e.getMessage());
        }
        return newsList;
    }
    /**
     * Đếm tổng số bài viết của một tác giả cụ thể
     */
    public int countByAuthor(String authorId) {
        String sql = "SELECT COUNT(*) FROM News WHERE Author = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, authorId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm số lượng tin tức theo tác giả: " + e.getMessage());
        }
        return 0;
    }
    /**
     * Lấy danh sách tin tức của một tác giả theo phân trang (Phóng viên)
     */
    public List<News> findByAuthorWithPagination(String authorId, int offset, int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT n.NewsId, n.Title, n.Content, n.Image, n.PostedDate, n.Author, " +
                "n.ViewCount, n.CategoryId, n.Home, n.Status, n.SubCategory, c.Name as CategoryName, u.Fullname as AuthorName " +
                "FROM News n " +
                "LEFT JOIN Categories c ON n.CategoryId = c.CategoryId " +
                "LEFT JOIN Users u ON n.Author = u.UserId " +
                "WHERE n.Author = ? " +
                "ORDER BY n.PostedDate DESC " +
                "LIMIT ?, ?";
                
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, authorId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tin tức theo tác giả có phân trang: " + e.getMessage());
        }
        return newsList;
    }
}
