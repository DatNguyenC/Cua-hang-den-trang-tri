package Model;

public class ChiTietHoaDon {
    private int maCtHd;
    private int maHd;
    private int maBienThe;
    private int soLuong;
    private double donGia;
    private double thanhTien;

    public ChiTietHoaDon() {
    }

    public ChiTietHoaDon(int maCtHd, int maHd, int maBienThe, int soLuong, double donGia, double thanhTien) {
        this.maCtHd = maCtHd;
        this.maHd = maHd;
        this.maBienThe = maBienThe;
        this.soLuong = soLuong;
        this.donGia = donGia;
        this.thanhTien = thanhTien;
    }

    public int getMaCtHd() {
        return maCtHd;
    }

    public void setMaCtHd(int maCtHd) {
        this.maCtHd = maCtHd;
    }

    public int getMaHd() {
        return maHd;
    }

    public void setMaHd(int maHd) {
        this.maHd = maHd;
    }

    public int getMaBienThe() {
        return maBienThe;
    }

    public void setMaBienThe(int maBienThe) {
        this.maBienThe = maBienThe;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public double getDonGia() {
        return donGia;
    }

    public void setDonGia(double donGia) {
        this.donGia = donGia;
    }

    public double getThanhTien() {
        return thanhTien;
    }

    public void setThanhTien(double thanhTien) {
        this.thanhTien = thanhTien;
    }
}
    