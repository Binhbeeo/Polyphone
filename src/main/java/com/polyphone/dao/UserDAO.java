package com.polyphone.dao;

import com.polyphone.model.User;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setRole(rs.getString("role"));
        u.setHoTen(rs.getString("ho_ten"));
        u.setEmail(rs.getString("email"));
        u.setSoDienThoai(rs.getString("so_dien_thoai"));
        u.setMatKhauHash(rs.getString("mat_khau_hash"));
        u.setAnhDaiDien(rs.getString("anh_dai_dien"));
        u.setDangHoatDong(rs.getBoolean("dang_hoat_dong"));
        u.setTrongBlacklist(rs.getBoolean("trong_blacklist"));
        u.setDiemTichLuy(rs.getInt("diem_tich_luy"));
        Timestamp ngayTao = rs.getTimestamp("ngay_tao");
        if (ngayTao != null) u.setNgayTao(ngayTao.toLocalDateTime());
        return u;
    }

    // RQ19: Đăng ký tài khoản
    public boolean dangKy(User user) {
        String sql = "INSERT INTO Users (role, ho_ten, email, so_dien_thoai, mat_khau_hash) VALUES (?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "user");
            ps.setString(2, user.getHoTen());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getSoDienThoai());
            ps.setString(5, user.getMatKhauHash());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // RQ20: Đăng nhập - tìm theo email hoặc SĐT
    public User findByEmailOrPhone(String loginInput) {
        String sql = "SELECT * FROM Users WHERE email = ? OR so_dien_thoai = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginInput);
            ps.setString(2, loginInput);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // RQ18: Cập nhật thông tin
    public boolean capNhatThongTin(User user) {
        String sql = "UPDATE Users SET ho_ten=?, so_dien_thoai=?, anh_dai_dien=?, ngay_cap_nhat=GETDATE() WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getHoTen());
            ps.setString(2, user.getSoDienThoai());
            ps.setString(3, user.getAnhDaiDien());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // RQ21: Cập nhật mật khẩu
    public boolean capNhatMatKhau(int userId, String matKhauHash) {
        String sql = "UPDATE Users SET mat_khau_hash=?, ngay_cap_nhat=GETDATE() WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, matKhauHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Admin: Lấy danh sách tất cả user theo role
    public List<User> findByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = ? ORDER BY ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin: Lấy tất cả user (trừ admin)
    public List<User> findAllNonAdmin() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role != 'admin' ORDER BY ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // RQ54: Vô hiệu hóa / kích hoạt tài khoản
    public boolean capNhatTrangThai(int userId, boolean dangHoatDong) {
        String sql = "UPDATE Users SET dang_hoat_dong=? WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, dangHoatDong);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // RQ53: Xóa tài khoản nhân viên
    public boolean xoaNhanVien(int userId) {
        String sql = "DELETE FROM Users WHERE user_id=? AND role='staff'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // RQ60: Blacklist
    public boolean capNhatBlacklist(int userId, boolean trongBlacklist) {
        String sql = "UPDATE Users SET trong_blacklist=?, dang_hoat_dong=? WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, trongBlacklist);
            ps.setBoolean(2, !trongBlacklist);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // RQ59: Cập nhật điểm tích lũy
    public boolean capNhatDiem(int userId, int diem) {
        String sql = "UPDATE Users SET diem_tich_luy=? WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, diem);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // RQ63: Tạo tài khoản nhân viên
    public boolean taoNhanVien(User user, int taoBoi) {
        String sql = "INSERT INTO Users (role, ho_ten, email, so_dien_thoai, mat_khau_hash, tao_boi) VALUES ('staff',?,?,?,?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getHoTen());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getSoDienThoai());
            ps.setString(4, user.getMatKhauHash());
            ps.setInt(5, taoBoi);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cộng điểm khi đơn hàng hoàn thành
    public boolean capNhatDiemCong(int userId, int diemCong) {
        String sql = "UPDATE Users SET diem_tich_luy = diem_tich_luy + ? WHERE user_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, diemCong);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean emailTonTai(String email) {
        String sql = "SELECT 1 FROM Users WHERE email=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sdtTonTai(String sdt) {
        String sql = "SELECT 1 FROM Users WHERE so_dien_thoai=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sdt);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Search users
    public List<User> search(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role != 'admin' AND (ho_ten LIKE ? OR email LIKE ? OR so_dien_thoai LIKE ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw); ps.setString(2, kw); ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Google OAuth2 methods ────────────────────────────────────────────

    /** Tìm user theo google_id. */
    public User findByGoogleId(String googleId) {
        String sql = "SELECT * FROM Users WHERE google_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, googleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**
     * Đăng nhập / Đăng ký qua Google.
     * 1. Có google_id → trả về user đó.
     * 2. Email tồn tại → liên kết google_id.
     * 3. Email chưa có → tạo tài khoản mới.
     */
    public User loginOrRegisterByGoogle(String googleId, String email,
                                        String hoTen, String avatarUrl) {
        User existing = findByGoogleId(googleId);
        if (existing != null) return existing;

        User byEmail = findByEmailOrPhone(email);
        if (byEmail != null) {
            String sql = "UPDATE Users SET google_id=?, anh_dai_dien=ISNULL(anh_dai_dien,?), ngay_cap_nhat=GETDATE() WHERE user_id=?";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, googleId); ps.setString(2, avatarUrl); ps.setInt(3, byEmail.getUserId());
                ps.executeUpdate();
            } catch (SQLException e) { e.printStackTrace(); return null; }
            return findById(byEmail.getUserId());
        }

        String sql = "INSERT INTO Users (role, ho_ten, email, mat_khau_hash, anh_dai_dien, google_id) VALUES ('user',?,?,'',?,?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, hoTen); ps.setString(2, email);
            ps.setString(3, avatarUrl); ps.setString(4, googleId);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return findById(keys.getInt(1));
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
