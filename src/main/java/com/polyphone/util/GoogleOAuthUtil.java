package com.polyphone.util;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.UUID;

/**
 * Google OAuth2 Authorization Code Flow
 * Tài liệu: https://developers.google.com/identity/protocols/oauth2/web-server
 *
 * Cấu hình tại Google Cloud Console:
 *  1. Vào https://console.cloud.google.com/apis/credentials
 *  2. Tạo "OAuth 2.0 Client ID" → loại "Web application"
 *  3. Thêm Authorized redirect URI: http://localhost:8080/PolyPhone/auth/google/callback
 *  4. Copy Client ID và Client Secret vào config.properties
 */
public class GoogleOAuthUtil {

    private static final String AUTH_URL     = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String TOKEN_URL    = "https://oauth2.googleapis.com/token";
    private static final String USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";
    private static final String SCOPE        = "openid email profile";

    private static String CLIENT_ID;
    private static String CLIENT_SECRET;
    private static String REDIRECT_URI;

    static {
        try (InputStream is = GoogleOAuthUtil.class.getClassLoader()
                .getResourceAsStream("config.properties")) {
            Properties props = new Properties();
            props.load(is);
            CLIENT_ID     = props.getProperty("google.client.id");
            CLIENT_SECRET = props.getProperty("google.client.secret");
            REDIRECT_URI  = props.getProperty("google.redirect.uri");
        } catch (IOException e) {
            throw new RuntimeException("Không thể tải Google OAuth config", e);
        }
    }

    /**
     * Tạo URL redirect đến Google để xác thực.
     * state parameter chống CSRF attack.
     */
    public static String buildAuthorizationUrl(String state) {
        return AUTH_URL + "?" +
                "response_type=code" +
                "&client_id=" + urlEncode(CLIENT_ID) +
                "&redirect_uri=" + urlEncode(REDIRECT_URI) +
                "&scope=" + urlEncode(SCOPE) +
                "&state=" + urlEncode(state) +
                "&access_type=offline" +
                "&prompt=select_account";
    }

    /**
     * Đổi authorization code lấy access token.
     * Trả về JsonObject chứa access_token, id_token, ...
     */
    public static JsonObject exchangeCodeForToken(String code) throws IOException {
        String params = "code="          + urlEncode(code)
                + "&client_id="          + urlEncode(CLIENT_ID)
                + "&client_secret="      + urlEncode(CLIENT_SECRET)
                + "&redirect_uri="       + urlEncode(REDIRECT_URI)
                + "&grant_type=authorization_code";

        HttpURLConnection conn = (HttpURLConnection) new URL(TOKEN_URL).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes(StandardCharsets.UTF_8));
        }

        return readResponse(conn);
    }

    /**
     * Dùng access_token để lấy thông tin user từ Google:
     * { sub, name, email, picture, email_verified, ... }
     */
    public static GoogleUserInfo getUserInfo(String accessToken) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(USERINFO_URL).openConnection();
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        JsonObject json = readResponse(conn);

        GoogleUserInfo info = new GoogleUserInfo();
        info.setGoogleId(json.get("sub").getAsString());
        info.setEmail(json.get("email").getAsString());
        info.setName(json.get("name").getAsString());
        info.setAvatarUrl(json.has("picture") ? json.get("picture").getAsString() : null);
        info.setEmailVerified(json.has("email_verified") && json.get("email_verified").getAsBoolean());
        return info;
    }

    /** Sinh random state string để chống CSRF */
    public static String generateState() {
        return UUID.randomUUID().toString();
    }

    // ─── helpers ───────────────────────────────────────────

    private static JsonObject readResponse(HttpURLConnection conn) throws IOException {
        int status = conn.getResponseCode();
        InputStream stream = (status >= 400) ? conn.getErrorStream() : conn.getInputStream();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return JsonParser.parseString(sb.toString()).getAsJsonObject();
        }
    }

    private static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    // ─── Inner DTO ──────────────────────────────────────────

    public static class GoogleUserInfo {
        private String googleId;
        private String email;
        private String name;
        private String avatarUrl;
        private boolean emailVerified;

        public String getGoogleId()     { return googleId; }
        public void setGoogleId(String v){ this.googleId = v; }
        public String getEmail()        { return email; }
        public void setEmail(String v)  { this.email = v; }
        public String getName()         { return name; }
        public void setName(String v)   { this.name = v; }
        public String getAvatarUrl()    { return avatarUrl; }
        public void setAvatarUrl(String v){ this.avatarUrl = v; }
        public boolean isEmailVerified(){ return emailVerified; }
        public void setEmailVerified(boolean v){ this.emailVerified = v; }
    }
}
