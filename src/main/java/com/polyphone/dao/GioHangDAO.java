package com.polyphone.dao;

import com.polyphone.model.GioHang;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GioHangDAO {

    // RQ11: Thêm vào giỏ hàng
    public boolean them(int userId, int sanPhamId, int soLuong) {
        // Nếu đã có thì cập nhật số lượng
        String sqlCheck = "SELECT ct_giohang_id, so_luong FROM ChiTietGioHang WHERE user_id=? AND sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
            psCheck.setInt(1, userId); psCheck.setInt(2, sanPhamId);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) {
                int currentQty = rs.getInt("so_luong");
                String sqlUp = "UPDATE ChiTietGioHang SET so_luong=? WHERE user_id=? AND sanpham_id=?";
                PreparedStatement psUp = conn.prepareStatement(sqlUp);
                psUp.setInt(1, currentQty + soLuong);
                psUp.setInt(2, userId); psUp.setInt(3, sanPhamId);
                return psUp.executeUpdate() > 0;
            } else {
                String sqlIns = "INSERT INTO ChiTietGioHang (user_id, sanpham_id, so_luong) VALUES (?,?,?)";
                PreparedStatement psIns = conn.prepareStatement(sqlIns);
                psIns.setInt(1, userId); psIns.setInt(2, sanPhamId); psIns.setInt(3, soLuong);
                return psIns.executeUpdate() > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // RQ10: Xem giỏ hàng
    public List<GioHang> findByUserId(int userId) {
        List<GioHang> list = new ArrayList<>();
        String sql = "SELECT cg.*, sp.ten_san_pham, sp.gia, sp.ton_kho, " +
                     "(SELECT TOP 1 url FROM AnhSanPham WHERE sanpham_id=sp.sanpham_id ORDER BY thu_tu) anh_url " +
                     "FROM ChiTietGioHang cg JOIN SanPham sp ON cg.sanpham_id=sp.sanpham_id " +
                     "WHERE cg.user_id=? AND sp.dang_ban=1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                GioHang gh = new GioHang();
                gh.setCtGioHangId(rs.getInt("ct_giohang_id"));
                gh.setUserId(userId);
                gh.setSanPhamId(rs.getInt("sanpham_id"));
                gh.setSoLuong(rs.getInt("so_luong"));
                gh.setTenSanPham(rs.getString("ten_san_pham"));
                gh.setGia(rs.getBigDecimal("gia"));
                gh.setTonKho(rs.getInt("ton_kho"));
                gh.setAnhUrl(rs.getString("anh_url"));
                list.add(gh);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ13: Cập nhật số lượng
    public boolean capNhatSoLuong(int userId, int sanPhamId, int soLuong) {
        if (soLuong <= 0) return xoa(userId, sanPhamId);
        String sql = "UPDATE ChiTietGioHang SET so_luong=? WHERE user_id=? AND sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, soLuong); ps.setInt(2, userId); ps.setInt(3, sanPhamId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // RQ12: Xóa khỏi giỏ
    public boolean xoa(int userId, int sanPhamId) {
        String sql = "DELETE FROM ChiTietGioHang WHERE user_id=? AND sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, sanPhamId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean xoaTatCa(int userId) {
        String sql = "DELETE FROM ChiTietGioHang WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int countItems(int userId) {
        String sql = "SELECT SUM(so_luong) FROM ChiTietGioHang WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
