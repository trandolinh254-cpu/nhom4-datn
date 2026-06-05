package com.example.asmnews.controller.auth;

import com.example.asmnews.config.OAuthConfig;
import com.example.asmnews.controller.common.BaseServlet;
import com.example.asmnews.entity.auth.User;
import com.example.asmnews.repository.auth.UserDAO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

/**
 * Servlet xử lý đăng nhập và đăng ký tự động bằng Facebook OAuth 2.0.
 */
@WebServlet("/login-facebook")
public class FacebookLoginServlet extends BaseServlet {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Constructor mặc định
     */
    public FacebookLoginServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy mã code hoặc lỗi do Facebook gửi về sau màn hình Consent
        String code = request.getParameter("code");
        String error = request.getParameter("error");

        // Xử lý nếu người dùng từ chối cấp quyền
        if (error != null) {
            request.setAttribute("errorMessage", "Từ chối quyền truy cập Facebook: " + request.getParameter("error_description"));
            forward(request, response, "/WEB-INF/views/auth/login.jsp");
            return;
        }

        OAuthConfig config = OAuthConfig.getInstance();
        String clientId = config.getFacebookClientId();
        String clientSecret = config.getFacebookClientSecret();

        // Kiểm tra cấu hình Client ID
        if (clientId == null || clientId.trim().isEmpty() || clientId.contains("YOUR_")) {
            request.setAttribute("errorMessage", "Facebook App ID chưa được cấu hình. Vui lòng thiết lập Client ID trong OAuthConfig.java!");
            forward(request, response, "/WEB-INF/views/auth/login.jsp");
            return;
        }

        // Redirect URI động dựa trên URL hiện tại
        String redirectUri = request.getRequestURL().toString();

        if (code == null || code.trim().isEmpty()) {
            // Chuyển hướng người dùng tới Facebook OAuth 2.0 để xác thực
            String fbAuthUrl = "https://www.facebook.com/v18.0/dialog/oauth"
                    + "?client_id=" + clientId
                    + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                    + "&response_type=code"
                    + "&scope=" + URLEncoder.encode("email,public_profile", StandardCharsets.UTF_8);
            redirect(response, fbAuthUrl);
        } else {
            // Xử lý callback khi đã có Auth Code
            try {
                HttpClient client = HttpClient.newHttpClient();

                // 1. Gửi request GET đổi code lấy Access Token
                String tokenUrl = "https://graph.facebook.com/v18.0/oauth/access_token"
                        + "?client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8)
                        + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                        + "&client_secret=" + URLEncoder.encode(clientSecret, StandardCharsets.UTF_8)
                        + "&code=" + URLEncoder.encode(code, StandardCharsets.UTF_8);

                HttpRequest tokenRequest = HttpRequest.newBuilder()
                        .uri(URI.create(tokenUrl))
                        .GET()
                        .build();

                HttpResponse<String> tokenResponse = client.send(tokenRequest, HttpResponse.BodyHandlers.ofString());

                if (tokenResponse.statusCode() != 200) {
                    throw new IOException("Lỗi khi lấy access token từ Facebook: " + tokenResponse.body());
                }

                Gson gson = new Gson();
                JsonObject jsonToken = gson.fromJson(tokenResponse.body(), JsonObject.class);
                String accessToken = jsonToken.get("access_token").getAsString();

                // 2. Sử dụng access_token để lấy thông tin user từ Facebook Graph API
                String userInfoUrl = "https://graph.facebook.com/me?fields=id,name,email,picture.type(large)&access_token=" + accessToken;
                HttpRequest userRequest = HttpRequest.newBuilder()
                        .uri(URI.create(userInfoUrl))
                        .GET()
                        .build();

                HttpResponse<String> userResponse = client.send(userRequest, HttpResponse.BodyHandlers.ofString());

                if (userResponse.statusCode() != 200) {
                    throw new IOException("Lỗi khi lấy thông tin user từ Facebook: " + userResponse.body());
                }

                JsonObject jsonUser = gson.fromJson(userResponse.body(), JsonObject.class);
                String fbId = jsonUser.get("id").getAsString();
                String name = jsonUser.has("name") ? jsonUser.get("name").getAsString() : "Facebook User";
                
                // Facebook cho phép đăng ký bằng sđt nên email có thể null, ta sẽ sinh email ảo nếu cần
                String email = jsonUser.has("email") ? jsonUser.get("email").getAsString() : fbId + "@facebook.com";

                // Parse Avatar URL từ cấu trúc lồng nhau của Facebook JSON
                String picture = null;
                if (jsonUser.has("picture")) {
                    JsonObject pictureObj = jsonUser.getAsJsonObject("picture");
                    if (pictureObj.has("data")) {
                        JsonObject dataObj = pictureObj.getAsJsonObject("data");
                        if (dataObj.has("url")) {
                            picture = dataObj.get("url").getAsString();
                        }
                    }
                }

                // 3. Logic đăng nhập/đăng ký bằng tài khoản Facebook
                User user = userDAO.findByEmail(email);

                if (user != null) {
                    // Nếu tài khoản đã tồn tại -> Kiểm tra trạng thái khóa tài khoản
                    if (!user.isActive()) {
                        request.setAttribute("errorMessage", "Tài khoản liên kết với email này đã bị khóa. Vui lòng liên hệ Admin!");
                        forward(request, response, "/WEB-INF/views/auth/login.jsp");
                        return;
                    }
                    
                    // Cập nhật Avatar mới nhất từ Facebook
                    if (picture != null && !picture.equals(user.getAvatar())) {
                        userDAO.updateAvatar(user.getId(), picture);
                        user.setAvatar(picture);
                    }
                } else {
                    // Nếu chưa tồn tại -> Tự động đăng ký mới làm Độc giả (Reader)
                    String userId = "fb_" + fbId;
                    if (userId.length() > 50) {
                        userId = userId.substring(0, 50);
                    }
                    
                    // Tránh trùng ID cục bộ
                    if (userDAO.exists(userId)) {
                        userId = "fb_" + UUID.randomUUID().toString().replace("-", "").substring(0, 20);
                    }

                    // Mật khẩu ngẫu nhiên cho user OAuth
                    String randomPassword = UUID.randomUUID().toString();
                    user = new User(userId, randomPassword, name, null, null, null, email, User.ROLE_READER);
                    
                    boolean success = userDAO.insert(user);
                    if (success) {
                        if (picture != null) {
                            userDAO.updateAvatar(userId, picture);
                            user.setAvatar(picture);
                        }
                    } else {
                        throw new Exception("Không thể đăng ký tài khoản Facebook mới vào Database.");
                    }
                }

                // 4. Đăng nhập thành công -> Lưu User vào Session và chuyển hướng về trang chủ
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30 * 60);

                setSuccessMessage(request, "Đăng nhập bằng Facebook thành công! Chào mừng " + user.getFullname());
                redirect(response, request.getContextPath() + "/");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi trong quá trình đăng nhập Facebook: " + e.getMessage());
                forward(request, response, "/WEB-INF/views/auth/login.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
