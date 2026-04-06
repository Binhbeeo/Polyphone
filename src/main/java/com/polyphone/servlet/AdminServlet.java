package com.polyphone.servlet;

import com.polyphone.dao.*;
import com.polyphone.model.*;
import com.polyphone.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/dashboard",
        "/admin/products", "/admin/products/add", "/admin/products/edit", "/admin/products/delete",
        "/admin/categories", "/admin/categories/add", "/admin/categories/edit", "/admin/categories/delete",
        "/admin/users", "/admin/users/detail", "/admin/users/toggle",
        "/admin/users/blacklist", "/admin/users/points",
        "/admin/staff", "/admin/staff/add", "/admin/staff/delete",
        "/admin/vouchers", "/admin/vouchers/add", "/admin/vouchers/edit",
        "/admin/orders", "/admin/orders/detail", "/admin/orders/update-status",
        "/admin/complaints", "/admin/complaints/detail", "/admin/complaints/respond",
        "/admin/reviews", "/admin/reviews/toggle",
        "/admin/trade-in"
})
public class AdminServlet extends HttpServlet {

    private final SanPhamDAO  spDAO  = new SanPhamDAO();
    private final DanhMucDAO  dmDAO  = new DanhMucDAO();
    private final ThuongHieuDAO thDAO = new ThuongHieuDAO();
    private final UserDAO     userDAO = new UserDAO();
    private final VoucherDAO  vcDAO  = new VoucherDAO();
    private final DonHangDAO  dhDAO  = new DonHangDAO();
    private final KhieuNaiDAO knDAO  = new KhieuNaiDAO();
    private final DanhGiaDAO  dgDAO  = new DanhGiaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/admin/dashboard"            -> showDashboard(req, resp);
            case "/admin/products"             -> showProducts(req, resp);
            case "/admin/products/add"         -> { loadProductForm(req); forward(req, resp, "admin/product-form.jsp"); }
            case "/admin/products/edit"        -> showEditProduct(req, resp);
            case "/admin/categories"           -> showCategories(req, resp);
            case "/admin/users"                -> showUsers(req, resp);
            case "/admin/users/detail"         -> showUserDetail(req, resp);
            case "/admin/staff"                -> showStaff(req, resp);
            case "/admin/staff/add"            -> forward(req, resp, "admin/staff-form.jsp");
            case "/admin/vouchers"             -> showVouchers(req, resp);
            case "/admin/vouchers/add"         -> forward(req, resp, "admin/voucher-form.jsp");
            case "/admin/vouchers/edit"        -> showEditVoucher(req, resp);
            case "/admin/orders"               -> showOrders(req, resp);
            case "/admin/orders/detail"        -> showOrderDetail(req, resp);
            case "/admin/complaints"           -> showComplaints(req, resp);
            case "/admin/complaints/detail"    -> showComplaintDetail(req, resp);
            case "/admin/reviews"              -> showReviews(req, resp);
            case "/admin/trade-in"             -> showTradeIn(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/admin/products/add"         -> doAddProduct(req, resp);
            case "/admin/products/edit"        -> doEditProduct(req, resp);
            case "/admin/products/delete"      -> doDeleteProduct(req, resp);
            case "/admin/categories/add"       -> doAddCategory(req, resp);
            case "/admin/categories/edit"      -> doEditCategory(req, resp);
            case "/admin/categories/delete"    -> doDeleteCategory(req, resp);
            case "/admin/users/toggle"         -> doToggleUser(req, resp);
            case "/admin/users/blacklist"      -> doBlacklist(req, resp);
            case "/admin/users/points"         -> doUpdatePoints(req, resp);
            case "/admin/staff/add"            -> doAddStaff(req, resp);
            case "/admin/staff/delete"         -> doDeleteStaff(req, resp);
            case "/admin/vouchers/add"         -> doAddVoucher(req, resp);
            case "/admin/vouchers/edit"        -> doEditVoucher(req, resp);
            case "/admin/orders/update-status" -> doUpdateOrderStatus(req, resp);
            case "/admin/complaints/respond"   -> doRespondComplaint(req, resp);
            case "/admin/reviews/toggle"       -> doToggleReview(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    // ─── Dashboard ───
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        long totalOrders   = dhDAO.findAll().size();
        long totalUsers    = userDAO.findByRole("user").size();
        long totalProducts = spDAO.findAllAdmin().size();
        long pendingComplaint = knDAO.findAll().stream()
                .filter(k -> "cho_xu_ly".equals(k.getTrangThai())).count();
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalUsers",  totalUsers);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("pendingComplaints", pendingComplaint);
        req.setAttribute("recentOrders", dhDAO.findByTrangThai("moi"));
        forward(req, resp, "admin/dashboard.jsp");
    }

    // ─── Products (RQ47/48/49) ───
    private void showProducts(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("products", spDAO.findAllAdmin());
        forward(req, resp, "admin/products.jsp");
    }

    private void loadProductForm(HttpServletRequest req) {
        req.setAttribute("danhMucs",    dmDAO.findAll());
        req.setAttribute("thuongHieus", thDAO.findAll());
    }

    private void showEditProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        SanPham sp = spDAO.findById(Integer.parseInt(req.getParameter("id")));
        req.setAttribute("product", sp);
        loadProductForm(req);
        forward(req, resp, "admin/product-form.jsp");
    }

