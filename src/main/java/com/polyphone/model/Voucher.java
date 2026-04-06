package com.polyphone.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Voucher {
    private int voucherId;
    private String maVoucher;
    private String loaiGiam;       // phan_tram | co_dinh
    private BigDecimal giaTriGiam;
    private BigDecimal donHangToiThieu;
    private int soLuotDungToiDa;
    private int daDung;
    private LocalDateTime hetHan;
    private LocalDateTime ngayBatDau;
    private boolean dangHoatDong;
    private LocalDateTime ngayTao;

    public Voucher() {}

    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }
    public String getMaVoucher() { return maVoucher; }
    public void setMaVoucher(String maVoucher) { this.maVoucher = maVoucher; }
    public String getLoaiGiam() { return loaiGiam; }
    public void setLoaiGiam(String loaiGiam) { this.loaiGiam = loaiGiam; }
    public BigDecimal getGiaTriGiam() { return giaTriGiam; }
    public void setGiaTriGiam(BigDecimal giaTriGiam) { this.giaTriGiam = giaTriGiam; }
    public BigDecimal getDonHangToiThieu() { return donHangToiThieu; }
    public void setDonHangToiThieu(BigDecimal donHangToiThieu) { this.donHangToiThieu = donHangToiThieu; }
    public int getSoLuotDungToiDa() { return soLuotDungToiDa; }
    public void setSoLuotDungToiDa(int soLuotDungToiDa) { this.soLuotDungToiDa = soLuotDungToiDa; }
    public int getDaDung() { return daDung; }
    public void setDaDung(int daDung) { this.daDung = daDung; }
    public LocalDateTime getHetHan() { return hetHan; }
    public void setHetHan(LocalDateTime hetHan) { this.hetHan = hetHan; }
    public LocalDateTime getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(LocalDateTime ngayBatDau) { this.ngayBatDau = ngayBatDau; }
    public boolean isDangHoatDong() { return dangHoatDong; }
    public void setDangHoatDong(boolean dangHoatDong) { this.dangHoatDong = dangHoatDong; }
    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }

    public boolean isConLuot() { return daDung < soLuotDungToiDa; }
    public boolean isChuaHetHan() {
        return hetHan == null || hetHan.isAfter(LocalDateTime.now());
    }
    public boolean isChuaBatDau() {
        return ngayBatDau != null && ngayBatDau.isAfter(LocalDateTime.now());
    }
    public boolean isHopLe() {
        return dangHoatDong && isConLuot() && isChuaHetHan() && !isChuaBatDau();
    }
}
