package Controller;

import DAO.*;
import Model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

@WebServlet(name = "CreateOrderServlet", urlPatterns = {"/CreateOrderServlet", "/create-order"})
public class CreateOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String maNdStr = request.getParameter("maNd");
        String ghiChu = request.getParameter("ghiChu");
        String[] maBienTheArray = request.getParameterValues("maBienThe[]");
        String[] soLuongArray = request.getParameterValues("soLuong[]");

        if (maNdStr == null || maNdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Vui lòng chọn khách hàng!");
            response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
            return;
        }

        if (maBienTheArray == null || maBienTheArray.length == 0) {
            request.getSession().setAttribute("errorMessage", "Vui lòng thêm ít nhất một sản phẩm!");
            response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
            return;
        }

        try {
            int maNd = Integer.parseInt(maNdStr);
            
            // Tính tổng tiền
            BienTheDenDAO bienTheDAO = new BienTheDenDAO();
            DenDAO denDAO = new DenDAO();
            double tongTien = 0;
            
            for (int i = 0; i < maBienTheArray.length; i++) {
                if (maBienTheArray[i] != null && !maBienTheArray[i].trim().isEmpty()) {
                    int maBienThe = Integer.parseInt(maBienTheArray[i]);
                    int soLuong = Integer.parseInt(soLuongArray[i]);
                    
                    BienTheDen variant = bienTheDAO.getById(maBienThe);
                    if (variant != null) {
                        Den product = denDAO.getById(variant.getMaDen());
                        if (product != null) {
                            tongTien += product.getGia() * soLuong;
                        }
                    }
                }
            }

            // Tạo hóa đơn
            HoaDon hoaDon = new HoaDon();
            hoaDon.setMaNd(maNd);
            hoaDon.setNgayLap(new Date());
            hoaDon.setTongTien(tongTien);
            hoaDon.setTrangThaiGiaoHang("chờ xử lý");
            
            StringBuilder ghiChuBuilder = new StringBuilder();
            ghiChuBuilder.append("Phương thức thanh toán: Thanh toán trực tiếp tại cửa hàng");
            if (ghiChu != null && !ghiChu.trim().isEmpty()) {
                ghiChuBuilder.append("\nGhi chú: ").append(ghiChu);
            }
            hoaDon.setGhiChu(ghiChuBuilder.toString());

            // Lưu hóa đơn
            HoaDonDAO hoaDonDAO = new HoaDonDAO();
            int maHd = hoaDonDAO.insertAndGetId(hoaDon);

            if (maHd <= 0) {
                request.getSession().setAttribute("errorMessage", "Không thể tạo hóa đơn!");
                response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
                return;
            }

            // Tạo chi tiết hóa đơn
            ChiTietHoaDonDAO chiTietDAO = new ChiTietHoaDonDAO();
            int successCount = 0;

            for (int i = 0; i < maBienTheArray.length; i++) {
                if (maBienTheArray[i] != null && !maBienTheArray[i].trim().isEmpty()) {
                    int maBienThe = Integer.parseInt(maBienTheArray[i]);
                    int soLuong = Integer.parseInt(soLuongArray[i]);
                    
                    BienTheDen variant = bienTheDAO.getById(maBienThe);
                    if (variant != null) {
                        Den product = denDAO.getById(variant.getMaDen());
                        if (product != null) {
                            double donGia = product.getGia();
                            ChiTietHoaDon chiTiet = new ChiTietHoaDon();
                            chiTiet.setMaHd(maHd);
                            chiTiet.setMaBienThe(maBienThe);
                            chiTiet.setSoLuong(soLuong);
                            chiTiet.setDonGia(donGia);
                            chiTiet.setThanhTien(donGia * soLuong);
                            
                            if (chiTietDAO.insert(chiTiet)) {
                                successCount++;
                            }
                        }
                    }
                }
            }

            if (successCount > 0) {
                request.getSession().setAttribute("successMessage", "Tạo hóa đơn #" + maHd + " thành công với " + successCount + " sản phẩm!");
            } else {
                request.getSession().setAttribute("errorMessage", "Tạo hóa đơn thành công nhưng không thể thêm chi tiết!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
    }
}

