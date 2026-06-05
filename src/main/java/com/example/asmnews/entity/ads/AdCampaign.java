package com.example.asmnews.entity.ads;

import java.sql.Timestamp;

public class AdCampaign {
    private int id; // CampaignId
    private int contractId;
    private int positionId;
    private String campaignName;
    private java.sql.Date startDate;
    private java.sql.Date endDate;
    private String targetUrl;
    private String driveUrl;
    private String imageUrl;
    private String status; // PENDING, APPROVED, RUNNING, STOPPED, REJECTED
    private String approvedBy;

    // Optional fields from JOINs (AdContract, Users)
    private AdContract contract;
    private AdPosition position;
    
    public AdCampaign() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getContractId() { return contractId; }
    public void setContractId(int contractId) { this.contractId = contractId; }
    
    public int getPositionId() { return positionId; }
    public void setPositionId(int positionId) { this.positionId = positionId; }
    
    public String getCampaignName() { return campaignName; }
    public void setCampaignName(String campaignName) { this.campaignName = campaignName; }
    
    public java.sql.Date getStartDate() { return startDate; }
    public void setStartDate(java.sql.Date startDate) { this.startDate = startDate; }
    
    public java.sql.Date getEndDate() { return endDate; }
    public void setEndDate(java.sql.Date endDate) { this.endDate = endDate; }
    
    public String getTargetUrl() { return targetUrl; }
    public void setTargetUrl(String targetUrl) { this.targetUrl = targetUrl; }
    
    public String getDriveUrl() { return driveUrl; }
    public void setDriveUrl(String driveUrl) { this.driveUrl = driveUrl; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getApprovedBy() { return approvedBy; }
    public void setApprovedBy(String approvedBy) { this.approvedBy = approvedBy; }

    public AdContract getContract() { return contract; }
    public void setContract(AdContract contract) { this.contract = contract; }

    public AdPosition getPosition() { return position; }
    public void setPosition(AdPosition position) { this.position = position; }
}
