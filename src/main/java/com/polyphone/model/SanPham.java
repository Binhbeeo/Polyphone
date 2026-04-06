package com.polyphone.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class SanPham {
    private int sanPhamId;
    private int danhMucId;
    private Integer thuongHieuId;
    private String tenSanPham;
    private String moTa;
    private BigDecimal gia;
    private int tonKho;
    private boolean dangBan;
    private LocalDateTime ngayTao;
    private LocalDateTime ngayCapNhat;

    // Joined fields
    private String tenDanhMuc;
    private String tenThuongHieu;
    private List<String> anhUrls;
    private double avgSoSao;
    private int soLuongDanhGia;

    public SanPham() {}

    // Getters & Setters
    public int getSanPhamId() { return sanPhamId; }
    public void setSanPhamId(int sanPhamId) { this.sanPhamId = sanPhamId; }

    public int getDanhMucId() { return danhMucId; }
    public void setDanhMucId(int danhMucId) { this.danhMucId = danhMucId; }

    public Integer getThuongHieuId() { return thuongHieuId; }
    public void setThuongHieuId(Integer thuongHieuId) { this.thuongHieuId = thuongHieuId; }

    public String getTenSanPham() { return tenSanPham; }
    public void setTenSanPham(String tenSanPham) { this.tenSanPham = tenSanPham; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public BigDecimal getGia() { return gia; }
    public void setGia(BigDecimal gia) { this.gia = gia; }

    public int getTonKho() { return tonKho; }
    public void setTonKho(int tonKho) { this.tonKho = tonKho; }

    public boolean isDangBan() { return dangBan; }
    public void setDangBan(boolean dangBan) { this.dangBan = dangBan; }

    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }

    public LocalDateTime getNgayCapNhat() { return ngayCapNhat; }
    public void setNgayCapNhat(LocalDateTime ngayCapNhat) { this.ngayCapNhat = ngayCapNhat; }

    public String getTenDanhMuc() { return tenDanhMuc; }
    public void setTenDanhMuc(String tenDanhMuc) { this.tenDanhMuc = tenDanhMuc; }

    public String getTenThuongHieu() { return tenThuongHieu; }
    public void setTenThuongHieu(String tenThuongHieu) { this.tenThuongHieu = tenThuongHieu; }

    public List<String> getAnhUrls() { return anhUrls; }
    public void setAnhUrls(List<String> anhUrls) { this.anhUrls = anhUrls; }

    public double getAvgSoSao() { return avgSoSao; }
    public void setAvgSoSao(double avgSoSao) { this.avgSoSao = avgSoSao; }

    public int getSoLuongDanhGia() { return soLuongDanhGia; }
    public void setSoLuongDanhGia(int soLuongDanhGia) { this.soLuongDanhGia = soLuongDanhGia; }

    public String getAnhDaiDien() {
        if (anhUrls != null && !anhUrls.isEmpty()) return anhUrls.get(0);
        return "images/no-image.png";
    }
}
