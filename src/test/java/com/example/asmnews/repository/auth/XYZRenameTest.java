package com.example.asmnews.repository.auth;

import org.testng.annotations.Test;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

public class XYZRenameTest {

    @Test
    public void renameXYZ() throws IOException {
        Path root = Paths.get("").toAbsolutePath();
        System.out.println("=== BAT DAU DOI TEN XYZ -> DONG CHAY ===");
        
        // 1. Quét và thay thế trong src/main/webapp (các file jsp, html, js, css)
        Files.walk(root.resolve("src/main/webapp"))
            .filter(p -> Files.isRegularFile(p))
            .filter(p -> p.toString().endsWith(".jsp") || p.toString().endsWith(".html") || p.toString().endsWith(".js") || p.toString().endsWith(".css"))
            .forEach(p -> {
                try {
                    String content = Files.readString(p, StandardCharsets.UTF_8);
                    boolean modified = false;
                    
                    if (content.contains("XYZ NEWS") || content.contains("XYZ News") || content.contains("XYZ REPORTER") || content.contains("XYZ ADMIN") || content.contains("XYZ SYSTEM") || content.contains("XYZ System") || content.contains("xyznews.vn") || content.contains("xyz_theme")) {
                        System.out.println("Sua file: " + p.getFileName());
                        
                        // Thay thế text
                        content = content.replace("XYZ NEWS", "DÒNG CHẢY TIN TỨC");
                        content = content.replace("XYZ News", "Dòng Chảy Tin Tức");
                        content = content.replace("XYZ REPORTER", "DÒNG CHẢY REPORTER");
                        content = content.replace("XYZ Reporter", "Dòng Chảy Reporter");
                        content = content.replace("XYZ ADMIN", "DÒNG CHẢY ADMIN");
                        content = content.replace("XYZ SYSTEM", "DÒNG CHẢY SYSTEM");
                        content = content.replace("XYZ System", "Dòng Chảy System");
                        content = content.replace("xyznews.vn", "dongchaytintuc.vn");
                        content = content.replace("xyz_theme", "dongchay_theme");
                        content = content.replace("XYZ INTERNAL", "DÒNG CHẢY INTERNAL");
                        content = content.replace("XYZ News Internal System", "Hệ thống nội bộ Dòng Chảy Tin Tức");
                        
                        modified = true;
                    }
                    
                    // Đặc biệt xử lý logo trong header.jsp để dùng PNG
                    if (p.getFileName().toString().equals("header.jsp")) {
                        String targetLogo = "<a href=\"${pageContext.request.contextPath}/\" class=\"text-4xl font-serif font-black text-gray-900 tracking-tighter hover:text-primary transition no-underline flex items-center gap-2\" style=\"color: #006389 !important;\">\r\n" +
                                            "            <i class=\"fas fa-newspaper text-[32px]\"></i> DÒNG CHẢY TIN TỨC\r\n" +
                                            "        </a>";
                        String newLogo = "<a href=\"${pageContext.request.contextPath}/\" class=\"hover:opacity-90 transition no-underline flex items-center\" style=\"height: 80px;\">\r\n" +
                                         "            <img src=\"${pageContext.request.contextPath}/images/logo.png\" alt=\"Dòng Chảy Tin Tức\" class=\"h-full object-contain\" id=\"logoImg\" />\r\n" +
                                         "        </a>";
                        
                        // Trường hợp không có \r\n (dùng \n)
                        String targetLogoLF = targetLogo.replace("\r\n", "\n");
                        String newLogoLF = newLogo.replace("\r\n", "\n");
                        
                        if (content.contains(targetLogo)) {
                            content = content.replace(targetLogo, newLogo);
                            modified = true;
                        } else if (content.contains(targetLogoLF)) {
                            content = content.replace(targetLogoLF, newLogoLF);
                            modified = true;
                        }
                        
                        // Cập nhật script thu nhỏ logo cho thẻ img
                        content = content.replace("logoSection.querySelector('i').classList.add('text-[20px]');", "logoSection.querySelector('img').style.height = '45px';");
                        content = content.replace("logoSection.querySelector('i').classList.remove('text-[32px]');", "");
                        content = content.replace("logoSection.querySelector('i').classList.remove('text-[20px]');", "");
                        content = content.replace("logoSection.querySelector('i').classList.add('text-[32px]');", "logoSection.querySelector('img').style.height = '80px';");
                        content = content.replace("logoSection.querySelector('a').classList.add('text-2xl');", "");
                        content = content.replace("logoSection.querySelector('a').classList.remove('text-4xl');", "");
                        content = content.replace("logoSection.querySelector('a').classList.remove('text-2xl');", "");
                        content = content.replace("logoSection.querySelector('a').classList.add('text-4xl');", "");
                    }
                    
                    if (modified) {
                        Files.writeString(p, content, StandardCharsets.UTF_8);
                    }
                } catch (Exception e) {
                    System.err.println("Loi file: " + p + " - " + e.getMessage());
                }
            });
            
        // 2. Quét và thay thế trong src/main/java (mã nguồn Java)
        Files.walk(root.resolve("src/main/java"))
            .filter(p -> Files.isRegularFile(p) && p.toString().endsWith(".java"))
            .forEach(p -> {
                try {
                    String content = Files.readString(p, StandardCharsets.UTF_8);
                    if (content.contains("XYZ") || content.contains("xyz")) {
                        System.out.println("Sua file Java: " + p.getFileName());
                        content = content.replace("XYZ NEWS", "DÒNG CHẢY TIN TỨC");
                        content = content.replace("XYZ News", "Dòng Chảy Tin Tức");
                        content = content.replace("XYZ REPORTER", "DÒNG CHẢY REPORTER");
                        content = content.replace("XYZ ADMIN", "DÒNG CHẢY ADMIN");
                        content = content.replace("toasoan@xyznews.vn", "toasoan@dongchaytintuc.vn");
                        content = content.replace("quangcao@xyznews.vn", "quangcao@dongchaytintuc.vn");
                        Files.writeString(p, content, StandardCharsets.UTF_8);
                    }
                } catch (Exception e) {
                    System.err.println("Loi file Java: " + p + " - " + e.getMessage());
                }
            });

        // 3. Thay thế trong sql
        Path sqlPath = root.resolve("asm_news_final.sql");
        if (Files.exists(sqlPath)) {
            System.out.println("Sua file SQL...");
            String content = Files.readString(sqlPath, StandardCharsets.UTF_8);
            content = content.replace("XYZ NEWS", "DÒNG CHẢY TIN TỨC");
            content = content.replace("XYZ News", "Dòng Chảy Tin Tức");
            content = content.replace("toasoan@xyznews.vn", "toasoan@dongchaytintuc.vn");
            content = content.replace("quangcao@xyznews.vn", "quangcao@dongchaytintuc.vn");
            Files.writeString(sqlPath, content, StandardCharsets.UTF_8);
        }

        System.out.println("=== HOAN THANH DOI TEN ===");
    }
}
