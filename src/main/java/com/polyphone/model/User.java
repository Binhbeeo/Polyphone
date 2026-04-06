package com.polyphone.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class User {
    private int userId;
    private String role;        // admin | staff | user
    private String hoTen;
    private String email;
    private String soDienThoai;
    private String matKhauHash;
    private String anhDaiDien;
    private boolean dangHoatDong;
    private boolean trongBlacklist;
    private int diemTichLuy;
    private LocalDateTime ngayTao;
    private LocalDateTime ngayCapNhat;
    private Integer taoBoi;

    public User() {}

    // Getters & Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getMatKhauHash() { return matKhauHash; }
    public void setMatKhauHash(String matKhauHash) { this.matKhauHash = matKhauHash; }

    public String getAnhDaiDien() { return anhDaiDien; }
    public void setAnhDaiDien(String anhDaiDien) { this.anhDaiDien = anhDaiDien; }

    public boolean isDangHoatDong() { return dangHoatDong; }
    public void setDangHoatDong(boolean dangHoatDong) { this.dangHoatDong = dangHoatDong; }

    public boolean isTrongBlacklist() { return trongBlacklist; }
    public void setTrongBlacklist(boolean trongBlacklist) { this.trongBlacklist = trongBlacklist; }

    public int getDiemTichLuy() { return diemTichLuy; }
    public void setDiemTichLuy(int diemTichLuy) { this.diemTichLuy = diemTichLuy; }

    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }

    public LocalDateTime getNgayCapNhat() { return ngayCapNhat; }
    public void setNgayCapNhat(LocalDateTime ngayCapNhat) { this.ngayCapNhat = ngayCapNhat; }

    public Integer getTaoBoi() { return taoBoi; }
    public void setTaoBoi(Integer taoBoi) { this.taoBoi = taoBoi; }

    public String getNgayTaoStr() {
        if (ngayTao == null) return "";
        return ngayTao.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getChuCaiDau() {
        if (hoTen == null || hoTen.isBlank()) return "?";
        return String.valueOf(hoTen.charAt(0)).toUpperCase();
    }
}