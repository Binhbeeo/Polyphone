package com.polyphone.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class KhieuNai {
    private int khieuNaiId;
    private int userId;
    private Integer donHangId;
    private String tieuDe;
    private String noiDung;
    private String trangThai;     // cho_xu_ly | dang_xu_ly | da_xu_ly
    private Integer nguoiXuLy;
    private String phanHoi;
    private LocalDateTime ngayTao;
    private LocalDateTime ngayCapNhat;

    // Joined
    private String hoTenKhach;
    private String hoTenNhanVien;

    public KhieuNai() {}

    public int getKhieuNaiId() { return khieuNaiId; }
    public void setKhieuNaiId(int khieuNaiId) { this.khieuNaiId = khieuNaiId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public Integer getDonHangId() { return donHangId; }
    public void setDonHangId(Integer donHangId) { this.donHangId = donHangId; }
    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }
    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    public Integer getNguoiXuLy() { return nguoiXuLy; }
    public void setNguoiXuLy(Integer nguoiXuLy) { this.nguoiXuLy = nguoiXuLy; }
    public String getPhanHoi() { return phanHoi; }
    public void setPhanHoi(String phanHoi) { this.phanHoi = phanHoi; }
    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }
    public LocalDateTime getNgayCapNhat() { return ngayCapNhat; }
    public void setNgayCapNhat(LocalDateTime ngayCapNhat) { this.ngayCapNhat = ngayCapNhat; }
    public String getHoTenKhach() { return hoTenKhach; }
    public void setHoTenKhach(String hoTenKhach) { this.hoTenKhach = hoTenKhach; }
    public String getHoTenNhanVien() { return hoTenNhanVien; }
    public void setHoTenNhanVien(String hoTenNhanVien) { this.hoTenNhanVien = hoTenNhanVien; }

    public String getTrangThaiLabel() {
        if (trangThai == null) return "";
        return switch (trangThai) {
            case "cho_xu_ly"  -> "Chờ xử lý";
            case "dang_xu_ly" -> "Đang xử lý";
            case "da_xu_ly"   -> "Đã xử lý";
            default           -> trangThai;
        };
    }

    public String getNgayTaoStr() {
        if (ngayTao == null) return "";
        return ngayTao.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}