package com.example.asmnews.util;

import java.util.regex.Pattern;

/**
 * Lớp tiện ích lọc từ ngữ thô tục/nhạy cảm cho bình luận
 * Đáp ứng yêu cầu RQ14
 */
public class ProfanityFilter {
    // Danh sách từ ngữ thô tục/nhạy cảm cần lọc 
    private static final String[] SENSITIVE_WORDS = { 
        "đm", "dcm", "vcl", "clm", "cl", "ngu", "chó", "cút", "đần", "mẹ mày", "bố mày", "chửi" 
    }; 

    /**
     * Lọc các từ nhạy cảm trong nội dung bình luận
     * 
     */
    public static String filter(String input) {
        if (input == null || input.trim().isEmpty()) {
            return input;
        }
        String output = input;
        for (String word : SENSITIVE_WORDS) {
            // Thay thế không phân biệt chữ hoa chữ thường bằng regex 
            output = output.replaceAll("(?i)" + Pattern.quote(word), "***");
        }
        return output;
    }
}
