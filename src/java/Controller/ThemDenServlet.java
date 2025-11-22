package Controller;

import DAO.DenDAO;
import Model.Den;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "ThemDenServlet", urlPatterns = {"/them-den"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ThemDenServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String tenDen = request.getParameter("tenDen");
            String maLoaiStr = request.getParameter("maLoai");
            String maNCCStr = request.getParameter("maNCC");
            String moTa = request.getParameter("moTa");
            String giaStr = request.getParameter("gia");

            int maLoai = Integer.parseInt(maLoaiStr);
            Integer maNCC = null;
            if (maNCCStr != null && !maNCCStr.isEmpty()) {
                maNCC = Integer.parseInt(maNCCStr);
            }
            double gia = Double.parseDouble(giaStr);

            // Xử lý upload ảnh
            Part filePart = request.getPart("hinhAnh");
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                // Đường dẫn lưu ảnh (ví dụ: webapp/assets/images/product/)
                String uploadPath = getServletContext().getRealPath("/assets/images/product");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
            }

            // Tạo đối tượng Đèn
            Den den = new Den();
            den.setTenDen(tenDen);
            den.setMaLoai(maLoai);
            den.setMaNCC(maNCC);
            den.setMoTa(moTa);
            den.setGia(gia);
            den.setHinhAnh(fileName);

            // Thêm vào DB qua DAO
            DenDAO dao = new DenDAO();
            dao.insert(den);

            // Quay lại trang danh sách
            response.sendRedirect(request.getContextPath() + "/elements/ShopItem.jsp");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/elements/ShopItem.jsp?error=1");
        }
    }
}
