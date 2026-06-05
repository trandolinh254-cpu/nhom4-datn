package com.example.asmnews.controller.auth;

import com.example.asmnews.controller.common.BaseServlet;






import com.example.asmnews.repository.auth.UserDAO;
import com.example.asmnews.entity.auth.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Hiển thị trang đăng ký
        forward(request, response, "/WEB-INF/views/auth/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = getParameter(request, "id", "");
        String password = getParameter(request, "password", "");
        String fullname = getParameter(request, "fullname", "");
        String email = getParameter(request, "email", "");
        String mobile = getParameter(request, "mobile", "");
        String birthdayStr = getParameter(request, "birthday", "");
        boolean gender = "1".equals(getParameter(request, "gender", "1"));

        // 1. Kiểm tra trống
        if (id.isEmpty() || password.isEmpty() || fullname.isEmpty() || email.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ các thông tin bắt buộc");
            forward(request, response, "/WEB-INF/views/auth/register.jsp");
            return;
        }

        // 2. Kiểm tra trùng ID (Username)
        if (userDAO.exists(id)) {
            request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại!");
            forward(request, response, "/WEB-INF/views/auth/register.jsp");
            return;
        }

        // 3. Kiểm tra trùng Email
        if (userDAO.emailExists(email)) {
            request.setAttribute("errorMessage", "Email này đã được sử dụng!");
            forward(request, response, "/WEB-INF/views/auth/register.jsp");
            return;
        }

        try {
            Date birthday = null;
            if (!birthdayStr.isEmpty()) {
                birthday = new SimpleDateFormat("yyyy-MM-dd").parse(birthdayStr);
            }

            // Tạo đối tượng User mới (Mặc định Role = false - Phóng viên/Người dùng)
            User newUser = new User(id, password, fullname, birthday, gender, mobile, email, User.ROLE_READER);

            if (userDAO.insert(newUser)) {
                setSuccessMessage(request, "Đăng ký tài khoản thành công! Mời bạn đăng nhập.");
                redirect(response, request.getContextPath() + "/login");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi lưu dữ liệu.");
                forward(request, response, "/WEB-INF/views/auth/register.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            forward(request, response, "/WEB-INF/views/auth/register.jsp");
        }
    }
}
