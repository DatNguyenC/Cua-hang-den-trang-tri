package Controller;

import Model.NguoiDung;
import DAO.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UserChangePasswordServlet", urlPatterns = {"/UserChangePasswordServlet", "/change-password", "/doi-mat-khau"})
public class UserChangePasswordServlet extends HttpServlet {

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
        
        // Lấy thông báo từ request
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
        
        // Set attributes để JSP sử dụng
        request.setAttribute("user", user);
        request.setAttribute("successMessage", successMessage);
        request.setAttribute("errorMessage", errorMessage);
        
        // Forward đến trang đổi mật khẩu
        request.getRequestDispatcher("/elements/change-password.jsp").forward(request, response);
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
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin");
            doGet(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu mới và xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp");
            doGet(request, response);
            return;
        }
        
        // Kiểm tra độ dài mật khẩu mới
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự");
            doGet(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu mới không được trùng với mật khẩu cũ
        if (currentPassword.equals(newPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải khác mật khẩu hiện tại");
            doGet(request, response);
            return;
        }
        
        try {
            NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
            
            // Kiểm tra mật khẩu hiện tại
            if (!nguoiDungDAO.checkCurrentPassword(user.getMaND(), currentPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng");
                doGet(request, response);
                return;
            }
            
            // Cập nhật mật khẩu mới
            boolean success = nguoiDungDAO.updatePassword(user.getMaND(), newPassword);
            
            if (success) {
                // Cập nhật thông tin trong session
                user.setMatKhau(newPassword);
                session.setAttribute("user", user);
                
                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi đổi mật khẩu");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}

