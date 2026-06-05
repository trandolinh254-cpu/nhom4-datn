package com.example.asmnews.controller.auth;

import java.io.IOException;
import java.util.List;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.ads.AdCampaign;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.repository.ads.AdCampaignDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/profile/ads")
public class MyAdsServlet extends BaseServlet {

    private AdCampaignDAO adCampaignDAO = new AdCampaignDAO();
    private com.example.asmnews.repository.news.CategoryDAO categoryDAO = new com.example.asmnews.repository.news.CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isLoggedIn(request)) {
            redirect(response, request.getContextPath() + "/login");
            return;
        }

        User currentUser = getCurrentUser(request);
        List<AdCampaign> myAds = adCampaignDAO.getMyCampaigns(currentUser.getId());
        
        // Đồng bộ Navbar
        request.setAttribute("categories", categoryDAO.findAll());
        // Tắt cờ quảng cáo Super Masthead trên header
        request.setAttribute("superMastheadAd", null);
        
        request.setAttribute("myAds", myAds);
        forward(request, response, "/WEB-INF/views/auth/my-ads.jsp");
    }
}
