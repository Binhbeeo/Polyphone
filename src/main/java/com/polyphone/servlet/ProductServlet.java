package com.polyphone.servlet;

import com.polyphone.dao.*;
import com.polyphone.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/products", "/products/detail", "/products/search"})
public class ProductServlet extends HttpServlet {

    private final SanPhamDAO spDAO  = new SanPhamDAO();
    private final DanhMucDAO dmDAO  = new DanhMucDAO();
    private final ThuongHieuDAO thDAO = new ThuongHieuDAO();
    private final DanhGiaDAO dgDAO  = new DanhGiaDAO();
    private final YeuThichDAO ytDAO = new YeuThichDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/products"        -> showList(req, resp);
            case "/products/detail" -> showDetail(req, resp);
            case "/products/search" -> showSearch(req, resp);
            default                 -> resp.sendRedirect(req.getContextPath() + "/products");
        }
    }

    // RQ02/RQ03: Danh sách + lọc sản phẩm
    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String danhMucParam   = req.getParameter("danhmuc");
        String thuongHieuParam = req.getParameter("thuonghieu");
        String giaMinParam    = req.getParameter("giaMin");
        String giaMaxParam    = req.getParameter("giaMax");
        String[] tagParams    = req.getParameterValues("tags");

        Integer danhMucId   = parseIntOrNull(danhMucParam);
        Integer thuongHieuId = parseIntOrNull(thuongHieuParam);
        Long giaMin = parseLongOrNull(giaMinParam);
        Long giaMax = parseLongOrNull(giaMaxParam);

        List<Integer> tagIds = null;
        if (tagParams != null) {
            tagIds = new java.util.ArrayList<>();
            for (String t : tagParams) {
                Integer tid = parseIntOrNull(t);
                if (tid != null) tagIds.add(tid);
            }
        }

        List<SanPham> products;
        boolean isFiltered = danhMucId != null || thuongHieuId != null ||
                giaMin != null || giaMax != null || (tagIds != null && !tagIds.isEmpty());

        if (isFiltered) {
            products = spDAO.filter(danhMucId, thuongHieuId, giaMin, giaMax, tagIds);
        } else {
            products = spDAO.findAll();
        }

        // Load tags (RQ55 support)
        List<Object[]> tags = getTagsWithGroups();

        req.setAttribute("products",    products);
        req.setAttribute("danhMucs",    dmDAO.findDangHien());
        req.setAttribute("thuongHieus", thDAO.findAll());
        req.setAttribute("tags",        tags);
        req.setAttribute("selectedDanhMuc",   danhMucId);
        req.setAttribute("selectedThuongHieu", thuongHieuId);
        req.setAttribute("giaMin", giaMinParam);
        req.setAttribute("giaMax", giaMaxParam);
        req.getRequestDispatcher("/WEB-INF/views/customer/products.jsp").forward(req, resp);
    }

    // RQ05/RQ04/RQ08/RQ07: Chi tiết sản phẩm
    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer id = parseIntOrNull(req.getParameter("id"));
        if (id == null) { resp.sendRedirect(req.getContextPath() + "/products"); return; }

        SanPham sp = spDAO.findById(id);
        if (sp == null || !sp.isDangBan()) { resp.sendRedirect(req.getContextPath() + "/products"); return; }

        List<SanPham> tuongTu = spDAO.findTuongTu(id, sp.getDanhMucId());
        List<DanhGia> danhGias = dgDAO.findBySanPham(id);

        // Kiểm tra đã yêu thích chưa
        HttpSession session = req.getSession(false);
        User loggedIn = session != null ? (User) session.getAttribute("loggedInUser") : null;
        boolean daYeuThich = false;
        boolean daMua = false;
        if (loggedIn != null) {
            daYeuThich = ytDAO.daYeuThich(loggedIn.getUserId(), id);
            daMua = new DonHangDAO().daMuaSanPham(loggedIn.getUserId(), id);
        }

        req.setAttribute("product",   sp);
        req.setAttribute("tuongTu",   tuongTu);
        req.setAttribute("danhGias",  danhGias);
        req.setAttribute("daYeuThich", daYeuThich);
        req.setAttribute("daMua",     daMua);
        req.getRequestDispatcher("/WEB-INF/views/customer/product-detail.jsp").forward(req, resp);
    }

    // RQ01: Tìm kiếm
    private void showSearch(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("q");
        List<SanPham> results = (keyword != null && !keyword.isBlank())
                ? spDAO.search(keyword.trim())
                : List.of();
        req.setAttribute("products", results);
        req.setAttribute("keyword",  keyword);
        req.setAttribute("danhMucs", dmDAO.findDangHien());
        req.getRequestDispatcher("/WEB-INF/views/customer/products.jsp").forward(req, resp);
    }

    // GET tags grouped (for filter sidebar)
    private List<Object[]> getTagsWithGroups() {
        List<Object[]> result = new java.util.ArrayList<>();
        String sql = "SELECT tag_id, ten_tag, nhom_tag FROM TagLoc ORDER BY nhom_tag, ten_tag";
        try (var conn = com.polyphone.util.DatabaseConnection.getConnection();
             var ps = conn.prepareStatement(sql)) {
            var rs = ps.executeQuery();
            while (rs.next()) {
                result.add(new Object[]{rs.getInt(1), rs.getString(2), rs.getString(3)});
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return null; }
    }

    private Long parseLongOrNull(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s.trim()); } catch (NumberFormatException e) { return null; }
    }
}
