package Controller;

import Model.NguoiDung;
import DAO.NguoiDungDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateUserInfoServlet")
public class UpdateUserInfoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/View/userLogin.jsp");
            return;
        }
        
        String tenDangNhap = request.getParameter("tenDangNhap");
        
        // Kiểm tra dữ liệu
        if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Tên đăng nhập không được để trống");
            response.sendRedirect(request.getContextPath() + "/UserAccountServlet");
            return;
        }
        
        tenDangNhap = tenDangNhap.trim();
        
        // Kiểm tra độ dài tên đăng nhập
        if (tenDangNhap.length() < 3 || tenDangNhap.length() > 50) {
            session.setAttribute("errorMessage", "Tên đăng nhập phải có từ 3 đến 50 ký tự");
            response.sendRedirect(request.getContextPath() + "/UserAccountServlet");
            return;
        }
        
        // Kiểm tra định dạng tên đăng nhập (chỉ cho phép chữ, số, dấu gạch dưới)
        String usernameRegex = "^[a-zA-Z0-9_]+$";
        if (!tenDangNhap.matches(usernameRegex)) {
            session.setAttribute("errorMessage", "Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới");
            response.sendRedirect(request.getContextPath() + "/UserAccountServlet");
            return;
        }
        
        try {
            NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
            boolean success = nguoiDungDAO.updateTenDangNhap(user.getMaND(), tenDangNhap);
            
            if (success) {
                // Cập nhật thông tin trong session
                user.setTenDangNhap(tenDangNhap);
                session.setAttribute("user", user);
                
                // Lưu message vào session để hiển thị sau redirect
                session.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                session.removeAttribute("errorMessage");
            } else {
                session.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại hoặc có lỗi xảy ra");
                session.removeAttribute("successMessage");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            session.removeAttribute("successMessage");
        }
        
        response.sendRedirect(request.getContextPath() + "/UserAccountServlet");
    }
}