package com.polyphone.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class DonHang {
    private int donHangId;
    private int userId;
    private String diaChi;
    private Integer voucherId;
    private BigDecimal tongTien;
    private BigDecimal tienGiamVoucher;
    private int diemSuDung;
    private BigDecimal tienGiamDiem;
    private BigDecimal thanhTien;
    private int diemDuocCong;
    private String phuongThucTT;   // COD | PayOS
    private String trangThaiTT;    // chua_tt | da_tt
    private String trangThaiDH;    // moi | xac_nhan | dong_goi | dang_giao | hoan_thanh | huy
    private String ghiChu;
    private Integer nhanVienXuLy;
    private LocalDateTime ngayTao;
    private LocalDateTime ngayCapNhat;
    private LocalDateTime ngayGiaoDuKien;
    private LocalDateTime ngayGiaoThucTe;

    // Joined
    private String hoTenKhach;
    private List<ChiTietDonHang> chiTietList;

    public DonHang() {}

    // Getters & Setters
    public int getDonHangId() { return donHangId; }
    public void setDonHangId(int donHangId) { this.donHangId = donHangId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public Integer getVoucherId() { return voucherId; }
    public void setVoucherId(Integer voucherId) { this.voucherId = voucherId; }

    public BigDecimal getTongTien() { return tongTien; }
    public void setTongTien(BigDecimal tongTien) { this.tongTien = tongTien; }

    public BigDecimal getTienGiamVoucher() { return tienGiamVoucher; }
    public void setTienGiamVoucher(BigDecimal tienGiamVoucher) { this.tienGiamVoucher = tienGiamVoucher; }

    public int getDiemSuDung() { return diemSuDung; }
    public void setDiemSuDung(int diemSuDung) { this.diemSuDung = diemSuDung; }

    public BigDecimal getTienGiamDiem() { return tienGiamDiem; }
    public void setTienGiamDiem(BigDecimal tienGiamDiem) { this.tienGiamDiem = tienGiamDiem; }

    public BigDecimal getThanhTien() { return thanhTien; }
    public void setThanhTien(BigDecimal thanhTien) { this.thanhTien = thanhTien; }

    public int getDiemDuocCong() { return diemDuocCong; }
    public void setDiemDuocCong(int diemDuocCong) { this.diemDuocCong = diemDuocCong; }

    public String getPhuongThucTT() { return phuongThucTT; }
    public void setPhuongThucTT(String phuongThucTT) { this.phuongThucTT = phuongThucTT; }

    public String getTrangThaiTT() { return trangThaiTT; }
    public void setTrangThaiTT(String trangThaiTT) { this.trangThaiTT = trangThaiTT; }

    public String getTrangThaiDH() { return trangThaiDH; }
    public void setTrangThaiDH(String trangThaiDH) { this.trangThaiDH = trangThaiDH; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }

    public Integer getNhanVienXuLy() { return nhanVienXuLy; }
    public void setNhanVienXuLy(Integer nhanVienXuLy) { this.nhanVienXuLy = nhanVienXuLy; }

    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }

    public LocalDateTime getNgayCapNhat() { return ngayCapNhat; }
    public void setNgayCapNhat(LocalDateTime ngayCapNhat) { this.ngayCapNhat = ngayCapNhat; }

    public LocalDateTime getNgayGiaoDuKien() { return ngayGiaoDuKien; }
    public void setNgayGiaoDuKien(LocalDateTime ngayGiaoDuKien) { this.ngayGiaoDuKien = ngayGiaoDuKien; }

    public LocalDateTime getNgayGiaoThucTe() { return ngayGiaoThucTe; }
    public void setNgayGiaoThucTe(LocalDateTime ngayGiaoThucTe) { this.ngayGiaoThucTe = ngayGiaoThucTe; }

    public String getHoTenKhach() { return hoTenKhach; }
    public void setHoTenKhach(String hoTenKhach) { this.hoTenKhach = hoTenKhach; }

    public List<ChiTietDonHang> getChiTietList() { return chiTietList; }
    public void setChiTietList(List<ChiTietDonHang> chiTietList) { this.chiTietList = chiTietList; }


    /** Dùng trong JSP thay cho fmt:formatDate (không hỗ trợ LocalDateTime) */
    public String getNgayTaoStr() {
        if (ngayTao == null) return "";
        return ngayTao.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getNgayGiaoThucTeStr() {
        if (ngayGiaoThucTe == null) return "";
        return ngayGiaoThucTe.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getNgayGiaoDuKienStr() {
        if (ngayGiaoDuKien == null) return "";
        return ngayGiaoDuKien.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getTrangThaiDHLabel() {
        if (trangThaiDH == null) return "";
        return switch (trangThaiDH) {
            case "moi"        -> "Mới";
            case "xac_nhan"   -> "Đã xác nhận";
            case "dong_goi"   -> "Đang đóng gói";
            case "dang_giao"  -> "Đang giao";
            case "hoan_thanh" -> "Hoàn thành";
            case "huy"        -> "Đã hủy";
            default           -> trangThaiDH;
        };
    }
}
