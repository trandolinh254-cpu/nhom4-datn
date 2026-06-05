package com.example.asmnews.controller.news;

import com.example.asmnews.controller.common.BaseServlet;






import java.io.IOException;
import java.util.List;

import com.example.asmnews.repository.news.CategoryDAO;
import com.example.asmnews.repository.news.NewsDAO;
// VỊ TRÍ 1: Import ReactionDAO
import com.example.asmnews.repository.news.ReactionDAO;
import com.example.asmnews.repository.news.commentDAO;
import com.example.asmnews.entity.news.Category;
import com.example.asmnews.entity.news.Comment;
import com.example.asmnews.entity.news.News;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý hiển thị tin tức
 */
@WebServlet("/news")
public class NewsServlet extends BaseServlet {

    private NewsDAO newsDAO = new NewsDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private commentDAO commentDAO = new commentDAO();
    // VỊ TRÍ 2: Khởi tạo ReactionDAO
    private ReactionDAO reactionDAO = new ReactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getParameter(request, "action", "list");

        try {
            // Lấy danh sách categories cho menu
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);

            // Lấy Quảng cáo đang chạy
            com.example.asmnews.repository.ads.AdCampaignDAO adDAO = new com.example.asmnews.repository.ads.AdCampaignDAO();
            request.setAttribute("superMastheadAd", adDAO.getRunningAdByPosition(1));
            request.setAttribute("topBannerAd", adDAO.getRunningAdByPosition(2));
            request.setAttribute("sidebarLeftAds", adDAO.getRunningAdsByPosition(4));   // Trái (List)
            request.setAttribute("sidebarRightAds", adDAO.getRunningAdsByPosition(5));  // Phải (List)

            switch (action) {
                case "detail":
                    showNewsDetail(request, response);
                    break;
                case "category":
                    showNewsByCategory(request, response);
                    break;
                // : Thêm case xử lý tìm kiếm
                case "search":
                    searchNews(request, response);
                    break;
                // : Xử lý trả về gợi ý tìm kiếm dạng JSON
                case "suggest":
                    suggestNews(request, response);
                    break;
                case "list":
                default:
                    showAllNews(request, response);
                    break;
            }

        } catch (Exception e) {
            System.err.println("Lỗi trong NewsServlet: " + e.getMessage());
            e.printStackTrace();
            
            // In thẳng stack trace ra màn hình để debug
            response.setContentType("text/plain; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("LỖI EXCEPTION: " + e.toString());
            e.printStackTrace(out);
            out.flush();
        }
    }

    /**
     * Hiển thị tất cả tin tức
     */
    /**
     * Hiển thị tất cả tin tức (Chỉ lấy bài đã duyệt cho độc giả)
     */
    private void showAllNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // : Đổi từ newsDAO.findAll() sang newsDAO.findAllApproved()
        List<News> newsList = newsDAO.findAllApproved();
        request.setAttribute("newsList", newsList);
        request.setAttribute("pageTitle", "Tất cả tin tức");

        forward(request, response, "/WEB-INF/views/news/news-list.jsp");
    }

    /**
     * Hiển thị tin tức theo category và subCategory
     */
    private void showNewsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryId = getParameter(request, "id", "");
        // : Lấy thêm tham số subCategory từ thanh URL (nếu có)
        String subCategory = getParameter(request, "subCategory", "");

        if (categoryId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin loại tin");
            return;
        }

        Category category = categoryDAO.findById(categoryId);
        if (category == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy loại tin");
            return;
        }

        List<News> newsList;
        String pageTitle = "Tin tức " + category.getName();

        // : Nếu người dùng click vào mục con -> Lọc theo mục con. Nếu không -> Lấy tất
        // cả của mục lớn.
        if (!subCategory.isEmpty()) {
            newsList = newsDAO.findByCategoryAndSubCategory(categoryId, subCategory);
            pageTitle += " - " + subCategory; // Đổi tiêu đề trang (VD: Tin tức Thể thao - Bóng đá)
        } else {
            newsList = newsDAO.findByCategory(categoryId);
        }

        request.setAttribute("newsList", newsList);
        request.setAttribute("category", category);
        request.setAttribute("pageTitle", pageTitle);

        forward(request, response, "/WEB-INF/views/news/news-list.jsp");
    }

    /**
     * Hiển thị chi tiết tin tức
     */
    private void showNewsDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String newsId = getParameter(request, "id", "");

        if (newsId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin tin tức");
            return;
        }

        // Lấy thông tin tin tức
        News news = newsDAO.findById(newsId);
        if (news == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tin tức");
            return;
        }

        // Tăng lượt xem
        newsDAO.updateViewCount(newsId);
        news.increaseViewCount();

        // Lấy danh sách bình luận từ DB
        List<Comment> comments = commentDAO.findByNewsId(newsId);
        news.setCommentCount(comments.size()); // Gán số đếm bình luận vào bài báo
        request.setAttribute("commentsList", comments); // Đẩy danh sách bình luận ra giao diện JSP

        // VỊ TRÍ 3: Lấy số đếm Thích và Không thích từ DB gán vào bài báo
        news.setLikeCount(reactionDAO.countReactions(newsId, 1));
        news.setDislikeCount(reactionDAO.countReactions(newsId, 0));

        // Lấy tin tức cùng loại (không bao gồm tin hiện tại)
        List<News> relatedNews = newsDAO.findByCategory(news.getCategoryId());
        relatedNews.removeIf(n -> n.getId().equals(newsId));
        if (relatedNews.size() > 5) {
            relatedNews = relatedNews.subList(0, 5);
        }

        request.setAttribute("news", news);
        request.setAttribute("relatedNews", relatedNews);
        request.setAttribute("pageTitle", news.getTitle());

        forward(request, response, "/WEB-INF/views/news/news-detail.jsp");
    }

    /**
     * : Hàm xử lý tìm kiếm tin tức
     */
    private void searchNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = getParameter(request, "keyword", "");

        if (keyword.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/news");
            return;
        }

        List<News> newsList = newsDAO.searchByKeyword(keyword);

        request.setAttribute("newsList", newsList);
        request.setAttribute("pageTitle", "Kết quả tìm kiếm cho: \"" + keyword + "\"");
        request.setAttribute("searchKeyword", keyword);

        forward(request, response, "/WEB-INF/views/news/news-list.jsp");
    }

    /**
     * : Hàm API trả về JSON gợi ý tìm kiếm (Tự build JSON để tránh lỗi thiếu thư viện)
     */
    private void suggestNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String keyword = getParameter(request, "keyword", "");
        if (keyword.trim().isEmpty()) {
            out.print("[]");
            out.flush();
            return;
        }

        // Lấy top 5 kết quả
        List<News> newsList = newsDAO.searchForSuggestion(keyword, 5);
        
        // Build JSON thủ công
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < newsList.size(); i++) {
            News n = newsList.get(i);
            json.append("{");
            json.append("\"id\":\"").append(escapeJson(n.getId())).append("\",");
            json.append("\"title\":\"").append(escapeJson(n.getTitle())).append("\",");
            json.append("\"image\":\"").append(escapeJson(n.getImage())).append("\",");
            json.append("\"shortContent\":\"").append(escapeJson(n.getShortContent(100))).append("\",");
            json.append("\"postedDate\":\"").append(n.getPostedDate() != null ? n.getPostedDate().toString() : "").append("\"");
            json.append("}");
            if (i < newsList.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        out.print(json.toString());
        out.flush();
    }

    // Hàm phụ trợ escape ký tự đặc biệt cho JSON
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
