package com.polyphone.servlet;

import com.polyphone.dao.UserDAO;
import com.polyphone.model.User;
import com.polyphone.util.EmailUtil;
import com.polyphone.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/auth/login", "/auth/logout", "/auth/register",
        "/auth/forgot-password", "/auth/verify-otp", "/auth/reset-password"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    // In-memory OTP store: email -> {otp, expiry}
    private static final Map<String, long[]> otpStore = new HashMap<>();

    // ===================== GET =====================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/auth/login"          -> req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            case "/auth/register"       -> req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            case "/auth/forgot-password"-> req.getRequestDispatcher("/WEB-INF/views/common/forgot-password.jsp").forward(req, resp);
            case "/auth/verify-otp"     -> req.getRequestDispatcher("/WEB-INF/views/common/verify-otp.jsp").forward(req, resp);
            case "/auth/reset-password" -> req.getRequestDispatcher("/WEB-INF/views/common/reset-password.jsp").forward(req, resp);
            case "/auth/logout"         -> doLogout(req, resp);
            default                     -> resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    // ===================== POST =====================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/auth/login"           -> doLogin(req, resp);
            case "/auth/register"        -> doRegister(req, resp);
            case "/auth/forgot-password" -> doForgotPassword(req, resp);
            case "/auth/verify-otp"      -> doVerifyOtp(req, resp);
            case "/auth/reset-password"  -> doResetPassword(req, resp);
            default                      -> resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    // ──────────────────── RQ20: Đăng nhập ────────────────────
    private void doLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String loginInput = req.getParameter("loginInput");
        String password   = req.getParameter("password");

        if (loginInput == null || loginInput.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findByEmailOrPhone(loginInput.trim());
        if (user == null || !PasswordUtil.checkPassword(password, user.getMatKhauHash())) {
            req.setAttribute("error", "Email/SĐT hoặc mật khẩu không đúng.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            return;
        }
        if (!user.isDangHoatDong() || user.isTrongBlacklist()) {
            req.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ hỗ trợ.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            return;
        }

        // Tạo session
        HttpSession session = req.getSession(true);
        session.setAttribute("loggedInUser", user);
        session.setMaxInactiveInterval(60 * 60); // 1 giờ

        // Redirect theo role
        String redirect = req.getParameter("redirect");
        if (redirect != null && !redirect.isBlank() && redirect.startsWith(req.getContextPath())) {
            resp.sendRedirect(redirect);
        } else {
            resp.sendRedirect(switch (user.getRole()) {
                case "admin" -> req.getContextPath() + "/admin/dashboard";
                case "staff" -> req.getContextPath() + "/staff/orders";
                default      -> req.getContextPath() + "/";
            });
        }
    }

    // ──────────────────── RQ19: Đăng ký ────────────────────
    private void doRegister(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String hoTen      = req.getParameter("hoTen");
        String email      = req.getParameter("email");
        String sdt        = req.getParameter("soDienThoai");
        String password   = req.getParameter("password");
        String confirm    = req.getParameter("confirmPassword");

        // Validate
        if (hoTen == null || hoTen.isBlank() || email == null || email.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }
        if (userDAO.emailTonTai(email.trim())) {
            req.setAttribute("error", "Email đã được sử dụng.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }
        if (sdt != null && !sdt.isBlank() && userDAO.sdtTonTai(sdt.trim())) {
            req.setAttribute("error", "Số điện thoại đã được sử dụng.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setHoTen(hoTen.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setSoDienThoai(sdt != null ? sdt.trim() : null);
        user.setMatKhauHash(PasswordUtil.hashPassword(password));

        if (userDAO.dangKy(user)) {
            req.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
        }
    }

    // ──────────────────── RQ22: Đăng xuất ────────────────────
    private void doLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }

    // ──────────────────── RQ21: Quên mật khẩu ────────────────────
    private void doForgotPassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String input = req.getParameter("emailOrPhone");
        if (input == null || input.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập email hoặc số điện thoại.");
            req.getRequestDispatcher("/WEB-INF/views/common/forgot-password.jsp").forward(req, resp);
            return;
        }
        User user = userDAO.findByEmailOrPhone(input.trim());
        if (user == null) {
            req.setAttribute("error", "Không tìm thấy tài khoản.");
            req.getRequestDispatcher("/WEB-INF/views/common/forgot-password.jsp").forward(req, resp);
            return;
        }
        if (user.getEmail() == null) {
            req.setAttribute("error", "Tài khoản không có email để gửi OTP.");
            req.getRequestDispatcher("/WEB-INF/views/common/forgot-password.jsp").forward(req, resp);
            return;
        }

        String otp = PasswordUtil.generateOTP();
        long expiry = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút
        otpStore.put(user.getEmail(), new long[]{Long.parseLong(otp), expiry});

        try {
            EmailUtil.sendOTP(user.getEmail(), otp);
            req.getSession().setAttribute("resetEmail", user.getEmail());
            resp.sendRedirect(req.getContextPath() + "/auth/verify-otp");
        } catch (Exception e) {
            req.setAttribute("error", "Không thể gửi email. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/common/forgot-password.jsp").forward(req, resp);
        }
    }

    private void doVerifyOtp(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String email = (String) req.getSession().getAttribute("resetEmail");
        String otpInput = req.getParameter("otp");

        if (email == null || otpInput == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        long[] stored = otpStore.get(email);
        if (stored == null || System.currentTimeMillis() > stored[1]) {
            req.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/common/verify-otp.jsp").forward(req, resp);
            return;
        }
        if (!otpInput.trim().equals(String.valueOf((long) stored[0]))) {
            req.setAttribute("error", "Mã OTP không đúng.");
            req.getRequestDispatcher("/WEB-INF/views/common/verify-otp.jsp").forward(req, resp);
            return;
        }

        otpStore.remove(email);
        req.getSession().setAttribute("otpVerified", true);
        resp.sendRedirect(req.getContextPath() + "/auth/reset-password");
    }

    private void doResetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        String email = session != null ? (String) session.getAttribute("resetEmail") : null;
        Boolean verified = session != null ? (Boolean) session.getAttribute("otpVerified") : null;

        if (email == null || !Boolean.TRUE.equals(verified)) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        String newPw  = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");
        if (newPw == null || newPw.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            req.getRequestDispatcher("/WEB-INF/views/common/reset-password.jsp").forward(req, resp);
            return;
        }
        if (!newPw.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            req.getRequestDispatcher("/WEB-INF/views/common/reset-password.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findByEmailOrPhone(email);
        if (user != null && userDAO.capNhatMatKhau(user.getUserId(), PasswordUtil.hashPassword(newPw))) {
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpVerified");
            req.setAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Đặt lại mật khẩu thất bại.");
            req.getRequestDispatcher("/WEB-INF/views/common/reset-password.jsp").forward(req, resp);
        }
    }
}
