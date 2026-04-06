package com.polyphone.servlet;

import com.polyphone.dao.UserDAO;
import com.polyphone.model.User;
import com.polyphone.util.GoogleOAuthUtil;
import com.polyphone.util.GoogleOAuthUtil.GoogleUserInfo;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Google OAuth2 Servlet
 *
 * Flow:
 *  1. User click "Đăng nhập với Google"
 *  2. GET /auth/google  → redirect đến Google consent screen
 *  3. Google redirect về GET /auth/google/callback?code=...&state=...
 *  4. Exchange code → access_token → lấy user info → tạo/login session
 */
@WebServlet(urlPatterns = {"/auth/google", "/auth/google/callback"})
public class GoogleAuthServlet extends HttpServlet {

    private static final String SESSION_OAUTH_STATE = "oauth_state";
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/auth/google".equals(path)) {
            initiateOAuth(req, resp);
        } else if ("/auth/google/callback".equals(path)) {
            handleCallback(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    // ── Bước 1: Redirect đến Google ──────────────────────────────────────
    private void initiateOAuth(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // Sinh state ngẫu nhiên để chống CSRF
        String state = GoogleOAuthUtil.generateState();
        req.getSession(true).setAttribute(SESSION_OAUTH_STATE, state);

        // Lưu redirect URL gốc nếu có (ví dụ: user vào /customer/cart → login → quay lại cart)
        String redirect = req.getParameter("redirect");
        if (redirect != null && !redirect.isBlank()) {
            req.getSession().setAttribute("loginRedirect", redirect);
        }

        String authUrl = GoogleOAuthUtil.buildAuthorizationUrl(state);
        resp.sendRedirect(authUrl);
    }

    // ── Bước 2: Google gọi callback ──────────────────────────────────────
    private void handleCallback(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String code    = req.getParameter("code");
        String state   = req.getParameter("state");
        String errorP  = req.getParameter("error");
        HttpSession session = req.getSession(false);

        // Xử lý nếu user hủy đăng nhập Google
        if ("access_denied".equals(errorP)) {
            resp.sendRedirect(req.getContextPath() + "/auth/login?error=google_denied");
            return;
        }

        // Kiểm tra state chống CSRF
        String expectedState = (session != null)
                ? (String) session.getAttribute(SESSION_OAUTH_STATE) : null;

        if (expectedState == null || !expectedState.equals(state)) {
            req.setAttribute("error", "Phiên đăng nhập không hợp lệ. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            return;
        }

        // Code không hợp lệ
        if (code == null || code.isBlank()) {
            req.setAttribute("error", "Đăng nhập Google thất bại. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            return;
        }

        try {
            // Đổi code lấy access_token
            JsonObject tokenResponse = GoogleOAuthUtil.exchangeCodeForToken(code);

            if (tokenResponse.has("error")) {
                String errDesc = tokenResponse.has("error_description")
                        ? tokenResponse.get("error_description").getAsString()
                        : tokenResponse.get("error").getAsString();
                req.setAttribute("error", "Lỗi xác thực Google: " + errDesc);
                req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
                return;
            }

            String accessToken = tokenResponse.get("access_token").getAsString();

            // Lấy thông tin user từ Google
            GoogleUserInfo googleUser = GoogleOAuthUtil.getUserInfo(accessToken);

            if (!googleUser.isEmailVerified()) {
                req.setAttribute("error", "Tài khoản Google chưa xác thực email.");
                req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
                return;
            }

            // Tìm hoặc tạo User trong DB
            User user = userDAO.loginOrRegisterByGoogle(
                    googleUser.getGoogleId(),
                    googleUser.getEmail(),
                    googleUser.getName(),
                    googleUser.getAvatarUrl()
            );

            if (user == null) {
                req.setAttribute("error", "Không thể tạo tài khoản từ Google. Vui lòng thử lại.");
                req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
                return;
            }

            // Kiểm tra tài khoản bị khóa / blacklist
            if (!user.isDangHoatDong() || user.isTrongBlacklist()) {
                req.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ hỗ trợ.");
                req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
                return;
            }

            // Tạo session đăng nhập
            session = req.getSession(true);
            session.invalidate();                          // regenerate session id (security)
            session = req.getSession(true);
            session.setAttribute("loggedInUser", user);
            session.setMaxInactiveInterval(60 * 60);      // 1 giờ

            // Xóa state đã dùng
            session.removeAttribute(SESSION_OAUTH_STATE);

            // Redirect về trang ban đầu hoặc theo role
            String loginRedirect = (String) session.getAttribute("loginRedirect");
            session.removeAttribute("loginRedirect");

            if (loginRedirect != null && !loginRedirect.isBlank()
                    && loginRedirect.startsWith(req.getContextPath())) {
                resp.sendRedirect(loginRedirect);
            } else {
                resp.sendRedirect(switch (user.getRole()) {
                    case "admin" -> req.getContextPath() + "/admin/dashboard";
                    case "staff" -> req.getContextPath() + "/staff/orders";
                    default      -> req.getContextPath() + "/";
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi khi đăng nhập Google. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
        }
    }
}
