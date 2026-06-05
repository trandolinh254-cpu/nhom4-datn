package com.example.asmnews.repository.ads;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.example.asmnews.entity.ads.AdContract;
import com.example.asmnews.util.DatabaseUtils;

public class AdContractDAO {
    
    public int insert(AdContract contract) {
        String sql = "INSERT INTO ad_contracts (user_id, company_name, billing_address, contact_name, phone, email, total_price, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, contract.getUserId());
            ps.setString(2, contract.getCompanyName());
            ps.setString(3, contract.getBillingAddress());
            ps.setString(4, contract.getContactName());
            ps.setString(5, contract.getPhone());
            ps.setString(6, contract.getEmail());
            ps.setDouble(7, contract.getTotalPrice());
            ps.setString(8, contract.getStatus());
            
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public AdContract findById(int id) {
        String sql = "SELECT * FROM ad_contracts WHERE ContractId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdContract c = new AdContract();
                    c.setId(rs.getInt("ContractId"));
                    c.setUserId(rs.getString("user_id"));
                    c.setCompanyName(rs.getString("company_name"));
                    c.setBillingAddress(rs.getString("billing_address"));
                    c.setContactName(rs.getString("contact_name"));
                    c.setPhone(rs.getString("phone"));
                    c.setEmail(rs.getString("email"));
                    c.setTotalPrice(rs.getDouble("total_price"));
                    c.setStatus(rs.getString("status"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
