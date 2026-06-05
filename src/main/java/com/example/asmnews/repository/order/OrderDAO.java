package com.example.asmnews.repository.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.example.asmnews.entity.order.Order;
import com.example.asmnews.util.DatabaseUtils;

/**
 * DAO class cho Order (Đơn đặt báo)
 * Thực hiện các thao tác CRUD với bảng Orders
 */
public class OrderDAO {

    /**
     * Thêm đơn đặt báo mới
     * * @param order Đối tượng Order cần lưu
     * 
     * @return true nếu thành công
     */
    public boolean create(Order order) {
        String sql = "INSERT INTO Orders (UserId, NewspaperType, PackageDuration, FullName, Phone, Email, " + // // FIX
                "Note, TotalAmount, Status, StartDate, EndDate, CreatedDate) " + // // FIX
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; // // FIX

        // FIX: Đã gỡ bỏ RETURN_GENERATED_KEYS gây xung đột với Database Driver
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            // userId = null nghĩa là khách vãng lai, set NULL trong DB
            if (order.getUserId() != null && !order.getUserId().trim().isEmpty()) {
                ps.setString(1, order.getUserId());
            } else {
                ps.setNull(1, Types.VARCHAR);
            }
            ps.setString(2, order.getNewspaperType());
            ps.setString(3, order.getPackageDuration());
            ps.setString(4, order.getFullName());
            ps.setString(5, order.getPhone());
            ps.setString(6, order.getEmail());
            ps.setString(7, order.getNote()); // // FIX
            ps.setInt(8, order.getTotalAmount()); // // FIX
            ps.setString(9, order.getStatus()); // // FIX

            if (order.getStartDate() != null) {
                ps.setTimestamp(10, new java.sql.Timestamp(order.getStartDate().getTime())); // // FIX
            } else {
                ps.setNull(10, Types.TIMESTAMP); // // FIX
            }

            if (order.getEndDate() != null) {
                ps.setTimestamp(11, new java.sql.Timestamp(order.getEndDate().getTime())); // // FIX
            } else {
                ps.setNull(11, Types.TIMESTAMP); // // FIX
            }

            if (order.getCreatedDate() != null) { // // FIX
                ps.setTimestamp(12, new java.sql.Timestamp(order.getCreatedDate().getTime())); // // FIX
            } else { // // FIX
                ps.setTimestamp(12, new java.sql.Timestamp(System.currentTimeMillis())); // // FIX
            } // // FIX

            int affectedRows = ps.executeUpdate();

            // FIX: Cách lấy ID thủ công - An toàn 100% trên mọi loại Database
            if (affectedRows > 0) {
                try (PreparedStatement psId = conn.prepareStatement("SELECT MAX(OrderId) FROM Orders");
                        ResultSet rsId = psId.executeQuery()) {
                    if (rsId.next()) {
                        order.setId(rsId.getInt(1)); // Gán ID vừa tạo vào order
                    }
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo đơn đặt báo: " + e.getMessage());
            e.printStackTrace(); // In lỗi ra Console (IDE) để dễ nhìn
            return false;
        }
    }

    /**
     * Lấy tất cả đơn đặt báo (cho Admin quản lý)
     * * @return Danh sách đơn đặt báo
     */
    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY CreatedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orders.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách đơn đặt báo: " + e.getMessage());
        }

