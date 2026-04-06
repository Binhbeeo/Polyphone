package com.polyphone.servlet;

import com.polyphone.dao.*;
import com.polyphone.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/customer/checkout", "/customer/orders",
        "/customer/orders/detail", "/customer/orders/cancel",
        "/customer/orders/review"})
public class OrderServlet extends HttpServlet {

    private final DonHangDAO dhDAO  = new DonHangDAO();
    private final GioHangDAO ghDAO  = new GioHangDAO();
    private final VoucherDAO vcDAO  = new VoucherDAO();
    private final DanhGiaDAO dgDAO  = new DanhGiaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        String path = req.getServletPath();
        switch (path) {
            case "/customer/checkout"      -> showCheckout(req, resp, user);
            case "/customer/orders"        -> showOrders(req, resp, user);      // RQ23
            case "/customer/orders/detail" -> showOrderDetail(req, resp, user); // RQ17
            case "/customer/orders/review" -> showReviewForm(req, resp, user);
            default -> resp.sendRedirect(req.getContextPath() + "/customer/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        String path = req.getServletPath();
        switch (path) {
            case "/customer/checkout"      -> doPlaceOrder(req, resp, user);   // RQ16
            case "/customer/orders/cancel" -> doCancelOrder(req, resp, user);
            case "/customer/orders/review" -> doSubmitReview(req, resp, user); // RQ07
            default -> resp.sendRedirect(req.getContextPath() + "/customer/orders");
        }
    }

    // RQ14/RQ15/RQ28: Trang thanh toán
    private void showCheckout(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<GioHang> items = ghDAO.findByUserId(user.getUserId());
        if (items.isEmpty()) { resp.sendRedirect(req.getContextPath() + "/customer/cart"); return; }

        BigDecimal tongTien = items.stream().map(GioHang::getThanhTien).reduce(BigDecimal.ZERO, BigDecimal::add);
        List<Voucher> vouchers = vcDAO.findHopLe();

        req.setAttribute("cartItems", items);
        req.setAttribute("tongTien",  tongTien);
        req.setAttribute("vouchers",  vouchers);
        req.setAttribute("userInfo",  user);
        req.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(req, resp);
    }

    // RQ16: Đặt hàng
    private void doPlaceOrder(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        List<GioHang> items = ghDAO.findByUserId(user.getUserId());
        if (items.isEmpty()) { resp.sendRedirect(req.getContextPath() + "/customer/cart"); return; }

        String diaChi      = req.getParameter("diaChi");
        String phuongThuc  = req.getParameter("phuongThuc"); // COD | PayOS
        String maVoucher   = req.getParameter("maVoucher");
        String ghiChu      = req.getParameter("ghiChu");
        String diemSuDungStr = req.getParameter("diemSuDung");

        BigDecimal tongTien = items.stream().map(GioHang::getThanhTien).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal tienGiamVoucher = BigDecimal.ZERO;
        Integer voucherId = null;

        // Áp voucher
        if (maVoucher != null && !maVoucher.isBlank()) {
            Voucher v = vcDAO.findByMa(maVoucher);
            if (v != null && v.isHopLe() && tongTien.compareTo(v.getDonHangToiThieu()) >= 0) {
                voucherId = v.getVoucherId();
                if ("phan_tram".equals(v.getLoaiGiam())) {
                    tienGiamVoucher = tongTien.multiply(v.getGiaTriGiam()).divide(BigDecimal.valueOf(100));
                } else {
                    tienGiamVoucher = v.getGiaTriGiam();
                }
                vcDAO.tangDaDung(voucherId);
            }
        }

        // Dùng điểm (100 điểm = 10,000đ)
        int diemSuDung = 0;
        BigDecimal tienGiamDiem = BigDecimal.ZERO;
        if (diemSuDungStr != null && !diemSuDungStr.isBlank()) {
            diemSuDung = Math.min(Integer.parseInt(diemSuDungStr), user.getDiemTichLuy());
            tienGiamDiem = BigDecimal.valueOf(diemSuDung).multiply(BigDecimal.valueOf(100));
        }

        BigDecimal thanhTien = tongTien.subtract(tienGiamVoucher).subtract(tienGiamDiem);
        if (thanhTien.compareTo(BigDecimal.ZERO) < 0) thanhTien = BigDecimal.ZERO;

        // Tính điểm được cộng: 1% của thành tiền
        int diemDuocCong = thanhTien.divide(BigDecimal.valueOf(1000)).intValue();

        DonHang dh = new DonHang();
        dh.setUserId(user.getUserId());
        dh.setDiaChi(diaChi);
        dh.setVoucherId(voucherId);
        dh.setTongTien(tongTien);
        dh.setTienGiamVoucher(tienGiamVoucher);
        dh.setDiemSuDung(diemSuDung);
        dh.setTienGiamDiem(tienGiamDiem);
        dh.setThanhTien(thanhTien);
        dh.setDiemDuocCong(diemDuocCong);
        dh.setPhuongThucTT(phuongThuc);
        dh.setGhiChu(ghiChu);

        // Chuyển giỏ hàng thành chi tiết đơn
        List<ChiTietDonHang> chiTiet = items.stream().map(gh -> {
            ChiTietDonHang ct = new ChiTietDonHang();
            ct.setSanPhamId(gh.getSanPhamId());
            ct.setSoLuong(gh.getSoLuong());
            ct.setDonGia(gh.getGia());
            return ct;
        }).toList();

        int result = dhDAO.taoDoanhHang(dh, chiTiet);
        if (result > 0) {
            // Trừ điểm đã dùng
            if (diemSuDung > 0) {
                user.setDiemTichLuy(user.getDiemTichLuy() - diemSuDung);
                new UserDAO().capNhatDiem(user.getUserId(), user.getDiemTichLuy());
                req.getSession().setAttribute("loggedInUser", new UserDAO().findById(user.getUserId()));
            }
            resp.sendRedirect(req.getContextPath() + "/customer/orders/detail?id=" + result + "&success=1");
        } else if (result == -2) {
            req.setAttribute("error", "Một số sản phẩm đã hết hàng. Vui lòng kiểm tra lại giỏ hàng.");
            showCheckout(req, resp, user);
        } else {
            req.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
            showCheckout(req, resp, user);
        }
    }

    // RQ23: Lịch sử đơn hàng
    private void showOrders(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String trangThai = req.getParameter("trangThai");
        List<DonHang> orders = dhDAO.findByUserId(user.getUserId());
        if (trangThai != null && !trangThai.isBlank()) {
            orders = orders.stream().filter(o -> trangThai.equals(o.getTrangThaiDH())).toList();
        }
        req.setAttribute("orders",     orders);
        req.setAttribute("trangThai",  trangThai);
        req.getRequestDispatcher("/WEB-INF/views/customer/orders.jsp").forward(req, resp);
    }

    // RQ17: Chi tiết đơn hàng
    private void showOrderDetail(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        Integer id = parseIntOrNull(req.getParameter("id"));
        if (id == null) { resp.sendRedirect(req.getContextPath() + "/customer/orders"); return; }

        DonHang dh = dhDAO.findById(id);
        if (dh == null || dh.getUserId() != user.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/customer/orders"); return;
        }
        req.setAttribute("order", dh);
        req.getRequestDispatcher("/WEB-INF/views/customer/order-detail.jsp").forward(req, resp);
    }

    // Hủy đơn hàng
    private void doCancelOrder(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        dhDAO.huyDonHang(id, user.getUserId());
        resp.sendRedirect(req.getContextPath() + "/customer/orders/detail?id=" + id);
    }

    // Trang đánh giá
    private void showReviewForm(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        int donHangId = Integer.parseInt(req.getParameter("donHangId"));
        DonHang dh = dhDAO.findById(donHangId);
        if (dh == null || dh.getUserId() != user.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/customer/orders"); return;
        }
        req.setAttribute("order", dh);
        req.getRequestDispatcher("/WEB-INF/views/customer/review.jsp").forward(req, resp);
    }

    // RQ07: Gửi đánh giá
    private void doSubmitReview(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        String donHangIdStr = req.getParameter("donHangId");
        String sanPhamIdStr = req.getParameter("sanPhamId");
        String soSaoStr     = req.getParameter("soSao");
        String nhanXet      = req.getParameter("nhanXet");

        if (sanPhamIdStr == null || soSaoStr == null) {
            resp.sendRedirect(req.getContextPath() + "/customer/orders");
            return;
        }

        int sanPhamId = Integer.parseInt(sanPhamIdStr);
        int soSao     = Integer.parseInt(soSaoStr);
        int donHangId = (donHangIdStr != null && !donHangIdStr.isBlank())
                        ? Integer.parseInt(donHangIdStr) : -1;

        DanhGia dg = new DanhGia();
        dg.setSanPhamId(sanPhamId);
        dg.setUserId(user.getUserId());
        dg.setSoSao(soSao);
        dg.setNhanXet(nhanXet);
        // donHangId = -1 nghĩa là đánh giá từ trang sản phẩm (không liên kết đơn cụ thể)
        if (donHangId > 0) dg.setDonHangId(donHangId);

        dgDAO.them(dg);

        // Redirect về trang phù hợp
        if (donHangId > 0) {
            resp.sendRedirect(req.getContextPath() + "/customer/orders/detail?id=" + donHangId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/products/detail?id=" + sanPhamId + "&reviewed=1");
        }
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return null; }
    }
}
