package com.polyphone.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DanhGia {
    private int danhGiaId;
    private int sanPhamId;
    private int userId;
    private int soSao;
    private String nhanXet;
    private boolean dangHien;
    private LocalDateTime ngayTao;
    private Integer anBoi;
    private String lyDoAn;
    private Integer donHangId;

    // Joined
    private String hoTenNguoiDung;
    private String anhDaiDien;

    public DanhGia() {}

    public int getDanhGiaId() { return danhGiaId; }
    public void setDanhGiaId(int danhGiaId) { this.danhGiaId = danhGiaId; }
    public int getSanPhamId() { return sanPhamId; }
    public void setSanPhamId(int sanPhamId) { this.sanPhamId = sanPhamId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getSoSao() { return soSao; }
    public void setSoSao(int soSao) { this.soSao = soSao; }
    public String getNhanXet() { return nhanXet; }
    public void setNhanXet(String nhanXet) { this.nhanXet = nhanXet; }
    public boolean isDangHien() { return dangHien; }
    public void setDangHien(boolean dangHien) { this.dangHien = dangHien; }
    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }
    public Integer getAnBoi() { return anBoi; }
    public void setAnBoi(Integer anBoi) { this.anBoi = anBoi; }
    public String getLyDoAn() { return lyDoAn; }
    public void setLyDoAn(String lyDoAn) { this.lyDoAn = lyDoAn; }
    public Integer getDonHangId() { return donHangId; }
    public void setDonHangId(Integer donHangId) { this.donHangId = donHangId; }
    public String getHoTenNguoiDung() { return hoTenNguoiDung; }
    public void setHoTenNguoiDung(String hoTenNguoiDung) { this.hoTenNguoiDung = hoTenNguoiDung; }
    public String getAnhDaiDien() { return anhDaiDien; }
    public void setAnhDaiDien(String anhDaiDien) { this.anhDaiDien = anhDaiDien; }

    public String getNgayTaoStr() {
        if (ngayTao == null) return "";
        return ngayTao.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}