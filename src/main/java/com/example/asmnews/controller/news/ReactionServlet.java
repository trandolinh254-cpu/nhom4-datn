package com.example.asmnews.controller.news;

import com.example.asmnews.controller.common.BaseServlet;






import com.example.asmnews.repository.news.ReactionDAO;
import com.example.asmnews.entity.auth.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/news/react")
public class ReactionServlet extends BaseServlet {

    private ReactionDAO reactionDAO = new ReactionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Trả về mã lỗi 401 nếu chưa đăng nhập để giao diện tự báo lỗi
        if (!isLoggedIn(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User currentUser = getCurrentUser(request);
        String newsId = request.getParameter("newsId");
        String action = request.getParameter("action");

        if (newsId != null && action != null) {
            int type = action.equals("like") ? 1 : 0;

            // Lưu tương tác xuống Database
            reactionDAO.upsertReaction(currentUser.getId(), newsId, type);

            // Đếm lại số lượng mới nhất
            int likes = reactionDAO.countReactions(newsId, 1);
            int dislikes = reactionDAO.countReactions(newsId, 0);

            // Trả về kết quả JSON để Javascript tự động cập nhật số liệu
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"likes\": " + likes + ", \"dislikes\": " + dislikes + "}");
        }
    }
}