        return orders;
    }

    /**
     * Lấy đơn theo ID
     * * @param id ID đơn hàng
     * 
     * @return Order hoặc null
     */
    public Order findById(int id) {
        String sql = "SELECT * FROM Orders WHERE OrderId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm đơn đặt báo theo ID: " + e.getMessage());
        }

        return null;
    }

    /**
     * Lấy đơn theo userId
     * * @param userId ID người dùng
     * 
     * @return Danh sách đơn của người dùng
     */
    public List<Order> findByUserId(String userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE UserId = ? ORDER BY CreatedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy đơn theo userId: " + e.getMessage());
        }

        return orders;
    }

    /**
     * Cập nhật trạng thái đơn hàng
     * * @param id ID đơn hàng
     * 
     * @param status Trạng thái mới
     * @return true nếu thành công
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật trạng thái đơn: " + e.getMessage());
            return false;
        }
    }

    /**
     * Đếm tổng số đơn đặt báo
     * * @return Số lượng đơn
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Orders";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm đơn đặt báo: " + e.getMessage());
        }

        return 0;
    }

    /**
     * Map ResultSet thành đối tượng Order
     * * @param rs ResultSet từ query
     * 
     * @return Order object
     */
    private Order mapRow(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("OrderId"));

        // userId có thể NULL trong DB (khách vãng lai)
        String userId = rs.getString("UserId");
        if (userId != null) {
            order.setUserId(userId);
        }

        order.setNewspaperType(rs.getString("NewspaperType"));
        order.setPackageDuration(rs.getString("PackageDuration"));
        order.setFullName(rs.getString("FullName"));
        order.setPhone(rs.getString("Phone"));
        order.setEmail(rs.getString("Email"));
        // order.setCity(rs.getString("City")); // // FIX (comment do DB đã DROP cột)
        // order.setDistrict(rs.getString("District")); // // FIX (comment do DB đã DROP cột)
        // order.setWard(rs.getString("Ward")); // // FIX (comment do DB đã DROP cột)
        // order.setAddressDetail(rs.getString("AddressDetail")); // // FIX (comment do DB đã DROP cột)
        order.setNote(rs.getString("Note"));
        order.setTotalAmount(rs.getInt("TotalAmount"));
        order.setStatus(rs.getString("Status"));
        order.setCreatedDate(rs.getTimestamp("CreatedDate"));

        // Thêm cho Premium
        order.setStartDate(rs.getTimestamp("StartDate"));
        order.setEndDate(rs.getTimestamp("EndDate"));

        return order;
    }

    /**
     * Lấy danh sách theo loại báo (Premium hoặc Print)
     */
    public List<Order> findByType(String type) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE NewspaperType = ? ORDER BY CreatedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách theo loại: " + e.getMessage());
        }

        return orders;
    }

    /**
     * Thêm đơn đặt báo mới (Trả về lỗi chi tiết của SQL)
     */
    public String createWithResult(Order order) {
        String sql = "INSERT INTO Orders (UserId, NewspaperType, PackageDuration, FullName, Phone, Email, " + // // FIX
                "Note, TotalAmount, Status, StartDate, EndDate, CreatedDate) " + // // FIX
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; // // FIX

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (order.getUserId() != null && !order.getUserId().trim().isEmpty()) {
                ps.setString(1, order.getUserId());
            } else {
                ps.setNull(1, Types.VARCHAR);
            }
            ps.setString(2, order.getNewspaperType());
            ps.setString(3, order.getPackageDuration());
            ps.setString(4, order.getFullName());
            ps.setString(5, order.getPhone());
            ps.setString(6, order.getEmail());
            ps.setString(7, order.getNote()); // // FIX
            ps.setInt(8, order.getTotalAmount()); // // FIX
            ps.setString(9, order.getStatus()); // // FIX

            if (order.getStartDate() != null) {
                ps.setTimestamp(10, new java.sql.Timestamp(order.getStartDate().getTime())); // // FIX
            } else {
                ps.setNull(10, Types.TIMESTAMP); // // FIX
            }

            if (order.getEndDate() != null) {
                ps.setTimestamp(11, new java.sql.Timestamp(order.getEndDate().getTime())); // // FIX
            } else {
                ps.setNull(11, Types.TIMESTAMP); // // FIX
            }

            if (order.getCreatedDate() != null) { // // FIX
                ps.setTimestamp(12, new java.sql.Timestamp(order.getCreatedDate().getTime())); // // FIX
            } else { // // FIX
                ps.setTimestamp(12, new java.sql.Timestamp(System.currentTimeMillis())); // // FIX
            } // // FIX

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                // Lấy ID vừa tạo
                try (PreparedStatement psId = conn.prepareStatement("SELECT MAX(OrderId) FROM Orders");
                        ResultSet rsId = psId.executeQuery()) {
                    if (rsId.next()) {
                        order.setId(rsId.getInt(1));
                    }
                }
                return "success";
            }
            return "Không có dòng nào được lưu vào Database.";

        } catch (SQLException e) {
            e.printStackTrace();
            // Trả về chính xác thông báo lỗi từ Database
            return e.getMessage();
        }
    }
}