    // ── Thay thế 2 method này trong AdminServlet.java ──────────────────────────

    private void doAddProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        SanPham sp = buildSanPhamFromRequest(req);
        int id = spDAO.them(sp);
        if (id > 0) {
            String[] anhUrls = req.getParameterValues("anhUrls");
            if (anhUrls != null) {
                int thuTu = 0;
                for (String url : anhUrls) {
                    if (url != null && !url.isBlank()) {
                        spDAO.themAnh(id, url.trim(), thuTu++);
                    }
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products?success=added");
    }

    private void doEditProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        SanPham sp = buildSanPhamFromRequest(req);
        sp.setSanPhamId(Integer.parseInt(req.getParameter("sanPhamId")));
        sp.setDangBan("1".equals(req.getParameter("dangBan")));
        spDAO.sua(sp);

        // Xóa ảnh cũ rồi lưu lại toàn bộ ảnh mới
        spDAO.xoaAnh(sp.getSanPhamId());
        String[] anhUrls = req.getParameterValues("anhUrls");
        if (anhUrls != null) {
            int thuTu = 0;
            for (String url : anhUrls) {
                if (url != null && !url.isBlank()) {
                    spDAO.themAnh(sp.getSanPhamId(), url.trim(), thuTu++);
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products?success=edited");
    }


    private void doDeleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        spDAO.xoa(Integer.parseInt(req.getParameter("id")));
        resp.sendRedirect(req.getContextPath() + "/admin/products?success=deleted");
    }

    private SanPham buildSanPhamFromRequest(HttpServletRequest req) {
        SanPham sp = new SanPham();
        sp.setDanhMucId(Integer.parseInt(req.getParameter("danhMucId")));
        String thId = req.getParameter("thuongHieuId");
        if (thId != null && !thId.isBlank()) sp.setThuongHieuId(Integer.parseInt(thId));
        sp.setTenSanPham(req.getParameter("tenSanPham"));
        sp.setMoTa(req.getParameter("moTa"));
        sp.setGia(new BigDecimal(req.getParameter("gia")));
        sp.setTonKho(Integer.parseInt(req.getParameter("tonKho")));
        return sp;
    }

    // ─── Categories (RQ50/51/52) ───
    private void showCategories(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categories", dmDAO.findAll());
        forward(req, resp, "admin/categories.jsp");
    }

    private void doAddCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        DanhMuc dm = new DanhMuc();
        dm.setTenDanhMuc(req.getParameter("tenDanhMuc"));
        dm.setMoTa(req.getParameter("moTa"));
        dmDAO.them(dm);
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void doEditCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        DanhMuc dm = new DanhMuc();
        dm.setDanhMucId(Integer.parseInt(req.getParameter("danhMucId")));
        dm.setTenDanhMuc(req.getParameter("tenDanhMuc"));
        dm.setMoTa(req.getParameter("moTa"));
        dm.setDangHien("1".equals(req.getParameter("dangHien")));
        dmDAO.sua(dm);
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void doDeleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        dmDAO.xoa(Integer.parseInt(req.getParameter("id")));
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    // ─── Users (RQ53/54/59/60) ───
    private void showUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("q");
        List<User> users = (keyword != null && !keyword.isBlank())
                ? userDAO.search(keyword) : userDAO.findByRole("user");
        req.setAttribute("users", users);
        forward(req, resp, "admin/users.jsp");
    }

    private void showUserDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = userDAO.findById(Integer.parseInt(req.getParameter("id")));
        req.setAttribute("viewUser", user);
        req.setAttribute("orders", dhDAO.findByUserId(user.getUserId()));
        forward(req, resp, "admin/user-detail.jsp");
    }

    private void doToggleUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        boolean active = "1".equals(req.getParameter("active"));
        userDAO.capNhatTrangThai(userId, active);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void doBlacklist(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        boolean blacklist = "1".equals(req.getParameter("blacklist"));
        userDAO.capNhatBlacklist(userId, blacklist);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void doUpdatePoints(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        int diem   = Integer.parseInt(req.getParameter("diem"));
        userDAO.capNhatDiem(userId, diem);
        resp.sendRedirect(req.getContextPath() + "/admin/users/detail?id=" + userId);
    }

    // ─── Staff (RQ53/63) ───
    private void showStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("staffList", userDAO.findByRole("staff"));
        forward(req, resp, "admin/staff.jsp");
    }

    private void doAddStaff(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        User admin = (User) req.getSession().getAttribute("loggedInUser");
        String email = req.getParameter("email");
        if (userDAO.emailTonTai(email)) {
            req.setAttribute("error", "Email đã tồn tại.");
            forward(req, resp, "admin/staff-form.jsp");
            return;
        }
        User staff = new User();
        staff.setHoTen(req.getParameter("hoTen"));
        staff.setEmail(email);
        staff.setSoDienThoai(req.getParameter("soDienThoai"));
        staff.setMatKhauHash(PasswordUtil.hashPassword(req.getParameter("password")));
        userDAO.taoNhanVien(staff, admin.getUserId());
        resp.sendRedirect(req.getContextPath() + "/admin/staff?success=1");
    }

    private void doDeleteStaff(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        userDAO.xoaNhanVien(Integer.parseInt(req.getParameter("id")));
        resp.sendRedirect(req.getContextPath() + "/admin/staff");
    }

    // ─── Vouchers (RQ61) ───
    private void showVouchers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("vouchers", vcDAO.findAll());
        forward(req, resp, "admin/vouchers.jsp");
    }

