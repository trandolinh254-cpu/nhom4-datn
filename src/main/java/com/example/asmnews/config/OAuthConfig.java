package com.example.asmnews.config;

/**
 * Lớp cấu hình lưu trữ thông tin Client ID và Client Secret cho Google và Facebook.
 * Cung cấp các thông tin kết nối OAuth 2.0 phục vụ cho đăng nhập/đăng ký.
 */
public class OAuthConfig {

    // Singleton instance để truy cập cấu hình tập trung
    private static final OAuthConfig INSTANCE = new OAuthConfig();

    // Thông tin cấu hình Google OAuth (Hãy thay thế bằng thông tin thực tế của bạn)
    private String googleClientId = "299301177626-tjapad9cm3ngdp13o6madrmcfjvodie4.apps.googleusercontent.com";
    private String googleClientSecret = "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";
    
    // Thông tin cấu hình Facebook OAuth (Hãy thay thế bằng thông tin thực tế của bạn)
    private String facebookClientId = "1410450107785934";
    private String facebookClientSecret = "d5a77430ad482b53e586ed9325d2b1c1";

    /**
     * Constructor mặc định
     */
    public OAuthConfig() {
    }

    /**
     * Lấy instance duy nhất của OAuthConfig
     * @return OAuthConfig instance
     */
    public static OAuthConfig getInstance() {
        return INSTANCE;
    }

    public String getGoogleClientId() {
        return googleClientId;
    }

    public void setGoogleClientId(String googleClientId) {
        this.googleClientId = googleClientId;
    }

    public String getGoogleClientSecret() {
        return googleClientSecret;
    }

    public void setGoogleClientSecret(String googleClientSecret) {
        this.googleClientSecret = googleClientSecret;
    }

    public String getFacebookClientId() {
        return facebookClientId;
    }

    public void setFacebookClientId(String facebookClientId) {
        this.facebookClientId = facebookClientId;
    }

    public String getFacebookClientSecret() {
        return facebookClientSecret;
    }

    public void setFacebookClientSecret(String facebookClientSecret) {
        this.facebookClientSecret = facebookClientSecret;
    }
}
