package Controller;

import DAO.HoaDonDAO;
import Model.NguoiDung;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ConfirmReceivedServlet", urlPatterns = {"/ConfirmReceivedServlet", "/confirm-received"})
public class ConfirmReceivedServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

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

        String maHdStr = request.getParameter("maHd");
        if (maHdStr == null || maHdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Mã đơn hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/MyOrderServlet");
            return;
        }

        try {
            int maHd = Integer.parseInt(maHdStr);
            HoaDonDAO hoaDonDAO = new HoaDonDAO();
            
            // Kiểm tra đơn hàng có thuộc về user này không
            Model.HoaDon order = hoaDonDAO.getById(maHd);
            if (order == null || order.getMaNd() != user.getMaND()) {
                request.getSession().setAttribute("errorMessage", "Bạn không có quyền xác nhận đơn hàng này!");
                response.sendRedirect(request.getContextPath() + "/MyOrderServlet");
                return;
            }

            // Kiểm tra trạng thái phải là "đã giao"
            String currentStatus = order.getTrangThaiGiaoHang();
            if (currentStatus == null || !currentStatus.contains("đã giao")) {
                request.getSession().setAttribute("errorMessage", "Chỉ có thể xác nhận đơn hàng đã được giao!");
                response.sendRedirect(request.getContextPath() + "/MyOrderServlet");
                return;
            }

            // Cập nhật trạng thái thành "đã nhận"
            boolean success = hoaDonDAO.updateTrangThai(maHd, "đã nhận");
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Xác nhận đã nhận hàng thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái đơn hàng!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Mã đơn hàng không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/MyOrderServlet");
    }
}

