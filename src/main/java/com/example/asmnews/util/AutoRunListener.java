package com.example.asmnews.util;






import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

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
