package com.example.asmnews.controller.auth;

import com.example.asmnews.controller.common.BaseServlet;






import com.example.asmnews.repository.auth.UserDAO;
import com.example.asmnews.entity.auth.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet xử lý đăng nhập/đăng xuất
 */
@WebServlet(urlPatterns = { "/login", "/logout" })
public class LoginServlet extends BaseServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            handleLogout(request, response);
        } else {
            // Nếu đã đăng nhập, chuyển hướng đến trang admin
            if (isLoggedIn(request)) {
                User user = getCurrentUser(request);
                // Phân luồng ngay cả khi họ đã có session và lỡ quay lại trang /login
                if (user.isAdmin()) {
                    redirect(response, request.getContextPath() + "/admin");
                } else if (user.isReporter()) {
                    redirect(response, request.getContextPath() + "/reporter/news");
                } else {
                    redirect(response, request.getContextPath() + "/"); // Độc giả về trang chủ
                }
                return;
            }

            // Hiển thị trang đăng nhập
            forward(request, response, "/WEB-INF/views/auth/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        handleLogin(request, response);
    }

    /**
     * Xử lý đăng nhập
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = getParameter(request, "username", "");
        String password = getParameter(request, "password", "");

        // Validate input
        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu");
            forward(request, response, "/WEB-INF/views/auth/login.jsp");
            return;
        }

        try {
            // Kiểm tra xem user có tồn tại và có đang bị khóa tạm thời không
            User checkLockUser = userDAO.findById(username);
            if (checkLockUser != null && !checkLockUser.isActive()) {
                if (checkLockUser.getLockoutTime() != null) {
                    long lockDuration = 5 * 60 * 1000; // Khóa tạm thời 5 phút
                    long timePassed = System.currentTimeMillis() - checkLockUser.getLockoutTime().getTime();
                    if (timePassed >= lockDuration) {
                        // Hết thời gian khóa -> Tự động mở khóa
                        userDAO.resetFailedAttempts(checkLockUser.getId());
                        checkLockUser.setActive(true);
                        checkLockUser.setFailedLoginAttempts(0);
                    }
                }
            }

            // Thực hiện đăng nhập
            User user = userDAO.login(username, password);

            if (user != null) {
                // --- [THÊM KIỂM TRA KHÓA TÀI KHOẢN] ---
                if (!user.isActive()) {
                    request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa tạm thời. Vui lòng quay lại sau!");
                    request.setAttribute("username", username);
                    forward(request, response, "/WEB-INF/views/auth/login.jsp");
                    return;
                }
                // -------------------------------------

                if (user.isAdmin() || user.isReporter()) {
                    // Để bảo mật, không tiết lộ tài khoản tồn tại hay link admin
                    request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng");
                    request.setAttribute("username", username);
                    forward(request, response, "/WEB-INF/views/auth/login.jsp");
                    return;
                }

                // Đăng nhập thành công -> Reset số lần đăng nhập sai
                userDAO.resetFailedAttempts(user.getId());

                // Đăng nhập thành công (Đoạn này của bạn giữ nguyên)
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30 * 60); // 30 phút

                setSuccessMessage(request, "Đăng nhập thành công! Chào mừng " + user.getFullname());

                redirect(response, request.getContextPath() + "/"); 

            } else {
                // Đăng nhập thất bại -> Tìm user để tăng số lần đăng nhập sai
                User existingUser = userDAO.findById(username);
                if (existingUser != null) {
                    if (!existingUser.isActive()) {
                        request.setAttribute("errorMessage", "Tài khoản của bạn đang bị khóa do nhập sai mật khẩu quá 5 lần!");
                    } else {
                        userDAO.incrementFailedAttempts(existingUser.getId());
                        User updatedUser = userDAO.findById(existingUser.getId());
                        if (updatedUser != null && !updatedUser.isActive()) {
                            request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa do nhập sai mật khẩu 5 lần!");
                        } else {
                            int attempts = updatedUser != null ? updatedUser.getFailedLoginAttempts() : 0;
                            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng. (Sai " + attempts + "/5 lần)");
                        }
                    }
                } else {
                    request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng");
                }
                request.setAttribute("username", username); // Giữ lại username đã nhập
                forward(request, response, "/WEB-INF/views/auth/login.jsp");
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi đăng nhập: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại sau.");
            forward(request, response, "/WEB-INF/views/auth/login.jsp");
        }
    }

    /**
     * Xử lý đăng xuất
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            session.invalidate();

            if (user != null) {
                setSuccessMessage(request, "Đã đăng xuất thành công. Hẹn gặp lại!");
            }
        }

        // Chuyển hướng về trang chủ
        redirect(response, request.getContextPath() + "/");
    }
}
