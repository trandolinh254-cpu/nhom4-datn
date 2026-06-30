package com.example.asmnews.repository.auth;

import org.testng.annotations.Test;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

public class EncodingFixTest {

    @Test
    public void fixEncoding() throws IOException {
        Path root = Paths.get("").toAbsolutePath().resolve("src/main/webapp/WEB-INF/views");
        System.out.println("=== BAT DAU SUA LOI MA HOA TIENG VIET JPS ===");
        System.out.println("Thu muc views: " + root);
        
        Files.walk(root)
            .filter(p -> p.toString().endsWith(".jsp"))
            .forEach(p -> {
                try {
                    // Doc file duoi dang UTF-8
                    String content = Files.readString(p, StandardCharsets.UTF_8);
                    
                    // Kiem tra xem co chua cac ky tu loi ma hoa dac trung
                    if (content.contains("Ã") || content.contains("Ä") || content.contains("á»") || content.contains("quáº£")) {
                        System.out.println("-> Dang sua file: " + p.getFileName());
                        
                        // Giai ma (mojibake decoder)
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        for (int i = 0; i < content.length(); i++) {
                            char c = content.charAt(i);
                            if (c <= 255) {
                                baos.write((byte) c);
                            } else {
                                baos.write(String.valueOf(c).getBytes(StandardCharsets.UTF_8));
                            }
                        }
                        String fixedContent = new String(baos.toByteArray(), StandardCharsets.UTF_8);
                        
                        // Ghi de lai file voi encoding dung
                        Files.writeString(p, fixedContent, StandardCharsets.UTF_8);
                    }
                } catch (Exception e) {
                    System.err.println("Loi khi sua file " + p + ": " + e.getMessage());
                }
            });
            
        System.out.println("=== DA SUA XONG TOAN BO LOI MA HOA TIENG VIET ===");
    }
}
