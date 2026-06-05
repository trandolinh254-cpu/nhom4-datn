package com.example.asmnews.controller.admin;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.ads.AdPosition;
import com.example.asmnews.entity.ads.AdCampaign;
import com.example.asmnews.repository.ads.AdPositionDAO;
import com.example.asmnews.repository.ads.AdCampaignDAO;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.util.ImageUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // Tối đa 10MB cho 1 ảnh
        maxRequestSize = 1024 * 1024 * 50 // Tối đa 50MB cho toàn request
)
@WebServlet(urlPatterns = { "/admin/ads", "/admin/ads/*" })
public class AdminAdsServlet extends BaseServlet {

    private AdCampaignDAO adCampaignDAO = new AdCampaignDAO();
    private AdPositionDAO adPositionDAO = new AdPositionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy đoạn URL phía sau /admin/ads
        String pathInfo = request.getPathInfo();

        try {
            // Nếu bấm vào "Tổng quan quảng cáo" (đường dẫn gốc)
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendRedirect(request.getContextPath() + "/admin/ads/requests");
                return;
            }

            String activeMenu = "ads_dashboard";
            String pageTitle = "Chức năng hệ thống";

            switch (pathInfo) {
                case "/requests":
                    List<AdCampaign> pendingList = adCampaignDAO.getRecentPendingCampaigns();
                    request.setAttribute("pendingRequests", pendingList);
                    List<AdCampaign> runningList = adCampaignDAO.getRunningCampaigns();
                    request.setAttribute("runningRequests", runningList);
                    activeMenu = "ads_req";
                    pageTitle = "Yêu cầu quảng cáo";
                    request.getRequestDispatcher("/WEB-INF/views/admin/ads/ads-requests.jsp").forward(request, response);
                    return;

                case "/online/positions":
                    List<AdPosition> onlinePositions = adPositionDAO.findAllByPlatform("ONLINE");
                    request.setAttribute("positions", onlinePositions);

                    java.util.Map<Integer, String> predefinedPositions = new java.util.LinkedHashMap<>();
                    predefinedPositions.put(1, "Top Banner");
                    predefinedPositions.put(2, "Medium Rectangle 1");
                    predefinedPositions.put(3, "Super Masthead");
                    predefinedPositions.put(4, "Sidebar Left");
                    predefinedPositions.put(5, "Sidebar Right");
                    predefinedPositions.put(6, "In-Article Content");
                    
                    java.util.Map<Integer, String> availablePositions = new java.util.LinkedHashMap<>();
                    for (java.util.Map.Entry<Integer, String> entry : predefinedPositions.entrySet()) {
                        boolean exists = false;
                        for (AdPosition p : onlinePositions) {
                            if (p.getId() == entry.getKey()) {
                                exists = true; break;
                            }
                        }
                        if (!exists) {
                            availablePositions.put(entry.getKey(), entry.getValue());
                        }
                    }
                    request.setAttribute("availablePositions", availablePositions);
                    
                    activeMenu = "ads_online_positions";
                    pageTitle = "Vị trí Quảng cáo (Báo Online)";
                    request.getRequestDispatcher("/WEB-INF/views/admin/ads/ads-online-positions.jsp").forward(request, response);
                    return;

                case "/online/pricing":
                    request.setAttribute("positions", adPositionDAO.findByPlatform("ONLINE"));
                    activeMenu = "ads_online_pricing";
                    pageTitle = "Bảng giá Quảng cáo (Báo Online)";
                    request.getRequestDispatcher("/WEB-INF/views/admin/ads/ads-online-pricing.jsp").forward(request, response);
                    return;


                case "/customers":
                    request.setAttribute("customers", adCampaignDAO.getAdCustomers());
                    activeMenu = "ads_client_list";
                    pageTitle = "DS Khách hàng đã đăng ký QC";
                    request.getRequestDispatcher("/WEB-INF/views/admin/ads/ads-customers.jsp").forward(request, response);
                    return;
                default:
                    pageTitle = "Trang không tồn tại";
            }

