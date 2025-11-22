package DAO;

import Model.ChiTietHoaDon;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChiTietHoaDonDAO {

    public List<ChiTietHoaDon> getByHoaDon(int maHD) {
        List<ChiTietHoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM chi_tiet_hoa_don WHERE ma_hd=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maHD);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new ChiTietHoaDon(
                        rs.getInt("ma_cthd"),
                        rs.getInt("ma_hd"),
                        rs.getInt("ma_bien_the"),
                        rs.getInt("so_luong"),
                        rs.getDouble("don_gia"),
                        rs.getDouble("thanh_tien")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(ChiTietHoaDon ct) {
        // Nếu thanh_tien là STORED GENERATED trong database, không cần insert
        // Thử insert không có thanh_tien trước, nếu lỗi thì thử có thanh_tien
        String sql = "INSERT INTO chi_tiet_hoa_don(ma_hd, ma_bien_the, so_luong, don_gia) VALUES(?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ct.getMaHd());
            ps.setInt(2, ct.getMaBienThe());
            ps.setInt(3, ct.getSoLuong());
            ps.setDouble(4, ct.getDonGia());

            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Đã insert chi tiết hóa đơn: maHd=" + ct.getMaHd() + ", maBienThe=" + ct.getMaBienThe() + ", soLuong=" + ct.getSoLuong() + ", donGia=" + ct.getDonGia());
                return true;
            } else {
                System.err.println("❌ Không có dòng nào được insert: maHd=" + ct.getMaHd() + ", maBienThe=" + ct.getMaBienThe());
                return false;
            }

        } catch (SQLException e) {
            System.err.println("❌ SQLException khi insert chi tiết hóa đơn:");
            System.err.println("   - maHd: " + ct.getMaHd());
            System.err.println("   - maBienThe: " + ct.getMaBienThe());
            System.err.println("   - soLuong: " + ct.getSoLuong());
            System.err.println("   - donGia: " + ct.getDonGia());
            System.err.println("   - Error: " + e.getMessage());
            System.err.println("   - SQLState: " + e.getSQLState());
            System.err.println("   - ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Exception khi insert chi tiết hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(ChiTietHoaDon ct) {
        String sql = "UPDATE chi_tiet_hoa_don SET ma_bien_the=?, so_luong=?, don_gia=? WHERE ma_cthd=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ct.getMaBienThe());
            ps.setInt(2, ct.getSoLuong());
            ps.setDouble(3, ct.getDonGia());
            ps.setInt(4, ct.getMaCtHd());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean delete(int maCTHD) {
        String sql = "DELETE FROM chi_tiet_hoa_don WHERE ma_cthd=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maCTHD);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("⚠️ Không thể xóa chi tiết hóa đơn.");
        }
        return false;
    }
}
