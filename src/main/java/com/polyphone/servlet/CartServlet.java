package com.polyphone.servlet;

import com.polyphone.dao.*;
import com.polyphone.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/customer/cart", "/customer/cart/add",
        "/customer/cart/update", "/customer/cart/remove"})
public class CartServlet extends HttpServlet {

    private final GioHangDAO ghDAO = new GioHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        List<GioHang> items = ghDAO.findByUserId(user.getUserId());
        BigDecimal tongTien = items.stream()
                .map(GioHang::getThanhTien)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        req.setAttribute("cartItems", items);
        req.setAttribute("tongTien",  tongTien);
        req.getRequestDispatcher("/WEB-INF/views/customer/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        String path = req.getServletPath();
        switch (path) {
            case "/customer/cart/add"    -> doAdd(req, resp, user);
            case "/customer/cart/update" -> doUpdate(req, resp, user);
            case "/customer/cart/remove" -> doRemove(req, resp, user);
            default -> resp.sendRedirect(req.getContextPath() + "/customer/cart");
        }
    }

    private void doAdd(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        int sanPhamId = Integer.parseInt(req.getParameter("sanPhamId"));
        int soLuong   = Integer.parseInt(req.getParameter("soLuong"));
        ghDAO.them(user.getUserId(), sanPhamId, soLuong);
        resp.sendRedirect(req.getContextPath() + "/customer/cart");
    }

    private void doUpdate(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        int sanPhamId = Integer.parseInt(req.getParameter("sanPhamId"));
        int soLuong   = Integer.parseInt(req.getParameter("soLuong"));
        ghDAO.capNhatSoLuong(user.getUserId(), sanPhamId, soLuong);
        resp.sendRedirect(req.getContextPath() + "/customer/cart");
    }

    private void doRemove(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        int sanPhamId = Integer.parseInt(req.getParameter("sanPhamId"));
        ghDAO.xoa(user.getUserId(), sanPhamId);
        resp.sendRedirect(req.getContextPath() + "/customer/cart");
    }
}
