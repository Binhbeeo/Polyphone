package com.polyphone.dao;

import com.polyphone.model.SanPham;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SanPhamDAO {

    private SanPham mapRow(ResultSet rs) throws SQLException {
        SanPham sp = new SanPham();
        sp.setSanPhamId(rs.getInt("sanpham_id"));
        sp.setDanhMucId(rs.getInt("danhmuc_id"));
        int thuongHieuId = rs.getInt("thuonghieu_id");
        if (!rs.wasNull()) sp.setThuongHieuId(thuongHieuId);
        sp.setTenSanPham(rs.getString("ten_san_pham"));
        sp.setMoTa(rs.getString("mo_ta"));
        sp.setGia(rs.getBigDecimal("gia"));
        sp.setTonKho(rs.getInt("ton_kho"));
        sp.setDangBan(rs.getBoolean("dang_ban"));
        Timestamp ngayTao = rs.getTimestamp("ngay_tao");
        if (ngayTao != null) sp.setNgayTao(ngayTao.toLocalDateTime());
        // Joined fields (may not exist in all queries)
        try { sp.setTenDanhMuc(rs.getString("ten_danh_muc")); } catch (SQLException ignored) {}
        try { sp.setTenThuongHieu(rs.getString("ten_thuong_hieu")); } catch (SQLException ignored) {}
        try { sp.setAvgSoSao(rs.getDouble("avg_sao")); } catch (SQLException ignored) {}
        try { sp.setSoLuongDanhGia(rs.getInt("so_dg")); } catch (SQLException ignored) {}
        return sp;
    }

    private static final String BASE_SELECT =
        "SELECT sp.*, dm.ten_danh_muc, th.ten_thuong_hieu, " +
        "ISNULL(AVG(CAST(dg.so_sao AS FLOAT)),0) avg_sao, COUNT(dg.danhgia_id) so_dg " +
        "FROM SanPham sp " +
        "JOIN DanhMuc dm ON sp.danhmuc_id = dm.danhmuc_id " +
        "LEFT JOIN ThuongHieu th ON sp.thuonghieu_id = th.thuonghieu_id " +
        "LEFT JOIN DanhGia dg ON sp.sanpham_id = dg.sanpham_id AND dg.dang_hien=1 ";

    private static final String BASE_GROUP = " GROUP BY sp.sanpham_id, sp.danhmuc_id, sp.thuonghieu_id, " +
        "sp.ten_san_pham, sp.mo_ta, sp.gia, sp.ton_kho, sp.dang_ban, sp.ngay_tao, sp.ngay_cap_nhat, " +
        "dm.ten_danh_muc, th.ten_thuong_hieu ";

    // RQ02: Lấy tất cả sản phẩm đang bán
    public List<SanPham> findAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE sp.dang_ban=1" + BASE_GROUP + "ORDER BY sp.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = mapRow(rs);
                sp.setAnhUrls(getAnhUrls(sp.getSanPhamId()));
                list.add(sp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ05: Xem chi tiết sản phẩm
    public SanPham findById(int sanPhamId) {
        String sql = BASE_SELECT + "WHERE sp.sanpham_id=?" + BASE_GROUP;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SanPham sp = mapRow(rs);
                sp.setAnhUrls(getAnhUrls(sanPhamId));
                return sp;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // RQ01: Tìm kiếm sản phẩm
    public List<SanPham> search(String keyword) {
        List<SanPham> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE sp.dang_ban=1 AND (sp.ten_san_pham LIKE ? OR dm.ten_danh_muc LIKE ? OR th.ten_thuong_hieu LIKE ?)" + BASE_GROUP + "ORDER BY sp.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw); ps.setString(2, kw); ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = mapRow(rs);
                sp.setAnhUrls(getAnhUrls(sp.getSanPhamId()));
                list.add(sp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ03: Lọc sản phẩm
    public List<SanPham> filter(Integer danhMucId, Integer thuongHieuId, Long giaMin, Long giaMax, List<Integer> tagIds) {
        List<SanPham> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE sp.dang_ban=1");
        if (danhMucId != null) sql.append(" AND sp.danhmuc_id=").append(danhMucId);
        if (thuongHieuId != null) sql.append(" AND sp.thuonghieu_id=").append(thuongHieuId);
        if (giaMin != null) sql.append(" AND sp.gia>=").append(giaMin);
        if (giaMax != null) sql.append(" AND sp.gia<=").append(giaMax);
        if (tagIds != null && !tagIds.isEmpty()) {
            sql.append(" AND sp.sanpham_id IN (SELECT sanpham_id FROM SanPhamTagLoc WHERE tag_id IN (");
            for (int i = 0; i < tagIds.size(); i++) {
                sql.append(tagIds.get(i));
                if (i < tagIds.size() - 1) sql.append(",");
            }
            sql.append(") GROUP BY sanpham_id HAVING COUNT(DISTINCT tag_id)=").append(tagIds.size()).append(")");
        }
        sql.append(BASE_GROUP).append("ORDER BY sp.gia ASC");
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = mapRow(rs);
                sp.setAnhUrls(getAnhUrls(sp.getSanPhamId()));
                list.add(sp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ04: Sản phẩm tương tự (cùng danh mục)
    public List<SanPham> findTuongTu(int sanPhamId, int danhMucId) {
        List<SanPham> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE sp.dang_ban=1 AND sp.danhmuc_id=? AND sp.sanpham_id!=?" + BASE_GROUP + "ORDER BY NEWID() OFFSET 0 ROWS FETCH NEXT 4 ROWS ONLY";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, danhMucId); ps.setInt(2, sanPhamId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = mapRow(rs);
                sp.setAnhUrls(getAnhUrls(sp.getSanPhamId()));
                list.add(sp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Admin: Thêm sản phẩm (RQ47)
    public int them(SanPham sp) {
        String sql = "INSERT INTO SanPham (danhmuc_id, thuonghieu_id, ten_san_pham, mo_ta, gia, ton_kho) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, sp.getDanhMucId());
            if (sp.getThuongHieuId() != null) ps.setInt(2, sp.getThuongHieuId()); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, sp.getTenSanPham());
            ps.setString(4, sp.getMoTa());
            ps.setBigDecimal(5, sp.getGia());
            ps.setInt(6, sp.getTonKho());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    // Admin: Sửa sản phẩm (RQ48)
    public boolean sua(SanPham sp) {
        String sql = "UPDATE SanPham SET danhmuc_id=?, thuonghieu_id=?, ten_san_pham=?, mo_ta=?, gia=?, ton_kho=?, dang_ban=?, ngay_cap_nhat=GETDATE() WHERE sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sp.getDanhMucId());
            if (sp.getThuongHieuId() != null) ps.setInt(2, sp.getThuongHieuId()); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, sp.getTenSanPham());
            ps.setString(4, sp.getMoTa());
            ps.setBigDecimal(5, sp.getGia());
            ps.setInt(6, sp.getTonKho());
            ps.setBoolean(7, sp.isDangBan());
            ps.setInt(8, sp.getSanPhamId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Admin: Xóa (ẩn) sản phẩm (RQ49)
    public boolean xoa(int sanPhamId) {
        String sql = "UPDATE SanPham SET dang_ban=0 WHERE sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sanPhamId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Admin: Lấy TẤT CẢ sản phẩm kể cả ẩn
    public List<SanPham> findAllAdmin() {
        List<SanPham> list = new ArrayList<>();
        String sql = BASE_SELECT + BASE_GROUP + "ORDER BY sp.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = mapRow(rs);
                sp.setAnhUrls(getAnhUrls(sp.getSanPhamId()));
                list.add(sp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Thêm ảnh sản phẩm
    public void themAnh(int sanPhamId, String url, int thuTu) {
        String sql = "INSERT INTO AnhSanPham (sanpham_id, url, thu_tu) VALUES (?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sanPhamId); ps.setString(2, url); ps.setInt(3, thuTu);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<String> getAnhUrls(int sanPhamId) {
        List<String> urls = new ArrayList<>();
        String sql = "SELECT url FROM AnhSanPham WHERE sanpham_id=? ORDER BY thu_tu";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) urls.add(rs.getString("url"));
        } catch (SQLException e) { e.printStackTrace(); }
        return urls;
    }

    public void xoaAnh(int sanPhamId) {
        String sql = "DELETE FROM AnhSanPham WHERE sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sanPhamId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Giảm tồn kho sau đặt hàng
    public boolean giamTonKho(Connection conn, int sanPhamId, int soLuong) throws SQLException {
        String sql = "UPDATE SanPham SET ton_kho = ton_kho - ? WHERE sanpham_id=? AND ton_kho >= ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, soLuong); ps.setInt(2, sanPhamId); ps.setInt(3, soLuong);
        return ps.executeUpdate() > 0;
    }
}