            request.setAttribute("activeMenu", activeMenu);
            request.setAttribute("pageTitle", pageTitle);
            request.getRequestDispatcher("/WEB-INF/views/admin/ads/ads-template.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Lỗi AdminAdsServlet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if ("/approve".equals(pathInfo)) {
            try {
                String paramId = request.getParameter("campaign_id");
                if (paramId == null) paramId = request.getParameter("request_id");
                int campaignId = Integer.parseInt(paramId);
                Part filePart = request.getPart("ad_image");
                String imageUrl = null; 

                if (filePart != null && filePart.getSize() > 0) {
                    String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "ads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    try (java.io.InputStream fileContent = filePart.getInputStream()) { }
                    filePart.write(uploadPath + File.separator + uniqueFileName);

                    String srcPath = "C:\\Users\\Acer Nitro 5\\Downloads\\Asm-new-main\\src\\main\\webapp\\images\\ads";
                    File srcDir = new File(srcPath);
                    if (srcDir.exists()) {
                        java.nio.file.Files.copy(
                            Paths.get(uploadPath + File.separator + uniqueFileName), 
                            Paths.get(srcPath + File.separator + uniqueFileName),
                            java.nio.file.StandardCopyOption.REPLACE_EXISTING
                        );
                    }
                    imageUrl = request.getContextPath() + "/images/ads/" + uniqueFileName;
                }

                User currentUser = getCurrentUser(request);
                String adminId = currentUser != null ? currentUser.getId() : "admin";
                boolean isSuccess = adCampaignDAO.approveAd(campaignId, imageUrl, adminId);

                if (isSuccess) {
                    setSuccessMessage(request, "Duyệt quảng cáo thành công! Quảng cáo đã được đưa lên trang chủ.");
                } else {
                    setErrorMessage(request, "Duyệt thất bại do lỗi cơ sở dữ liệu.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                setErrorMessage(request, "Lỗi khi upload ảnh: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/admin/ads/requests");
            
        } else if ("/reject".equals(pathInfo)) {
            try {
                String paramId = request.getParameter("campaign_id");
                if (paramId == null) paramId = request.getParameter("request_id");
                int campaignId = Integer.parseInt(paramId);
                User currentUser = getCurrentUser(request);
                String adminId = currentUser != null ? currentUser.getId() : "admin";
                boolean isSuccess = adCampaignDAO.rejectAd(campaignId, adminId);
                
                if (isSuccess) {
                    setSuccessMessage(request, "Đã từ chối yêu cầu quảng cáo.");
                } else {
                    setErrorMessage(request, "Từ chối thất bại do lỗi hệ thống.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                setErrorMessage(request, "Lỗi từ chối: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/ads/requests");
        } else if ("/stop".equals(pathInfo)) {
            try {
                String paramId = request.getParameter("campaign_id");
                if (paramId == null) paramId = request.getParameter("request_id");
                int campaignId = Integer.parseInt(paramId);
                User currentUser = getCurrentUser(request);
                String adminId = currentUser != null ? currentUser.getId() : "admin";
                boolean isSuccess = adCampaignDAO.stopAd(campaignId, adminId);
                
                if (isSuccess) {
                    setSuccessMessage(request, "Đã dừng quảng cáo thành công.");
                } else {
                    setErrorMessage(request, "Dừng thất bại do lỗi hệ thống.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                setErrorMessage(request, "Lỗi dừng quảng cáo: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/ads/requests");
        }
        else if ("/online/positions/add".equals(pathInfo) || "/online/positions/edit".equals(pathInfo)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String sizeDesc = request.getParameter("size_desc");
                double basePrice = Double.parseDouble(request.getParameter("base_price"));
                String status = request.getParameter("status");

                AdPosition pos = new AdPosition();
                pos.setId(id);
                pos.setPlatform("ONLINE");
                pos.setName(name);
                pos.setSizeDesc(sizeDesc);
                pos.setBasePrice(basePrice);
                pos.setStatus(status);

                boolean success;
                if ("/online/positions/add".equals(pathInfo)) {
                    if (adPositionDAO.findById(id) != null) {
                        System.out.println("DEBUG: ADD -> UPDATE FALLBACK. ID=" + id + ", STATUS=" + status);
                        success = adPositionDAO.update(pos);
                    } else {
                        System.out.println("DEBUG: ADD -> INSERT. ID=" + id + ", STATUS=" + status);
                        success = adPositionDAO.insert(pos);
                    }
                } else {
                    System.out.println("DEBUG: EDIT -> UPDATE. ID=" + id + ", STATUS=" + status);
                    success = adPositionDAO.update(pos);
                }

                System.out.println("DEBUG: UPDATE SUCCESS=" + success);

                if (success) {
                    setSuccessMessage(request, "Lưu vị trí quảng cáo thành công!");
                } else {
                    setErrorMessage(request, "Lỗi: Không thể lưu vị trí quảng cáo.");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/ads/online/positions");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                setErrorMessage(request, "Lỗi xử lý dữ liệu: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/ads/online/positions");
                return;
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
