package DAO;

import Model.LoaiDen;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoaiDenDAO {

    public List<LoaiDen> getAll() {
        List<LoaiDen> list = new ArrayList<>();
        String sql = "SELECT * FROM loai_den";
        try (Connection conn = DBConnect.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new LoaiDen(
                        rs.getInt("ma_loai"),
                        rs.getString("ten_loai"),
                        rs.getString("mo_ta")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(LoaiDen loai) {
        String sql = "INSERT INTO loai_den(ten_loai, mo_ta) VALUES(?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loai.getTenLoai());
            ps.setString(2, loai.getMoTa());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(LoaiDen loai) {
        String sql = "UPDATE loai_den SET ten_loai=?, mo_ta=? WHERE ma_loai=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loai.getTenLoai());
            ps.setString(2, loai.getMoTa());
            ps.setInt(3, loai.getMaLoai());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int maLoai) {
        String sql = "DELETE FROM loai_den WHERE ma_loai=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maLoai);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getTenLoaiById(int maLoai) {
        String tenLoai = "";
        String sql = "SELECT ten_loai FROM loai_den WHERE ma_loai = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maLoai);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                tenLoai = rs.getString("ten_loai");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tenLoai;
    }

    // Thêm phương thức kiểm tra sự tồn tại
    public boolean exists(int maLoai) {
        String sql = "SELECT COUNT(*) FROM loai_den WHERE ma_loai = ?";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maLoai);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Đếm số sản phẩm theo danh mục
    public int countProductsByCategory(int maLoai) {
        String sql = "SELECT COUNT(*) FROM den WHERE ma_loai = ?";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maLoai);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}