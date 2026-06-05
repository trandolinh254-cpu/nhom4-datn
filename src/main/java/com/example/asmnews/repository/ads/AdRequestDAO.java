package com.example.asmnews.repository.ads;

import com.example.asmnews.entity.ads.AdCustomerDTO;
import com.example.asmnews.entity.ads.AdRequest;
import com.example.asmnews.util.DatabaseUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdRequestDAO {

    // 1. Lưu đơn đăng ký quảng cáo mới từ Khách hàng
    public boolean insert(AdRequest req) throws Exception {
        String sql = "INSERT INTO ad_requests (user_id, position_id, campaign_name, start_date, duration, " +
                     "target_url, drive_url, image_url, contact_name, phone, email, company_name, billing_address, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";
                     
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, req.getUserId());
            ps.setInt(2, req.getPositionId());
            ps.setString(3, req.getCampaignName());
            if (req.getStartDate() != null) {
                ps.setDate(4, new java.sql.Date(req.getStartDate().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            ps.setString(5, req.getDuration());
            ps.setString(6, req.getTargetUrl());
            ps.setString(7, req.getDriveUrl());
            ps.setString(8, req.getImageUrl());
            ps.setString(9, req.getContactName());
            ps.setString(10, req.getPhone());
            ps.setString(11, req.getEmail());
            ps.setString(12, req.getCompanyName());
            ps.setString(13, req.getBillingAddress());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    // 2. Lấy danh sách 5 đơn chờ duyệt mới nhất cho Dashboard Admin
    public List<AdRequest> getRecentPendingRequests() {
        List<AdRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM ad_requests WHERE status = 'PENDING' ORDER BY created_at DESC LIMIT 5"; // Dùng LIMIT 5 nếu là MySQL
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                AdRequest req = new AdRequest();
                req.setId(rs.getInt("RequestId"));
                req.setCampaignName(rs.getString("campaign_name"));
                req.setContactName(rs.getString("contact_name"));
                req.setEmail(rs.getString("email"));
                req.setTotalPrice(rs.getDouble("total_price"));
                req.setStatus(rs.getString("status"));
                req.setCreatedAt(rs.getDate("created_at"));
                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // 3. Admin duyệt đơn: Đổi status thành RUNNING và lưu link ảnh đã upload
    public boolean approveAd(int requestId, String imageUrl, int adminId) {
        String sql = "UPDATE ad_requests SET status = 'RUNNING', image_url = COALESCE(?, image_url), approved_by = ? WHERE RequestId = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, imageUrl); // Sẽ truyền null nếu admin không up ảnh mới
            ps.setInt(2, adminId);
            ps.setInt(3, requestId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 4. Admin từ chối đơn: Đổi status thành REJECTED
    public boolean rejectAd(int requestId, int adminId) {
        String sql = "UPDATE ad_requests SET status = 'REJECTED', approved_by = ? WHERE RequestId = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, adminId);
            ps.setInt(2, requestId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 5. Admin hủy đơn đang chạy: Đổi status thành STOPPED
    public boolean stopAd(int requestId, int adminId) {
        String sql = "UPDATE ad_requests SET status = 'STOPPED', approved_by = ? WHERE RequestId = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, adminId);
            ps.setInt(2, requestId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 6. Lấy danh sách đơn đang chạy (RUNNING) cho Admin
    public List<AdRequest> getRunningRequests() {
        List<AdRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM ad_requests WHERE status = 'RUNNING' ORDER BY RequestId DESC LIMIT 10";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                AdRequest req = new AdRequest();
                req.setId(rs.getInt("RequestId"));
                req.setCampaignName(rs.getString("campaign_name"));
                req.setContactName(rs.getString("contact_name"));
                req.setEmail(rs.getString("email"));
                req.setStatus(rs.getString("status"));
                req.setCreatedAt(rs.getDate("created_at"));
                req.setImageUrl(rs.getString("image_url"));
                req.setPositionId(rs.getInt("position_id"));
                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Lấy danh sách khách hàng đã chạy quảng cáo (Gom nhóm theo User)
    public List<AdCustomerDTO> getAdCustomers() {
        List<AdCustomerDTO> list = new ArrayList<>();
        // INNER JOIN lấy User có đơn, đếm số chiến dịch và tổng tiền
        String sql = "SELECT u.UserId, u.fullname, u.email, u.phone, COUNT(r.RequestId) as total_campaigns, SUM(r.total_price) as total_spent " +
                     "FROM users u INNER JOIN ad_requests r ON u.UserId = r.user_id " +
                     "GROUP BY u.UserId, u.fullname, u.email, u.phone ORDER BY total_spent DESC";
                     
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                AdCustomerDTO c = new AdCustomerDTO();
                c.setId(rs.getString("UserId"));
                c.setFullname(rs.getString("fullname"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setTotalCampaigns(rs.getInt("total_campaigns"));
                c.setTotalSpent(rs.getDouble("total_spent"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Lấy quảng cáo đang chạy theo ID vị trí (1: Top, 2: Sidebar) - Chỉ lấy 1 cái mới nhất (cho Top, Masthead)
    public AdRequest getRunningAdByPosition(int positionId) {
        String sql = "SELECT * FROM ad_requests WHERE status = 'RUNNING' AND position_id = ? ORDER BY RequestId DESC LIMIT 1";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, positionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdRequest req = new AdRequest();
                    req.setId(rs.getInt("RequestId"));
                    req.setUserId(rs.getString("user_id"));
                    req.setPositionId(rs.getInt("position_id"));
                    req.setCampaignName(rs.getString("campaign_name"));
                    req.setStartDate(rs.getDate("start_date"));
                    req.setDuration(rs.getString("duration"));
                    req.setTargetUrl(rs.getString("target_url"));
                    req.setImageUrl(rs.getString("image_url"));
                    return req;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy TẤT CẢ quảng cáo đang chạy theo ID vị trí (Cho Sidebar để có thể xếp chồng nhiều banner)
    public List<AdRequest> getRunningAdsByPosition(int positionId) {
        List<AdRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM ad_requests WHERE status = 'RUNNING' AND position_id = ? ORDER BY RequestId DESC";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, positionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdRequest req = new AdRequest();
                    req.setId(rs.getInt("RequestId"));
                    req.setUserId(rs.getString("user_id"));
                    req.setPositionId(rs.getInt("position_id"));
                    req.setCampaignName(rs.getString("campaign_name"));
                    req.setStartDate(rs.getDate("start_date"));
                    req.setDuration(rs.getString("duration"));
                    req.setTargetUrl(rs.getString("target_url"));
                    req.setImageUrl(rs.getString("image_url"));
                    list.add(req);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countPendingRequests() {
        String sql = "SELECT COUNT(*) FROM ad_requests WHERE status = 'PENDING'";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countRunningRequests() {
        String sql = "SELECT COUNT(*) FROM ad_requests WHERE status = 'RUNNING'";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double calculateMonthlyRevenue() {
        // Tuỳ thuộc SQL Server hoặc MySQL
        String sql = "SELECT SUM(total_price) FROM ad_requests WHERE status IN ('RUNNING', 'COMPLETED') AND MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}