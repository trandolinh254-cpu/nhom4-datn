package com.example.asmnews.controller.admin;

import com.example.asmnews.controller.common.BaseServlet;






import com.example.asmnews.repository.news.commentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/comments")
public class AdminCommentServlet extends BaseServlet {
    private commentDAO commentDAO = new commentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra quyền Admin (Tự bạn viết hàm isAdmin() hoặc chặn trong Filter)
        request.setAttribute("commentsList", commentDAO.findAllForAdmin());
        forward(request, response, "/WEB-INF/views/admin/users/comment-management.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (commentDAO.delete(id)) {
                setSuccessMessage(request, "Đã xóa bình luận vi phạm!");
            } else {
                setErrorMessage(request, "Lỗi khi xóa bình luận.");
            }
        }
        redirect(response, request.getContextPath() + "/admin/comments");
    }
}
