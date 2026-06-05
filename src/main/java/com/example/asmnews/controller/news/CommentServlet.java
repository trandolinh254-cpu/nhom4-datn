package com.example.asmnews.controller.news;

import com.example.asmnews.controller.common.BaseServlet;






import java.io.IOException;
import java.util.Date;

import com.example.asmnews.repository.news.commentDAO;
import com.example.asmnews.entity.news.Comment;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.util.ProfanityFilter; // 
import com.example.asmnews.util.EmailUtils; // 
import com.example.asmnews.repository.auth.UserDAO; // 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/comment/action")
public class CommentServlet extends BaseServlet {

    private commentDAO commentDAO = new commentDAO();
    private com.example.asmnews.repository.news.NewsDAO newsDAO = new com.example.asmnews.repository.news.NewsDAO(); // : Thêm NewsDAO
    private UserDAO userDAO = new UserDAO(); // 

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
                // Lọc từ nhạy cảm tiếng Việt 
                String filteredContent = ProfanityFilter.filter(content.trim()); 
                comment.setContent(filteredContent); 
                comment.setCreatedDate(new Date());

                if (commentDAO.insert(comment)) {
                    String jsonResponse = String.format(
                            "{\"status\":\"success\", \"fullname\":\"%s\", \"content\":\"%s\"}",
                            currentUser.getFullname().replace("\"", "\\\""),
                            filteredContent.replace("\"", "\\\"").replace("\n", "\\n")); 
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
                Comment comment = commentDAO.findById(commentId); 
                if (comment == null) { 
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND); 
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Bình luận không tồn tại!\"}"); 
                    return; 
                } 

                // Ràng buộc giới hạn thời gian chỉnh sửa trong vòng 24 giờ 
                long diff = System.currentTimeMillis() - comment.getCreatedDate().getTime(); 
                if (diff > 24 * 60 * 60 * 1000) { 
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN); 
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Chỉ được chỉnh sửa bình luận trong vòng 24 giờ kể từ khi đăng!\"}"); 
                    return; 
                } 

                // Lọc từ nhạy cảm tiếng Việt 
                String filteredContent = ProfanityFilter.filter(content.trim()); 
                if (commentDAO.update(commentId, currentUser.getId(), filteredContent)) { 
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

                Comment parentComment = commentDAO.findById(parentId); 

                Comment reply = new Comment();
                reply.setNewsId(newsId);
                reply.setUserId(currentUser.getId());
                // Lọc từ nhạy cảm tiếng Việt 
                String filteredContent = ProfanityFilter.filter(content.trim()); 
                reply.setContent(filteredContent); 
                reply.setCreatedDate(new Date());
                reply.setParentId(parentId);

                if (commentDAO.insertReply(reply)) {
                    // Tự động gửi email thông báo cho chủ bình luận cha (chạy bất đồng bộ) 
                    if (parentComment != null) { 
                        User parentUser = userDAO.findById(parentComment.getUserId()); 
                        if (parentUser != null) { 
                            final String parentEmail = parentUser.getEmail(); 
                            final String parentName = parentUser.getFullname(); 
                            final String replierName = currentUser.getFullname(); 
                            final com.example.asmnews.entity.news.News newsObj = newsDAO.findById(newsId); 
                            final String newsTitle = newsObj != null ? newsObj.getTitle() : "Bài viết"; 
                            final String replyContentFinal = filteredContent; 

                            if (parentEmail != null && !parentEmail.trim().isEmpty()) { 
                                new Thread(() -> { 
                                    EmailUtils.sendCommentReplyNotification(parentEmail, parentName, replierName, newsTitle, replyContentFinal); 
                                }).start(); 
                            } 
                        } 
                    } 

                    String jsonResponse = String.format(
                            "{\"status\":\"success\", \"fullname\":\"%s\", \"content\":\"%s\", \"userId\":\"%s\"}",
                            currentUser.getFullname().replace("\"", "\\\""),
                            filteredContent.replace("\"", "\\\"").replace("\n", "\\n"),
                            currentUser.getId().replace("\"", "\\\""));
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
