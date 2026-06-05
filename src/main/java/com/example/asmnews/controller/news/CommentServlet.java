package com.example.asmnews.controller.news;

import com.example.asmnews.controller.common.BaseServlet;






import java.io.IOException;
import java.util.Date;

import com.example.asmnews.repository.news.commentDAO;
import com.example.asmnews.entity.news.Comment;
import com.example.asmnews.entity.auth.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/comment/action")
public class CommentServlet extends BaseServlet {

    private commentDAO commentDAO = new commentDAO();
    private com.example.asmnews.repository.news.NewsDAO newsDAO = new com.example.asmnews.repository.news.NewsDAO(); // : Thêm NewsDAO

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cấu hình trả về JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Vui lòng đăng nhập!\"}");
            return;
        }

        String action = request.getParameter("action");

        try {
            // // : Xử lý cập nhật bình luận
            if ("update".equals(action)) {
                String id = request.getParameter("id");
                String content = request.getParameter("content");

                // Logic cập nhật vào DB (Giả sử bạn đã có newsDAO.updateComment)
                boolean updated = newsDAO.updateComment(id, content);

                response.setContentType("application/json");
                if (updated) {
                    response.getWriter().write("{\"status\":\"success\"}");
                } else {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Không thể cập nhật\"}");
                }
                return;
            }

            if ("add".equals(action)) {
                String content = request.getParameter("content");
                // Kiểm tra rỗng CHỈ áp dụng cho chức năng Thêm
                if (content == null || content.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Nội dung trống!\"}");
                    return;
                }

                String newsId = request.getParameter("newsId");
                Comment comment = new Comment();
                comment.setNewsId(newsId);
                comment.setUserId(currentUser.getId());
                comment.setContent(content.trim());
                comment.setCreatedDate(new Date());

                if (commentDAO.insert(comment)) {
                    String jsonResponse = String.format(
                            "{\"status\":\"success\", \"fullname\":\"%s\", \"content\":\"%s\"}",
                            currentUser.getFullname().replace("\"", "\\\""),
                            content.replace("\"", "\\\"").replace("\n", "\\n"));
                    response.getWriter().write(jsonResponse);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }

            } else if ("edit".equals(action)) {
                String content = request.getParameter("content");
                // Kiểm tra rỗng CHỈ áp dụng cho chức năng Sửa
                if (content == null || content.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Nội dung trống!\"}");
                    return;
                }

                int commentId = Integer.parseInt(request.getParameter("commentId"));

                if (commentDAO.update(commentId, currentUser.getId(), content.trim())) {
                    response.getWriter().write("{\"status\":\"success\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Không có quyền sửa!\"}");
                }

            } else if ("report".equals(action)) {
                // Chức năng Báo cáo KHÔNG CẦN kiểm tra nội dung
                int commentId = Integer.parseInt(request.getParameter("commentId"));

                if (commentDAO.reportComment(commentId)) {
                    response.getWriter().write("{\"status\":\"success\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }

            } else if ("reply".equals(action)) {
                // Trả lời một bình luận cụ thể
                String content = request.getParameter("content");
                if (content == null || content.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Nội dung trống!\"}");
                    return;
                }

                String newsId = request.getParameter("newsId");
                int parentId = Integer.parseInt(request.getParameter("parentId"));

                Comment reply = new Comment();
                reply.setNewsId(newsId);
                reply.setUserId(currentUser.getId());
                reply.setContent(content.trim());
                reply.setCreatedDate(new Date());
                reply.setParentId(parentId);

                if (commentDAO.insertReply(reply)) {
                    String jsonResponse = String.format(
                            "{\"status\":\"success\", \"fullname\":\"%s\", \"content\":\"%s\"}",
                            currentUser.getFullname().replace("\"", "\\\""),
                            content.trim().replace("\"", "\\\"").replace("\n", "\\n"));
                    response.getWriter().write(jsonResponse);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
