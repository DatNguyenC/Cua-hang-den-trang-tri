package Controller;

import DAO.DenDAO;
import Model.Den;
// import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GetProductServlet", urlPatterns = {"/get-product"})
public class GetProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int maDen = Integer.parseInt(idStr);
                DenDAO dao = new DenDAO();
                Den den = dao.getById(maDen);
                
                if (den != null) {
                    // Manual JSON creation without Gson
                    StringBuilder json = new StringBuilder();
                    json.append("{");
                    json.append("\"maDen\":").append(den.getMaDen()).append(",");
                    json.append("\"tenDen\":\"").append(den.getTenDen() != null ? den.getTenDen().replace("\"", "\\\"") : "").append("\",");
                    json.append("\"maLoai\":").append(den.getMaLoai()).append(",");
                    json.append("\"maNCC\":").append(den.getMaNCC() != null ? den.getMaNCC() : "null").append(",");
                    json.append("\"moTa\":\"").append(den.getMoTa() != null ? den.getMoTa().replace("\"", "\\\"") : "").append("\",");
                    json.append("\"gia\":").append(den.getGia()).append(",");
                    json.append("\"hinhAnh\":\"").append(den.getHinhAnh() != null ? den.getHinhAnh().replace("\"", "\\\"") : "").append("\"");
                    json.append("}");
                    
                    PrintWriter out = response.getWriter();
                    out.print(json.toString());
                    out.flush();
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    PrintWriter out = response.getWriter();
                    out.print("{\"error\":\"Product not found\"}");
                    out.flush();
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"error\":\"Missing product ID\"}");
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"Internal server error\"}");
            out.flush();
        }
    }
}