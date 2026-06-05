package com.example.asmnews.controller.auth;

import com.example.asmnews.controller.common.BaseServlet;






import java.io.File;
import java.io.IOException;

import com.example.asmnews.repository.auth.UserDAO;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.repository.news.BookmarkDAO; // -- FIX
import com.example.asmnews.repository.news.ReadingHistoryDAO; // -- FIX
import com.example.asmnews.repository.order.NewsletterDAO; // -- FIX
import com.example.asmnews.entity.news.News; // -- FIX
import java.util.List; // -- FIX
import com.example.asmnews.repository.news.FollowDAO; // -- FIX

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
@WebServlet("/profile")
public class ProfileServlet extends BaseServlet {

    private UserDAO userDAO = new UserDAO();
    private BookmarkDAO bookmarkDAO = new BookmarkDAO(); // -- FIX
    private ReadingHistoryDAO readingHistoryDAO = new ReadingHistoryDAO(); // -- FIX
    private NewsletterDAO newsletterDAO = new NewsletterDAO(); // -- FIX
    private FollowDAO followDAO = new FollowDAO(); // -- FIX

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            redirect(response, request.getContextPath() + "/login");
            return;
        }
        User currentUser = getCurrentUser(request); // -- FIX
        String email = currentUser.getEmail(); // -- FIX

        // Nạp các dữ liệu bổ sung cho Độc giả -- FIX
        boolean isSubscribed = email != null && newsletterDAO.isActive(email); // -- FIX
        List<News> bookmarks = bookmarkDAO.findByUserId(currentUser.getId()); // -- FIX
        List<News> history = readingHistoryDAO.findByUserId(currentUser.getId()); // -- FIX
        List<User> followingAuthors = followDAO.getFollowingAuthors(currentUser.getId()); // -- FIX

        request.setAttribute("isSubscribedNewsletter", isSubscribed); // -- FIX
        request.setAttribute("bookmarkList", bookmarks); // -- FIX
        request.setAttribute("readingHistoryList", history); // -- FIX
        request.setAttribute("followingAuthorsList", followingAuthors); // -- FIX

        forward(request, response, "/WEB-INF/views/auth/profile.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            redirect(response, request.getContextPath() + "/login");
            return;
        }

        User currentUser = getCurrentUser(request);
        String action = getParameter(request, "action", "");

        try {
            if ("updateProfile".equals(action)) {
                // Đọc thông tin cá nhân từ form
                String fullname = getParameter(request, "fullname", "").trim();
                String email = getParameter(request, "email", "").trim();
                String mobile = getParameter(request, "mobile", "").trim();
                String genderStr = getParameter(request, "gender", "true");
                String birthdayStr = getParameter(request, "birthday", "");
                String penName = getParameter(request, "penName", "").trim();
                String bio = getParameter(request, "bio", "").trim();

                if (!fullname.isEmpty()) {
                    currentUser.setFullname(fullname);
                }
                if (!email.isEmpty()) {
                    currentUser.setEmail(email);
                }
                currentUser.setMobile(mobile.isEmpty() ? null : mobile);
                currentUser.setGender(Boolean.parseBoolean(genderStr));

                if (!birthdayStr.isEmpty()) {
                    try {
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                        currentUser.setBirthday(sdf.parse(birthdayStr));
                    } catch (Exception e) {
                        // Bỏ qua nếu lỗi định dạng ngày
                    }
                }

                // Cập nhật Bút danh và Tiểu sử cho Nhà báo / Admin
                if (currentUser.isReporter() || currentUser.isAdmin()) {
                    currentUser.setPenName(penName.isEmpty() ? null : penName);
                    currentUser.setBio(bio.isEmpty() ? null : bio);
                }

                // Thực hiện lưu vào database
                if (userDAO.update(currentUser)) {
                    request.getSession().setAttribute("currentUser", currentUser);
                    setSuccessMessage(request, "Cập nhật thông tin cá nhân thành công!");
                } else {
                    setErrorMessage(request, "Không thể cập nhật thông tin trong cơ sở dữ liệu!");
                }
            } else {
                // Xử lý upload avatar (khi bấm chọn ảnh avatar)
                Part filePart = request.getPart("avatar");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = "AVT_" + currentUser.getId() + "_" + filePart.getSubmittedFileName();

                    String savePath = request.getServletContext().getRealPath("") + File.separator + "images";
                    File fileSaveDir = new File(savePath);
                    if (!fileSaveDir.exists())
                        fileSaveDir.mkdir();

                    filePart.write(savePath + File.separator + fileName);

                    // Cập nhật DB
                    if (userDAO.updateAvatar(currentUser.getId(), fileName)) {
                        currentUser.setAvatar(fileName);
                        request.getSession().setAttribute("currentUser", currentUser);
                        setSuccessMessage(request, "Cập nhật ảnh đại diện thành công!");
                    } else {
                        setErrorMessage(request, "Lỗi cập nhật ảnh đại diện trong CSDL!");
                    }
                }
            }
        } catch (Exception e) {
            setErrorMessage(request, "Lỗi xử lý hồ sơ: " + e.getMessage());
        }

        redirect(response, request.getContextPath() + "/profile");
    }
}
