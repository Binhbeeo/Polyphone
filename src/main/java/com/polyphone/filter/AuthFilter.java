package com.polyphone.filter;

import com.polyphone.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter(urlPatterns = {"/customer/*", "/staff/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=" +
                    request.getRequestURI());
            return;
        }

        // Role-based access
        if (path.startsWith("/admin/") && !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/error/403");
            return;
        }
        if (path.startsWith("/staff/") && !"staff".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/error/403");
            return;
        }

        // Blacklist / bị khóa
        if (user.isTrongBlacklist() || !user.isDangHoatDong()) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/auth/login?error=account_locked");
            return;
        }

        chain.doFilter(req, res);
    }
}
