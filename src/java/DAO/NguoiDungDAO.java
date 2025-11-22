package DAO;

import Model.NguoiDung;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NguoiDungDAO {

    public List<NguoiDung> getAll() {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT * FROM nguoi_dung";
        try (Connection conn = DBConnect.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new NguoiDung(
                        rs.getInt("ma_nd"),
                        rs.getString("ten_dang_nhap"),
                        rs.getString("mat_khau"),
                        rs.getString("email"),
                        rs.getString("vai_tro")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public NguoiDung getByUsername(String username) {
        String sql = "SELECT * FROM nguoi_dung WHERE ten_dang_nhap=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new NguoiDung(
                        rs.getInt("ma_nd"),
                        rs.getString("ten_dang_nhap"),
                        rs.getString("mat_khau"),
                        rs.getString("email"),
                        rs.getString("vai_tro")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public NguoiDung getByEmail(String email) {
        String sql = "SELECT * FROM nguoi_dung WHERE email = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new NguoiDung(
                        rs.getInt("ma_nd"),
                        rs.getString("ten_dang_nhap"),
                        rs.getString("mat_khau"),
                        rs.getString("email"),
                        rs.getString("vai_tro")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(NguoiDung n) {
        String sql = "INSERT INTO nguoi_dung(ten_dang_nhap, mat_khau, email, vai_tro) VALUES(?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            if (conn == null) {
                System.err.println("❌ Lỗi: Không thể kết nối đến database!");
                return false;
            }
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, n.getTenDangNhap());
            ps.setString(2, n.getMatKhau());
            ps.setString(3, n.getEmail());
            
            // Đảm bảo vai_tro không null - nếu null hoặc empty thì mặc định là "customer"
            // Database sử dụng "customer" thay vì "user" để phù hợp với dữ liệu hiện có
            String vaiTro = n.getVaiTro();
            if (vaiTro == null || vaiTro.trim().isEmpty()) {
                vaiTro = "customer"; // Mặc định là customer nếu không được set
            } else {
                // Chuyển về lowercase để đồng nhất
                vaiTro = vaiTro.toLowerCase().trim();
                // Chỉ chấp nhận "admin" hoặc "customer"
                if (!vaiTro.equals("admin") && !vaiTro.equals("customer")) {
                    // Nếu không hợp lệ, mặc định là customer (tránh lỗi database)
                    vaiTro = "customer";
                }
                // Nếu đã được set là "admin" thì giữ nguyên (cho phép admin đăng ký từ AdminRegisterServlet)
            }
            ps.setString(4, vaiTro);
            
            System.out.println("🔍 Thực thi INSERT: ten_dang_nhap=" + n.getTenDangNhap() + ", email=" + n.getEmail() + ", vai_tro=" + vaiTro);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Đăng ký thành công: " + n.getEmail() + " - Vai trò: " + vaiTro);
            } else {
                System.err.println("❌ Không có dòng nào được insert!");
            }
            ps.close();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi SQL khi thêm người dùng:");
            System.err.println("   - SQL State: " + e.getSQLState());
            System.err.println("   - Error Code: " + e.getErrorCode());
            System.err.println("   - Message: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("❌ Lỗi không mong đợi khi thêm người dùng: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("❌ Lỗi đóng connection: " + e.getMessage());
                }
            }
        }
    }

    // SỬA LẠI PHƯƠNG THỨC UPDATE - CHỈ CẬP NHẬT USERNAME VÀ EMAIL
    public boolean update(NguoiDung n) {
        String sql = "UPDATE nguoi_dung SET ten_dang_nhap=?, email=? WHERE ma_nd=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n.getTenDangNhap());
            ps.setString(2, n.getEmail());
            ps.setInt(3, n.getMaND());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật người dùng: " + e.getMessage());
            return false;
        }
    }

    // THÊM PHƯƠNG THỨC UPDATE ĐẦY ĐỦ (NẾU CẦN)
    public boolean updateFull(NguoiDung n) {
        String sql = "UPDATE nguoi_dung SET ten_dang_nhap=?, mat_khau=?, email=?, vai_tro=? WHERE ma_nd=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n.getTenDangNhap());
            ps.setString(2, n.getMatKhau());
            ps.setString(3, n.getEmail());
            ps.setString(4, n.getVaiTro());
            ps.setInt(5, n.getMaND());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật người dùng: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int maND) {
        String sql = "DELETE FROM nguoi_dung WHERE ma_nd=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maND);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("⚠️ Không thể xóa người dùng đang có đánh giá hoặc dữ liệu liên quan.");
            return false;
        }
    }

    public NguoiDung checkLogin(String email, String password) {
        String sql = "SELECT * FROM nguoi_dung WHERE email = ? AND mat_khau = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new NguoiDung(
                        rs.getInt("ma_nd"),
                        rs.getString("ten_dang_nhap"),
                        rs.getString("mat_khau"),
                        rs.getString("email"),
                        rs.getString("vai_tro")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
   public boolean updateUserEmail(int maND, String email) {
        String sql = "UPDATE nguoi_dung SET email = ? WHERE ma_nd = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setInt(2, maND);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateTenDangNhap(int maND, String tenDangNhap) {
        // Kiểm tra tên đăng nhập đã tồn tại chưa (trừ chính user hiện tại)
        String checkSql = "SELECT COUNT(*) FROM nguoi_dung WHERE ten_dang_nhap = ? AND ma_nd != ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            
            checkStmt.setString(1, tenDangNhap);
            checkStmt.setInt(2, maND);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Tên đăng nhập đã tồn tại
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        // Cập nhật tên đăng nhập
        String sql = "UPDATE nguoi_dung SET ten_dang_nhap = ? WHERE ma_nd = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tenDangNhap);
            pstmt.setInt(2, maND);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateUserInfo(int maND, String tenDangNhap, String email) {
        // Kiểm tra tên đăng nhập đã tồn tại chưa (trừ chính user hiện tại)
        String checkSql = "SELECT COUNT(*) FROM nguoi_dung WHERE ten_dang_nhap = ? AND ma_nd != ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            
            checkStmt.setString(1, tenDangNhap);
            checkStmt.setInt(2, maND);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Tên đăng nhập đã tồn tại
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        // Cập nhật cả tên đăng nhập và email
        String sql = "UPDATE nguoi_dung SET ten_dang_nhap = ?, email = ? WHERE ma_nd = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tenDangNhap);
            pstmt.setString(2, email);
            pstmt.setInt(3, maND);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean checkCurrentPassword(int maND, String currentPassword) {
        String sql = "SELECT mat_khau FROM nguoi_dung WHERE ma_nd = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, maND);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("mat_khau");
                return storedPassword.equals(currentPassword);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updatePassword(int maND, String newPassword) {
        String sql = "UPDATE nguoi_dung SET mat_khau = ? WHERE ma_nd = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, maND);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // THÊM PHƯƠNG THỨC LẤY USER THEO ID
    public NguoiDung getById(int maND) {
        String sql = "SELECT * FROM nguoi_dung WHERE ma_nd=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maND);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new NguoiDung(
                        rs.getInt("ma_nd"),
                        rs.getString("ten_dang_nhap"),
                        rs.getString("mat_khau"),
                        rs.getString("email"),
                        rs.getString("vai_tro")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}