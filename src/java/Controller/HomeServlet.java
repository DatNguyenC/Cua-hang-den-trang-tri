package Controller;

import DAO.DenDAO;
import DAO.LoaiDenDAO;
import Model.Den;
import Model.LoaiDen;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HomeServlet", urlPatterns = {"/HomeServlet", "/home", "/trang-chu"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        DenDAO denDAO = new DenDAO();
        LoaiDenDAO loaiDenDAO = new LoaiDenDAO();
        
        // Lấy danh mục sản phẩm
        List<LoaiDen> categories = loaiDenDAO.getAll();
        
        // Đếm số sản phẩm theo từng danh mục
        Map<Integer, Integer> categoryProductCount = new HashMap<>();
        for (LoaiDen category : categories) {
            int count = loaiDenDAO.countProductsByCategory(category.getMaLoai());
            categoryProductCount.put(category.getMaLoai(), count);
        }
        
        // Lấy sản phẩm nổi bật (8 sản phẩm)
        List<Den> featuredProducts = denDAO.getFeaturedProducts(8);
        
        // Lấy sản phẩm mới nhất (8 sản phẩm)
        List<Den> newestProducts = denDAO.getNewestProducts(8);
        
        // Lấy sản phẩm bán chạy (8 sản phẩm)
        List<Den> bestSellingProducts = denDAO.getBestSellingProducts(8);
        
        // Đếm tổng số sản phẩm
        int totalProducts = denDAO.countSearchAndFilter(null, null, null, null);
        
        // Set attributes
        request.setAttribute("categories", categories);
        request.setAttribute("categoryProductCount", categoryProductCount);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("newestProducts", newestProducts);
        request.setAttribute("bestSellingProducts", bestSellingProducts);
        request.setAttribute("totalProducts", totalProducts);
        
        // Forward to JSP
        request.getRequestDispatcher("/View/userHome.jsp").forward(request, response);
    }
}

