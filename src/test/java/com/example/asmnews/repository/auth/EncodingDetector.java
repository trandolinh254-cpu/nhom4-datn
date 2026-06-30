package com.example.asmnews.repository.auth;

import org.testng.annotations.Test;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

public class EncodingDetector {

    @Test
    public void detectAndFix() throws IOException {
        Path root = Paths.get("").toAbsolutePath().resolve("src/main/webapp/WEB-INF/views");
        System.out.println("=== KIEM TRA MA HOA CHI TIET ===");
        
        Path forgot = root.resolve("auth/forgot-password.jsp");
        if (Files.exists(forgot)) {
            byte[] bytes = Files.readAllBytes(forgot);
            // Thu cac loai encoding pho bien
            String[] charsets = {"UTF-8", "Windows-1258", "ISO-8859-1", "UTF-16"};
            for (String csName : charsets) {
                try {
                    Charset cs = Charset.forName(csName);
                    String decoded = new String(bytes, cs);
                    if (decoded.contains("Khôi phục") || decoded.contains("đăng ký") || decoded.contains("đăng ký") || decoded.contains("Lấy mã")) {
                        System.out.println("SUCCESS! Encoding dung la: " + csName);
                        return;
                    }
                    // In thu mot doan ngan de mat nguoi doc xem co doc duoc chu nao khong
                    int len = Math.min(decoded.length(), 200);
                    System.out.println("[" + csName + "] " + decoded.substring(0, len).replace("\n", " "));
                } catch (Exception e) {
                    System.out.println("[" + csName + "] loi: " + e.getMessage());
                }
            }
        }
    }
}
