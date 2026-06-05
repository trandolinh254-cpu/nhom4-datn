package com.example.asmnews.controller.order;

import java.io.IOException;
import java.util.List;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.entity.news.Category;
import com.example.asmnews.entity.order.Order;
import com.example.asmnews.entity.order.Transaction; // Đã thêm Transaction Entity
import com.example.asmnews.repository.news.CategoryDAO;
import com.example.asmnews.repository.order.OrderDAO;
import com.example.asmnews.repository.order.TransactionDAO; // Đã thêm TransactionDAO

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý trang Đặt báo
 * GET /order → Hiển thị form đặt báo
 * POST /order → Xử lý đơn đặt báo mới
 */
@WebServlet(urlPatterns = "/order")
public class OrderServlet extends BaseServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private TransactionDAO txDAO = new TransactionDAO(); // Khởi tạo DAO cho Transaction

    /**
     * Hiển thị form đặt báo
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy categories cho header menu
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);

            // Nếu đã đăng nhập, điền sẵn thông tin user
            User currentUser = getCurrentUser(request);
            if (currentUser != null) {
                if (currentUser.isPremium()) {
                    setErrorMessage(request, "Tài khoản của bạn đã là Premium Trọn Đời. Không cần đăng ký lại!");
                    redirect(response, request.getContextPath() + "/");
                    return;
                }
                request.setAttribute("prefillName", currentUser.getFullname());
                request.setAttribute("prefillEmail", currentUser.getEmail());
            }

            // Forward đến trang đặt báo
            forward(request, response, "/WEB-INF/views/order/order.jsp");

        } catch (Exception e) {
            System.err.println("Lỗi trong OrderServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Xử lý đơn đặt báo
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String newspaperType = getParameter(request, "newspaper_type", "print");
            String packageDuration = getParameter(request, "package_duration", "lifetime"); // // FIX
            String fullName = getParameter(request, "fullName", "");
            String phone = getParameter(request, "phone", "");
            String email = getParameter(request, "email", "");
            String city = getParameter(request, "city", "");
            String district = getParameter(request, "district", "");
            String ward = getParameter(request, "ward", "");
            String addressDetail = getParameter(request, "addressDetail", "");
            String note = getParameter(request, "note", "");

            // Validate dữ liệu bắt buộc
            if (fullName.isEmpty() || phone.isEmpty() || city.isEmpty() || addressDetail.isEmpty()) {
                setErrorMessage(request, "Vui lòng điền đầy đủ thông tin bắt buộc!");
                redirect(response, request.getContextPath() + "/order");
                return;
            }

            // Tạo đối tượng Order
            Order order = new Order(newspaperType, packageDuration, fullName,
                    phone, email, city, district, ward, addressDetail, note);
            
            // TỰ ĐỘNG DUYỆT ĐƠN
            order.setStatus("confirmed");

            // Nếu đã đăng nhập, gán userId
            User currentUser = getCurrentUser(request);
            if (currentUser != null) {
                if (currentUser.isPremium()) {
                    setErrorMessage(request, "Tài khoản của bạn đã là Premium Trọn Đời. Không cần đăng ký lại!");
                    redirect(response, request.getContextPath() + "/");
                    return;
                }
                order.setUserId(currentUser.getId());
            }

            // =========================================================
            // FIX: Sử dụng createWithResult để in thẳng lỗi Database ra màn hình UI
            // =========================================================
            String dbResult = orderDAO.createWithResult(order);

            if ("success".equals(dbResult)) {
                // =========================================================
                // LOGIC LƯU LỊCH SỬ GIAO DỊCH (TRANSACTION)
                // =========================================================
                try {
                    Transaction tx = new Transaction();

                    // Lấy ID đơn hàng vừa tạo
                    tx.setOrderId(order.getId());

                    if (currentUser != null) {
                        tx.setUserId(currentUser.getId());
                    }

                    // Quy đổi dữ liệu để lưu theo cấu trúc CSDL của bạn
                    tx.setTransactionType("digital".equals(newspaperType) ? "premium" : "print");
                    tx.setTransactionAction("new"); // Mua mới
                    String paymentMethod = getParameter(request, "payment_method", "cod");
                    tx.setPaymentMethod(paymentMethod); // // FIX: Lấy phương thức thanh toán động từ form (cod hoặc bank_transfer)
                    tx.setStatus("success"); // Đã thanh toán thành công

                    // Gán số tiền dạng số nguyên (int)
                    int amount = 0;
                    if ("3_months".equals(packageDuration))
                        amount = 250000;
                    else if ("6_months".equals(packageDuration))
                        amount = 480000;
                    else if ("12_months".equals(packageDuration))
                        amount = 900000;
                    else if ("lifetime".equals(packageDuration)) // // FIX
                        amount = 990000; // // FIX
                    tx.setAmount(amount);

                    // Lưu vào Database thông qua TransactionDAO
                    boolean txSuccess = txDAO.create(tx);

                    if (!txSuccess) {
                        System.err.println("Cảnh báo: Tạo đơn hàng thành công nhưng không tạo được Lịch sử Giao dịch.");
                    }
                    
                    // =========================================================
                    // TỰ ĐỘNG KÍCH HOẠT PREMIUM CHO NGƯỜI DÙNG
                    // =========================================================
                    if (currentUser != null) {
                        com.example.asmnews.repository.auth.UserDAO userDAO = new com.example.asmnews.repository.auth.UserDAO();
                        boolean upgraded = userDAO.upgradeToPremium(currentUser.getId());
                        if (upgraded) {
                            // Cập nhật session hiện tại
                            currentUser.setPremium(true);
                            request.getSession().setAttribute("currentUser", currentUser);
                        }
                    }

                } catch (Exception ex) {
                    System.err.println("Lỗi khi lưu Lịch sử Giao dịch: " + ex.getMessage());
                }
                // =========================================================

                setSuccessMessage(request, "Đăng ký thành công! Tài khoản của bạn đã được nâng cấp lên Premium.");
            } else {
                // BẮT BỆNH Ở ĐÂY: Hiện dòng báo lỗi đỏ chót của SQL lên giao diện JSP
                setErrorMessage(request, "Lỗi Database: " + dbResult);
            }

            redirect(response, request.getContextPath() + "/order");

        } catch (Exception e) {
            System.err.println("Lỗi trong OrderServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            setErrorMessage(request, "Có lỗi xảy ra: " + e.getMessage());
            redirect(response, request.getContextPath() + "/order");
        }
    }
}