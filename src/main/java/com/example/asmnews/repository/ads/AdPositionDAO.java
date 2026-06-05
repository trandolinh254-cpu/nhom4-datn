package com.example.asmnews.repository.ads;

import com.example.asmnews.entity.ads.AdPosition;
import com.example.asmnews.util.DatabaseUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdPositionDAO {
    
    // Lấy danh sách vị trí quảng cáo theo Nền tảng (ONLINE hoặc PRINT)
    public List<AdPosition> findByPlatform(String platform) {
        List<AdPosition> list = new ArrayList<>();
        String sql = "SELECT * FROM ad_positions WHERE platform = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, platform);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdPosition pos = new AdPosition();
                    pos.setId(rs.getInt("PositionId"));
                    pos.setPlatform(rs.getString("platform"));
                    pos.setName(rs.getString("name"));
                    pos.setSizeDesc(rs.getString("size_desc"));
                    pos.setBasePrice(rs.getDouble("base_price"));
                    pos.setStatus(rs.getString("status"));
                    list.add(pos);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách TẤT CẢ vị trí quảng cáo theo Nền tảng (Cho Admin)
    public List<AdPosition> findAllByPlatform(String platform) {
        List<AdPosition> list = new ArrayList<>();
        String sql = "SELECT * FROM ad_positions WHERE platform = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, platform);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdPosition pos = new AdPosition();
                    pos.setId(rs.getInt("PositionId"));
                    pos.setPlatform(rs.getString("platform"));
                    pos.setName(rs.getString("name"));
                    pos.setSizeDesc(rs.getString("size_desc"));
                    pos.setBasePrice(rs.getDouble("base_price"));
                    pos.setStatus(rs.getString("status"));
                    list.add(pos);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public AdPosition findById(int id) {
        String sql = "SELECT * FROM ad_positions WHERE PositionId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdPosition pos = new AdPosition();
                    pos.setId(rs.getInt("PositionId"));
                    pos.setPlatform(rs.getString("platform"));
                    pos.setName(rs.getString("name"));
                    pos.setSizeDesc(rs.getString("size_desc"));
                    pos.setBasePrice(rs.getDouble("base_price"));
                    pos.setStatus(rs.getString("status"));
                    return pos;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(AdPosition pos) {
        String sql = "INSERT INTO ad_positions (PositionId, platform, name, size_desc, base_price, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pos.getId());
            ps.setString(2, pos.getPlatform());
            ps.setString(3, pos.getName());
            ps.setString(4, pos.getSizeDesc());
            ps.setDouble(5, pos.getBasePrice());
            ps.setString(6, pos.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(AdPosition pos) {
        String sql = "UPDATE ad_positions SET platform = ?, name = ?, size_desc = ?, base_price = ?, status = ? WHERE PositionId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pos.getPlatform());
            ps.setString(2, pos.getName());
            ps.setString(3, pos.getSizeDesc());
            ps.setDouble(4, pos.getBasePrice());
            ps.setString(5, pos.getStatus());
            ps.setInt(6, pos.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}