package Controller;

import DAO.*;
import Model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/OrderDetailServlet", "/order-detail", "/chi-tiet-don-hang"})
public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/View/userLogin.jsp");
            return;
        }
        
        NguoiDung user = (NguoiDung) session.getAttribute("user");
        if (user == null || (user.getVaiTro() != null && user.getVaiTro().equalsIgnoreCase("admin"))) {
            response.sendRedirect(request.getContextPath() + "/View/userLogin.jsp");
            return;
        }
        
        // Lấy mã hóa đơn từ request
        String maHdStr = request.getParameter("maHd");
        if (maHdStr == null || maHdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/MyOrderServlet");
            return;
        }
        
        int maHd;
        try {
            maHd = Integer.parseInt(maHdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/MyOrderServlet");
            return;
        }
        
        // Lấy thông tin hóa đơn
        HoaDonDAO hoaDonDAO = new HoaDonDAO();
        HoaDon hoaDon = hoaDonDAO.getById(maHd);
        
        if (hoaDon == null) {
            request.setAttribute("error", "Không tìm thấy đơn hàng!");
            request.getRequestDispatcher("/elements/my-order.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra đơn hàng có thuộc về user này không
        if (hoaDon.getMaNd() != user.getMaND()) {
            request.setAttribute("error", "Bạn không có quyền xem đơn hàng này!");
            request.getRequestDispatcher("/elements/my-order.jsp").forward(request, response);
            return;
        }
        
        // Lấy chi tiết hóa đơn
        ChiTietHoaDonDAO chiTietHoaDonDAO = new ChiTietHoaDonDAO();
        List<ChiTietHoaDon> chiTietList = chiTietHoaDonDAO.getByHoaDon(maHd);
        
        // Tạo ViewModel list từ chi tiết hóa đơn
        List<OrderDetailViewModel> orderDetails = new ArrayList<>();
        DenDAO denDAO = new DenDAO();
        BienTheDenDAO bienTheDenDAO = new BienTheDenDAO();
        MauSacDAO mauSacDAO = new MauSacDAO();
        KichThuocDAO kichThuocDAO = new KichThuocDAO();
        
        for (ChiTietHoaDon chiTiet : chiTietList) {
            // Lấy thông tin biến thể
            BienTheDen variant = null;
            if (chiTiet.getMaBienThe() > 0) {
                try {
                    variant = bienTheDenDAO.getById(chiTiet.getMaBienThe());
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi lấy biến thể maBienThe=" + chiTiet.getMaBienThe() + ": " + e.getMessage());
                }
            }
            
            // Lấy thông tin sản phẩm từ biến thể
            Den product = null;
            if (variant != null && variant.getMaDen() > 0) {
                try {
                    product = denDAO.getById(variant.getMaDen());
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi lấy sản phẩm maDen=" + variant.getMaDen() + ": " + e.getMessage());
                }
            }
            
            // Lấy thông tin màu sắc
            MauSac mau = null;
            if (variant != null && variant.getMaMau() != null) {
                try {
                    mau = mauSacDAO.getById(variant.getMaMau());
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi lấy màu sắc maMau=" + variant.getMaMau() + ": " + e.getMessage());
                }
            }
            
            // Lấy thông tin kích thước
            KichThuoc kichThuoc = null;
            if (variant != null && variant.getMaKichThuoc() != null) {
                try {
                    kichThuoc = kichThuocDAO.getById(variant.getMaKichThuoc());
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi lấy kích thước maKichThuoc=" + variant.getMaKichThuoc() + ": " + e.getMessage());
                }
            }
            
            // Tạo ViewModel
            OrderDetailViewModel viewModel = new OrderDetailViewModel(chiTiet, product, variant, mau, kichThuoc);
            orderDetails.add(viewModel);
        }
        
        // Set attributes để JSP sử dụng
        request.setAttribute("hoaDon", hoaDon);
        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("user", user);
        
        // Forward đến trang chi tiết đơn hàng
        request.getRequestDispatcher("/elements/order-detail.jsp").forward(request, response);
    }
}

