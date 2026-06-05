package com.example.asmnews.controller.common;






import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet để serve ảnh từ thư mục D:/news-uploads
 * URL pattern: /upload/*
 * Ví dụ: /upload/sport1.jpg
 */
@WebServlet("/upload/*")
public class ImageUploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tên file từ path info (bỏ dấu / đầu)
        String fileName = request.getPathInfo();
        if (fileName == null || fileName.length() <= 1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not specified");
            return;
        }

        // Bỏ dấu / đầu tiên
        fileName = fileName.substring(1);

        // Tạo đường dẫn file đầy đủ từ webapp directory
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File file = new File(uploadPath, fileName);

        // Kiểm tra file có tồn tại không
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found: " + fileName);
            return;
        }

        // Xác định MIME type
        String mimeType = getServletContext().getMimeType(file.getAbsolutePath());
        if (mimeType == null) {
            // Fallback cho các file không có MIME type
            String extension = fileName.toLowerCase();
            if (extension.endsWith(".jpg") || extension.endsWith(".jpeg")) {
                mimeType = "image/jpeg";
            } else if (extension.endsWith(".png")) {
                mimeType = "image/png";
            } else if (extension.endsWith(".gif")) {
                mimeType = "image/gif";
            } else if (extension.endsWith(".svg")) {
                mimeType = "image/svg+xml";
            } else {
                mimeType = "application/octet-stream";
            }
        }

        // Set response headers
        response.setContentType(mimeType);
        response.setContentLengthLong(file.length());
        response.setHeader("Cache-Control", "public, max-age=31536000"); // Cache 1 năm

        // Stream file content
        try (FileInputStream inputStream = new FileInputStream(file);
                OutputStream outputStream = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            outputStream.flush();
        }
    }
}
