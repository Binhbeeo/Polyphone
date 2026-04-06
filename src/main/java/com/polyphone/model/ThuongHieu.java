package com.polyphone.model;

public class ThuongHieu {
    private int thuongHieuId;
    private String tenThuongHieu;
    private String logoUrl;

    public ThuongHieu() {}

    public int getThuongHieuId() { return thuongHieuId; }
    public void setThuongHieuId(int thuongHieuId) { this.thuongHieuId = thuongHieuId; }
    public String getTenThuongHieu() { return tenThuongHieu; }
    public void setTenThuongHieu(String tenThuongHieu) { this.tenThuongHieu = tenThuongHieu; }
    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }
}
