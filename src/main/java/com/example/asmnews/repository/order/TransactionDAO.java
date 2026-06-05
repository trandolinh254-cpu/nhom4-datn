package com.example.asmnews.repository.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.example.asmnews.entity.order.Transaction;
import com.example.asmnews.util.DatabaseUtils;

public class TransactionDAO {

    public boolean create(Transaction tx) {
        String sql = "INSERT INTO Transactions (OrderId, UserId, TransactionType, Amount, PaymentMethod, Status, TransactionAction) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (tx.getOrderId() != null) {
                ps.setInt(1, tx.getOrderId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            if (tx.getUserId() != null && !tx.getUserId().trim().isEmpty()) {
                ps.setString(2, tx.getUserId());
            } else {
                ps.setNull(2, Types.VARCHAR);
            }

            ps.setString(3, tx.getTransactionType());
            ps.setInt(4, tx.getAmount());
            ps.setString(5, tx.getPaymentMethod());
            ps.setString(6, tx.getStatus());
            ps.setString(7, tx.getTransactionAction());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi tạo Transaction: " + e.getMessage());
            return false;
        }
    }

    public List<Transaction> findAll() {
        List<Transaction> list = new ArrayList<>();
        // JOIN với Users để lấy Fullname và Email hiển thị
        String sql = "SELECT t.*, u.Fullname, u.Email " +
                "FROM Transactions t " +
                "LEFT JOIN Users u ON t.UserId = u.Id " +
                "ORDER BY t.CreatedDate DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi findAll Transaction: " + e.getMessage());
        }
        return list;
    }

    public Transaction findById(int id) {
        String sql = "SELECT t.*, u.Fullname, u.Email " +
                "FROM Transactions t " +
                "LEFT JOIN Users u ON t.UserId = u.Id " +
                "WHERE TransactionId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi findById Transaction: " + e.getMessage());
        }
        return null;
    }

    public Transaction findByOrderId(int orderId) {
        String sql = "SELECT t.*, u.Fullname, u.Email " +
                "FROM Transactions t " +
                "LEFT JOIN Users u ON t.UserId = u.Id " +
                "WHERE OrderId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi findByOrderId Transaction: " + e.getMessage());
        }
        return null;
    }

    private Transaction mapRow(ResultSet rs) throws SQLException {
        Transaction tx = new Transaction();
        tx.setId(rs.getInt("TransactionId"));

        int orderId = rs.getInt("OrderId");
        if (!rs.wasNull()) {
            tx.setOrderId(orderId);
        }

        tx.setUserId(rs.getString("UserId"));
        tx.setTransactionType(rs.getString("TransactionType"));
        tx.setAmount(rs.getInt("Amount"));
        tx.setPaymentMethod(rs.getString("PaymentMethod"));
        tx.setStatus(rs.getString("Status"));
        tx.setTransactionAction(rs.getString("TransactionAction"));
        tx.setCreatedDate(rs.getTimestamp("CreatedDate"));

        // Cột join thêm
        tx.setUserFullName(rs.getString("Fullname"));
        tx.setUserEmail(rs.getString("Email"));

        return tx;
    }

    /**
     * Cập nhật trạng thái Giao dịch dựa trên ID Đơn hàng
     * 
     * @param orderId ID của đơn hàng
     * @param status  Trạng thái giao dịch mới (success, failed, pending)
     * @return true nếu thành công
     */
    public boolean updateStatusByOrderId(int orderId, String status) {
        String sql = "UPDATE Transactions SET Status = ? WHERE OrderId = ?";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật trạng thái Transaction: " + e.getMessage());
            return false;
        }
    }
}
