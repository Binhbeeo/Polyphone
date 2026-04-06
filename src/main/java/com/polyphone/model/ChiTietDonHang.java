package com.polyphone.model;

import java.math.BigDecimal;

public class ChiTietDonHang {
    private int ctDonHangId;
    private int donHangId;
    private int sanPhamId;
    private int soLuong;
    private BigDecimal donGia;

    // Joined
    private String tenSanPham;
    private String anhUrl;

    public ChiTietDonHang() {}

    public int getCtDonHangId() { return ctDonHangId; }
    public void setCtDonHangId(int ctDonHangId) { this.ctDonHangId = ctDonHangId; }

    public int getDonHangId() { return donHangId; }
    public void setDonHangId(int donHangId) { this.donHangId = donHangId; }

    public int getSanPhamId() { return sanPhamId; }
    public void setSanPhamId(int sanPhamId) { this.sanPhamId = sanPhamId; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public BigDecimal getDonGia() { return donGia; }
    public void setDonGia(BigDecimal donGia) { this.donGia = donGia; }

    public String getTenSanPham() { return tenSanPham; }
    public void setTenSanPham(String tenSanPham) { this.tenSanPham = tenSanPham; }

    public String getAnhUrl() { return anhUrl; }
    public void setAnhUrl(String anhUrl) { this.anhUrl = anhUrl; }

    public BigDecimal getThanhTien() {
        if (donGia == null) return BigDecimal.ZERO;
        return donGia.multiply(BigDecimal.valueOf(soLuong));
    }
}
