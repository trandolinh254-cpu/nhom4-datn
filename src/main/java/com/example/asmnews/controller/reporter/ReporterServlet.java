package com.example.asmnews.controller.reporter;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.entity.news.Category;
import com.example.asmnews.entity.news.News;
import com.example.asmnews.entity.news.Comment;
import com.example.asmnews.repository.news.CategoryDAO;
import com.example.asmnews.repository.news.NewsDAO;
import com.example.asmnews.repository.news.commentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@jakarta.servlet.annotation.MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
@WebServlet("/reporter/*")
public class ReporterServlet extends BaseServlet {

    private NewsDAO newsDAO = new NewsDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private commentDAO commentDAO = new commentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền truy cập (Chỉ dành cho Phóng viên)
        if (!checkReporterAccess(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/news"; // Chuyển hướng mặc định về danh sách tin tức
        }

        try {
            switch (pathInfo) {
                case "/news":
                    showNewsManagement(request, response);
                    break;
                case "/news/add":
                    showAddNews(request, response);
                    break;
                case "/news/edit":
                    showEditNews(request, response);
                    break;
                case "/comments":
                    showCommentsManagement(request, response);
                    break;
                case "/analytics":
                    showAnalytics(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong ReporterServlet: " + e.getMessage());
            e.printStackTrace();
            try (java.io.FileWriter fw = new java.io.FileWriter("c:/Users/Acer Nitro 5/Downloads/Asm-new-main/debug.log", true);
                 java.io.PrintWriter pw = new java.io.PrintWriter(fw)) {
                pw.println("--- ERROR " + new java.util.Date() + " ---");
                e.printStackTrace(pw);
            } catch (Exception ignored) {}
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Có lỗi xảy ra khi xử lý yêu cầu: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền truy cập
        if (!checkReporterAccess(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/news";

        try {
            switch (pathInfo) {
                case "/news/save":
                    saveNews(request, response);
                    break;
                case "/news/autosave":
                    // // FIX: Xử lý lưu nháp bài viết qua Ajax
                    autoSaveNews(request, response);
                    break;
                case "/news/delete":
                    deleteNews(request, response);
                    break;
                case "/comments/pin":
                    togglePinComment(request, response);
                    break;
                case "/comments/hide":
                    toggleHideComment(request, response);
                    break;
                case "/comments/reply":
                    replyCommentByAuthor(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong ReporterServlet POST: " + e.getMessage());
            e.printStackTrace();
            setErrorMessage(request, "Có lỗi xảy ra khi xử lý yêu cầu");
            redirect(response, request.getContextPath() + "/reporter/news");
        }
    }

    private void showNewsManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentUser(request);
        List<News> newsList;

        // // FIX: Lấy các tham số lọc và tìm kiếm từ request
        String search = request.getParameter("search");
        String statusStr = request.getParameter("status");
        String categoryId = request.getParameter("categoryId");
        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");

        Integer status = null;
        if (statusStr != null && !statusStr.isEmpty() && !statusStr.equals("all")) {
            try {
                status = Integer.parseInt(statusStr);
            } catch (NumberFormatException e) {}
        }

        java.util.Date dateFrom = null;
        java.util.Date dateTo = null;
        java.text.SimpleDateFormat inputSdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        if (dateFromStr != null && !dateFromStr.isEmpty()) {
            try {
                dateFrom = inputSdf.parse(dateFromStr);
            } catch (Exception e) {}
        }
        if (dateToStr != null && !dateToStr.isEmpty()) {
            try {
                dateTo = inputSdf.parse(dateToStr);
            } catch (Exception e) {}
        }

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

        // // FIX: Phóng viên: Đếm và xem tin tức của chính mình có lọc/tìm kiếm
        int totalItems = newsDAO.countByAuthorWithFilters(currentUser.getId(), search, status, categoryId, dateFrom, dateTo);
        newsList = newsDAO.findByAuthorWithFiltersAndPagination(currentUser.getId(), search, status, categoryId, dateFrom, dateTo, offset, limit);

        int totalPages = (int) Math.ceil((double) totalItems / limit);

        // // FIX: Lấy danh sách Categories để phục vụ hiển thị bộ lọc
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        // // FIX: Lưu lại trạng thái bộ lọc để hiển thị trên UI
        request.setAttribute("search", search);
        request.setAttribute("status", statusStr);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("dateFrom", dateFromStr);
        request.setAttribute("dateTo", dateToStr);

        request.setAttribute("newsList", newsList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        forward(request, response, "/WEB-INF/views/reporter/news/news-management.jsp");
    }

    private void showAddNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        forward(request, response, "/WEB-INF/views/reporter/news/news-form.jsp");
    }

    private void showEditNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String newsId = getParameter(request, "id", "");
        if (newsId.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin tin tức");
            redirect(response, request.getContextPath() + "/reporter/news");
            return;
        }

        News news = newsDAO.findById(newsId);
        if (news == null) {
            setErrorMessage(request, "Không tìm thấy tin tức");
            redirect(response, request.getContextPath() + "/reporter/news");
            return;
        }

        // Kiểm tra quyền sửa (tác giả)
        User currentUser = getCurrentUser(request);
        if (!news.getAuthor().equals(currentUser.getId())) {
            setErrorMessage(request, "Bạn không có quyền sửa tin tức này");
            redirect(response, request.getContextPath() + "/reporter/news");
            return;
        }

        // Chặn sửa bài viết nếu đã xuất bản (Status = 1) hoặc đang chờ lên lịch xuất bản
        boolean isScheduled = news.getScheduledDate() != null && news.getScheduledDate().after(new Date());
        boolean isPublished = news.getStatus() == 1;
        if (isScheduled || isPublished) {
            setErrorMessage(request, "Không thể chỉnh sửa bài viết đã xuất bản hoặc đang lên lịch xuất bản!");
            redirect(response, request.getContextPath() + "/reporter/news");
            return;
        }

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("news", news);

        forward(request, response, "/WEB-INF/views/reporter/news/news-form.jsp");
    }

    private void saveNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String newsId = getParameter(request, "id", "");
        String title = getParameter(request, "title", "");
        String content = getParameter(request, "content", "");
        String categoryId = getParameter(request, "categoryId", "");
        String subCategory = getParameter(request, "subCategoryId", "");

        String summary = getParameter(request, "summary", "");
        String metaTitle = getParameter(request, "metaTitle", "");
        String metaDescription = getParameter(request, "metaDescription", "");
        String slug = getParameter(request, "slug", "");
        String scheduledDateStr = getParameter(request, "scheduledDate", "");
        String statusStr = getParameter(request, "status", "0");

        // // FIX: Đọc trạng thái bài viết từ form (0: Chờ duyệt, 3: Bản nháp)
        int targetStatus = 0;
        try {
            targetStatus = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {}

        // Phóng viên không có quyền set home, nên mặc định là false
        boolean home = false; 

        String fileName = null;
        try {
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                fileName = filePart.getSubmittedFileName();
                String appPath = request.getServletContext().getRealPath("");
                String savePath = appPath + File.separator + "images";

                File fileSaveDir = new File(savePath);
                if (!fileSaveDir.exists()) fileSaveDir.mkdir();

                filePart.write(savePath + File.separator + fileName);
            } else if (!newsId.isEmpty()) {
                News existingNews = newsDAO.findById(newsId);
                if (existingNews != null) fileName = existingNews.getImage();
            }
        } catch (Exception e) {
            System.err.println("Lỗi xử lý file ảnh: " + e.getMessage());
        }

        if (title.isEmpty() || content.isEmpty() || categoryId.isEmpty()) {
            setErrorMessage(request, "Vui lòng nhập đầy đủ thông tin bắt buộc");
            // // FIX: Redirect về trang edit nếu là chỉnh sửa bài viết cũ
            if (!newsId.isEmpty()) {
                redirect(response, request.getContextPath() + "/reporter/news/edit?id=" + newsId);
            } else {
                redirect(response, request.getContextPath() + "/reporter/news/add");
            }
            return;
        }

        // Tự động điền các trường SEO/Slug nếu trống
        if (slug.isEmpty()) {
            slug = generateSlug(title);
        }
        if (metaTitle.isEmpty()) {
            metaTitle = title;
            if (metaTitle.length() > 65) {
                metaTitle = metaTitle.substring(0, 62) + "...";
            }
        }
        if (metaDescription.isEmpty()) {
            metaDescription = summary.isEmpty() ? content : summary;
            if (metaDescription.length() > 160) {
                metaDescription = metaDescription.substring(0, 157) + "...";
            }
        }

        Date scheduledDate = null;
        if (!scheduledDateStr.isEmpty()) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                scheduledDate = sdf.parse(scheduledDateStr);
            } catch (Exception e) {
                try {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                    scheduledDate = sdf.parse(scheduledDateStr);
                } catch (Exception ex) {}
            }
        }

        User currentUser = getCurrentUser(request);
        boolean isEdit = !newsId.isEmpty();
        News news;

        if (isEdit) {
            news = newsDAO.findById(newsId);
            if (news == null || !news.getAuthor().equals(currentUser.getId())) {
                setErrorMessage(request, "Không tìm thấy tin tức hoặc không có quyền sửa");
                redirect(response, request.getContextPath() + "/reporter/news");
                return;
            }

            // Chặn sửa bài viết nếu đã xuất bản hoặc đang lên lịch
            boolean isScheduled = news.getScheduledDate() != null && news.getScheduledDate().after(new Date());
            boolean isPublished = news.getStatus() == 1;
            if (isScheduled || isPublished) {
                setErrorMessage(request, "Không thể chỉnh sửa bài viết đã xuất bản hoặc đang lên lịch xuất bản!");
                redirect(response, request.getContextPath() + "/reporter/news");
                return;
            }

            news.setTitle(title);
            news.setContent(content);
            news.setImage(fileName);
            news.setCategoryId(categoryId);
            news.setSubCategory(subCategory);
            // // FIX: Sử dụng targetStatus từ tham số gửi lên
            news.setStatus(targetStatus);
            news.setSummary(summary);
            news.setMetaTitle(metaTitle);
            news.setMetaDescription(metaDescription);
            news.setSlug(slug);
            news.setScheduledDate(scheduledDate);
            news.setLastModified(new Date());
        } else {
            news = new News();
            news.setId("NEWS" + System.currentTimeMillis());
            news.setTitle(title);
            news.setContent(content);
            news.setImage(fileName);
            news.setCategoryId(categoryId);
            news.setSubCategory(subCategory);
            news.setAuthor(currentUser.getId());
            news.setPostedDate(new Date());
            news.setViewCount(0);
            news.setHome(home);
            // // FIX: Sử dụng targetStatus từ tham số gửi lên
            news.setStatus(targetStatus);
            news.setSummary(summary);
            news.setMetaTitle(metaTitle);
            news.setMetaDescription(metaDescription);
            news.setSlug(slug);
            news.setScheduledDate(scheduledDate);
            news.setLastModified(new Date());
        }

        boolean success = isEdit ? newsDAO.update(news) : newsDAO.insert(news);

        if (success) {
            // // FIX: Hiển thị thông báo phù hợp cho việc lưu nháp hoặc gửi bài
            String msg = isEdit ? "Cập nhật tin tức thành công!" : "Thêm tin tức thành công, vui lòng chờ duyệt!";
            if (targetStatus == 3) {
                msg = "Đã lưu nháp bài viết thành công!";
            }
            setSuccessMessage(request, msg);
        } else {
            setErrorMessage(request, isEdit ? "Có lỗi khi cập nhật tin tức" : "Có lỗi khi thêm tin tức");
        }

        redirect(response, request.getContextPath() + "/reporter/news");
    }

    private void deleteNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String newsId = getParameter(request, "id", "");
        if (newsId.isEmpty()) {
            setErrorMessage(request, "Thiếu thông tin tin tức");
            redirect(response, request.getContextPath() + "/reporter/news");
            return;
        }

        News news = newsDAO.findById(newsId);
        User currentUser = getCurrentUser(request);
        
        if (news == null || !news.getAuthor().equals(currentUser.getId())) {
            setErrorMessage(request, "Không tìm thấy tin tức hoặc không có quyền xóa");
            redirect(response, request.getContextPath() + "/reporter/news");
            return;
        }

        if (newsDAO.delete(newsId)) {
            setSuccessMessage(request, "Xóa tin tức thành công!");
        } else {
            setErrorMessage(request, "Có lỗi khi xóa tin tức");
        }

        redirect(response, request.getContextPath() + "/reporter/news");
    }

    /**
     * Tạo URL Slug tự động từ Tiêu đề tiếng Việt
     */
    private String generateSlug(String title) {
        if (title == null || title.isEmpty()) {
            return "";
        }
        String slug = title.toLowerCase();
        slug = slug.replaceAll("[áàảãạăắằẳẵặâấầẩẫậ]", "a");
        slug = slug.replaceAll("[éèẻẽẹêếềểễệ]", "e");
        slug = slug.replaceAll("[íìỉĩị]", "i");
        slug = slug.replaceAll("[óòỏõọôốồổỗộơớờởỡợ]", "o");
        slug = slug.replaceAll("[úùủũụưứừửữự]", "u");
        slug = slug.replaceAll("[ýỳỷỹỵ]", "y");
        slug = slug.replaceAll("đ", "d");
        slug = slug.replaceAll("[^a-z0-9\\s-]", "");
        slug = slug.replaceAll("\\s+", "-");
        slug = slug.replaceAll("-+", "-");
        if (slug.startsWith("-")) {
            slug = slug.substring(1);
        }
        if (slug.endsWith("-")) {
            slug = slug.substring(0, slug.length() - 1);
        }
        return slug;
    }

    /**
     * // FIX: Xử lý tự động lưu bản nháp bài viết qua Ajax (gửi định kỳ mỗi 60 giây)
     */
    private void autoSaveNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        // // FIX: Nhận các tham số văn bản từ Ajax để tự động lưu nháp
        String newsId = getParameter(request, "id", "");
        String title = getParameter(request, "title", "");
        String content = getParameter(request, "content", "");
        String categoryId = getParameter(request, "categoryId", "");
        String subCategory = getParameter(request, "subCategoryId", "");
        String summary = getParameter(request, "summary", "");
        String metaTitle = getParameter(request, "metaTitle", "");
        String metaDescription = getParameter(request, "metaDescription", "");
        String slug = getParameter(request, "slug", "");
        String scheduledDateStr = getParameter(request, "scheduledDate", "");

        if (title.isEmpty()) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Tiêu đề trống\"}");
            return;
        }

        // Tự động điền các trường SEO/Slug nếu trống
        if (slug.isEmpty()) {
            slug = generateSlug(title);
        }
        if (metaTitle.isEmpty()) {
            metaTitle = title;
            if (metaTitle.length() > 65) {
                metaTitle = metaTitle.substring(0, 62) + "...";
            }
        }
        if (metaDescription.isEmpty()) {
            metaDescription = summary.isEmpty() ? content : summary;
            if (metaDescription.length() > 160) {
                metaDescription = metaDescription.substring(0, 157) + "...";
            }
        }

        Date scheduledDate = null;
        if (!scheduledDateStr.isEmpty()) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                scheduledDate = sdf.parse(scheduledDateStr);
            } catch (Exception e) {
                try {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                    scheduledDate = sdf.parse(scheduledDateStr);
                } catch (Exception ex) {}
            }
        }

        User currentUser = getCurrentUser(request);
        boolean isEdit = !newsId.isEmpty();
        News news = null;
        boolean success = false;

        if (isEdit) {
            news = newsDAO.findById(newsId);
            if (news != null && news.getAuthor().equals(currentUser.getId())) {
                // Chặn sửa bài viết nếu đã xuất bản hoặc đang lên lịch
                boolean isScheduled = news.getScheduledDate() != null && news.getScheduledDate().after(new Date());
                boolean isPublished = news.getStatus() == 1;
                if (!isScheduled && !isPublished) {
                    news.setTitle(title);
                    news.setContent(content);
                    news.setCategoryId(categoryId);
                    news.setSubCategory(subCategory);
                    news.setStatus(3); // Auto-save mặc định lưu dưới dạng bản nháp (status = 3)
                    news.setSummary(summary);
                    news.setMetaTitle(metaTitle);
                    news.setMetaDescription(metaDescription);
                    news.setSlug(slug);
                    news.setScheduledDate(scheduledDate);
                    news.setLastModified(new Date());
                    success = newsDAO.update(news);
                }
            }
        } else {
            news = new News();
            news.setId("NEWS" + System.currentTimeMillis());
            news.setTitle(title);
            news.setContent(content);
            news.setCategoryId(categoryId);
            news.setSubCategory(subCategory);
            news.setAuthor(currentUser.getId());
            news.setPostedDate(new Date());
            news.setViewCount(0);
            news.setHome(false);
            news.setStatus(3); // Bản nháp
            news.setSummary(summary);
            news.setMetaTitle(metaTitle);
            news.setMetaDescription(metaDescription);
            news.setSlug(slug);
            news.setScheduledDate(scheduledDate);
            news.setLastModified(new Date());
            success = newsDAO.insert(news);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format("{\"success\": %b, \"id\": \"%s\"}", success, news != null ? news.getId() : ""));
    }

    /**
     * // FIX: Hiển thị giao diện quản lý bình luận cho phóng viên (RQ46)
     */
    private void showCommentsManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = getCurrentUser(request);
        List<Comment> commentList = commentDAO.findByAuthor(currentUser.getId());
        request.setAttribute("commentList", commentList);
        forward(request, response, "/WEB-INF/views/reporter/news/comments.jsp");
    }

    /**
     * // FIX: Xử lý bật/tắt ghim bình luận bảo mật (RQ46)
     */
    private void togglePinComment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = getCurrentUser(request);
        int commentId = 0;
        try {
            commentId = Integer.parseInt(getParameter(request, "commentId", "0"));
        } catch (NumberFormatException e) {}
        boolean pin = Boolean.parseBoolean(getParameter(request, "pin", "false"));

        boolean success = commentDAO.updatePinStatusByAuthor(commentId, pin, currentUser.getId());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format("{\"success\": %b}", success));
    }

    /**
     * // FIX: Xử lý bật/tắt ẩn bình luận bảo mật (RQ46)
     */
    private void toggleHideComment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = getCurrentUser(request);
        int commentId = 0;
        try {
            commentId = Integer.parseInt(getParameter(request, "commentId", "0"));
        } catch (NumberFormatException e) {}
        boolean hide = Boolean.parseBoolean(getParameter(request, "hide", "false"));

        boolean success = commentDAO.updateHiddenStatusByAuthor(commentId, hide, currentUser.getId());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format("{\"success\": %b}", success));
    }

    /**
     * // FIX: Xử lý nhà báo trả lời bình luận (RQ46)
     */
    private void replyCommentByAuthor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = getCurrentUser(request);
        int parentId = 0;
        try {
            parentId = Integer.parseInt(getParameter(request, "parentId", "0"));
        } catch (NumberFormatException e) {}
        String newsId = getParameter(request, "newsId", "");
        String content = getParameter(request, "content", "");

        if (content.trim().isEmpty() || newsId.isEmpty() || parentId == 0) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin hoặc nội dung trống\"}");
            return;
        }

        // Kiểm tra xem bài viết có đúng của phóng viên đang đăng nhập hay không
        News news = newsDAO.findById(newsId);
        if (news == null || !news.getAuthor().equals(currentUser.getId())) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Không có quyền phản hồi bài viết này!\"}");
            return;
        }

        Comment reply = new Comment();
        reply.setNewsId(newsId);
        reply.setUserId(currentUser.getId());
        reply.setContent(content.trim());
        reply.setCreatedDate(new Date());
        reply.setParentId(parentId);

        boolean success = commentDAO.insertReply(reply);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format("{\"success\": %b}", success));
    }

    /**
     * // FIX: Hiển thị giao diện Thống kê bài viết (Analytics) cho phóng viên (RQ48)
     */
    private void showAnalytics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = getCurrentUser(request);
        String authorId = currentUser.getId();

        // Lấy thống kê chung
        java.util.Map<String, Object> stats = newsDAO.getAuthorStats(authorId);
        request.setAttribute("totalArticles", stats.get("totalArticles"));
        request.setAttribute("totalViews", stats.get("totalViews"));
        request.setAttribute("totalComments", stats.get("totalComments"));

        // Lấy top 5 bài viết xem nhiều nhất
        List<News> topViews = newsDAO.findTopViewsByAuthor(authorId, 5);
        request.setAttribute("topViews", topViews);

        // Lấy top 5 bài viết thảo luận nhiều nhất
        List<java.util.Map<String, Object>> topComments = newsDAO.findTopCommentsByAuthor(authorId, 5);
        request.setAttribute("topComments", topComments);

        forward(request, response, "/WEB-INF/views/reporter/news/analytics.jsp");
    }
}
