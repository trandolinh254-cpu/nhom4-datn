package com.example.asmnews.controller.admin;

import java.io.IOException;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.repository.auth.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/login")
public class AdminLoginServlet extends BaseServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu đã đăng nhập, phân luồng
        if (isLoggedIn(request)) {
            User user = getCurrentUser(request);
            if (user.isAdmin()) {
                redirect(response, request.getContextPath() + "/admin");
            } else if (user.isReporter()) {
                redirect(response, request.getContextPath() + "/reporter/news");
            } else {
                redirect(response, request.getContextPath() + "/");
            }
            return;
        }

        forward(request, response, "/WEB-INF/views/admin/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = getParameter(request, "username", "");
        String password = getParameter(request, "password", "");

        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu");
            forward(request, response, "/WEB-INF/views/admin/login.jsp");
            return;
        }

        try {
            User user = userDAO.login(username, password);

            if (user != null) {
                if (!user.isActive()) {
                    request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Quản trị viên cấp cao!");
                    request.setAttribute("username", username);
                    forward(request, response, "/WEB-INF/views/admin/login.jsp");
                    return;
                }

                // Kiểm tra quyền (Chỉ Admin và Reporter mới được login ở đây)
                if (user.isReader()) {
                    request.setAttribute("errorMessage", "Tài khoản của bạn không có quyền truy cập Cổng Quản Trị!");
                    request.setAttribute("username", username);
                    forward(request, response, "/WEB-INF/views/admin/login.jsp");
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(60 * 60); // 1 giờ cho admin

                setSuccessMessage(request, "Đăng nhập Cổng Nội Bộ thành công! Chào mừng " + user.getFullname());

                if (user.isAdmin()) {
                    redirect(response, request.getContextPath() + "/admin");
                } else if (user.isReporter()) {
                    redirect(response, request.getContextPath() + "/reporter/news");
                }

            } else {
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng");
                request.setAttribute("username", username);
                forward(request, response, "/WEB-INF/views/admin/login.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            forward(request, response, "/WEB-INF/views/admin/login.jsp");
        }
    }
}
