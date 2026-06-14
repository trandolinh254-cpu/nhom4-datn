package com.example.asmnews.controller.admin;

import com.example.asmnews.controller.common.BaseServlet;






import java.io.File; // THÊM IMPORT
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.example.asmnews.repository.news.CategoryDAO;
import com.example.asmnews.repository.news.NewsDAO;
import com.example.asmnews.repository.order.NewsletterDAO;
import com.example.asmnews.util.DatabaseUtils;
import com.example.asmnews.repository.auth.UserDAO;
import com.example.asmnews.repository.news.FollowDAO; // 
import com.example.asmnews.util.EmailUtils; // 
import com.example.asmnews.entity.news.Category;
import com.example.asmnews.entity.news.News;
import com.example.asmnews.entity.order.Newsletter;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.repository.ads.AdCampaignDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part; // THÊM IMPORT

/**
 * Servlet xử lý trang admin
 */

@jakarta.servlet.annotation.MultipartConfig( // // : Cấu hình để Servlet nhận được file upload
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)

@WebServlet("/admin/*")
public class AdminServlet extends BaseServlet {

    private NewsDAO newsDAO = new NewsDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private UserDAO userDAO = new UserDAO();
    private NewsletterDAO newsletterDAO = new NewsletterDAO();
    private AdCampaignDAO adCampaignDAO = new AdCampaignDAO();
    private FollowDAO followDAO = new FollowDAO(); // 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền truy cập (Chỉ Admin)
        if (!checkAdminAccess(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            switch (pathInfo) {
                case "/":
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/news":
                    showNewsManagement(request, response);
                    break;
                case "/news/add":
                    showAddNews(request, response);
                    break;
                case "/news/edit":
                    showEditNews(request, response);
                    break;
                case "/categories":
                    showCategoryManagement(request, response);
                    break;
                case "/users":
                    showUserManagement(request, response);
                    break;
                case "/newsletters":
                    showNewsletterManagement(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong AdminServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Có lỗi xảy ra khi xử lý yêu cầu");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền truy cập (Chỉ Admin)
        if (!checkAdminAccess(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            switch (pathInfo) {
                case "/news/save":
                    saveNews(request, response);
                    break;
                case "/news/delete":
                    deleteNews(request, response);
                    break;
                case "/categories/save":
                    saveCategory(request, response);
                    break;
                case "/categories/delete":
                    deleteCategory(request, response);
                    break;
                case "/users/save":
                    saveUser(request, response);
                    break;

                case "/users/toggle-status":
                    toggleUserStatus(request, response);
                    break;
                case "/newsletters/delete":
                    deleteNewsletter(request, response);
                    break;
                case "/news/status":
                    updateNewsStatus(request, response);
                    break;
                // : Thêm case xử lý Duyệt tất cả
                case "/news/approve-all":
                    approveAllNews(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong AdminServlet POST: " + e.getMessage());
            e.printStackTrace();
            setErrorMessage(request, "Có lỗi xảy ra khi xử lý yêu cầu");
            redirect(response, request.getContextPath() + "/admin");
        }
    }

    /**
     * Hiển thị dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thống kê cơ bản
        List<News> allNews = newsDAO.findAll();
        List<Category> allCategories = categoryDAO.findAll();
        List<User> allUsers = userDAO.findAll();

        request.setAttribute("totalNews", allNews.size());
        request.setAttribute("totalCategories", allCategories.size());
        request.setAttribute("totalUsers", allUsers.size());
        request.setAttribute("totalNewsletters", newsletterDAO.countActive());

        // Tin tức mới nhất
        List<News> latestNews = newsDAO.findTop5Latest();
        request.setAttribute("latestNews", latestNews);

        // Thống kê quảng cáo
        request.setAttribute("pendingAdsCount", adCampaignDAO.countPendingCampaigns());
        request.setAttribute("runningAdsCount", adCampaignDAO.countRunningCampaigns());
        request.setAttribute("revenueThisMonth", adCampaignDAO.calculateMonthlyRevenue());
        request.setAttribute("recentAdRequests", adCampaignDAO.getRecentPendingCampaigns());

        // : Thêm dữ liệu cho Biểu đồ Tròn (Tổng quan Hệ thống - Tin tức theo Chuyên mục)
        java.util.Map<String, Integer> newsByCategory = categoryDAO.getNewsCountByCategory();
        StringBuilder pieLabels = new StringBuilder("[");
        StringBuilder pieData = new StringBuilder("[");
        int pieIndex = 0;
        for (java.util.Map.Entry<String, Integer> entry : newsByCategory.entrySet()) {
            if (pieIndex > 0) {
                pieLabels.append(",");
                pieData.append(",");
            }
            pieLabels.append("\"").append(entry.getKey()).append("\"");
            pieData.append(entry.getValue());
            pieIndex++;
        }
        pieLabels.append("]");
        pieData.append("]");
        request.setAttribute("chartCategoryLabels", pieLabels.toString());
        request.setAttribute("chartCategoryData", pieData.toString());

        // : Thêm dữ liệu cho Biểu đồ Cột (Tổng quan Quảng Cáo - Doanh thu theo tháng)
        int currentYear = java.time.Year.now().getValue();
        java.util.Map<Integer, Double> revenueByMonth = adCampaignDAO.getRevenueByMonth(currentYear);
        StringBuilder barLabels = new StringBuilder("[");
        StringBuilder barData = new StringBuilder("[");
        for (int i = 1; i <= 12; i++) {
            if (i > 1) {
                barLabels.append(",");
                barData.append(",");
            }
            barLabels.append("\"Tháng ").append(i).append("\"");
            barData.append(revenueByMonth.get(i));
        }
        barLabels.append("]");
        barData.append("]");
        request.setAttribute("chartRevenueLabels", barLabels.toString());
        request.setAttribute("chartRevenueData", barData.toString());
        request.setAttribute("currentYear", currentYear);

        forward(request, response, "/WEB-INF/views/admin/dashboard.jsp");
    }

    /**
     * Hiển thị quản lý tin tức
     */
    private void showNewsManagement(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    User currentUser = getCurrentUser(request);
    List<News> newsList;

    // 1. Xử lý tham số trang hiện tại (mặc định là trang 1, mỗi trang 10 bài)
    int page = 1;
    int limit = 10;
    
    try {
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }
    } catch (NumberFormatException e) {
        page = 1;
    }

    int offset = (page - 1) * limit;
    int totalItems = 0;

    // 2. Truy vấn dữ liệu (có kèm phân trang)
    totalItems = newsDAO.countAll();
    newsList = newsDAO.findAllWithPagination(offset, limit);

    // 3. Tính toán tổng số trang
    int totalPages = (int) Math.ceil((double) totalItems / limit);

    // 4. Truyền dữ liệu sang giao diện (JSP)
    request.setAttribute("newsList", newsList);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    
    forward(request, response, "/WEB-INF/views/admin/news/news-management.jsp");
}

    /**
     * Hiển thị form thêm tin tức
     */
    private void showAddNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        forward(request, response, "/WEB-INF/views/admin/news/news-form.jsp");
    }

    /**
     * Hiển thị form sửa tin tức
     */
    private void showEditNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String newsId = getParameter(request, "id", "");
        if (newsId.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin tin tức");
            redirect(response, request.getContextPath() + "/admin/news");
            return;
        }

        News news = newsDAO.findById(newsId);
        if (news == null) {
            setErrorMessage(request, "Không tìm thấy tin tức");
            redirect(response, request.getContextPath() + "/admin/news");
            return;
        }

        // Admin có toàn quyền sửa tin tức.

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("news", news);

        forward(request, response, "/WEB-INF/views/admin/news/news-form.jsp");
    }

    /**
     * Lưu tin tức
     */
    private void saveNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException { // // : Thêm ServletException vào signature

        String newsId = getParameter(request, "id", "");
        String title = getParameter(request, "title", "");
        String content = getParameter(request, "content", "");
        String categoryId = getParameter(request, "categoryId", "");

        // : Hứng thêm dữ liệu Danh mục con từ ô Select thứ 2
        String subCategory = getParameter(request, "subCategoryId", "");

        boolean home = getBooleanParameter(request, "home");

        // // : Xử lý lấy file ảnh và lưu vào thư mục images
        String fileName = null;
        try {
            Part filePart = request.getPart("image"); // Lấy part có name="image" từ form
            if (filePart != null && filePart.getSize() > 0) {
                fileName = filePart.getSubmittedFileName();

                // Xác định đường dẫn tuyệt đối đến thư mục images trong webapp
                String appPath = request.getServletContext().getRealPath("");
                String savePath = appPath + File.separator + "images";

                // Tạo thư mục nếu chưa tồn tại
                File fileSaveDir = new File(savePath);
                if (!fileSaveDir.exists())
                    fileSaveDir.mkdir();

                // Ghi file xuống ổ đĩa
                filePart.write(savePath + File.separator + fileName);
            } else if (!newsId.isEmpty()) {
                // Nếu là chế độ sửa và không chọn ảnh mới, giữ lại tên ảnh cũ
                News existingNews = newsDAO.findById(newsId);
                if (existingNews != null)
                    fileName = existingNews.getImage();
            }
        } catch (Exception e) {
            System.err.println("Lỗi xử lý file ảnh: " + e.getMessage());
        }

        // Validate
        if (title.isEmpty() || content.isEmpty() || categoryId.isEmpty()) {
            setErrorMessage(request, "Vui lòng nhập đầy đủ thông tin bắt buộc");
            redirect(response, request.getContextPath() + "/admin/news/add");
            return;
        }

        User currentUser = getCurrentUser(request);
        boolean isEdit = !newsId.isEmpty();
        News news;

        if (isEdit) {
            news = newsDAO.findById(newsId);
            if (news == null) {
                setErrorMessage(request, "Không tìm thấy tin tức");
                redirect(response, request.getContextPath() + "/admin/news");
                return;
            }
            news.setTitle(title);
            news.setContent(content);
            news.setImage(fileName); // // : Gán tên file mới
            news.setCategoryId(categoryId);
            news.setSubCategory(subCategory); // : Set dữ liệu khi SỬA
            news.setHome(home);
        } else {
            news = new News();
            news.setId("NEWS" + System.currentTimeMillis());
            news.setTitle(title);
            news.setContent(content);
            news.setImage(fileName); // // : Gán tên file upload
            news.setCategoryId(categoryId);
            news.setSubCategory(subCategory); // : Set dữ liệu khi THÊM
            news.setAuthor(currentUser.getId());
            news.setPostedDate(new Date());
            news.setViewCount(0);
            news.setHome(home);
        }

        boolean success = isEdit ? newsDAO.update(news) : newsDAO.insert(news);

        if (success) {
            setSuccessMessage(request, isEdit ? "Cập nhật tin tức thành công!" : "Thêm tin tức thành công!");
        } else {
            setErrorMessage(request, isEdit ? "Có lỗi khi cập nhật tin tức" : "Có lỗi khi thêm tin tức");
        }

        redirect(response, request.getContextPath() + "/admin/news");
    }

    /**
     * Xóa tin tức
     */
    private void deleteNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String newsId = getParameter(request, "id", "");
        if (newsId.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin tin tức");
            redirect(response, request.getContextPath() + "/admin/news");
            return;
        }

        News news = newsDAO.findById(newsId);
        if (news == null) {
            setErrorMessage(request, "Không tìm thấy tin tức");
            redirect(response, request.getContextPath() + "/admin/news");
            return;
        }

        // Admin có toàn quyền xóa tin tức.

        if (newsDAO.delete(newsId)) {
            setSuccessMessage(request, "Xóa tin tức thành công!");
        } else {
            setErrorMessage(request, "Có lỗi khi xóa tin tức");
        }

        redirect(response, request.getContextPath() + "/admin/news");
    }

    /**
     * Hiển thị quản lý categories (chỉ admin)
     */
    private void showCategoryManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        forward(request, response, "/WEB-INF/views/admin/news/category-management.jsp");
    }

    /**
     * Lưu category (chỉ admin)
     */
    private void saveCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        String mode = getParameter(request, "mode", "create");
        String categoryId = getParameter(request, "id", "").trim().toUpperCase();
        String categoryName = getParameter(request, "name", "").trim();

        if (categoryId.isEmpty() || categoryName.isEmpty()) {
            setErrorMessage(request, "Vui lòng nhập đầy đủ mã và tên loại tin");
            redirect(response, request.getContextPath() + "/admin/categories");
            return;
        }

        boolean isEdit = "edit".equals(mode);
        Category category;

        if (isEdit) {
            category = categoryDAO.findById(categoryId);
            if (category == null) {
                setErrorMessage(request, "Không tìm thấy loại tin");
                redirect(response, request.getContextPath() + "/admin/categories");
                return;
            }
            category.setName(categoryName);
        } else {
            if (categoryDAO.exists(categoryId)) {
                setErrorMessage(request, "Mã loại tin đã tồn tại");
                redirect(response, request.getContextPath() + "/admin/categories");
                return;
            }
            category = new Category();
            category.setId(categoryId);
            category.setName(categoryName);
        }

        boolean success = isEdit ? categoryDAO.update(category) : categoryDAO.insert(category);

        if (success) {
            setSuccessMessage(request, isEdit ? "Cập nhật loại tin thành công!" : "Thêm loại tin thành công!");
        } else {
            setErrorMessage(request, isEdit ? "Có lỗi khi cập nhật loại tin" : "Có lỗi khi thêm loại tin");
        }

        redirect(response, request.getContextPath() + "/admin/categories");
    }

