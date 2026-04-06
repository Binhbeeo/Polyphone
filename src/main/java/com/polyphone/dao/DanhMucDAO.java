package com.polyphone.dao;

import com.polyphone.model.DanhMuc;
import com.polyphone.model.ThuongHieu;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DanhMucDAO {

    private DanhMuc mapRow(ResultSet rs) throws SQLException {
        DanhMuc dm = new DanhMuc();
        dm.setDanhMucId(rs.getInt("danhmuc_id"));
        dm.setTenDanhMuc(rs.getString("ten_danh_muc"));
        dm.setMoTa(rs.getString("mo_ta"));
        dm.setDangHien(rs.getBoolean("dang_hien"));
        Timestamp t = rs.getTimestamp("ngay_tao"); if (t != null) dm.setNgayTao(t.toLocalDateTime());
        return dm;
    }

    public List<DanhMuc> findAll() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT * FROM DanhMuc ORDER BY ten_danh_muc";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<DanhMuc> findDangHien() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT * FROM DanhMuc WHERE dang_hien=1 ORDER BY ten_danh_muc";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public DanhMuc findById(int id) {
        String sql = "SELECT * FROM DanhMuc WHERE danhmuc_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // RQ50
    public boolean them(DanhMuc dm) {
        String sql = "INSERT INTO DanhMuc (ten_danh_muc, mo_ta) VALUES (?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dm.getTenDanhMuc()); ps.setString(2, dm.getMoTa());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // RQ51
    public boolean sua(DanhMuc dm) {
        String sql = "UPDATE DanhMuc SET ten_danh_muc=?, mo_ta=?, dang_hien=? WHERE danhmuc_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dm.getTenDanhMuc()); ps.setString(2, dm.getMoTa());
            ps.setBoolean(3, dm.isDangHien()); ps.setInt(4, dm.getDanhMucId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // RQ52
    public boolean xoa(int id) {
        String sql = "UPDATE DanhMuc SET dang_hien=0 WHERE danhmuc_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
