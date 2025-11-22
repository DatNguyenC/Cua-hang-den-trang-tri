/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.DenDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author PC
 */
@WebServlet(name = "XoaDenServlet", urlPatterns = {"/xoa-den"})
public class XoaDenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maDenStr = request.getParameter("maDen");
        if (maDenStr != null) {
            try {
                int maDen = Integer.parseInt(maDenStr);
                DenDAO dao = new DenDAO();
                dao.delete(maDen);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Quay lại trang danh sách đèn
        response.sendRedirect(request.getContextPath() + "/elements/ShopItem.jsp");
    }


}
