/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.DenDAO;
import Model.Den;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

/**
 *
 * @author PC
 */
@WebServlet(name = "SuaDenServlet", urlPatterns = {"/sua-den"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class SuaDenServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int maDen = Integer.parseInt(request.getParameter("maDen"));
            String tenDen = request.getParameter("tenDen");
            int maLoai = Integer.parseInt(request.getParameter("maLoai"));
            String maNCCStr = request.getParameter("maNCC");
            Integer maNCC = null;
            if (maNCCStr != null && !maNCCStr.isEmpty()) {
                maNCC = Integer.parseInt(maNCCStr);
            }
            String moTa = request.getParameter("moTa");
            double gia = Double.parseDouble(request.getParameter("gia"));

            // Xử lý ảnh (nếu có upload mới)
            Part filePart = request.getPart("hinhAnh");
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/assets/images/product");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + File.separator + fileName);
            } else {
                // Nếu không upload ảnh mới, giữ nguyên ảnh cũ
                fileName = request.getParameter("oldHinhAnh");
            }

            Den den = new Den();
            den.setMaDen(maDen);
            den.setTenDen(tenDen);
            den.setMaLoai(maLoai);
            den.setMaNCC(maNCC);
            den.setMoTa(moTa);
            den.setGia(gia);
            den.setHinhAnh(fileName);

            DenDAO dao = new DenDAO();
            dao.update(den);

            response.sendRedirect(request.getContextPath() + "/elements/ShopItem.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/elements/ShopItem.jsp?error=update");
        }
    }

}
