package com.polyphone.dao;

import com.polyphone.model.KhieuNai;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class KhieuNaiDAO {

    private KhieuNai mapRow(ResultSet rs) throws SQLException {
        KhieuNai kn = new KhieuNai();
        kn.setKhieuNaiId(rs.getInt("khieunai_id"));
        kn.setUserId(rs.getInt("user_id"));
        int dhId = rs.getInt("donhang_id"); if (!rs.wasNull()) kn.setDonHangId(dhId);
        kn.setTieuDe(rs.getString("tieu_de"));
        kn.setNoiDung(rs.getString("noi_dung"));
        kn.setTrangThai(rs.getString("trang_thai"));
        int nxl = rs.getInt("nguoi_xu_ly"); if (!rs.wasNull()) kn.setNguoiXuLy(nxl);
        kn.setPhanHoi(rs.getString("phan_hoi"));
        Timestamp t1 = rs.getTimestamp("ngay_tao"); if (t1 != null) kn.setNgayTao(t1.toLocalDateTime());
        Timestamp t2 = rs.getTimestamp("ngay_cap_nhat"); if (t2 != null) kn.setNgayCapNhat(t2.toLocalDateTime());
        try { kn.setHoTenKhach(rs.getString("ho_ten_khach")); } catch (SQLException ignored) {}
        try { kn.setHoTenNhanVien(rs.getString("ho_ten_nv")); } catch (SQLException ignored) {}
        return kn;
    }

    // Khách hàng gửi khiếu nại
    public boolean them(KhieuNai kn) {
        String sql = "INSERT INTO KhieuNai (user_id, donhang_id, tieu_de, noi_dung) VALUES (?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, kn.getUserId());
            if (kn.getDonHangId() != null) ps.setInt(2, kn.getDonHangId()); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, kn.getTieuDe()); ps.setString(4, kn.getNoiDung());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<KhieuNai> findByUserId(int userId) {
        List<KhieuNai> list = new ArrayList<>();
        String sql = "SELECT kn.*, u.ho_ten ho_ten_khach, nv.ho_ten ho_ten_nv FROM KhieuNai kn " +
                     "JOIN Users u ON kn.user_id=u.user_id " +
                     "LEFT JOIN Users nv ON kn.nguoi_xu_ly=nv.user_id " +
                     "WHERE kn.user_id=? ORDER BY kn.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<KhieuNai> findAll() {
        List<KhieuNai> list = new ArrayList<>();
        String sql = "SELECT kn.*, u.ho_ten ho_ten_khach, nv.ho_ten ho_ten_nv FROM KhieuNai kn " +
                     "JOIN Users u ON kn.user_id=u.user_id " +
                     "LEFT JOIN Users nv ON kn.nguoi_xu_ly=nv.user_id ORDER BY kn.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public KhieuNai findById(int id) {
        String sql = "SELECT kn.*, u.ho_ten ho_ten_khach, nv.ho_ten ho_ten_nv FROM KhieuNai kn " +
                     "JOIN Users u ON kn.user_id=u.user_id " +
                     "LEFT JOIN Users nv ON kn.nguoi_xu_ly=nv.user_id WHERE kn.khieunai_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // RQ38: Xử lý khiếu nại
    public boolean xuLy(int khieuNaiId, String phanHoi, int nguoiXuLy, String trangThai) {
        String sql = "UPDATE KhieuNai SET phan_hoi=?, nguoi_xu_ly=?, trang_thai=?, ngay_cap_nhat=GETDATE() WHERE khieunai_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phanHoi); ps.setInt(2, nguoiXuLy); ps.setString(3, trangThai); ps.setInt(4, khieuNaiId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
