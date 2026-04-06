package com.polyphone.dao;

import com.polyphone.model.DanhGia;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DanhGiaDAO {

    private DanhGia mapRow(ResultSet rs) throws SQLException {
        DanhGia dg = new DanhGia();
        dg.setDanhGiaId(rs.getInt("danhgia_id"));
        dg.setSanPhamId(rs.getInt("sanpham_id"));
        dg.setUserId(rs.getInt("user_id"));
        dg.setSoSao(rs.getInt("so_sao"));
        dg.setNhanXet(rs.getString("nhan_xet"));
        dg.setDangHien(rs.getBoolean("dang_hien"));
        Timestamp t = rs.getTimestamp("ngay_tao"); if (t != null) dg.setNgayTao(t.toLocalDateTime());
        try { dg.setHoTenNguoiDung(rs.getString("ho_ten")); } catch (SQLException ignored) {}
        try { dg.setAnhDaiDien(rs.getString("anh_dai_dien")); } catch (SQLException ignored) {}
        return dg;
    }

    // RQ08: Lấy đánh giá của sản phẩm
    public List<DanhGia> findBySanPham(int sanPhamId) {
        List<DanhGia> list = new ArrayList<>();
        String sql = "SELECT dg.*, u.ho_ten, u.anh_dai_dien FROM DanhGia dg JOIN Users u ON dg.user_id=u.user_id " +
                     "WHERE dg.sanpham_id=? AND dg.dang_hien=1 ORDER BY dg.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Admin: Xem tất cả đánh giá (RQ64)
    public List<DanhGia> findAll() {
        List<DanhGia> list = new ArrayList<>();
        String sql = "SELECT dg.*, u.ho_ten, u.anh_dai_dien FROM DanhGia dg JOIN Users u ON dg.user_id=u.user_id ORDER BY dg.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ07: Tạo đánh giá
    public boolean them(DanhGia dg) {
        // Kiểm tra đã đánh giá chưa (tránh duplicate)
        String sqlCheck = "SELECT 1 FROM DanhGia WHERE user_id=? AND sanpham_id=?" +
                          (dg.getDonHangId() != null ? " AND donhang_id=?" : " AND donhang_id IS NULL");
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
            psCheck.setInt(1, dg.getUserId());
            psCheck.setInt(2, dg.getSanPhamId());
            if (dg.getDonHangId() != null) psCheck.setInt(3, dg.getDonHangId());
            if (psCheck.executeQuery().next()) return false; // Đã đánh giá rồi
        } catch (SQLException e) { e.printStackTrace(); }

        String sql = "INSERT INTO DanhGia (sanpham_id, user_id, so_sao, nhan_xet, donhang_id) VALUES (?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dg.getSanPhamId());
            ps.setInt(2, dg.getUserId());
            ps.setInt(3, dg.getSoSao());
            ps.setString(4, dg.getNhanXet());
            if (dg.getDonHangId() != null) ps.setInt(5, dg.getDonHangId()); else ps.setNull(5, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Admin: Ẩn đánh giá (RQ64)
    public boolean anDanhGia(int danhGiaId, int anBoi, String lyDoAn) {
        String sql = "UPDATE DanhGia SET dang_hien=0, an_boi=?, ly_do_an=? WHERE danhgia_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, anBoi); ps.setString(2, lyDoAn); ps.setInt(3, danhGiaId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Hiện lại đánh giá
    public boolean hienDanhGia(int danhGiaId) {
        String sql = "UPDATE DanhGia SET dang_hien=1, an_boi=NULL, ly_do_an=NULL WHERE danhgia_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, danhGiaId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
