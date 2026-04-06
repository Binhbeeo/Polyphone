package com.polyphone.servlet;

import com.polyphone.dao.*;
import com.polyphone.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/staff/orders", "/staff/orders/detail", "/staff/orders/update-status",
        "/staff/complaints", "/staff/complaints/detail", "/staff/complaints/respond",
        "/staff/profile"
})
public class StaffServlet extends HttpServlet {

    private final DonHangDAO dhDAO = new DonHangDAO();
    private final KhieuNaiDAO knDAO = new KhieuNaiDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/staff/orders"            -> showOrders(req, resp);
            case "/staff/orders/detail"     -> showOrderDetail(req, resp);
            case "/staff/complaints"        -> showComplaints(req, resp);
            case "/staff/complaints/detail" -> showComplaintDetail(req, resp);
            case "/staff/profile"           -> showProfile(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/staff/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/staff/orders/update-status"  -> doUpdateStatus(req, resp);
            case "/staff/complaints/respond"    -> doRespond(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/staff/orders");
        }
    }

    // RQ36: Xem đơn hàng
    private void showOrders(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String trangThai = req.getParameter("trangThai");
        List<DonHang> orders = (trangThai != null && !trangThai.isBlank())
                ? dhDAO.findByTrangThai(trangThai) : dhDAO.findAll();
        req.setAttribute("orders", orders);
        req.setAttribute("trangThai", trangThai);
        req.getRequestDispatcher("/WEB-INF/views/staff/orders.jsp").forward(req, resp);
    }

    private void showOrderDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DonHang dh = dhDAO.findById(Integer.parseInt(req.getParameter("id")));
        req.setAttribute("order", dh);
        req.getRequestDispatcher("/WEB-INF/views/staff/order-detail.jsp").forward(req, resp);
    }

    // RQ37: Cập nhật trạng thái đơn
    private void doUpdateStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User staff = (User) req.getSession().getAttribute("loggedInUser");
        int donHangId = Integer.parseInt(req.getParameter("id"));
        String trangThai = req.getParameter("trangThai");
        dhDAO.capNhatTrangThai(donHangId, trangThai, staff.getUserId());
        resp.sendRedirect(req.getContextPath() + "/staff/orders/detail?id=" + donHangId);
    }

    // RQ38: Xử lý khiếu nại
    private void showComplaints(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("complaints", knDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/staff/complaints.jsp").forward(req, resp);
    }

    private void showComplaintDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("complaint", knDAO.findById(Integer.parseInt(req.getParameter("id"))));
        req.getRequestDispatcher("/WEB-INF/views/staff/complaint-detail.jsp").forward(req, resp);
    }

    private void doRespond(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User staff = (User) req.getSession().getAttribute("loggedInUser");
        int id = Integer.parseInt(req.getParameter("id"));
        knDAO.xuLy(id, req.getParameter("phanHoi"), staff.getUserId(), "da_xu_ly");
        resp.sendRedirect(req.getContextPath() + "/staff/complaints/detail?id=" + id);
    }

    private void showProfile(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User staff = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("user", staff);
        req.getRequestDispatcher("/WEB-INF/views/staff/profile.jsp").forward(req, resp);
    }
}
