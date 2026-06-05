package com.example.asmnews;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class RefactorTool {
    static String rootPath = "c:/Users/Acer Nitro 5/Downloads/Asm-new-main/Asm-new-main";
    static String basePath = rootPath + "/src/main/java/com/example/asmnews";
    static String webappPath = rootPath + "/src/main/webapp/WEB-INF/views";

    public static void main(String[] args) throws IOException {
        System.out.println("=== BAT DAU TAI CAU TRUC DU AN ===");

        // 1. CHUYỂN JSP FILES
        System.out.println("1. Di chuyen JSP files...");
        moveJsp("public/index.jsp", "home/index.jsp");
        moveJsp("public/news-detail.jsp", "news/news-detail.jsp");
        moveJsp("public/news-list.jsp", "news/news-list.jsp");
        moveJsp("public/my-news.jsp", "news/my-news.jsp");
        moveJsp("public/order.jsp", "order/order.jsp");
        moveJsp("public/premium.jsp", "order/premium.jsp");
        moveJsp("public/profile.jsp", "auth/profile.jsp");
        moveFile(webappPath + "/login.jsp", webappPath + "/auth/login.jsp");
        moveFile(webappPath + "/register.jsp", webappPath + "/auth/register.jsp");

        // 2. ĐỔI TÊN THƯ MỤC ROOT
        System.out.println("2. Doi ten thu muc dao, servlet, utils...");
        renameDir("dao", "repository");
        renameDir("servlet", "controller");
        renameDir("utils", "util");

        // 3. DI CHUYỂN JAVA FILES
        System.out.println("3. Di chuyen Java files vao package chuc nang...");
        // Controllers
        moveJava("controller/LoginServlet.java", "controller/auth/LoginServlet.java");
        moveJava("controller/RegisterServlet.java", "controller/auth/RegisterServlet.java");
        moveJava("controller/ProfileServlet.java", "controller/auth/ProfileServlet.java");
        moveJava("controller/ChangePasswordServlet.java", "controller/auth/ChangePasswordServlet.java");
        moveJava("controller/ForgotPasswordServlet.java", "controller/auth/ForgotPasswordServlet.java");

        moveJava("controller/NewsServlet.java", "controller/news/NewsServlet.java");
        moveJava("controller/CommentServlet.java", "controller/news/CommentServlet.java");
        moveJava("controller/ReactionServlet.java", "controller/news/ReactionServlet.java");
        moveJava("controller/MyNewsServlet.java", "controller/news/MyNewsServlet.java");

        moveJava("controller/OrderServlet.java", "controller/order/OrderServlet.java");
        moveJava("controller/PremiumServlet.java", "controller/order/PremiumServlet.java");
        moveJava("controller/NewsletterServlet.java", "controller/order/NewsletterServlet.java");

        moveJava("controller/AdminServlet.java", "controller/admin/AdminServlet.java");
        moveJava("controller/AdminCommentServlet.java", "controller/admin/AdminCommentServlet.java");

        moveJava("controller/HomeServlet.java", "controller/common/HomeServlet.java");
        moveJava("controller/BaseServlet.java", "controller/common/BaseServlet.java");
        moveJava("controller/UploadServlet.java", "controller/common/UploadServlet.java");
        moveJava("controller/ImageUploadServlet.java", "controller/common/ImageUploadServlet.java");

        // Repositories
        moveJava("repository/UserDAO.java", "repository/auth/UserDAO.java");
        moveJava("repository/NewsDAO.java", "repository/news/NewsDAO.java");
        moveJava("repository/CategoryDAO.java", "repository/news/CategoryDAO.java");
        moveJava("repository/commentDAO.java", "repository/news/commentDAO.java");
        moveJava("repository/ReactionDAO.java", "repository/news/ReactionDAO.java");
        moveJava("repository/OrderDAO.java", "repository/order/OrderDAO.java");
        moveJava("repository/NewsletterDAO.java", "repository/order/NewsletterDAO.java");

        // Entities
        moveJava("entity/User.java", "entity/auth/User.java");
        moveJava("entity/News.java", "entity/news/News.java");
        moveJava("entity/Category.java", "entity/news/Category.java");
        moveJava("entity/Comment.java", "entity/news/Comment.java");
        moveJava("entity/Order.java", "entity/order/Order.java");
        moveJava("entity/Newsletter.java", "entity/order/Newsletter.java");

        // 4. CẬP NHẬT PACKAGE & IMPORTS
        System.out.println("4. Cap nhat imports va request dispatcher...");
        updateAllFileContents();

        System.out.println("=== TAI CAU TRUC HOAN TAT ===");
        System.out.println("Vui long Refresh (F5) project trong IDE cua ban.");
    }

    private static void moveJsp(String oldSub, String newSub) {
        moveFile(webappPath + "/" + oldSub, webappPath + "/" + newSub);
    }

    private static void moveJava(String oldSub, String newSub) {
        moveFile(basePath + "/" + oldSub, basePath + "/" + newSub);
    }

    private static void renameDir(String oldName, String newName) {
        Path oldPath = Paths.get(basePath, oldName);
        Path newPath = Paths.get(basePath, newName);
        try {
            if (Files.exists(oldPath)) {
                Files.move(oldPath, newPath, StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (Exception e) {
            System.err.println("Loi doi ten: " + oldPath + " -> " + newPath);
        }
    }

    private static void moveFile(String oldPathStr, String newPathStr) {
        Path oldPath = Paths.get(oldPathStr);
        Path newPath = Paths.get(newPathStr);
        if (Files.exists(oldPath)) {
            try {
                Files.createDirectories(newPath.getParent());
                Files.move(oldPath, newPath, StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                System.err.println("Loi di chuyen: " + oldPath);
            }
        }
    }

    private static void updateAllFileContents() throws IOException {
        // Build replacements map
        Map<String, String> replacements = new LinkedHashMap<>();
        
        // Java Package & Imports
        replacements.put("com.example.asmnews.util.", "com.example.asmnews.util.");
        
        replacements.put("com.example.asmnews.entity.auth.User", "com.example.asmnews.entity.auth.User");
        replacements.put("com.example.asmnews.entity.news.News", "com.example.asmnews.entity.news.News");
        replacements.put("com.example.asmnews.entity.news.Category", "com.example.asmnews.entity.news.Category");
        replacements.put("com.example.asmnews.entity.news.Comment", "com.example.asmnews.entity.news.Comment");
        replacements.put("com.example.asmnews.entity.order.Order", "com.example.asmnews.entity.order.Order");
        replacements.put("com.example.asmnews.entity.order.Newsletter", "com.example.asmnews.entity.order.Newsletter");
        
        replacements.put("com.example.asmnews.repository.", "com.example.asmnews.repository.");
        replacements.put("com.example.asmnews.repository.auth.UserDAO", "com.example.asmnews.repository.auth.UserDAO");
        replacements.put("com.example.asmnews.repository.news.NewsDAO", "com.example.asmnews.repository.news.NewsDAO");
        replacements.put("com.example.asmnews.repository.news.CategoryDAO", "com.example.asmnews.repository.news.CategoryDAO");
        replacements.put("com.example.asmnews.repository.news.commentDAO", "com.example.asmnews.repository.news.commentDAO");
        replacements.put("com.example.asmnews.repository.news.ReactionDAO", "com.example.asmnews.repository.news.ReactionDAO");
        replacements.put("com.example.asmnews.repository.order.OrderDAO", "com.example.asmnews.repository.order.OrderDAO");
        replacements.put("com.example.asmnews.repository.order.NewsletterDAO", "com.example.asmnews.repository.order.NewsletterDAO");

        replacements.put("com.example.asmnews.controller.common.BaseServlet", "com.example.asmnews.controller.common.BaseServlet");
        
        // Cập nhật câu lệnh package trong từng file
        replacements.put("package com.example.asmnews.entity.TEMP;", "package com.example.asmnews.entity.TEMP;");
        replacements.put("package com.example.asmnews.repository.TEMP;", "package com.example.asmnews.repository.TEMP;");
        replacements.put("package com.example.asmnews.controller.TEMP;", "package com.example.asmnews.controller.TEMP;");
        replacements.put("package com.example.asmnews.util;", "package com.example.asmnews.util;");

        // JSP paths in RequestDispatcher
        replacements.put("page=\"components/", "page=\"../public/components/");
        replacements.put("/WEB-INF/views/home/index.jsp", "/WEB-INF/views/home/index.jsp");
        replacements.put("/WEB-INF/views/news/news-detail.jsp", "/WEB-INF/views/news/news-detail.jsp");
        replacements.put("/WEB-INF/views/news/news-list.jsp", "/WEB-INF/views/news/news-list.jsp");
        replacements.put("/WEB-INF/views/news/my-news.jsp", "/WEB-INF/views/news/my-news.jsp");
        replacements.put("/WEB-INF/views/order/order.jsp", "/WEB-INF/views/order/order.jsp");
        replacements.put("/WEB-INF/views/order/premium.jsp", "/WEB-INF/views/order/premium.jsp");
        replacements.put("/WEB-INF/views/auth/profile.jsp", "/WEB-INF/views/auth/profile.jsp");
        replacements.put("/WEB-INF/views/auth/login.jsp", "/WEB-INF/views/auth/login.jsp");
        replacements.put("/WEB-INF/views/auth/register.jsp", "/WEB-INF/views/auth/register.jsp");

        // Lặp qua tất cả file .java và .jsp
        Files.walk(Paths.get(rootPath + "/src/main"))
            .filter(p -> Files.isRegularFile(p) && (p.toString().endsWith(".java") || p.toString().endsWith(".jsp")))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    boolean changed = false;
                    
                    for (Map.Entry<String, String> entry : replacements.entrySet()) {
                        if (content.contains(entry.getKey())) {
                            content = content.replace(entry.getKey(), entry.getValue());
                            changed = true;
                        }
                    }
                    
                    // Fix package statement for subfolders manually based on path
                    if (p.toString().endsWith(".java")) {
                        String pathStr = p.toString().replace("\\", "/");
                        if (pathStr.contains("/controller/auth/")) content = content.replace("package com.example.asmnews.controller.TEMP;", "package com.example.asmnews.controller.auth;");
                        else if (pathStr.contains("/controller/news/")) content = content.replace("package com.example.asmnews.controller.TEMP;", "package com.example.asmnews.controller.news;");
                        else if (pathStr.contains("/controller/order/")) content = content.replace("package com.example.asmnews.controller.TEMP;", "package com.example.asmnews.controller.order;");
                        else if (pathStr.contains("/controller/admin/")) content = content.replace("package com.example.asmnews.controller.TEMP;", "package com.example.asmnews.controller.admin;");
                        else if (pathStr.contains("/controller/common/")) content = content.replace("package com.example.asmnews.controller.TEMP;", "package com.example.asmnews.controller.common;");
                        
                        if (pathStr.contains("/repository/auth/")) content = content.replace("package com.example.asmnews.repository.TEMP;", "package com.example.asmnews.repository.auth;");
                        else if (pathStr.contains("/repository/news/")) content = content.replace("package com.example.asmnews.repository.TEMP;", "package com.example.asmnews.repository.news;");
                        else if (pathStr.contains("/repository/order/")) content = content.replace("package com.example.asmnews.repository.TEMP;", "package com.example.asmnews.repository.order;");
                        
                        if (pathStr.contains("/entity/auth/")) content = content.replace("package com.example.asmnews.entity.TEMP;", "package com.example.asmnews.entity.auth;");
                        else if (pathStr.contains("/entity/news/")) content = content.replace("package com.example.asmnews.entity.TEMP;", "package com.example.asmnews.entity.news;");
                        else if (pathStr.contains("/entity/order/")) content = content.replace("package com.example.asmnews.entity.TEMP;", "package com.example.asmnews.entity.order;");
                    }
                    
                    if (changed || content.contains("TEMP;")) {
                        Files.write(p, content.getBytes(StandardCharsets.UTF_8));
                    }
                } catch (IOException e) {
                    System.err.println("Loi xu ly file: " + p);
                }
            });
    }
}
