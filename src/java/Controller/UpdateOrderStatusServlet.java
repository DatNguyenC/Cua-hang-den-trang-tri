package Controller;

import DAO.HoaDonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "UpdateOrderStatusServlet", urlPatterns = {"/UpdateOrderStatusServlet", "/update-order-status"})
public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String maHdStr = request.getParameter("maHd");
        String trangThai = request.getParameter("trangThai");

        if (maHdStr == null || trangThai == null || maHdStr.trim().isEmpty() || trangThai.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Thông tin không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
            return;
        }

        try {
            int maHd = Integer.parseInt(maHdStr);
            HoaDonDAO hoaDonDAO = new HoaDonDAO();
            
            boolean success = hoaDonDAO.updateTrangThai(maHd, trangThai.trim());
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Cập nhật trạng thái đơn hàng #" + maHd + " thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái đơn hàng!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Mã đơn hàng không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
    }
}

