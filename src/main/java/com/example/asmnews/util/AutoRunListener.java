package com.example.asmnews.util;






import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AutoRunListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Sự kiện này tự động chạy MỘT LẦN DUY NHẤT khi bạn bật Tomcat lên
        System.out.println("=== HỆ THỐNG AUTO FETCHER ĐÃ KHỞI ĐỘNG ===");

        NewsAutoFetcher fetcher = new NewsAutoFetcher();

        // Tạo một luồng chạy ngầm
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Cài đặt lịch trình:
        // Chạy ngay lập tức lần đầu (0), sau đó lặp lại mỗi 24 Giờ (24, TimeUnit.HOURS)
        // Nếu bạn muốn test nhanh, hãy đổi 24, TimeUnit.HOURS thành 1, TimeUnit.MINUTES
        // (Chạy mỗi 1 phút)
        // scheduler.scheduleAtedRate(() -> {
        // fetcher.fetchAndSaveNews();
        // }, 0, 1, TimeUnit.HOURS);

        // // FIX: Quét và tự động xuất bản các tin tức đã đến giờ lên lịch (chạy mỗi 1 phút)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                publishScheduledNews();
            } catch (Exception e) {
                System.err.println("[Scheduled Publisher] Lỗi khi chạy tác vụ quét xuất bản: " + e.getMessage());
            }
        }, 5, 60, TimeUnit.SECONDS);
    }

    /**
     * // FIX: Quét và cập nhật trạng thái bài viết đã đến giờ xuất bản từ "Chờ duyệt" hoặc "Nháp" sang "Đã xuất bản/Đã duyệt" (Status = 1)
     */
    private void publishScheduledNews() {
        String sql = "UPDATE News SET Status = 1 WHERE Status IN (0, 3, 4) AND ScheduledDate IS NOT NULL AND ScheduledDate <= NOW()";
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int updatedRows = ps.executeUpdate();
            if (updatedRows > 0) {
                System.out.println("[Scheduled Publisher] Đã tự động xuất bản " + updatedRows + " bài viết đến giờ lên lịch.");
            }
        } catch (SQLException e) {
            System.err.println("[Scheduled Publisher] Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Tắt luồng chạy ngầm khi bạn tắt Tomcat để tránh lỗi tràn bộ nhớ
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            System.out.println("=== HỆ THỐNG AUTO FETCHER ĐÃ TẮT ===");
        }
    }
}
