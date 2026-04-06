package com.polyphone.servlet;

import com.polyphone.dao.*;
import com.polyphone.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/customer/profile", "/customer/profile/update",
        "/customer/profile/change-password"})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        String path = req.getServletPath();
        if ("/customer/profile/update".equals(path)) {
            doUpdate(req, resp, user);
        } else if ("/customer/profile/change-password".equals(path)) {
            doChangePassword(req, resp, user);
        }
    }

    // RQ18: Cập nhật thông tin
    private void doUpdate(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        String hoTen = req.getParameter("hoTen");
        String sdt   = req.getParameter("soDienThoai");

        user.setHoTen(hoTen != null ? hoTen.trim() : user.getHoTen());
        user.setSoDienThoai(sdt != null ? sdt.trim() : user.getSoDienThoai());

        if (userDAO.capNhatThongTin(user)) {
            // Refresh session
            User updated = userDAO.findById(user.getUserId());
            req.getSession().setAttribute("loggedInUser", updated);
            req.setAttribute("success", "Cập nhật thành công!");
        } else {
            req.setAttribute("error", "Cập nhật thất bại.");
        }
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, resp);
    }

    private void doChangePassword(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        String currentPw = req.getParameter("currentPassword");
        String newPw     = req.getParameter("newPassword");
        String confirm   = req.getParameter("confirmPassword");

        if (!com.polyphone.util.PasswordUtil.checkPassword(currentPw, user.getMatKhauHash())) {
            req.setAttribute("error", "Mật khẩu hiện tại không đúng.");
        } else if (!newPw.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu mới không khớp.");
        } else if (newPw.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
        } else {
            userDAO.capNhatMatKhau(user.getUserId(), com.polyphone.util.PasswordUtil.hashPassword(newPw));
            req.setAttribute("success", "Đổi mật khẩu thành công!");
        }
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, resp);
    }
}
