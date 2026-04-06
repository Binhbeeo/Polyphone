package com.polyphone.dao;

import com.polyphone.model.Voucher;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    private Voucher mapRow(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getInt("voucher_id"));
        v.setMaVoucher(rs.getString("ma_voucher"));
        v.setLoaiGiam(rs.getString("loai_giam"));
        v.setGiaTriGiam(rs.getBigDecimal("gia_tri_giam"));
        v.setDonHangToiThieu(rs.getBigDecimal("don_hang_toi_thieu"));
        v.setSoLuotDungToiDa(rs.getInt("so_luot_dung_toi_da"));
        v.setDaDung(rs.getInt("da_dung"));
        Timestamp hetHan = rs.getTimestamp("het_han");
        if (hetHan != null) v.setHetHan(hetHan.toLocalDateTime());
        Timestamp batDau = rs.getTimestamp("ngay_bat_dau");
        if (batDau != null) v.setNgayBatDau(batDau.toLocalDateTime());
        v.setDangHoatDong(rs.getBoolean("dang_hoat_dong"));
        Timestamp ngayTao = rs.getTimestamp("ngay_tao");
        if (ngayTao != null) v.setNgayTao(ngayTao.toLocalDateTime());
        return v;
    }

    public List<Voucher> findAll() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher ORDER BY ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ28: Tìm voucher theo mã (cho user áp dụng)
    public Voucher findByMa(String maVoucher) {
        String sql = "SELECT * FROM Voucher WHERE ma_voucher=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maVoucher.trim().toUpperCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Voucher findById(int voucherId) {
        String sql = "SELECT * FROM Voucher WHERE voucher_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Lấy danh sách voucher hợp lệ cho user xem
    public List<Voucher> findHopLe() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher WHERE dang_hoat_dong=1 AND da_dung < so_luot_dung_toi_da " +
                     "AND (het_han IS NULL OR het_han > GETDATE()) AND ngay_bat_dau <= GETDATE()";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ61: Tạo voucher
    public boolean them(Voucher v) {
        String sql = "INSERT INTO Voucher (ma_voucher,loai_giam,gia_tri_giam,don_hang_toi_thieu,so_luot_dung_toi_da,het_han,ngay_bat_dau) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getMaVoucher().toUpperCase());
            ps.setString(2, v.getLoaiGiam());
            ps.setBigDecimal(3, v.getGiaTriGiam());
            ps.setBigDecimal(4, v.getDonHangToiThieu());
            ps.setInt(5, v.getSoLuotDungToiDa());
            if (v.getHetHan() != null) ps.setTimestamp(6, Timestamp.valueOf(v.getHetHan())); else ps.setNull(6, Types.TIMESTAMP);
            ps.setTimestamp(7, Timestamp.valueOf(v.getNgayBatDau()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean sua(Voucher v) {
        String sql = "UPDATE Voucher SET loai_giam=?,gia_tri_giam=?,don_hang_toi_thieu=?,so_luot_dung_toi_da=?,het_han=?,ngay_bat_dau=?,dang_hoat_dong=? WHERE voucher_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getLoaiGiam());
            ps.setBigDecimal(2, v.getGiaTriGiam());
            ps.setBigDecimal(3, v.getDonHangToiThieu());
            ps.setInt(4, v.getSoLuotDungToiDa());
            if (v.getHetHan() != null) ps.setTimestamp(5, Timestamp.valueOf(v.getHetHan())); else ps.setNull(5, Types.TIMESTAMP);
            ps.setTimestamp(6, Timestamp.valueOf(v.getNgayBatDau()));
            ps.setBoolean(7, v.isDangHoatDong());
            ps.setInt(8, v.getVoucherId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Tăng số lượt đã dùng
    public boolean tangDaDung(int voucherId) {
        String sql = "UPDATE Voucher SET da_dung=da_dung+1 WHERE voucher_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean xoa(int voucherId) {
        String sql = "UPDATE Voucher SET dang_hoat_dong=0 WHERE voucher_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
