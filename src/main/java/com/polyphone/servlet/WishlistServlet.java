package com.polyphone.servlet;

import com.polyphone.dao.*;
import com.polyphone.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/customer/wishlist", "/customer/wishlist/toggle"})
public class WishlistServlet extends HttpServlet {

    private final YeuThichDAO ytDAO = new YeuThichDAO();
    private final SanPhamDAO spDAO  = new SanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        List<Integer> ids = ytDAO.getSanPhamIds(user.getUserId());
        List<SanPham> products = ids.stream()
                .map(spDAO::findById)
                .filter(sp -> sp != null && sp.isDangBan())
                .toList();
        req.setAttribute("wishlist", products);
        req.getRequestDispatcher("/WEB-INF/views/customer/wishlist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        int sanPhamId = Integer.parseInt(req.getParameter("sanPhamId"));
        String action  = req.getParameter("action"); // add | remove

        if ("remove".equals(action)) {
            ytDAO.xoa(user.getUserId(), sanPhamId);
        } else {
            ytDAO.them(user.getUserId(), sanPhamId);
        }

        String referer = req.getHeader("Referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/customer/wishlist");
    }
}
