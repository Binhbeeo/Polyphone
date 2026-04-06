package com.polyphone.dao;

import com.polyphone.model.ChiTietDonHang;
import com.polyphone.model.DonHang;
import com.polyphone.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangDAO {

    private DonHang mapRow(ResultSet rs) throws SQLException {
        DonHang dh = new DonHang();
        dh.setDonHangId(rs.getInt("donhang_id"));
        dh.setUserId(rs.getInt("user_id"));
        dh.setDiaChi(rs.getString("diachi"));
        int vId = rs.getInt("voucher_id"); if (!rs.wasNull()) dh.setVoucherId(vId);
        dh.setTongTien(rs.getBigDecimal("tong_tien"));
        dh.setTienGiamVoucher(rs.getBigDecimal("tien_giam_voucher"));
        dh.setDiemSuDung(rs.getInt("diem_su_dung"));
        dh.setTienGiamDiem(rs.getBigDecimal("tien_giam_diem"));
        dh.setThanhTien(rs.getBigDecimal("thanh_tien"));
        dh.setDiemDuocCong(rs.getInt("diem_duoc_cong"));
        dh.setPhuongThucTT(rs.getString("phuong_thuc_tt"));
        dh.setTrangThaiTT(rs.getString("trang_thai_tt"));
        dh.setTrangThaiDH(rs.getString("trang_thai_dh"));
        dh.setGhiChu(rs.getString("ghi_chu"));
        int nvxl = rs.getInt("nhan_vien_xu_ly"); if (!rs.wasNull()) dh.setNhanVienXuLy(nvxl);
        Timestamp t = rs.getTimestamp("ngay_tao"); if (t != null) dh.setNgayTao(t.toLocalDateTime());
        Timestamp tc = rs.getTimestamp("ngay_cap_nhat"); if (tc != null) dh.setNgayCapNhat(tc.toLocalDateTime());
        Timestamp tgdk = rs.getTimestamp("ngay_giao_du_kien"); if (tgdk != null) dh.setNgayGiaoDuKien(tgdk.toLocalDateTime());
        Timestamp tgtt = rs.getTimestamp("ngay_giao_thuc_te"); if (tgtt != null) dh.setNgayGiaoThucTe(tgtt.toLocalDateTime());
        try { dh.setHoTenKhach(rs.getString("ho_ten")); } catch (SQLException ignored) {}
        return dh;
    }

    // RQ16: Tạo đơn hàng (transaction)
    public int taoDoanhHang(DonHang dh, List<ChiTietDonHang> chiTiet) {
        String sqlDH = "INSERT INTO DonHang (user_id,diachi,voucher_id,tong_tien,tien_giam_voucher,diem_su_dung,tien_giam_diem,thanh_tien,diem_duoc_cong,phuong_thuc_tt,ghi_chu) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        String sqlCT = "INSERT INTO ChiTietDonHang (donhang_id,sanpham_id,so_luong,don_gia) VALUES (?,?,?,?)";
        SanPhamDAO spDAO = new SanPhamDAO();

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Insert DonHang
                PreparedStatement psDH = conn.prepareStatement(sqlDH, Statement.RETURN_GENERATED_KEYS);
                psDH.setInt(1, dh.getUserId());
                psDH.setString(2, dh.getDiaChi());
                if (dh.getVoucherId() != null) psDH.setInt(3, dh.getVoucherId()); else psDH.setNull(3, Types.INTEGER);
                psDH.setBigDecimal(4, dh.getTongTien());
                psDH.setBigDecimal(5, dh.getTienGiamVoucher());
                psDH.setInt(6, dh.getDiemSuDung());
                psDH.setBigDecimal(7, dh.getTienGiamDiem());
                psDH.setBigDecimal(8, dh.getThanhTien());
                psDH.setInt(9, dh.getDiemDuocCong());
                psDH.setString(10, dh.getPhuongThucTT());
                psDH.setString(11, dh.getGhiChu());
                psDH.executeUpdate();

                ResultSet keys = psDH.getGeneratedKeys();
                if (!keys.next()) { conn.rollback(); return -1; }
                int donHangId = keys.getInt(1);

                // Insert ChiTiet & giảm tồn kho
                PreparedStatement psCT = conn.prepareStatement(sqlCT);
                for (ChiTietDonHang ct : chiTiet) {
                    if (!spDAO.giamTonKho(conn, ct.getSanPhamId(), ct.getSoLuong())) {
                        conn.rollback();
                        return -2; // hết hàng
                    }
                    psCT.setInt(1, donHangId);
                    psCT.setInt(2, ct.getSanPhamId());
                    psCT.setInt(3, ct.getSoLuong());
                    psCT.setBigDecimal(4, ct.getDonGia());
                    psCT.addBatch();
                }
                psCT.executeBatch();

                // Xóa giỏ hàng
                PreparedStatement psGH = conn.prepareStatement("DELETE FROM ChiTietGioHang WHERE user_id=?");
                psGH.setInt(1, dh.getUserId());
                psGH.executeUpdate();

                conn.commit();
                return donHangId;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return -1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    // RQ17: Theo dõi đơn hàng của user
    public List<DonHang> findByUserId(int userId) {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT dh.*, u.ho_ten FROM DonHang dh JOIN Users u ON dh.user_id=u.user_id WHERE dh.user_id=? ORDER BY dh.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Lấy chi tiết 1 đơn hàng
    public DonHang findById(int donHangId) {
        String sql = "SELECT dh.*, u.ho_ten FROM DonHang dh JOIN Users u ON dh.user_id=u.user_id WHERE dh.donhang_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donHangId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                DonHang dh = mapRow(rs);
                dh.setChiTietList(getChiTiet(donHangId));
                return dh;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<ChiTietDonHang> getChiTiet(int donHangId) {
        List<ChiTietDonHang> list = new ArrayList<>();
        String sql = "SELECT ct.*, sp.ten_san_pham, (SELECT TOP 1 url FROM AnhSanPham WHERE sanpham_id=sp.sanpham_id ORDER BY thu_tu) anh_url " +
                     "FROM ChiTietDonHang ct JOIN SanPham sp ON ct.sanpham_id=sp.sanpham_id WHERE ct.donhang_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donHangId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ChiTietDonHang ct = new ChiTietDonHang();
                ct.setCtDonHangId(rs.getInt("ct_donhang_id"));
                ct.setDonHangId(donHangId);
                ct.setSanPhamId(rs.getInt("sanpham_id"));
                ct.setSoLuong(rs.getInt("so_luong"));
                ct.setDonGia(rs.getBigDecimal("don_gia"));
                ct.setTenSanPham(rs.getString("ten_san_pham"));
                ct.setAnhUrl(rs.getString("anh_url"));
                list.add(ct);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ36/56: Lấy tất cả đơn hàng (staff/admin)
    public List<DonHang> findAll() {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT dh.*, u.ho_ten FROM DonHang dh JOIN Users u ON dh.user_id=u.user_id ORDER BY dh.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Lọc theo trạng thái
    public List<DonHang> findByTrangThai(String trangThai) {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT dh.*, u.ho_ten FROM DonHang dh JOIN Users u ON dh.user_id=u.user_id WHERE dh.trang_thai_dh=? ORDER BY dh.ngay_tao DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RQ37/57: Cập nhật trạng thái đơn hàng
    public boolean capNhatTrangThai(int donHangId, String trangThai, Integer nhanVienId) {
        String sql = "UPDATE DonHang SET trang_thai_dh=?, nhan_vien_xu_ly=?, ngay_cap_nhat=GETDATE() " +
                     (trangThai.equals("hoan_thanh") ? ", ngay_giao_thuc_te=GETDATE(), trang_thai_tt='da_tt' " : "") +
                     "WHERE donhang_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            if (nhanVienId != null) ps.setInt(2, nhanVienId); else ps.setNull(2, Types.INTEGER);
            ps.setInt(3, donHangId);
            boolean ok = ps.executeUpdate() > 0;
            // Nếu hoàn thành → cộng điểm
            if (ok && trangThai.equals("hoan_thanh")) {
                DonHang dh = findById(donHangId);
                if (dh != null && dh.getDiemDuocCong() > 0) {
                    new UserDAO().capNhatDiemCong(dh.getUserId(), dh.getDiemDuocCong());
                }
            }
            return ok;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Hủy đơn hàng (chỉ khi còn ở trạng thái mới)
    public boolean huyDonHang(int donHangId, int userId) {
        String sql = "UPDATE DonHang SET trang_thai_dh='huy', ngay_cap_nhat=GETDATE() WHERE donhang_id=? AND user_id=? AND trang_thai_dh='moi'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donHangId); ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Kiểm tra user đã mua sản phẩm chưa (để cho đánh giá)
    public boolean daMuaSanPham(int userId, int sanPhamId) {
        String sql = "SELECT 1 FROM DonHang dh JOIN ChiTietDonHang ct ON dh.donhang_id=ct.donhang_id " +
                     "WHERE dh.user_id=? AND ct.sanpham_id=? AND dh.trang_thai_dh='hoan_thanh'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, sanPhamId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
