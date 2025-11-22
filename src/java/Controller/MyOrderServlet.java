package Controller;

import DAO.HoaDonDAO;
import Model.HoaDon;
import Model.NguoiDung;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyOrderServlet", urlPatterns = {"/MyOrderServlet", "/my-orders", "/don-hang-cua-toi"})
public class MyOrderServlet extends HttpServlet {

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
        
        // Lấy danh sách đơn hàng của user
        HoaDonDAO hoaDonDAO = new HoaDonDAO();
        List<HoaDon> orders = hoaDonDAO.getByUserId(user.getMaND());
        
        System.out.println("🔍 MyOrderServlet - Lấy đơn hàng cho user maND=" + user.getMaND());
        System.out.println("   - Số lượng đơn hàng: " + (orders != null ? orders.size() : 0));
        if (orders != null && !orders.isEmpty()) {
            for (HoaDon order : orders) {
                System.out.println("   - Đơn hàng #" + order.getMaHd() + ", ngày: " + order.getNgayLap() + ", tổng tiền: " + order.getTongTien());
            }
        }
        
        // Set attributes để JSP sử dụng
        request.setAttribute("orders", orders);
        request.setAttribute("user", user);
        
        // Forward đến trang danh sách đơn hàng
        request.getRequestDispatcher("/elements/my-order.jsp").forward(request, response);
    }
}

