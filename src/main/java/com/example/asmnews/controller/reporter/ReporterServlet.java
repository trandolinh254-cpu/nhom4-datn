package com.example.asmnews.controller.reporter;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.entity.news.Category;
import com.example.asmnews.entity.news.News;
import com.example.asmnews.repository.news.CategoryDAO;
import com.example.asmnews.repository.news.NewsDAO;
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
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong ReporterServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Có lỗi xảy ra khi xử lý yêu cầu");
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
                case "/news/delete":
                    deleteNews(request, response);
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

        // Phóng viên: Chỉ đếm và xem tin tức của chính mình
        int totalItems = newsDAO.countByAuthor(currentUser.getId());
        newsList = newsDAO.findByAuthorWithPagination(currentUser.getId(), offset, limit);

        int totalPages = (int) Math.ceil((double) totalItems / limit);

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
            redirect(response, request.getContextPath() + "/reporter/news/add");
            return;
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
            news.setTitle(title);
            news.setContent(content);
            news.setImage(fileName);
            news.setCategoryId(categoryId);
            news.setSubCategory(subCategory);
            // Giữ nguyên trạng thái (Status) hoặc bạn có thể reset về 0 (Chờ duyệt) nếu sửa nội dung.
            // Ở đây giữ nguyên như cũ hoặc reset tuỳ yêu cầu (hiện tại mình để nguyên để tránh phức tạp)
            news.setStatus(0); // Sửa là về Chờ duyệt
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
            news.setStatus(0); // Chờ duyệt
        }

        boolean success = isEdit ? newsDAO.update(news) : newsDAO.insert(news);

        if (success) {
            setSuccessMessage(request, isEdit ? "Cập nhật tin tức thành công!" : "Thêm tin tức thành công, vui lòng chờ duyệt!");
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
}
