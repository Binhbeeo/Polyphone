package com.polyphone.model;

import java.math.BigDecimal;

public class GioHang {
    private int ctGioHangId;
    private int userId;
    private int sanPhamId;
    private int soLuong;

    // Joined
    private String tenSanPham;
    private BigDecimal gia;
    private String anhUrl;
    private int tonKho;

    public GioHang() {}

    public int getCtGioHangId() { return ctGioHangId; }
    public void setCtGioHangId(int ctGioHangId) { this.ctGioHangId = ctGioHangId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getSanPhamId() { return sanPhamId; }
    public void setSanPhamId(int sanPhamId) { this.sanPhamId = sanPhamId; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public String getTenSanPham() { return tenSanPham; }
    public void setTenSanPham(String tenSanPham) { this.tenSanPham = tenSanPham; }
    public BigDecimal getGia() { return gia; }
    public void setGia(BigDecimal gia) { this.gia = gia; }
    public String getAnhUrl() { return anhUrl; }
    public void setAnhUrl(String anhUrl) { this.anhUrl = anhUrl; }
    public int getTonKho() { return tonKho; }
    public void setTonKho(int tonKho) { this.tonKho = tonKho; }

    public BigDecimal getThanhTien() {
        if (gia == null) return BigDecimal.ZERO;
        return gia.multiply(BigDecimal.valueOf(soLuong));
    }
}
