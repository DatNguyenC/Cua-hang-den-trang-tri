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
import java.util.Date;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/CheckoutServlet", "/checkout", "/thanh-toan"})
public class CheckoutServlet extends HttpServlet {

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
        
        // Lấy giỏ hàng từ session
        GioHang cart = (GioHang) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            // Nếu giỏ hàng trống, chuyển về trang giỏ hàng
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }
        
        // Tạo ViewModel list từ giỏ hàng
        List<CartItemViewModel> cartItems = new ArrayList<>();
        DenDAO denDAO = new DenDAO();
        BienTheDenDAO bienTheDenDAO = new BienTheDenDAO();
        MauSacDAO mauSacDAO = new MauSacDAO();
        KichThuocDAO kichThuocDAO = new KichThuocDAO();
        
        for (GioHangItem item : cart.getItems()) {
            Den product = null;
            try {
                product = denDAO.getById(item.getMaDen());
            } catch (Exception e) {
                System.err.println("❌ Lỗi khi lấy sản phẩm maDen=" + item.getMaDen() + ": " + e.getMessage());
            }
            
            BienTheDen variant = null;
            if (item.getMaBienThe() != null) {
                try {
                    variant = bienTheDenDAO.getById(item.getMaBienThe());
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi lấy biến thể maBienThe=" + item.getMaBienThe() + ": " + e.getMessage());
                }
            }
            
            MauSac mau = null;
            if (variant != null && variant.getMaMau() != null) {
                try {
                    mau = mauSacDAO.getById(variant.getMaMau());
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi lấy màu sắc maMau=" + variant.getMaMau() + ": " + e.getMessage());
                }
            }
            
            KichThuoc kichThuoc = null;
            if (variant != null && variant.getMaKichThuoc() != null) {
                try {
                    kichThuoc = kichThuocDAO.getById(variant.getMaKichThuoc());
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi lấy kích thước maKichThuoc=" + variant.getMaKichThuoc() + ": " + e.getMessage());
                }
            }
            
            CartItemViewModel viewModel = new CartItemViewModel(item, product, variant, mau, kichThuoc);
            cartItems.add(viewModel);
        }
        
        // Set attributes để JSP sử dụng
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cart", cart);
        request.setAttribute("user", user);
        
        // Forward đến trang thanh toán
        request.getRequestDispatcher("/elements/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
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
        
        // Lấy giỏ hàng từ session
        GioHang cart = (GioHang) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Giỏ hàng của bạn đang trống!");
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }
        
        // Lấy thông tin từ form
        String hoTen = request.getParameter("hoTen");
        String soDienThoai = request.getParameter("soDienThoai");
        String diaChi = request.getParameter("diaChi");
        String ghiChu = request.getParameter("ghiChu");
        String phuongThucThanhToan = request.getParameter("phuongThucThanhToan");
        
        // Validate
        if (hoTen == null || hoTen.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập họ tên!");
            doGet(request, response);
            return;
        }
        
        if (soDienThoai == null || soDienThoai.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập số điện thoại!");
            doGet(request, response);
            return;
        }
        
        if (diaChi == null || diaChi.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ giao hàng!");
            doGet(request, response);
            return;
        }
        
        if (phuongThucThanhToan == null || phuongThucThanhToan.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn phương thức thanh toán!");
            doGet(request, response);
            return;
        }
        
        // Tạo hóa đơn
        HoaDon hoaDon = new HoaDon();
        hoaDon.setMaNd(user.getMaND());
        hoaDon.setNgayLap(new Date());
        hoaDon.setTongTien(cart.getTotalPrice());
        hoaDon.setTrangThaiGiaoHang("chờ xử lý");
        
        // Xác định phương thức thanh toán
        String phuongThucText = "1".equals(phuongThucThanhToan) ? "Thanh toán online / Chuyển khoản" : "Thanh toán khi nhận hàng (COD)";
        
        // Tạo ghi chú từ thông tin giao hàng
        StringBuilder ghiChuBuilder = new StringBuilder();
        ghiChuBuilder.append("Họ tên: ").append(hoTen).append("\n");
        ghiChuBuilder.append("Số điện thoại: ").append(soDienThoai).append("\n");
        ghiChuBuilder.append("Địa chỉ: ").append(diaChi).append("\n");
        ghiChuBuilder.append("Phương thức thanh toán: ").append(phuongThucText);
        if (ghiChu != null && !ghiChu.trim().isEmpty()) {
            ghiChuBuilder.append("\nGhi chú: ").append(ghiChu);
        }
        hoaDon.setGhiChu(ghiChuBuilder.toString());
        
        // Lưu hóa đơn vào database
        HoaDonDAO hoaDonDAO = new HoaDonDAO();
        int maHd = hoaDonDAO.insertAndGetId(hoaDon);
        
        if (maHd <= 0) {
            request.setAttribute("error", "Có lỗi xảy ra khi tạo đơn hàng. Vui lòng thử lại!");
            doGet(request, response);
            return;
        }
        
        // Tạo chi tiết hóa đơn
        ChiTietHoaDonDAO chiTietHoaDonDAO = new ChiTietHoaDonDAO();
        BienTheDenDAO bienTheDenDAO = new BienTheDenDAO();
        int successCount = 0;
        int totalItems = cart.getItems().size();
        
        System.out.println("🔍 Bắt đầu tạo chi tiết hóa đơn:");
        System.out.println("   - maHd: " + maHd);
        System.out.println("   - Tổng số items trong giỏ: " + totalItems);
        
        for (GioHangItem item : cart.getItems()) {
            System.out.println("\n🔍 Xử lý item:");
            System.out.println("   - maDen: " + item.getMaDen());
            System.out.println("   - maBienThe: " + item.getMaBienThe());
            System.out.println("   - maMau: " + item.getMaMau());
            System.out.println("   - maKichThuoc: " + item.getMaKichThuoc());
            System.out.println("   - soLuong: " + item.getSoLuong());
            System.out.println("   - gia: " + item.getGia());
            System.out.println("   - key: " + item.getKey());
            ChiTietHoaDon chiTiet = new ChiTietHoaDon();
            chiTiet.setMaHd(maHd);
            
            // Lấy maBienThe từ item
            Integer maBienThe = item.getMaBienThe();
            if (maBienThe == null || maBienThe == 0) {
                // Nếu không có maBienThe, thử tìm biến thể dựa trên maDen, maMau, maKichThuoc
                System.err.println("⚠️ Item không có maBienThe, thử tìm biến thể: maDen=" + item.getMaDen() + ", maMau=" + item.getMaMau() + ", maKichThuoc=" + item.getMaKichThuoc());
                
                try {
                    // Tìm biến thể dựa trên maDen, maMau, maKichThuoc
                    BienTheDen variant = bienTheDenDAO.findByMaDenAndVariant(
                        item.getMaDen(), 
                        item.getMaMau(), 
                        item.getMaKichThuoc()
                    );
                    
                    if (variant != null) {
                        maBienThe = variant.getMaBienThe();
                        System.out.println("✅ Tìm thấy biến thể: maBienThe=" + maBienThe);
                    } else {
                        System.err.println("❌ Không tìm thấy biến thể cho item: " + item.getKey());
                        continue;
                    }
                } catch (Exception e) {
                    System.err.println("❌ Lỗi khi tìm biến thể: " + e.getMessage());
                    e.printStackTrace();
                    continue;
                }
            }
            
            // Validate maBienThe có tồn tại không
            try {
                BienTheDen checkVariant = bienTheDenDAO.getById(maBienThe);
                if (checkVariant == null) {
                    System.err.println("❌ maBienThe không tồn tại trong database: " + maBienThe);
                    System.err.println("   - Thử tìm lại với maDen=" + item.getMaDen() + ", maMau=" + item.getMaMau() + ", maKichThuoc=" + item.getMaKichThuoc());
                    // Thử tìm lại
                    BienTheDen retryVariant = bienTheDenDAO.findByMaDenAndVariant(
                        item.getMaDen(), 
                        item.getMaMau(), 
                        item.getMaKichThuoc()
                    );
                    if (retryVariant != null) {
                        maBienThe = retryVariant.getMaBienThe();
                        System.out.println("✅ Tìm lại thành công: maBienThe=" + maBienThe);
                    } else {
                        System.err.println("❌ Không tìm thấy biến thể sau khi retry");
                        continue;
                    }
                } else {
                    System.out.println("✅ Đã xác nhận maBienThe tồn tại: " + maBienThe);
                    System.out.println("   - maDen: " + checkVariant.getMaDen());
                    System.out.println("   - maMau: " + checkVariant.getMaMau());
                    System.out.println("   - maKichThuoc: " + checkVariant.getMaKichThuoc());
                }
            } catch (Exception e) {
                System.err.println("❌ Lỗi khi kiểm tra maBienThe: " + e.getMessage());
                e.printStackTrace();
                continue;
            }
            
            chiTiet.setMaBienThe(maBienThe);
            chiTiet.setSoLuong(item.getSoLuong());
            chiTiet.setDonGia(item.getGia());
            chiTiet.setThanhTien(item.getTongTien());
            
            System.out.println("🔍 Đang tạo chi tiết hóa đơn:");
            System.out.println("   - maHd: " + maHd);
            System.out.println("   - maBienThe: " + maBienThe);
            System.out.println("   - soLuong: " + item.getSoLuong());
            System.out.println("   - donGia: " + item.getGia());
            
            try {
                if (chiTietHoaDonDAO.insert(chiTiet)) {
                    successCount++;
                    System.out.println("✅ Đã tạo chi tiết hóa đơn thành công: maBienThe=" + maBienThe + ", soLuong=" + item.getSoLuong());
                } else {
                    System.err.println("❌ Lỗi khi tạo chi tiết hóa đơn cho item: " + item.getKey());
                }
            } catch (Exception e) {
                System.err.println("❌ Exception khi tạo chi tiết hóa đơn: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // Kiểm tra nếu không có chi tiết nào được tạo
        if (successCount == 0) {
            // Xóa hóa đơn vừa tạo vì không có chi tiết
            hoaDonDAO.delete(maHd);
            request.setAttribute("error", "Không thể tạo chi tiết đơn hàng. Vui lòng kiểm tra lại giỏ hàng và thử lại!");
            doGet(request, response);
            return;
        }
        
        // Nếu chỉ một phần chi tiết được tạo
        if (successCount < totalItems) {
            System.err.println("⚠️ Chỉ tạo được " + successCount + "/" + totalItems + " chi tiết hóa đơn!");
        }
        
        // Xóa giỏ hàng sau khi đặt hàng thành công
        cart.clear();
        session.setAttribute("cart", cart);
        
        // Chuyển đến trang danh sách đơn hàng với thông báo thành công
        response.sendRedirect(request.getContextPath() + "/MyOrderServlet?success=true&maHd=" + maHd);
    }
}

