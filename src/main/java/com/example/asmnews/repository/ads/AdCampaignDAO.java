package com.example.asmnews.repository.ads;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.example.asmnews.entity.ads.AdCampaign;
import com.example.asmnews.entity.ads.AdContract;
import com.example.asmnews.entity.ads.AdCustomerDTO;
import com.example.asmnews.util.DatabaseUtils;

public class AdCampaignDAO {

    public boolean insert(AdCampaign camp) {
        String sql = "INSERT INTO ad_campaigns (contract_id, position_id, campaign_name, start_date, end_date, target_url, drive_url, image_url, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, camp.getContractId());
            ps.setInt(2, camp.getPositionId());
            ps.setString(3, camp.getCampaignName());
            if (camp.getStartDate() != null) {
                ps.setDate(4, new java.sql.Date(camp.getStartDate().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            if (camp.getEndDate() != null) {
                ps.setDate(5, new java.sql.Date(camp.getEndDate().getTime()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }
            ps.setString(6, camp.getTargetUrl());
            ps.setString(7, camp.getDriveUrl());
            ps.setString(8, camp.getImageUrl());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<AdCampaign> getRecentPendingCampaigns() {
        List<AdCampaign> list = new ArrayList<>();
        // JOIN with ad_contracts to get contact_name, email, total_price
        String sql = "SELECT c.*, ct.contact_name, ct.email, ct.total_price, ct.created_at " +
                "FROM ad_campaigns c " +
                "INNER JOIN ad_contracts ct ON c.contract_id = ct.ContractId " +
                "WHERE c.status = 'PENDING' ORDER BY ct.created_at DESC LIMIT 5";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdCampaign camp = new AdCampaign();
                camp.setId(rs.getInt("CampaignId"));
                camp.setContractId(rs.getInt("contract_id"));
                camp.setCampaignName(rs.getString("campaign_name"));
                camp.setStatus(rs.getString("status"));

                AdContract contract = new AdContract();
                contract.setContactName(rs.getString("contact_name"));
                contract.setEmail(rs.getString("email"));
                contract.setTotalPrice(rs.getDouble("total_price"));
                contract.setCreatedAt(rs.getTimestamp("created_at"));
                camp.setContract(contract);

                list.add(camp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean approveAd(int campaignId, String imageUrl, String adminId) {
        String sql = "UPDATE ad_campaigns SET status = 'RUNNING', image_url = COALESCE(?, image_url), approved_by = ? WHERE CampaignId = ?";
        String sqlContract = "UPDATE ad_contracts SET status = 'RUNNING' WHERE ContractId = (SELECT contract_id FROM ad_campaigns WHERE CampaignId = ?)";
        try (Connection conn = DatabaseUtils.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql);
                    PreparedStatement psContract = conn.prepareStatement(sqlContract)) {

                ps.setString(1, imageUrl);
                ps.setString(2, adminId);
                ps.setInt(3, campaignId);
                int rowCamp = ps.executeUpdate();

                psContract.setInt(1, campaignId);
                psContract.executeUpdate();

                conn.commit();
                return rowCamp > 0;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectAd(int campaignId, String adminId) {
        String sql = "UPDATE ad_campaigns SET status = 'REJECTED', approved_by = ? WHERE CampaignId = ?";
        String sqlContract = "UPDATE ad_contracts SET status = 'REJECTED' WHERE ContractId = (SELECT contract_id FROM ad_campaigns WHERE CampaignId = ?)";
        try (Connection conn = DatabaseUtils.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql);
                    PreparedStatement psContract = conn.prepareStatement(sqlContract)) {

                ps.setString(1, adminId);
                ps.setInt(2, campaignId);
                int rowCamp = ps.executeUpdate();

                psContract.setInt(1, campaignId);
                psContract.executeUpdate();

                conn.commit();
                return rowCamp > 0;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean stopAd(int campaignId, String adminId) {
        String sql = "UPDATE ad_campaigns SET status = 'STOPPED', approved_by = ? WHERE CampaignId = ?";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, adminId);
            ps.setInt(2, campaignId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<AdCampaign> getRunningCampaigns() {
        List<AdCampaign> list = new ArrayList<>();
        String sql = "SELECT c.*, ct.contact_name, ct.email " +
                "FROM ad_campaigns c INNER JOIN ad_contracts ct ON c.contract_id = ct.ContractId " +
                "WHERE c.status = 'RUNNING' ORDER BY c.CampaignId DESC LIMIT 10";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdCampaign camp = new AdCampaign();
                camp.setId(rs.getInt("CampaignId"));
                camp.setContractId(rs.getInt("contract_id"));
                camp.setPositionId(rs.getInt("position_id"));
                camp.setCampaignName(rs.getString("campaign_name"));
                camp.setStatus(rs.getString("status"));
                camp.setImageUrl(rs.getString("image_url"));

                AdContract contract = new AdContract();
                contract.setContactName(rs.getString("contact_name"));
                contract.setEmail(rs.getString("email"));
                camp.setContract(contract);
                list.add(camp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<AdCustomerDTO> getAdCustomers() {
        List<AdCustomerDTO> list = new ArrayList<>();

        String sql = "SELECT u.UserId, u.Fullname as fullname, u.Email as email, u.Mobile as phone, COUNT(c.CampaignId) as total_campaigns, SUM(ct.total_price) as total_spent "
                +
                "FROM Users u INNER JOIN ad_contracts ct ON u.UserId = ct.user_id " +
                "INNER JOIN ad_campaigns c ON ct.ContractId = c.contract_id " +
                "GROUP BY u.UserId, u.Fullname, u.Email, u.Mobile ORDER BY total_spent DESC";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdCustomerDTO dto = new AdCustomerDTO();
                dto.setId(rs.getString("UserId"));
                dto.setFullname(rs.getString("fullname"));
                dto.setEmail(rs.getString("email"));
                dto.setPhone(rs.getString("phone"));
                dto.setTotalCampaigns(rs.getInt("total_campaigns"));
                dto.setTotalSpent(rs.getDouble("total_spent"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public AdCampaign getRunningAdByPosition(int positionId) {
        String sql = "SELECT c.* FROM ad_campaigns c " +
                "INNER JOIN ad_positions p ON c.position_id = p.PositionId " +
                "WHERE c.status = 'RUNNING' AND p.status = 'ACTIVE' AND c.position_id = ? " +
                "ORDER BY c.CampaignId DESC LIMIT 1";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, positionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdCampaign camp = new AdCampaign();
                    camp.setId(rs.getInt("CampaignId"));
                    camp.setContractId(rs.getInt("contract_id"));
                    camp.setPositionId(rs.getInt("position_id"));
                    camp.setCampaignName(rs.getString("campaign_name"));
                    camp.setStartDate(rs.getDate("start_date"));
                    camp.setEndDate(rs.getDate("end_date"));
                    camp.setTargetUrl(rs.getString("target_url"));
                    camp.setImageUrl(rs.getString("image_url"));
                    return camp;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<AdCampaign> getRunningAdsByPosition(int positionId) {
        List<AdCampaign> list = new ArrayList<>();
        String sql = "SELECT c.* FROM ad_campaigns c " +
                "INNER JOIN ad_positions p ON c.position_id = p.PositionId " +
                "WHERE c.status = 'RUNNING' AND p.status = 'ACTIVE' AND c.position_id = ? " +
                "ORDER BY c.CampaignId DESC";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, positionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdCampaign camp = new AdCampaign();
                    camp.setId(rs.getInt("CampaignId"));
                    camp.setContractId(rs.getInt("contract_id"));
                    camp.setPositionId(rs.getInt("position_id"));
                    camp.setCampaignName(rs.getString("campaign_name"));
                    camp.setStartDate(rs.getDate("start_date"));
                    camp.setEndDate(rs.getDate("end_date"));
                    camp.setTargetUrl(rs.getString("target_url"));
                    camp.setImageUrl(rs.getString("image_url"));
                    list.add(camp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countPendingCampaigns() {
        String sql = "SELECT COUNT(*) FROM ad_campaigns WHERE status = 'PENDING'";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countRunningCampaigns() {
        String sql = "SELECT COUNT(*) FROM ad_campaigns WHERE status = 'RUNNING'";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double calculateMonthlyRevenue() {
        String sql = "SELECT SUM(ct.total_price) FROM ad_contracts ct " +
                "WHERE ct.status IN ('PAID', 'APPROVED', 'RUNNING', 'COMPLETED') AND MONTH(ct.created_at) = MONTH(NOW()) AND YEAR(ct.created_at) = YEAR(NOW())";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // : Thêm hàm thống kê doanh thu theo từng tháng trong năm
    public java.util.Map<Integer, Double> getRevenueByMonth(int year) {
        java.util.Map<Integer, Double> revenueMap = new java.util.HashMap<>();
        // Khởi tạo 12 tháng bằng 0
        for (int i = 1; i <= 12; i++) {
            revenueMap.put(i, 0.0);
        }

        String sql = "SELECT MONTH(created_at) as month, SUM(total_price) as total " +
                "FROM ad_contracts " +
                "WHERE YEAR(created_at) = ? AND status IN ('PAID', 'APPROVED', 'RUNNING', 'COMPLETED') " +
                "GROUP BY MONTH(created_at)";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revenueMap.put(rs.getInt("month"), rs.getDouble("total"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueMap;
    }

    // : Truy vết toàn bộ chiến dịch trước tháng 6
    public List<AdCampaign> getOldCampaignsBeforeJune(int currentYear) {
        List<AdCampaign> list = new ArrayList<>();
        String sql = "SELECT * FROM ad_campaigns "
                + "WHERE MONTH(start_date) < 6 AND YEAR(start_date) = ? "
                + "ORDER BY start_date DESC";

        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, currentYear);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdCampaign campaign = new AdCampaign();
                    campaign.setId(rs.getInt("CampaignId"));
                    campaign.setContractId(rs.getInt("contract_id"));
                    campaign.setCampaignName(rs.getString("campaign_name"));
                    campaign.setStartDate(rs.getDate("start_date"));
                    campaign.setEndDate(rs.getDate("end_date"));

                    list.add(campaign);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi truy vết chiến dịch cũ: " + e.getMessage());
        }
        return list;
    }

    public List<Integer> getOccupiedPositionIds() {
        List<Integer> list = new ArrayList<>();
        // Lấy danh sách position_id của các quảng cáo đang chạy hoặc đang chờ (tránh
        // đặt trùng)
        String sql = "SELECT DISTINCT position_id FROM ad_campaigns WHERE status IN ('RUNNING', 'PENDING', 'APPROVED')";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt("position_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<AdCampaign> getMyCampaigns(String userId) {
        List<AdCampaign> list = new ArrayList<>();
        String sql = "SELECT c.*, ct.contact_name, ct.email, ct.total_price, ct.created_at " +
                "FROM ad_campaigns c " +
                "INNER JOIN ad_contracts ct ON c.contract_id = ct.ContractId " +
                "WHERE ct.user_id = ? ORDER BY c.CampaignId DESC";
        try (Connection conn = DatabaseUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdCampaign camp = new AdCampaign();
                    camp.setId(rs.getInt("CampaignId"));
                    camp.setContractId(rs.getInt("contract_id"));
                    camp.setPositionId(rs.getInt("position_id"));
                    camp.setCampaignName(rs.getString("campaign_name"));
                    camp.setTargetUrl(rs.getString("target_url"));
                    camp.setImageUrl(rs.getString("image_url"));
                    camp.setStatus(rs.getString("status"));
                    camp.setStartDate(rs.getDate("start_date"));

                    com.example.asmnews.entity.ads.AdContract contract = new com.example.asmnews.entity.ads.AdContract();
                    contract.setContactName(rs.getString("contact_name"));
                    contract.setEmail(rs.getString("email"));
                    contract.setTotalPrice(rs.getDouble("total_price"));
                    contract.setCreatedAt(rs.getTimestamp("created_at"));
                    camp.setContract(contract);

                    list.add(camp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
