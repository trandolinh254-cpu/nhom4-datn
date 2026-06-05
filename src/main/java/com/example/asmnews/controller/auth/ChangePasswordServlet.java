package com.example.asmnews.controller.auth;

import com.example.asmnews.controller.common.BaseServlet;






import com.example.asmnews.repository.auth.UserDAO;
import com.example.asmnews.entity.auth.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends BaseServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            redirect(response, request.getContextPath() + "/login");
            return;
        }
        forward(request, response, "/WEB-INF/views/auth/change-password.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            redirect(response, request.getContextPath() + "/login");
            return;
        }

        User currentUser = getCurrentUser(request);
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            setErrorMessage(request, "Xác nhận mật khẩu không khớp!");
            redirect(response, request.getContextPath() + "/change-password");
            return;
        }

        if (userDAO.changePassword(currentUser.getId(), oldPassword, newPassword)) {
            setSuccessMessage(request, "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
            request.getSession().invalidate(); // Bắt đăng nhập lại
            redirect(response, request.getContextPath() + "/login");
        } else {
            setErrorMessage(request, "Mật khẩu hiện tại không đúng!");
            redirect(response, request.getContextPath() + "/change-password");
        }
    }
}
