package com.example.asmnews;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.HashMap;
import java.util.Map;

public class ReplaceSidebarTool {
    public static void main(String[] args) throws IOException {
        String basePath = "c:/Users/Acer Nitro 5/Downloads/Asm-new-main/Asm-new-main/src/main/webapp/WEB-INF/views/admin";
        
        Map<String, String> filesToMenu = new HashMap<>();
        filesToMenu.put("dashboard.jsp", "dashboard");
        filesToMenu.put("news-management.jsp", "news");
        filesToMenu.put("category-management.jsp", "categories");
        filesToMenu.put("user-management.jsp", "users");
        filesToMenu.put("comment-management.jsp", "comments");
        filesToMenu.put("newsletter-management.jsp", "newsletters");
        // news-form.jsp might have it but usually it belongs to "news" menu
        filesToMenu.put("news-form.jsp", "news");

        for (Map.Entry<String, String> entry : filesToMenu.entrySet()) {
            Path filePath = Paths.get(basePath, entry.getKey());
            if (!Files.exists(filePath)) continue;

            String content = new String(Files.readAllBytes(filePath), StandardCharsets.UTF_8);

            // Regex to find the <div class="col-md-3 col-lg-2 px-0 sidebar position-ed"> ... </div>
            // This is tricky with regex. Let's just find the start and end.
            int startIdx = content.indexOf("<div class=\"col-md-3 col-lg-2 px-0 sidebar position-ed\">");
            if (startIdx == -1) {
                // Thử không có position-ed (trong dashboard)
                startIdx = content.indexOf("<div class=\"col-md-3 col-lg-2 px-0 sidebar");
            }
            if (startIdx == -1) continue;

            // Tìm endIdx: là thẻ </div> đóng thẻ <div class="col-md-3... ms-auto main-content">
            // Thẻ main-content thường nằm ngay sau đó
            int endIdx = content.indexOf("<div class=\"col-md-9 col-lg-10 ms-auto main-content\">");
            if (endIdx == -1) continue;

            String replacement = "<jsp:include page=\"/WEB-INF/views/admin/components/admin-sidebar.jsp\">\n" +
                                 "                <jsp:param name=\"activeMenu\" value=\"" + entry.getValue() + "\" />\n" +
                                 "            </jsp:include>\n\n            ";

            String newContent = content.substring(0, startIdx) + replacement + content.substring(endIdx);
            Files.write(filePath, newContent.getBytes(StandardCharsets.UTF_8));
            System.out.println("Replaced sidebar in " + entry.getKey());
        }
    }
}