    /**
     * Xóa category (chỉ admin)
     */
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        String categoryId = getParameter(request, "id", "");
        if (categoryId.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin loại tin");
            redirect(response, request.getContextPath() + "/admin/categories");
            return;
        }

        if (categoryDAO.delete(categoryId)) {
            setSuccessMessage(request, "Xóa loại tin thành công!");
        } else {
            setErrorMessage(request, "Có lỗi khi xóa loại tin (có thể đang được sử dụng)");
        }

        redirect(response, request.getContextPath() + "/admin/categories");
    }

    /**
     * Hiển thị quản lý users (chỉ admin)
     */
    private void showUserManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);

        forward(request, response, "/WEB-INF/views/admin/users/user-management.jsp");
    }

    /**
     * Lưu user (chỉ admin)
     */
    private void saveUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        String userId = getParameter(request, "id", "");
        String password = getParameter(request, "password", "");
        String fullname = getParameter(request, "fullname", "");
        String birthdayStr = getParameter(request, "birthday", "");
        String genderStr = getParameter(request, "gender", "");
        String mobile = getParameter(request, "mobile", "");
        String email = getParameter(request, "email", "");

        // --- [SỬA TỪ ĐÂY]: Đọc role dưới dạng Integer, có bắt lỗi an toàn ---
        int role = User.ROLE_READER; // Mặc định là Độc giả (Nguyên tắc đặc quyền tối thiểu)
        try {
            String roleStr = getParameter(request, "role", "");
            if (!roleStr.isEmpty()) {
                role = Integer.parseInt(roleStr);
            }
        } catch (NumberFormatException e) {
            System.err.println("Lỗi parse role: " + e.getMessage());
        }
        // --- [KẾT THÚC SỬA] ---

        // Validate
        if (fullname.isEmpty() || email.isEmpty()) {
            setErrorMessage(request, "Vui lòng nhập đầy đủ thông tin bắt buộc");
            redirect(response, request.getContextPath() + "/admin/users");
            return;
        }

        // ❗❗❗ SỬA Ở ĐÂY – XÁC ĐỊNH ĐÚNG LÀ THÊM HAY SỬA
        boolean isEdit = userDAO.findById(userId) != null;

        User user;

        if (isEdit) {
            user = userDAO.findById(userId);
            if (user == null) {
                setErrorMessage(request, "Không tìm thấy người dùng");
                redirect(response, request.getContextPath() + "/admin/users");
                return;
            }

            if (!password.isEmpty()) {
                user.setPassword(password);
            }
        } else {
            if (userId.isEmpty() || password.isEmpty()) {
                setErrorMessage(request, "Vui lòng nhập ID và mật khẩu cho người dùng mới");
                redirect(response, request.getContextPath() + "/admin/users");
                return;
            }

            user = new User();
            user.setId(userId);
            user.setPassword(password);
        }

        user.setFullname(fullname);
        user.setMobile(mobile);
        user.setEmail(email);
        user.setRole(role);

        // Parse birthday
        if (!birthdayStr.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                user.setBirthday(sdf.parse(birthdayStr));
            } catch (ParseException e) {
                // Ignore invalid date
            }
        }

        // Parse gender
        if (!genderStr.isEmpty()) {
            user.setGender("true".equals(genderStr) || "1".equals(genderStr));
        }

        boolean success = isEdit ? userDAO.update(user) : userDAO.insert(user);

        if (success) {
            setSuccessMessage(request, isEdit ? "Cập nhật người dùng thành công!" : "Thêm người dùng thành công!");
        } else {
            setErrorMessage(request, isEdit ? "Có lỗi khi cập nhật người dùng" : "Có lỗi khi thêm người dùng");
        }

        redirect(response, request.getContextPath() + "/admin/users");
    }

    /**
     * Xóa user (chỉ admin)
     */
    /**
     * Khóa / Mở khóa user (thay thế cho chức năng Xóa)
     */
    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!checkAdminAccess(request, response))
            return;

        String userId = getParameter(request, "id", "");
        boolean isActive = Boolean.parseBoolean(getParameter(request, "isActive", "true"));

        if (userId.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin người dùng");
            redirect(response, request.getContextPath() + "/admin/users");
            return;
        }

        // Không cho phép khóa chính mình
        User currentUser = getCurrentUser(request);
        if (userId.equals(currentUser.getId())) {
            setErrorMessage(request, "Không thể khóa tài khoản của chính mình");
            redirect(response, request.getContextPath() + "/admin/users");
            return;
        }

        if (userDAO.toggleStatus(userId, isActive)) {
            setSuccessMessage(request, isActive ? "Đã mở khóa tài khoản thành công!" : "Đã khóa tài khoản thành công!");
        } else {
            setErrorMessage(request, "Có lỗi khi cập nhật trạng thái");
        }

        redirect(response, request.getContextPath() + "/admin/users");
    }

    /**
     * Hiển thị quản lý newsletters (chỉ admin)
     */
    private void showNewsletterManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        List<Newsletter> newsletters = newsletterDAO.findAll();
        request.setAttribute("newsletters", newsletters);

        forward(request, response, "/WEB-INF/views/admin/marketing/newsletter-management.jsp");
    }

    /**
     * Xóa newsletter (chỉ admin)
     */
    private void deleteNewsletter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!checkAdminAccess(request, response)) {
            return;
        }

        String email = getParameter(request, "email", "");
        if (email.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin email");
            redirect(response, request.getContextPath() + "/admin/newsletters");
            return;
        }

        if (newsletterDAO.delete(email)) {
            setSuccessMessage(request, "Xóa đăng ký newsletter thành công!");
        } else {
            setErrorMessage(request, "Có lỗi khi xóa đăng ký newsletter");
        }

        redirect(response, request.getContextPath() + "/admin/newsletters");
    }

    /**
     * : Xử lý Duyệt hoặc Từ chối bài viết
     */
    private void updateNewsStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!checkAdminAccess(request, response))
            return;

        String newsId = getParameter(request, "id", "");
        int status = Integer.parseInt(getParameter(request, "status", "0"));
        String rejectReason = getParameter(request, "rejectReason", "");

        if (newsId.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin bài viết.");
        } else if (newsDAO.updateStatus(newsId, status, rejectReason)) {
            setSuccessMessage(request, status == 1 ? "Đã duyệt bài viết thành công!" : "Đã từ chối bài viết!");

            // Gửi email thông báo cho những người theo dõi tác giả bài viết khi được duyệt (status = 1) 
            if (status == 1) { 
                News news = newsDAO.findById(newsId); 
                if (news != null) { 
                    List<String> followerEmails = followDAO.getFollowerEmails(news.getAuthor()); 
                    User author = userDAO.findById(news.getAuthor()); 
                    String authorName = (author != null) ? (author.getPenName() != null ? author.getPenName() : author.getFullname()) : "Nhà báo"; 

                    String scheme = request.getScheme(); 
                    String serverName = request.getServerName(); 
                    int serverPort = request.getServerPort(); 
                    String contextPath = request.getContextPath(); 
                    String articleLink = scheme + "://" + serverName + ":" + serverPort + contextPath + "/news?action=detail&id=" + news.getId(); 

                    new Thread(() -> { 
                        // 1. Gửi cho các độc giả đang theo dõi tác giả
                        if (followerEmails != null && !followerEmails.isEmpty()) { 
                            for (String email : followerEmails) { 
                                EmailUtils.sendNewArticleNotification(email, authorName, news.getTitle(), articleLink); 
                            } 
                        } 
                        // 2. Gửi cho chính tác giả bài viết
                        if (author != null && author.getEmail() != null && !author.getEmail().trim().isEmpty()) { 
                            EmailUtils.sendArticleApprovedNotification(author.getEmail(), author.getFullname(), news.getTitle(), articleLink); 
                        } 
                        // 3. Gửi bản tin cho những người đăng ký nhận tin (Newsletter) -- FIX
                        List<com.example.asmnews.entity.order.Newsletter> activeNewsletters = newsletterDAO.findActive(); // // FIX
                        if (activeNewsletters != null && !activeNewsletters.isEmpty()) { // // FIX
                            for (com.example.asmnews.entity.order.Newsletter nl : activeNewsletters) { // // FIX
                                EmailUtils.sendNewsletterNotification(nl.getEmail(), news.getTitle(), articleLink); // // FIX
                            } // // FIX
                        } // // FIX
                    }).start(); 
                } 
            } 
        } else {
            setErrorMessage(request, "Có lỗi xảy ra khi cập nhật trạng thái bài viết.");
        }

        redirect(response, request.getContextPath() + "/admin/news");
    }

    /**
     * : Hàm xử lý Duyệt tất cả bài viết
     */
    private void approveAllNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Chỉ Admin mới được dùng nút này
        if (!checkAdminAccess(request, response))
            return;

        // Lấy danh sách bài viết đang chờ duyệt trước khi duyệt 
        List<News> pendingNews = newsDAO.findPendingNews(); 

        if (newsDAO.approveAllPendingNews()) {
            setSuccessMessage(request, "Đã duyệt toàn bộ bài viết chờ duyệt thành công!");

            // Gửi email thông báo cho những người theo dõi các tác giả bài viết được duyệt hàng loạt 
            if (pendingNews != null && !pendingNews.isEmpty()) { 
                new Thread(() -> { 
                    for (News news : pendingNews) { 
                        List<String> followerEmails = followDAO.getFollowerEmails(news.getAuthor()); 
                        User author = userDAO.findById(news.getAuthor()); 
                        String authorName = (author != null) ? (author.getPenName() != null ? author.getPenName() : author.getFullname()) : "Nhà báo"; 

                        String scheme = request.getScheme(); 
                        String serverName = request.getServerName(); 
                        int serverPort = request.getServerPort(); 
                        String contextPath = request.getContextPath(); 
                        String articleLink = scheme + "://" + serverName + ":" + serverPort + contextPath + "/news?action=detail&id=" + news.getId(); 

                        // 1. Gửi cho các độc giả đang theo dõi
                        if (followerEmails != null && !followerEmails.isEmpty()) { 
                            for (String email : followerEmails) { 
                                EmailUtils.sendNewArticleNotification(email, authorName, news.getTitle(), articleLink); 
                            } 
                        }
                        // 2. Gửi cho chính tác giả bài viết
                        if (author != null && author.getEmail() != null && !author.getEmail().trim().isEmpty()) { 
                            EmailUtils.sendArticleApprovedNotification(author.getEmail(), author.getFullname(), news.getTitle(), articleLink); 
                        } 
                        // 3. Gửi bản tin cho những người đăng ký nhận tin (Newsletter) -- FIX
                        List<com.example.asmnews.entity.order.Newsletter> activeNewsletters = newsletterDAO.findActive(); // // FIX
                        if (activeNewsletters != null && !activeNewsletters.isEmpty()) { // // FIX
                            for (com.example.asmnews.entity.order.Newsletter nl : activeNewsletters) { // // FIX
                                EmailUtils.sendNewsletterNotification(nl.getEmail(), news.getTitle(), articleLink); // // FIX
                            } // // FIX
                        } // // FIX
                    } 
                }).start(); 
            } 
        } else {
            setErrorMessage(request, "Không có bài viết nào cần duyệt hoặc có lỗi xảy ra.");
        }

        redirect(response, request.getContextPath() + "/admin/news");
    }
}
