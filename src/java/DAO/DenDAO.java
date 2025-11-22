package DAO;

import Model.Den;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DenDAO {

    // Helper method để xử lý hinh_anh từ ResultSet (NULL hoặc empty string -> null)
    private String normalizeHinhAnh(String hinhAnh) {
        if (hinhAnh == null || hinhAnh.trim().isEmpty()) {
            return null;
        }
        return hinhAnh.trim();
    }

    public List<Den> getAll() {
        List<Den> list = new ArrayList<>();
        String sql = "SELECT * FROM den";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                System.err.println("❌ Không thể kết nối CSDL (DB null) trong DenDAO.getAll()");
                return list;
            }
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    Integer maNCC = rs.getObject("ma_ncc", Integer.class);
                    list.add(new Den(
                            rs.getInt("ma_den"),
                            rs.getString("ten_den"),
                            rs.getInt("ma_loai"),
                            maNCC,
                            rs.getString("mo_ta"),
                            rs.getDouble("gia"),
                            normalizeHinhAnh(rs.getString("hinh_anh"))
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Den getById(int maDen) throws SQLException {
        String sql = "SELECT * FROM den WHERE ma_den=?";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                System.err.println("❌ Không thể kết nối CSDL (DB null) trong DenDAO.getById()");
                return null;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, maDen);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    Integer maNCC = rs.getObject("ma_ncc", Integer.class);
                    return new Den(
                            rs.getInt("ma_den"),
                            rs.getString("ten_den"),
                            rs.getInt("ma_loai"),
                            maNCC,
                            rs.getString("mo_ta"),
                            rs.getDouble("gia"),
                            normalizeHinhAnh(rs.getString("hinh_anh"))
                    );
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return null;
        }
    }

    public boolean insert(Den den) {
        String sql = "INSERT INTO den(ten_den, ma_loai, ma_ncc, mo_ta, gia, hinh_anh) VALUES(?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                System.err.println("❌ Không thể kết nối CSDL (DB null) trong DenDAO.insert()");
                return false;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, den.getTenDen());
                ps.setInt(2, den.getMaLoai());
                if (den.getMaNCC() != null) {
                    ps.setInt(3, den.getMaNCC());
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setString(4, den.getMoTa());
                ps.setDouble(5, den.getGia());
                ps.setString(6, den.getHinhAnh());
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Den den) {
        String sql = "UPDATE den SET ten_den=?, ma_loai=?, ma_ncc=?, mo_ta=?, gia=?, hinh_anh=? WHERE ma_den=?";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                System.err.println("❌ Không thể kết nối CSDL (DB null) trong DenDAO.update()");
                return false;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, den.getTenDen());
                ps.setInt(2, den.getMaLoai());
                if (den.getMaNCC() != null) {
                    ps.setInt(3, den.getMaNCC());
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setString(4, den.getMoTa());
                ps.setDouble(5, den.getGia());
                ps.setString(6, den.getHinhAnh());
                ps.setInt(7, den.getMaDen());
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void delete(int maDen) {
        String sql = "DELETE FROM den WHERE ma_den=?";
        try (Connection conn = DBConnect.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, maDen);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();

        }
    }

    public String getTenDenById(int maDen) {
        String ten = null;
        String sql = "SELECT ten_den FROM den WHERE ma_den = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maDen);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ten = rs.getString("ten_den");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ten != null ? ten : "Không xác định";
    }
    
    // Tìm kiếm và lọc sản phẩm
    public List<Den> searchAndFilter(String keyword, Integer maLoai, Double minPrice, Double maxPrice, String sortBy, int offset, int limit) {
        List<Den> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM den WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Tìm kiếm theo từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (ten_den LIKE ? OR mo_ta LIKE ?)");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Lọc theo loại đèn
        if (maLoai != null && maLoai > 0) {
            sql.append(" AND ma_loai = ?");
            params.add(maLoai);
        }
        
        // Lọc theo khoảng giá
        if (minPrice != null && minPrice > 0) {
            sql.append(" AND gia >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null && maxPrice > 0) {
            sql.append(" AND gia <= ?");
            params.add(maxPrice);
        }
        
        // Sắp xếp
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "price_asc":
                    sql.append(" ORDER BY gia ASC");
                    break;
                case "price_desc":
                    sql.append(" ORDER BY gia DESC");
                    break;
                case "name_asc":
                    sql.append(" ORDER BY ten_den ASC");
                    break;
                case "name_desc":
                    sql.append(" ORDER BY ten_den DESC");
                    break;
                default:
                    sql.append(" ORDER BY ma_den DESC");
            }
        } else {
            sql.append(" ORDER BY ma_den DESC");
        }
        
        // Phân trang
        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                System.err.println("❌ Không thể kết nối CSDL trong DenDAO.searchAndFilter()");
                return list;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(new Den(
                            rs.getInt("ma_den"),
                            rs.getString("ten_den"),
                            rs.getInt("ma_loai"),
                            rs.getInt("ma_ncc"),
                            rs.getString("mo_ta"),
                            rs.getDouble("gia"),
                            normalizeHinhAnh(rs.getString("hinh_anh"))
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Đếm tổng số sản phẩm sau khi filter
    public int countSearchAndFilter(String keyword, Integer maLoai, Double minPrice, Double maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM den WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (ten_den LIKE ? OR mo_ta LIKE ?)");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (maLoai != null && maLoai > 0) {
            sql.append(" AND ma_loai = ?");
            params.add(maLoai);
        }
        
        if (minPrice != null && minPrice > 0) {
            sql.append(" AND gia >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null && maxPrice > 0) {
            sql.append(" AND gia <= ?");
            params.add(maxPrice);
        }
        
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                return 0;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy sản phẩm theo loại
    public List<Den> getByCategory(int maLoai) {
        List<Den> list = new ArrayList<>();
        String sql = "SELECT * FROM den WHERE ma_loai = ? ORDER BY ma_den DESC";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                return list;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, maLoai);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(new Den(
                            rs.getInt("ma_den"),
                            rs.getString("ten_den"),
                            rs.getInt("ma_loai"),
                            rs.getInt("ma_ncc"),
                            rs.getString("mo_ta"),
                            rs.getDouble("gia"),
                            normalizeHinhAnh(rs.getString("hinh_anh"))
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Lấy sản phẩm mới nhất
    public List<Den> getNewestProducts(int limit) {
        List<Den> list = new ArrayList<>();
        String sql = "SELECT * FROM den ORDER BY ma_den DESC LIMIT ?";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                return list;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, limit);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(new Den(
                            rs.getInt("ma_den"),
                            rs.getString("ten_den"),
                            rs.getInt("ma_loai"),
                            rs.getInt("ma_ncc"),
                            rs.getString("mo_ta"),
                            rs.getDouble("gia"),
                            normalizeHinhAnh(rs.getString("hinh_anh"))
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Lấy sản phẩm nổi bật (sản phẩm có giá cao hoặc mới nhất)
    public List<Den> getFeaturedProducts(int limit) {
        List<Den> list = new ArrayList<>();
        String sql = "SELECT * FROM den ORDER BY gia DESC, ma_den DESC LIMIT ?";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                return list;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, limit);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(new Den(
                            rs.getInt("ma_den"),
                            rs.getString("ten_den"),
                            rs.getInt("ma_loai"),
                            rs.getInt("ma_ncc"),
                            rs.getString("mo_ta"),
                            rs.getDouble("gia"),
                            normalizeHinhAnh(rs.getString("hinh_anh"))
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Lấy sản phẩm bán chạy (dựa vào số lượng đã bán trong chi_tiet_hoa_don)
    public List<Den> getBestSellingProducts(int limit) {
        List<Den> list = new ArrayList<>();
        String sql = "SELECT d.*, COALESCE(SUM(cthd.so_luong), 0) as total_sold " +
                     "FROM den d " +
                     "LEFT JOIN bien_the_den btd ON d.ma_den = btd.ma_den " +
                     "LEFT JOIN chi_tiet_hoa_don cthd ON btd.ma_bien_the = cthd.ma_bien_the " +
                     "GROUP BY d.ma_den " +
                     "ORDER BY total_sold DESC, d.ma_den DESC " +
                     "LIMIT ?";
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                return list;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, limit);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(new Den(
                            rs.getInt("ma_den"),
                            rs.getString("ten_den"),
                            rs.getInt("ma_loai"),
                            rs.getInt("ma_ncc"),
                            rs.getString("mo_ta"),
                            rs.getDouble("gia"),
                            normalizeHinhAnh(rs.getString("hinh_anh"))
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
