package com.example.asmnews.controller.common;

import java.io.IOException;
import java.util.List;

import com.example.asmnews.repository.news.CategoryDAO;
import com.example.asmnews.repository.news.NewsDAO;
import com.example.asmnews.entity.news.Category;
import com.example.asmnews.entity.news.News;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý trang chủ
 */
@WebServlet(urlPatterns = { "/", "/home" })
public class HomeServlet extends BaseServlet {

    private NewsDAO newsDAO = new NewsDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy danh sách categories cho menu
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);

            // Lấy tin tức hiển thị trên trang chủ
            List<News> homeNews = newsDAO.findHomeNews();
            request.setAttribute("homeNews", homeNews);

            // Lấy 5 tin được xem nhiều nhất
            List<News> mostViewedNews = newsDAO.findTop5MostViewed();
            request.setAttribute("mostViewedNews", mostViewedNews);

            // Lấy 5 tin mới nhất
            List<News> latestNews = newsDAO.findTop5Latest();
            request.setAttribute("latestNews", latestNews);

            // Lấy danh sách xếp hạng lượt xem và ném ra JSP
            List<News> trendingNews = newsDAO.findTopViewedNews();
            request.setAttribute("trendingNews", trendingNews);

            // Tin tiêu điểm = bài đầu tiên của homeNews
            if (homeNews != null && !homeNews.isEmpty()) {
                request.setAttribute("topNews", homeNews.get(0));
            }

            // Tin sức khỏe - lọc theo categoryId HEALTH
            List<News> healthNews = newsDAO.findByCategory("HEALTH");
            if (healthNews.size() > 4)
                healthNews = healthNews.subList(0, 4);
            request.setAttribute("healthNews", healthNews);

            // Tin công nghệ - lọc theo categoryId TECH
            List<News> techNews = newsDAO.findByCategory("TECH");
            if (techNews.size() > 4)
                techNews = techNews.subList(0, 4);
            request.setAttribute("techNews", techNews);

            // Tin tổng hợp - dùng lại trendingNews
            request.setAttribute("generalNews", trendingNews);
            
            // Lấy Quảng cáo đang chạy
            com.example.asmnews.repository.ads.AdCampaignDAO adDAO = new com.example.asmnews.repository.ads.AdCampaignDAO();
            request.setAttribute("superMastheadAd", adDAO.getRunningAdByPosition(1)); // Super Masthead
            request.setAttribute("topBannerAd", adDAO.getRunningAdByPosition(2)); // Top Banner
            request.setAttribute("sidebarLeftAds", adDAO.getRunningAdsByPosition(4));   // Trái (List)
            request.setAttribute("sidebarRightAds", adDAO.getRunningAdsByPosition(5));  // Phải (List)
            
            // Forward đến trang chủ
            forward(request, response, "/WEB-INF/views/home/index.jsp");

        } catch (Exception e) {
            System.err.println("Lỗi trong HomeServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Có lỗi xảy ra khi tải trang chủ");
        }
    }
}
