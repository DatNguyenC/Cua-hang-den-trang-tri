package DAO;

import Model.HoaDon;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HoaDonDAO {

    public List<HoaDon> getAll() {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don ORDER BY ma_hd DESC";

        try (Connection conn = DBConnect.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(new HoaDon(
                        rs.getInt("ma_hd"),
                        rs.getInt("ma_nd"),
                        rs.getTimestamp("ngay_lap"),
                        rs.getDouble("tong_tien"),
                        rs.getString("trang_thai_giao_hang"),
                        rs.getString("ghi_chu")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public HoaDon getById(int maHD) {
        String sql = "SELECT * FROM hoa_don WHERE ma_hd=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maHD);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new HoaDon(
                        rs.getInt("ma_hd"),
                        rs.getInt("ma_nd"),
                        rs.getTimestamp("ngay_lap"),
                        rs.getDouble("tong_tien"),
                        rs.getString("trang_thai_giao_hang"),
                        rs.getString("ghi_chu")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<HoaDon> getByUserId(int maND) {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don WHERE ma_nd=? ORDER BY ma_hd DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maND);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new HoaDon(
                        rs.getInt("ma_hd"),
                        rs.getInt("ma_nd"),
                        rs.getTimestamp("ngay_lap"),
                        rs.getDouble("tong_tien"),
                        rs.getString("trang_thai_giao_hang"),
                        rs.getString("ghi_chu")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(HoaDon hd) {
        String sql = "INSERT INTO hoa_don(ma_nd, ngay_lap, tong_tien, trang_thai_giao_hang, ghi_chu) VALUES(?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, hd.getMaNd());
            ps.setTimestamp(2, new Timestamp(hd.getNgayLap().getTime()));
            ps.setDouble(3, hd.getTongTien());
            ps.setString(4, hd.getTrangThaiGiaoHang());
            ps.setString(5, hd.getGhiChu());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int insertAndGetId(HoaDon hd) {
        String sql = "INSERT INTO hoa_don(ma_nd, ngay_lap, tong_tien, trang_thai_giao_hang, ghi_chu) VALUES(?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, hd.getMaNd());
            ps.setTimestamp(2, new Timestamp(hd.getNgayLap().getTime()));
            ps.setDouble(3, hd.getTongTien());
            ps.setString(4, hd.getTrangThaiGiaoHang());
            ps.setString(5, hd.getGhiChu());

            System.out.println("🔍 Đang insert hóa đơn:");
            System.out.println("   - maNd: " + hd.getMaNd());
            System.out.println("   - ngayLap: " + hd.getNgayLap());
            System.out.println("   - tongTien: " + hd.getTongTien());
            System.out.println("   - trangThai: " + hd.getTrangThaiGiaoHang());
            System.out.println("   - ghiChu length: " + (hd.getGhiChu() != null ? hd.getGhiChu().length() : 0));

            int affectedRows = ps.executeUpdate();
            System.out.println("✅ Affected rows: " + affectedRows);
            
            if (affectedRows > 0) {
                // Thử lấy generated key trước
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int maHd = generatedKeys.getInt(1);
                        System.out.println("✅ Đã tạo hóa đơn thành công (từ generated key): maHd=" + maHd);
                        return maHd;
                    }
                }
                
                // Nếu không có generated key, thử lấy ID từ query
                String selectSql = "SELECT ma_hd FROM hoa_don WHERE ma_nd = ? AND ngay_lap = ? ORDER BY ma_hd DESC LIMIT 1";
                try (PreparedStatement selectPs = conn.prepareStatement(selectSql)) {
                    selectPs.setInt(1, hd.getMaNd());
                    selectPs.setTimestamp(2, new Timestamp(hd.getNgayLap().getTime()));
                    try (ResultSet rs = selectPs.executeQuery()) {
                        if (rs.next()) {
                            int maHd = rs.getInt("ma_hd");
                            System.out.println("✅ Đã tạo hóa đơn thành công (từ query): maHd=" + maHd);
                            return maHd;
                        }
                    }
                }
                
                System.err.println("❌ Không lấy được ma_hd sau khi insert!");
            } else {
                System.err.println("❌ Không có dòng nào được insert!");
            }

        } catch (SQLException e) {
            System.err.println("❌ SQLException khi insert hóa đơn:");
            System.err.println("   - Error: " + e.getMessage());
            System.err.println("   - SQLState: " + e.getSQLState());
            System.err.println("   - ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Exception khi insert hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public boolean update(HoaDon hd) {
        String sql = "UPDATE hoa_don SET ma_nd=?, ngay_lap=?, tong_tien=?, trang_thai_giao_hang=?, ghi_chu=? WHERE ma_hd=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, hd.getMaNd());
            ps.setTimestamp(2, new Timestamp(hd.getNgayLap().getTime()));
            ps.setDouble(3, hd.getTongTien());
            ps.setString(4, hd.getTrangThaiGiaoHang());
            ps.setString(5, hd.getGhiChu());
            ps.setInt(6, hd.getMaHd());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateTrangThai(int maHD, String trangThai) {
        String sql = "UPDATE hoa_don SET trang_thai_giao_hang=? WHERE ma_hd=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trangThai);
            ps.setInt(2, maHD);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int maHD) {
        String sql = "DELETE FROM hoa_don WHERE ma_hd=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maHD);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("⚠️ Không thể xóa hóa đơn vì có chi tiết hóa đơn liên quan.");
        }
        return false;
    }
}