    private void showEditVoucher(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("voucher", vcDAO.findById(Integer.parseInt(req.getParameter("id"))));
        forward(req, resp, "admin/voucher-form.jsp");
    }

    private void doAddVoucher(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        vcDAO.them(buildVoucherFromRequest(req));
        resp.sendRedirect(req.getContextPath() + "/admin/vouchers");
    }

    private void doEditVoucher(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Voucher v = buildVoucherFromRequest(req);
        v.setVoucherId(Integer.parseInt(req.getParameter("voucherId")));
        v.setDangHoatDong("1".equals(req.getParameter("dangHoatDong")));
        vcDAO.sua(v);
        resp.sendRedirect(req.getContextPath() + "/admin/vouchers");
    }

    private Voucher buildVoucherFromRequest(HttpServletRequest req) {
        Voucher v = new Voucher();
        v.setMaVoucher(req.getParameter("maVoucher"));
        v.setLoaiGiam(req.getParameter("loaiGiam"));
        v.setGiaTriGiam(new BigDecimal(req.getParameter("giaTriGiam")));
        v.setDonHangToiThieu(new BigDecimal(req.getParameter("donHangToiThieu")));
        v.setSoLuotDungToiDa(Integer.parseInt(req.getParameter("soLuotDungToiDa")));
        String hetHan = req.getParameter("hetHan");
        if (hetHan != null && !hetHan.isBlank()) v.setHetHan(LocalDateTime.parse(hetHan + ":00"));
        String batDau = req.getParameter("ngayBatDau");
        v.setNgayBatDau(batDau != null && !batDau.isBlank() ? LocalDateTime.parse(batDau + ":00") : LocalDateTime.now());
        return v;
    }

    // ─── Orders (RQ56/57) ───
    private void showOrders(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String trangThai = req.getParameter("trangThai");
        List<DonHang> orders = (trangThai != null && !trangThai.isBlank())
                ? dhDAO.findByTrangThai(trangThai) : dhDAO.findAll();
        req.setAttribute("orders",    orders);
        req.setAttribute("trangThai", trangThai);
        forward(req, resp, "admin/orders.jsp");
    }

    private void showOrderDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("order", dhDAO.findById(Integer.parseInt(req.getParameter("id"))));
        forward(req, resp, "admin/order-detail.jsp");
    }

    private void doUpdateOrderStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User admin = (User) req.getSession().getAttribute("loggedInUser");
        int donHangId  = Integer.parseInt(req.getParameter("id"));
        String newStatus = req.getParameter("trangThai");
        dhDAO.capNhatTrangThai(donHangId, newStatus, admin.getUserId());
        resp.sendRedirect(req.getContextPath() + "/admin/orders/detail?id=" + donHangId);
    }

    // ─── Complaints (RQ58) ───
    private void showComplaints(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("complaints", knDAO.findAll());
        forward(req, resp, "admin/complaints.jsp");
    }

    private void showComplaintDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("complaint", knDAO.findById(Integer.parseInt(req.getParameter("id"))));
        forward(req, resp, "admin/complaint-detail.jsp");
    }

    private void doRespondComplaint(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User admin = (User) req.getSession().getAttribute("loggedInUser");
        int id = Integer.parseInt(req.getParameter("id"));
        String phanHoi   = req.getParameter("phanHoi");
        String trangThai = req.getParameter("trangThai");
        knDAO.xuLy(id, phanHoi, admin.getUserId(), trangThai);
        resp.sendRedirect(req.getContextPath() + "/admin/complaints/detail?id=" + id);
    }

    // ─── Reviews (RQ64) ───
    private void showReviews(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("reviews", dgDAO.findAll());
        forward(req, resp, "admin/reviews.jsp");
    }

    private void doToggleReview(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User admin = (User) req.getSession().getAttribute("loggedInUser");
        int id = Integer.parseInt(req.getParameter("id"));
        String action = req.getParameter("action");
        if ("hide".equals(action)) {
            dgDAO.anDanhGia(id, admin.getUserId(), req.getParameter("lyDoAn"));
        } else {
            dgDAO.hienDanhGia(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/reviews");
    }

    // ─── RQ62: Trade-In (xem lịch sử đơn hàng online đã hoàn thành) ───
    private void showTradeIn(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<DonHang> completed = dhDAO.findByTrangThai("hoan_thanh");
        req.setAttribute("tradeInOrders", completed);
        forward(req, resp, "admin/trade-in.jsp");
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/" + view).forward(req, resp);
    }
}
