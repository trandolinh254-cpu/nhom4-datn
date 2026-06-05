package com.example.asmnews.controller.order;

import com.example.asmnews.controller.common.BaseServlet;






import com.example.asmnews.repository.order.NewsletterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * Servlet xử lý đăng ký/hủy newsletter
 */
@WebServlet("/newsletter")
public class NewsletterServlet extends BaseServlet {

    private NewsletterDAO newsletterDAO = new NewsletterDAO();

    // Pattern để validate email
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getParameter(request, "action", "subscribe");

        try {
            switch (action) {
                case "subscribe":
                    handleSubscribe(request, response);
                    break;
                case "unsubscribe":
                    handleUnsubscribe(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ");
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong NewsletterServlet: " + e.getMessage());
            e.printStackTrace();
            setErrorMessage(request, "Có lỗi xảy ra khi xử lý yêu cầu");
            redirect(response, request.getHeader("Referer") != null ? request.getHeader("Referer")
                    : request.getContextPath() + "/");
        }
    }

    /**
     * Xử lý đăng ký newsletter
     */
    private void handleSubscribe(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = getParameter(request, "email", "").toLowerCase();

        // Validate email
        if (email.isEmpty()) {
            setErrorMessage(request, "Vui lòng nhập địa chỉ email");
            redirect(response, request.getHeader("Referer") != null ? request.getHeader("Referer")
                    : request.getContextPath() + "/");
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setErrorMessage(request, "Địa chỉ email không hợp lệ");
            redirect(response, request.getHeader("Referer") != null ? request.getHeader("Referer")
                    : request.getContextPath() + "/");
            return;
        }

        // Kiểm tra email đã đăng ký chưa
        if (newsletterDAO.exists(email)) {
            if (newsletterDAO.isActive(email)) {
                setErrorMessage(request, "Email này đã đăng ký nhận tin");
            } else {
                // Kích hoạt lại nếu đã hủy trước đó
                if (newsletterDAO.reactivate(email)) {
                    setSuccessMessage(request, "Đã kích hoạt lại đăng ký nhận tin thành công!");
                } else {
                    setErrorMessage(request, "Có lỗi xảy ra khi kích hoạt lại đăng ký");
                }
            }
        } else {
            // Đăng ký mới
            if (newsletterDAO.subscribe(email)) {
                setSuccessMessage(request, "Đăng ký nhận tin thành công! Cảm ơn bạn đã quan tâm.");
            } else {
                setErrorMessage(request, "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại sau.");
            }
        }

        // Redirect về trang trước đó hoặc trang chủ
        redirect(response,
                request.getHeader("Referer") != null ? request.getHeader("Referer") : request.getContextPath() + "/");
    }

    /**
     * Xử lý hủy đăng ký newsletter
     */
    private void handleUnsubscribe(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = getParameter(request, "email", "").toLowerCase();

        // Validate email
        if (email.isEmpty()) {
            setErrorMessage(request, "Vui lòng nhập địa chỉ email");
            redirect(response, request.getHeader("Referer") != null ? request.getHeader("Referer")
                    : request.getContextPath() + "/");
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setErrorMessage(request, "Địa chỉ email không hợp lệ");
            redirect(response, request.getHeader("Referer") != null ? request.getHeader("Referer")
                    : request.getContextPath() + "/");
            return;
        }

        // Kiểm tra email có đăng ký không
        if (!newsletterDAO.exists(email)) {
            setErrorMessage(request, "Email này chưa đăng ký nhận tin");
        } else if (!newsletterDAO.isActive(email)) {
            setErrorMessage(request, "Email này đã hủy đăng ký trước đó");
        } else {
            // Hủy đăng ký
            if (newsletterDAO.unsubscribe(email)) {
                setSuccessMessage(request, "Đã hủy đăng ký nhận tin thành công!");
            } else {
                setErrorMessage(request, "Có lỗi xảy ra khi hủy đăng ký. Vui lòng thử lại sau.");
            }
        }

        // Redirect về trang trước đó hoặc trang chủ
        redirect(response,
                request.getHeader("Referer") != null ? request.getHeader("Referer") : request.getContextPath() + "/");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Chuyển hướng GET requests về trang chủ
        redirect(response, request.getContextPath() + "/");
    }
}
