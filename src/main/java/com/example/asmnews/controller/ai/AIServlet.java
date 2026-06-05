package com.example.asmnews.controller.ai;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.repository.auth.UserDAO;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AIServlet", urlPatterns = { "/ai/summarize", "/ai/translate" })
public class AIServlet extends BaseServlet {

    private static final String API_KEY = "AQ.Ab8RN6J6VWZDnnsHIEX6_yi8UYHG7dm7CBf7JIJf9qXtWVM5VA";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key="
            + API_KEY;
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Vui lòng đăng nhập để sử dụng tính năng này.\"}");
            return;
        }

        String path = request.getServletPath();

        // Đọc body từ request
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        JsonObject requestBody = JsonParser.parseString(sb.toString()).getAsJsonObject();
        String textToProcess = requestBody.has("text") ? requestBody.get("text").getAsString() : "";

        if (textToProcess.isEmpty()) {
            response.getWriter().write("{\"error\": \"Văn bản không được để trống.\"}");
            return;
        }

        String prompt = "";

        if ("/ai/summarize".equals(path)) {
            // Xử lý tóm tắt
            if (!currentUser.isPremium()) {
                // Kiểm tra và trừ lượt tóm tắt
                if (!userDAO.decrementFreeSummaryCount(currentUser.getId())) {
                    // Trả về JSON lỗi với HTTP status 200 để tránh Tomcat tự động ghi đè HTML
                    response.getWriter()
                            .write("{\"error\": \"Bạn đã hết lượt tóm tắt miễn phí. Vui lòng nâng cấp Premium!\"}");
                    return;
                }
                // Cập nhật session sau khi trừ lượt
                currentUser.setFreeSummaryCount(currentUser.getFreeSummaryCount() - 1);
                request.getSession().setAttribute("currentUser", currentUser);
            }
            prompt = "Hãy tóm tắt ngắn gọn đoạn văn bản báo chí sau bằng tiếng Việt trong khoảng 2-3 câu. Chỉ trả về kết quả tóm tắt:\n\n"
                    + textToProcess;

        } else if ("/ai/translate".equals(path)) {
            // Xử lý dịch thuật
            if (!currentUser.isPremium()) {
                // Trả về JSON lỗi với HTTP status 200 để tránh Tomcat tự động ghi đè HTML
                response.getWriter().write("{\"error\": \"Chức năng dịch thuật chỉ dành cho tài khoản Premium!\"}");
                return;
            }
            prompt = "Nếu đoạn văn bản sau là tiếng Việt, hãy dịch toàn bộ sang tiếng Anh. Nếu là ngôn ngữ khác, hãy dịch toàn bộ sang tiếng Việt. Chỉ trả về kết quả dịch, không giải thích, không cắt bớt nội dung:\n\n"
                    + textToProcess;
        }

        try {
            String resultText;
            try {
                if ("/ai/summarize".equals(path)) {
                    // Tóm tắt vẫn dùng Gemini AI vì cần tư duy tóm tắt
                    resultText = callGeminiAPI(prompt);
                } else {
                    // Dịch thuật chuyển sang dùng Google Translate API siêu tốc
                    resultText = callGoogleTranslateAPI(textToProcess);
                }
            } catch (Exception apiEx) {
                System.err.println("API gap loi: " + apiEx.getMessage());
                // Chế độ dự phòng (Mock)
                if ("/ai/summarize".equals(path)) {
                    // Tự động chuyển sang thuật toán trích xuất câu (Extractive Summarization)
                    resultText = extractSummary(textToProcess);
                } else {
                    resultText = "Hệ thống Dịch thuật đang quá tải hoặc phản hồi chậm. Vui lòng thử lại sau giây lát.";
                }
            }

            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("result", resultText);

            // Nếu là tóm tắt và không phải premium, gửi kèm số lượt còn lại
            if ("/ai/summarize".equals(path) && !currentUser.isPremium()) {
                jsonResponse.addProperty("freeSummaryLeft", currentUser.getFreeSummaryCount());
            }

            response.getWriter().write(gson.toJson(jsonResponse));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Có lỗi xảy ra trong quá trình xử lý AI.\"}");
        }
    }

    private String callGeminiAPI(String prompt) throws IOException {
        URL url = new URL(GEMINI_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setConnectTimeout(60000); // Tăng lên 60 giây chờ kết nối
        conn.setReadTimeout(60000); // Tăng lên 60 giây chờ AI phản hồi
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // Tạo JSON cho Gemini
        JsonObject content = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject part = new JsonObject();
        part.addProperty("text", prompt);
        parts.add(part);
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject requestBody = new JsonObject();
        requestBody.add("contents", contents);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
            }

            // Parse response từ Gemini
            JsonObject jsonResponse = JsonParser.parseString(response.toString()).getAsJsonObject();
            return jsonResponse.getAsJsonArray("candidates")
                    .get(0).getAsJsonObject()
                    .getAsJsonObject("content")
                    .getAsJsonArray("parts")
                    .get(0).getAsJsonObject()
                    .get("text").getAsString();
        } else {
            // Read error
            StringBuilder err = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    err.append(responseLine.trim());
                }
            }
            System.err.println("Gemini API Error: " + err.toString());
            throw new IOException("Failed to call Gemini API: HTTP " + responseCode);
        }
    }

    /**
     * Gọi Google Translate API (Không cần API Key) siêu tốc
     */
    private String callGoogleTranslateAPI(String text) throws IOException {
        // Nhận diện tiếng Việt cơ bản bằng Regular Expression
        boolean isVietnamese = text.matches(".*[áàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ].*");
        String targetLang = isVietnamese ? "en" : "vi"; // Có dấu TV -> Dịch sang Anh. Ngược lại -> Việt
        
        String urlStr = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" + targetLang + "&dt=t&q=" + java.net.URLEncoder.encode(text, "UTF-8");
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(10000); // Tăng lên 10 giây
        conn.setReadTimeout(15000); // Tăng lên 15 giây
        
        if (conn.getResponseCode() == 200) {
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }
            
            // JSON Google Translate trả về mảng lồng nhau: [[[ "Dịch", "Gốc", ... ]]]
            JsonArray jsonArray = JsonParser.parseString(response.toString()).getAsJsonArray();
            JsonArray segments = jsonArray.get(0).getAsJsonArray();
            StringBuilder translatedText = new StringBuilder();
            for (int i = 0; i < segments.size(); i++) {
                translatedText.append(segments.get(i).getAsJsonArray().get(0).getAsString());
            }
            return translatedText.toString();
        } else {
            throw new IOException("Google Translate API Error: HTTP " + conn.getResponseCode());
        }
    }

    /**
     * Thuật toán Tóm tắt Trích xuất (Extractive Summarization) nội bộ
     * Sử dụng khi API Key AI bị lỗi. Lấy 2 câu đầu tiên (chuẩn Inverted Pyramid của báo chí).
     */
    private String extractSummary(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "Không có nội dung để tóm tắt.";
        }
        // Tách câu dựa trên dấu chấm, hỏi, than
        String[] sentences = text.split("(?<=[.?!])\\s+");
        StringBuilder summary = new StringBuilder();
        int maxSentences = Math.min(2, sentences.length);
        for (int i = 0; i < maxSentences; i++) {
            summary.append(sentences[i].trim()).append(" ");
        }
        
        String result = summary.toString().trim();
        return "[Tóm tắt nhanh]: " + (result.isEmpty() ? text : result);
    }
}
