package Model;

/**
 * ViewModel cho Chi tiết đơn hàng
 * Kết hợp thông tin từ:
 * - ChiTietHoaDon: số lượng, đơn giá, thành tiền
 * - BienTheDen: màu sắc, kích thước
 * - Den: tên sản phẩm, hình ảnh, mô tả
 * - MauSac, KichThuoc: tên màu, tên kích thước
 */
public class OrderDetailViewModel {
    // Từ ChiTietHoaDon
    private int maCtHd;
    private int maHd;
    private int maBienThe;
    private int soLuong;
    private double donGia;
    private double thanhTien;
    
    // Từ Den (sản phẩm chính)
    private int maDen;
    private String tenDen;
    private String hinhAnh;
    private String moTa;
    
    // Từ BienTheDen (biến thể)
    private Integer maMau;
    private Integer maKichThuoc;
    
    // Từ MauSac và KichThuoc
    private String tenMau;
    private String tenKichThuoc;
    private String maHex; // Mã màu hex để hiển thị

    public OrderDetailViewModel() {
    }

    public OrderDetailViewModel(ChiTietHoaDon chiTiet, Den product, BienTheDen variant, MauSac mau, KichThuoc kichThuoc) {
        // Từ ChiTietHoaDon
        this.maCtHd = chiTiet.getMaCtHd();
        this.maHd = chiTiet.getMaHd();
        this.maBienThe = chiTiet.getMaBienThe();
        this.soLuong = chiTiet.getSoLuong();
        this.donGia = chiTiet.getDonGia();
        this.thanhTien = chiTiet.getThanhTien();
        
        // Từ Den (sản phẩm chính)
        if (product != null) {
            this.maDen = product.getMaDen();
            this.tenDen = product.getTenDen();
            this.hinhAnh = product.getHinhAnh();
            this.moTa = product.getMoTa();
        }
        
        // Từ BienTheDen (biến thể)
        if (variant != null) {
            this.maMau = variant.getMaMau();
            this.maKichThuoc = variant.getMaKichThuoc();
        }
        
        // Từ MauSac
        if (mau != null) {
            this.tenMau = mau.getTenMau();
            this.maHex = mau.getMaHex();
        }
        
        // Từ KichThuoc
        if (kichThuoc != null) {
            this.tenKichThuoc = kichThuoc.getTenKichThuoc();
        }
    }

    // Getters và Setters
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

    public int getMaDen() {
        return maDen;
    }

    public void setMaDen(int maDen) {
        this.maDen = maDen;
    }

    public String getTenDen() {
        return tenDen;
    }

    public void setTenDen(String tenDen) {
        this.tenDen = tenDen;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public Integer getMaMau() {
        return maMau;
    }

    public void setMaMau(Integer maMau) {
        this.maMau = maMau;
    }

    public Integer getMaKichThuoc() {
        return maKichThuoc;
    }

    public void setMaKichThuoc(Integer maKichThuoc) {
        this.maKichThuoc = maKichThuoc;
    }

    public String getTenMau() {
        return tenMau;
    }

    public void setTenMau(String tenMau) {
        this.tenMau = tenMau;
    }

    public String getTenKichThuoc() {
        return tenKichThuoc;
    }

    public void setTenKichThuoc(String tenKichThuoc) {
        this.tenKichThuoc = tenKichThuoc;
    }

    public String getMaHex() {
        return maHex;
    }

    public void setMaHex(String maHex) {
        this.maHex = maHex;
    }
}

