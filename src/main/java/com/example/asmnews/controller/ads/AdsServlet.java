package com.example.asmnews.controller.ads;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.ads.AdCampaign;
import com.example.asmnews.entity.ads.AdContract;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.entity.news.Category;
import com.example.asmnews.repository.ads.AdCampaignDAO;
import com.example.asmnews.repository.ads.AdContractDAO;
import com.example.asmnews.repository.news.CategoryDAO;
import com.example.asmnews.util.ImageUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 * Servlet xử lý trang Đăng ký quảng cáo
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
@WebServlet(urlPatterns = { "/quang-cao", "/quang-cao/online", "/ads/register" })
public class AdsServlet extends BaseServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();
    private AdContractDAO adContractDAO = new AdContractDAO();
    private AdCampaignDAO adCampaignDAO = new AdCampaignDAO();
    private com.example.asmnews.repository.ads.AdPositionDAO adPositionDAO = new com.example.asmnews.repository.ads.AdPositionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        try {
            // 1. Lấy danh mục để Header có thể hiển thị Menu chuyên mục
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);

            // Mở trang form Báo Online cho mọi URL "/quang-cao"
            if ("/quang-cao".equals(path) || "/quang-cao/online".equals(path)) {
                List<com.example.asmnews.entity.ads.AdPosition> positions = adPositionDAO.findByPlatform("ONLINE");
                
                // Vị trí độc quyền vẫn hiển thị giá, nhưng khóa nút mua nếu đã có người đặt.
                List<Integer> occupiedIds = adCampaignDAO.getOccupiedPositionIds();
                
                request.setAttribute("positions", positions);
                request.setAttribute("occupiedIds", occupiedIds);
                request.getRequestDispatcher("/WEB-INF/views/ads/ads-online.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            System.err.println("Lỗi load trang Quảng cáo: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/ads/register".equals(path)) {
            try {
                // 1. Lấy thông tin User (Khách hàng)
                String userId = "GUEST";
                User sessionUser = (User) request.getSession().getAttribute("currentUser");
                if (sessionUser != null) {
                    userId = sessionUser.getId();
                }
                
                // 2. Tạo Hợp đồng (AdContract)
                AdContract contract = new AdContract();
                contract.setUserId(userId);
                contract.setContactName(request.getParameter("contact_name"));
                contract.setPhone(request.getParameter("phone"));
                contract.setEmail(request.getParameter("email"));
                String companyName = request.getParameter("company_name");
                contract.setCompanyName(companyName != null && !companyName.trim().isEmpty() ? companyName : "Cá nhân");
                
                String paymentMethod = request.getParameter("payment_method");
                String methodLabel = "bank_transfer".equals(paymentMethod) ? "Chuyển khoản VietQR" : "Thanh toán sau (Offline)";
                String address = request.getParameter("address");
                String fullAddress = (address != null && !address.trim().isEmpty() ? address : "Chưa cập nhật");
                contract.setBillingAddress("[" + methodLabel + "] " + fullAddress); // FIX: Lưu phương thức thanh toán đính kèm vào billingAddress
                
                // --- TÍNH TOÁN GIÁ TIỀN TỰ ĐỘNG ---
                String posIdStr = request.getParameter("position_id");
                int positionId = (posIdStr != null && !posIdStr.isEmpty()) ? Integer.parseInt(posIdStr) : 1;
                
                String durationStr = request.getParameter("duration");
                int durationDays = 7; // Mặc định 1 tuần
                double multiplier = 1.0;
                
                if (durationStr != null && !durationStr.isEmpty()) {
                    if ("1w".equals(durationStr)) {
                        durationDays = 7;
                        multiplier = 1.0;
                    } else if ("2w".equals(durationStr)) {
                        durationDays = 14;
                        multiplier = 2.0;
                    } else if ("1m".equals(durationStr)) {
                        durationDays = 30;
                        multiplier = 4.0 * 0.9; // 4 tuần, giảm 10%
                    }
                }
                
                com.example.asmnews.entity.ads.AdPosition position = adPositionDAO.findById(positionId);
                double basePrice = position != null ? position.getBasePrice() : 5000000;
                
                // basePrice là giá 1 tuần
                double totalPrice = basePrice * multiplier;
                
                contract.setTotalPrice(totalPrice);
                contract.setStatus("PENDING");
                
                // Lưu Contract và lấy ID vừa tạo
                int contractId = adContractDAO.insert(contract);
                
                if (contractId <= 0) {
                    throw new Exception("Không thể tạo hợp đồng, vui lòng thử lại!");
                }
                
                // 3. Tạo Chiến dịch quảng cáo (AdCampaign)
                AdCampaign campaign = new AdCampaign();
                campaign.setContractId(contractId);
                campaign.setContractId(contractId);
                campaign.setPositionId(positionId);
                
                campaign.setCampaignName(request.getParameter("campaign_name"));
                
                String startDateStr = request.getParameter("start_date");
                if (startDateStr != null && !startDateStr.isEmpty()) {
                    campaign.setStartDate(java.sql.Date.valueOf(startDateStr));
                }
                
                // Tính End Date dựa vào Start Date và Duration (ví dụ: '1w', '1m')
                if (durationStr != null && startDateStr != null && !startDateStr.isEmpty()) {
                    try {
                        java.time.LocalDate sDate = java.time.LocalDate.parse(startDateStr);
                        campaign.setEndDate(java.sql.Date.valueOf(sDate.plusDays(durationDays)));
                    } catch (Exception e) {
                        System.err.println("Lỗi tính end_date: " + e.getMessage());
                        // Fallback: Default
                        java.time.LocalDate sDate = java.time.LocalDate.parse(startDateStr);
                        campaign.setEndDate(java.sql.Date.valueOf(sDate.plusDays(durationDays)));
                    }
                }
                
                campaign.setTargetUrl(request.getParameter("landing_url"));
                
                // 4. Xử lý upload ảnh
                Part filePart = request.getPart("client_ad_image");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "ads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    int pos = campaign.getPositionId();
                    int tWidth = 1120, tHeight = 90; // Mặc định là Top Banner
                    
                    if (pos == 1) { // Super Masthead
                        tWidth = 1920; tHeight = 250;
                    } else if (pos == 3 || pos == 4 || pos == 5) { // Medium Rectangle / Sidebar
                        tWidth = 300; tHeight = 250;
                    }

                    File targetFile = new File(uploadPath + File.separator + uniqueFileName);
                    
                    try (java.io.InputStream fileContent = filePart.getInputStream()) {
                        ImageUtils.resizeAndCrop(fileContent, targetFile, tWidth, tHeight);
                    }
                    
                    // Lưu copy vào src
                    String srcPath = "C:\\Users\\Acer Nitro 5\\Downloads\\Asm-new-main\\src\\main\\webapp\\images\\ads";
                    File srcDir = new File(srcPath);
                    if (srcDir.exists()) {
                        java.nio.file.Files.copy(
                            Paths.get(uploadPath + File.separator + uniqueFileName), 
                            Paths.get(srcPath + File.separator + uniqueFileName),
                            java.nio.file.StandardCopyOption.REPLACE_EXISTING
                        );
                    }
                    
                    String imageUrl = request.getContextPath() + "/images/ads/" + uniqueFileName;
                    campaign.setImageUrl(imageUrl);
                } else {
                    campaign.setDriveUrl(request.getParameter("drive_url"));
                }
                
                // 5. Lưu Chiến dịch vào Database
                boolean isSuccess = adCampaignDAO.insert(campaign);

                if (isSuccess) {
                    setSuccessMessage(request, "Đã gửi yêu cầu quảng cáo thành công! Chuyên viên của chúng tôi sẽ liên hệ ngay.");
                } else {
                    setErrorMessage(request, "Lỗi: Không thể lưu yêu cầu vào hệ thống, vui lòng thử lại!");
                }

                response.sendRedirect(request.getContextPath() + "/quang-cao/online");
                
            } catch (Exception e) {
                e.printStackTrace();
                setErrorMessage(request, "Lỗi hệ thống: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/quang-cao");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
