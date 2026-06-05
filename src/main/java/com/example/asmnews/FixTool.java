package com.example.asmnews;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

public class FixTool {
    public static void main(String[] args) throws IOException {
        System.out.println("=== BAT DAU FIX LOI IMPORT SAI VI TRI ===");
        String rootPath = "c:/Users/Acer Nitro 5/Downloads/Asm-new-main/Asm-new-main";
        Path srcPath = Paths.get(rootPath + "/src/main/java/com/example/asmnews");

        Files.walk(srcPath)
            .filter(p -> p.toString().endsWith(".java") && !p.toString().endsWith("RefactorTool.java") && !p.toString().endsWith("FixTool.java"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    
                    // Xóa dòng import cũ bị chèn sai chỗ (dưới @WebServlet)
                    content = content.replace("import com.example.asmnews.controller.common.BaseServlet;\r\n", "");
                    content = content.replace("import com.example.asmnews.controller.common.BaseServlet;\n", "");
                    
                    String[] lines = content.split("\n");
                    StringBuilder newContent = new StringBuilder();
                    
                    for (String line : lines) {
                        // Thêm lại dòng vào StringBuilder
                        if (line.endsWith("\r")) {
                            newContent.append(line).append("\n");
                        } else {
                            newContent.append(line).append("\r\n");
                        }
                        
                        // Nếu là dòng package, chèn ngay dòng import hợp lệ xuống bên dưới
                        if (line.trim().startsWith("package ")) {
                            // Chỉ chèn import BaseServlet cho các thư mục con của controller (ngoại trừ common)
                            if (line.contains(".controller.") && !line.contains(".common;")) {
                                newContent.append("\r\nimport com.example.asmnews.controller.common.BaseServlet;\r\n");
                            }
                        }
                    }
                    
                    Files.write(p, newContent.toString().getBytes(StandardCharsets.UTF_8));
                } catch (Exception e) {
                    System.err.println("Lỗi file: " + p);
                }
            });
            
        System.out.println("=== DA FIX XONG VI TRI IMPORT ===");
        System.out.println("Ban vui long Refresh (F5) lai project nhe!");
    }
}
