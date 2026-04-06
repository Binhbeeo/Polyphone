package com.polyphone.model;

import java.time.LocalDateTime;

public class DanhMuc {
    private int danhMucId;
    private String tenDanhMuc;
    private String moTa;
    private boolean dangHien;
    private LocalDateTime ngayTao;

    public DanhMuc() {}

    public int getDanhMucId() { return danhMucId; }
    public void setDanhMucId(int danhMucId) { this.danhMucId = danhMucId; }
    public String getTenDanhMuc() { return tenDanhMuc; }
    public void setTenDanhMuc(String tenDanhMuc) { this.tenDanhMuc = tenDanhMuc; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    public boolean isDangHien() { return dangHien; }
    public void setDangHien(boolean dangHien) { this.dangHien = dangHien; }
    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }
}
