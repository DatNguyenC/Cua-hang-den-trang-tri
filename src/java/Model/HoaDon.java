package Model;

import java.util.Date;

public class HoaDon {
    private int maHd;
    private int maNd;
    private Date ngayLap;
    private double tongTien;
    private String trangThaiGiaoHang; // chờ xử lý / đang giao / đã giao / hủy / đã nhận
    private String ghiChu;

    public HoaDon() {
    }

    public HoaDon(int maHd, int maNd, Date ngayLap, double tongTien, String trangThaiGiaoHang, String ghiChu) {
        this.maHd = maHd;
        this.maNd = maNd;
        this.ngayLap = ngayLap;
        this.tongTien = tongTien;
        this.trangThaiGiaoHang = trangThaiGiaoHang;
        this.ghiChu = ghiChu;
    }

    public int getMaHd() {
        return maHd;
    }

    public void setMaHd(int maHd) {
        this.maHd = maHd;
    }

    public int getMaNd() {
        return maNd;
    }

    public void setMaNd(int maNd) {
        this.maNd = maNd;
    }

    public Date getNgayLap() {
        return ngayLap;
    }

    public void setNgayLap(Date ngayLap) {
        this.ngayLap = ngayLap;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public String getTrangThaiGiaoHang() {
        return trangThaiGiaoHang;
    }

    public void setTrangThaiGiaoHang(String trangThaiGiaoHang) {
        this.trangThaiGiaoHang = trangThaiGiaoHang;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
