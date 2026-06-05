package com.example.asmnews.controller.order;

import com.example.asmnews.controller.common.BaseServlet;

// FIX 1: Bạn cần import class xử lý DB (DAO hoặc Service) của chuyên mục vào đây
import com.example.asmnews.repository.news.CategoryDAO;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý hiển thị trang Premium và Thanh toán gói Premium
 */
@WebServlet(name = "PremiumServlet", urlPatterns = {"/premium", "/premium-checkout"})
public class PremiumServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if ("/premium".equals(path)) {
            // FIX 2: Khởi tạo class DAO và truyền danh sách chuyên mục lên request cho header.jsp
            // Bỏ comment 2 dòng dưới và đổi tên class/phương thức cho khớp với dự án của bạn
            CategoryDAO categoryDAO = new CategoryDAO();
            request.setAttribute("categories", categoryDAO.findAll());
            
            // Hiển thị trang giới thiệu các gói Premium
            request.getRequestDispatcher("/WEB-INF/views/order/premium.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String path = request.getServletPath();
        
        if ("/premium-checkout".equals(path)) {
            // Xử lý logic thanh toán gói Premium ở đây
            String plan = request.getParameter("plan");
            
            // Tạm thời, redirect về trang chủ kèm thông báo thành công
            // (Bạn có thể thêm logic lưu vào Database, gọi API Momo/VNPAY tại đây)
            setSuccessMessage(request, "Cảm ơn bạn đã chọn gói: " + plan + "! Chức năng thanh toán đang được phát triển.");
            response.sendRedirect(request.getContextPath() + "/premium");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}