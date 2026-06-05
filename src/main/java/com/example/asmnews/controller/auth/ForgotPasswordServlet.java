package com.example.asmnews.controller.auth;

import com.example.asmnews.controller.common.BaseServlet;






import com.example.asmnews.repository.auth.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends BaseServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forward(request, response, "/WEB-INF/views/auth/forgot-password.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action"); 
        
        //: Xử lý yêu cầu gửi mã OTP từ Frontend (Ajax)
        if ("sendOTP".equals(action)) { 
            String emailOTP = request.getParameter("email"); 
            
            // 1. Sinh ngẫu nhiên mã OTP 6 chữ số 
            String otpCode = String.format("%06d", new java.util.Random().nextInt(999999)); 
            
            // 2. Lưu tạm OTP và Email vào Session để lát nữa so sánh khi người dùng nhập vào 
            request.getSession().setAttribute("OTP_CODE", otpCode); 
            request.getSession().setAttribute("RESET_EMAIL", emailOTP); 
            
            // 3. Gọi hàm gửi Email 
            boolean isSent = com.example.asmnews.util.EmailUtils.sendOTP(emailOTP, otpCode); 
            
            // 4. Trả kết quả về cho Javascript 
            response.setContentType("application/json"); 
            response.setCharacterEncoding("UTF-8"); 
            if (isSent) { 
                response.getWriter().write("{\"status\":\"success\"}"); 
            } else { 
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Không thể gửi thư. Kiểm tra lại cấu hình SMTP.\"}"); 
            } 
            return; 
        } 

        // : Xử lý khi người dùng bấm nút "KHÔI PHỤC MẬT KHẨU"
        if ("verify".equals(action)) { 
            String inputEmail = request.getParameter("email"); 
            String inputOtp = request.getParameter("otpCode"); 
            
            // Lấy OTP và Email đã lưu trong Session lúc gửi thư ra để đối chiếu 
            String sessionOtp = (String) request.getSession().getAttribute("OTP_CODE"); 
            String sessionEmail = (String) request.getSession().getAttribute("RESET_EMAIL"); 
            
            // Kiểm tra xem OTP có khớp không và email có đúng email vừa xin mã không 
            if (sessionOtp != null && sessionOtp.equals(inputOtp)  
                && sessionEmail != null && sessionEmail.equals(inputEmail)) { 
                
                // Chuẩn cmnr! Cho phép chuyển sang trang đặt mật khẩu mới 
                // Xóa OTP cũ đi để bảo mật (không cho dùng lại) 
                request.getSession().removeAttribute("OTP_CODE");  
                
                // Chuyển hướng sang trang nhập mật khẩu mới (nhớ tạo file này nhé) 
                request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response); 
                return; 
                
            } else { 
                // Sai mã hoặc sai email 
                request.setAttribute("error", "Mã xác thực (OTP) không chính xác hoặc đã hết hạn!"); 
                request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response); 
                return; 
            } 
        } 

        // : Xử lý nhánh cập nhật mật khẩu mới vào Database
        if ("reset".equals(action)) { 
            String email = request.getParameter("email"); 
            String newPassword = request.getParameter("newPassword"); 
            String confirmPassword = request.getParameter("confirmPassword"); 
            
            // 1. Kiểm tra mật khẩu xác nhận có khớp không 
            if (newPassword == null || !newPassword.equals(confirmPassword)) { 
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!"); 
                request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response); 
                return; 
            } 
            
            // FIX: Gọi thẳng xuống DB để update mật khẩu
            boolean isUpdated = userDAO.updatePasswordByEmail(email, newPassword);
            
            if (isUpdated) { 
                // Xóa email trong Session đi để bảo mật 
                request.getSession().removeAttribute("RESET_EMAIL"); 
                
                // Chuyển về trang Đăng nhập và báo thành công 
                request.setAttribute("message", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại."); 
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response); 
            } else { 
                request.setAttribute("error", "Lỗi hệ thống, không thể đổi mật khẩu."); 
                request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response); 
            } 
            return; 
        } 
    }
}
