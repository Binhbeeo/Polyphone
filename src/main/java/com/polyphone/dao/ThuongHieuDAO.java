package com.polyphone.dao;

import com.polyphone.model.ThuongHieu;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThuongHieuDAO {

    private ThuongHieu mapRow(ResultSet rs) throws SQLException {
        ThuongHieu th = new ThuongHieu();
        th.setThuongHieuId(rs.getInt("thuonghieu_id"));
        th.setTenThuongHieu(rs.getString("ten_thuong_hieu"));
        th.setLogoUrl(rs.getString("logo_url"));
        return th;
    }

    public List<ThuongHieu> findAll() {
        List<ThuongHieu> list = new ArrayList<>();
        String sql = "SELECT * FROM ThuongHieu ORDER BY ten_thuong_hieu";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ThuongHieu findById(int id) {
        String sql = "SELECT * FROM ThuongHieu WHERE thuonghieu_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean them(ThuongHieu th) {
        String sql = "INSERT INTO ThuongHieu (ten_thuong_hieu, logo_url) VALUES (?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, th.getTenThuongHieu()); ps.setString(2, th.getLogoUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean sua(ThuongHieu th) {
        String sql = "UPDATE ThuongHieu SET ten_thuong_hieu=?, logo_url=? WHERE thuonghieu_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, th.getTenThuongHieu()); ps.setString(2, th.getLogoUrl()); ps.setInt(3, th.getThuongHieuId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean xoa(int id) {
        String sql = "DELETE FROM ThuongHieu WHERE thuonghieu_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
