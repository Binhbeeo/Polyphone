package com.polyphone.dao;

import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class YeuThichDAO {

    // RQ09: Thêm yêu thích
    public boolean them(int userId, int sanPhamId) {
        String sql = "IF NOT EXISTS (SELECT 1 FROM YeuThich WHERE user_id=? AND sanpham_id=?) " +
                     "INSERT INTO YeuThich (user_id, sanpham_id) VALUES (?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, sanPhamId);
            ps.setInt(3, userId); ps.setInt(4, sanPhamId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // RQ06: Bỏ yêu thích
    public boolean xoa(int userId, int sanPhamId) {
        String sql = "DELETE FROM YeuThich WHERE user_id=? AND sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, sanPhamId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean daYeuThich(int userId, int sanPhamId) {
        String sql = "SELECT 1 FROM YeuThich WHERE user_id=? AND sanpham_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, sanPhamId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Integer> getSanPhamIds(int userId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT sanpham_id FROM YeuThich WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt(1));
        } catch (SQLException e) { e.printStackTrace(); }
        return ids;
    }
}
