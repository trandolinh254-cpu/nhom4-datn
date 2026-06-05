package com.example.asmnews.controller.auth;

import com.example.asmnews.controller.common.BaseServlet;






import java.io.File;
import java.io.IOException;

import com.example.asmnews.repository.auth.UserDAO;
import com.example.asmnews.entity.auth.User;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            redirect(response, request.getContextPath() + "/login");
            return;
        }
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

        try {
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
                    // Cập nhật lại Session để UI đổi ảnh ngay lập tức
                    currentUser.setAvatar(fileName);
                    request.getSession().setAttribute("currentUser", currentUser);
                    setSuccessMessage(request, "Cập nhật ảnh đại diện thành công!");
                } else {
                    setErrorMessage(request, "Lỗi cập nhật CSDL!");
                }
            }
        } catch (Exception e) {
            setErrorMessage(request, "Lỗi xử lý file: " + e.getMessage());
        }

        redirect(response, request.getContextPath() + "/profile");
    }
}
