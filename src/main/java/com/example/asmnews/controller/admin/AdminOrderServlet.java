package com.example.asmnews.controller.admin;

import java.io.IOException;
import java.util.List;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.order.Order;
import com.example.asmnews.entity.order.Transaction;
import com.example.asmnews.repository.order.OrderDAO;
import com.example.asmnews.repository.order.TransactionDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/orders/*")
public class AdminOrderServlet extends BaseServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/premium";

        try {
            switch (pathInfo) {
                case "/premium":
                    showPremiumManagement(request, response);
                    break;

                case "/transactions":
                    showTransactions(request, response);
                    break;
                case "/transactions/detail":
                    showTransactionDetail(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            setErrorMessage(request, "Có lỗi xảy ra: " + e.getMessage());
            redirect(response, request.getContextPath() + "/admin");
        }
    }

    private void showPremiumManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> premiumOrders = orderDAO.findByType("digital");
        
        java.util.Map<Integer, Transaction> txMap = new java.util.HashMap<>();
        for (Order o : premiumOrders) {
            Transaction tx = transactionDAO.findByOrderId(o.getId());
            if (tx != null) {
                txMap.put(o.getId(), tx);
            }
        }
        
        request.setAttribute("orders", premiumOrders);
        request.setAttribute("txMap", txMap);
        forward(request, response, "/WEB-INF/views/admin/transactions/order-premium.jsp");
    }


    private void showTransactions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Transaction> transactions = transactionDAO.findAll();
        request.setAttribute("transactions", transactions);
        forward(request, response, "/WEB-INF/views/admin/transactions/transaction-history.jsp");
    }

    private void showTransactionDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            redirect(response, request.getContextPath() + "/admin/orders/transactions");
            return;
        }

        int id = Integer.parseInt(idStr);
        Transaction tx = transactionDAO.findById(id);
        if (tx == null) {
            setErrorMessage(request, "Không tìm thấy giao dịch!");
            redirect(response, request.getContextPath() + "/admin/orders/transactions");
            return;
        }

        request.setAttribute("transaction", tx);

        // Nếu giao dịch liên kết với order thì load thêm order
        if (tx.getOrderId() != null && tx.getOrderId() != 0) {
            Order order = orderDAO.findById(tx.getOrderId());
            request.setAttribute("order", order);
        }

        forward(request, response, "/WEB-INF/views/admin/transactions/transaction-detail.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        try {
            switch (pathInfo) {
                case "/update-status":
                    updateOrderStatus(request, response);
                    break;
                case "/update-transaction-status":
                    updateTransactionStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            setErrorMessage(request, "Lỗi cập nhật: " + e.getMessage());
            redirect(response, request.getHeader("Referer"));
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status"); // VD: "active", "delivered", "cancelled"...

        if (orderDAO.updateStatus(orderId, status)) {
            // Lấy thông tin đơn hàng để kiểm tra loại
            Order order = orderDAO.findById(orderId);

            // =======================================================
            // FIX: ĐỒNG BỘ TRẠNG THÁI GIAO DỊCH (TRANSACTION) & KÍCH HOẠT PREMIUM
            // =======================================================
            String txStatus = "pending";
            // Các trạng thái đơn hàng coi là "Thành công"
            boolean isSuccessStatus = "active".equals(status) || "delivered".equals(status) || "completed".equals(status);
            if (isSuccessStatus) {
                txStatus = "success";
            }
            // Các trạng thái đơn hàng coi là "Thất bại" hoặc Hủy
            else if ("cancelled".equals(status) || "failed".equals(status)) {
                txStatus = "failed";
            }

            // Gọi hàm DAO để update bên bảng Transactions
            boolean txUpdated = transactionDAO.updateStatusByOrderId(orderId, txStatus);
            if (!txUpdated) {
                System.err.println(
                        "Cảnh báo: Cập nhật Order thành công nhưng chưa đổi được trạng thái Transaction liên kết.");
            }

            // Kích hoạt Premium cho User nếu đây là đơn hàng Báo điện tử Premium thành công
            if (order != null && "digital".equals(order.getNewspaperType()) && isSuccessStatus) {
                String userId = order.getUserId();
                if (userId != null && !userId.trim().isEmpty()) {
                    com.example.asmnews.repository.auth.UserDAO userDAO = new com.example.asmnews.repository.auth.UserDAO();
                    boolean userUpgraded = userDAO.upgradeToPremium(userId);
                    if (userUpgraded) {
                        System.out.println("Đã tự động kích hoạt tài khoản Premium thành công cho User: " + userId);
                    } else {
                        System.err.println("Lỗi: Không thể tự động nâng cấp Premium cho User: " + userId);
                    }
                }
            }
            // =======================================================

            setSuccessMessage(request, "Cập nhật trạng thái thành công!");
        } else {
            setErrorMessage(request, "Lỗi khi cập nhật trạng thái!");
        }
        redirect(response, request.getHeader("Referer"));
    }

    private void updateTransactionStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Cập nhật sau (nếu cần thiết cho phép admin thay đổi thủ công)
        redirect(response, request.getHeader("Referer"));
    }
}