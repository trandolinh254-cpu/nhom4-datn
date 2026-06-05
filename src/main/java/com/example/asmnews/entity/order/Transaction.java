package com.example.asmnews.entity.order;

import java.util.Date;

/**
 * Entity đại diện cho Lịch sử giao dịch (Transaction)
 */
public class Transaction {
    private int id;
    private Integer orderId;
    private String userId;
    private String transactionType; // "premium" hoặc "print"
    private int amount;
    private String paymentMethod; // "bank_transfer", "e_wallet", "cod"
    private String status; // "success", "failed", "pending"
    private String transactionAction; // "new", "renew", "upgrade", "refund"
    private Date createdDate;

    // Các trường phụ trợ (dùng để hiển thị)
    private String userFullName;
    private String userEmail;

    public Transaction() {
        this.createdDate = new Date();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionAction() {
        return transactionAction;
    }

    public void setTransactionAction(String transactionAction) {
        this.transactionAction = transactionAction;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
}
