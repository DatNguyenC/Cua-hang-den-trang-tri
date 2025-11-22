<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Den" %>
<%@ page import="DAO.DenDAO" %>
<%@ page import="java.util.List" %>
<%
    DenDAO denDAO = new DenDAO();
    List<Den> products = denDAO.getAll();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Image Paths</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        img { max-width: 100px; max-height: 100px; }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <h1>Debug: Image Paths</h1>
    <p><strong>Context Path:</strong> ${pageContext.request.contextPath}</p>
    <p><strong>Total Products:</strong> <%= products.size() %></p>
    <table>
        <tr>
            <th>Ma Den</th>
            <th>Ten Den</th>
            <th>Hinh Anh (from DB)</th>
            <th>Image Path</th>
            <th>Full URL</th>
            <th>Image Preview</th>
            <th>Status</th>
        </tr>
        <% for (Den p : products) { 
            String hinhAnh = p.getHinhAnh();
            String imagePath = "assets/images/product/den_tran.png";
            if (hinhAnh != null && !hinhAnh.trim().isEmpty()) {
                hinhAnh = hinhAnh.trim();
                imagePath = "assets/images/product/" + hinhAnh;
            }
        %>
        <tr>
            <td><%= p.getMaDen() %></td>
            <td><%= p.getTenDen() %></td>
            <td><%= hinhAnh != null ? hinhAnh : "<span class='error'>NULL</span>" %></td>
            <td><%= imagePath %></td>
            <td><a href="${pageContext.request.contextPath}/<%= imagePath %>" target="_blank">${pageContext.request.contextPath}/<%= imagePath %></a></td>
            <td>
                <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                     alt="<%= p.getTenDen() %>"
                     onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=\\'http://www.w3.org/2000/svg\\' width=\\'100\\' height=\\'100\\'%3E%3Crect fill=\\'%23f00\\' width=\\'100\\' height=\\'100\\'/%3E%3Ctext fill=\\'%23fff\\' x=\\'50\\' y=\\'50\\' text-anchor=\\'middle\\' dy=\\'.3em\\'%3EError%3C/text%3E%3C/svg%3E'; this.parentElement.nextElementSibling.innerHTML='<span class=\\'error\\'>❌ Error</span>';"
                     onload="this.parentElement.nextElementSibling.innerHTML='<span class=\\'success\\'>✓ OK</span>';">
            </td>
            <td id="status-<%= p.getMaDen() %>">Loading...</td>
        </tr>
        <% } %>
    </table>
    
    <hr>
    <h2>Instructions:</h2>
    <p>1. Check the "Hinh Anh (from DB)" column - should show image filename without Unicode characters</p>
    <p>2. Click on "Full URL" links to test if images are accessible</p>
    <p>3. Check "Status" column - green ✓ means image loaded successfully, red ❌ means error</p>
    <p>4. If images show errors, verify:</p>
    <ul>
        <li>File exists in: <code>web/assets/images/product/</code></li>
        <li>Filename matches exactly (case-sensitive)</li>
        <li>Database has been updated with new filenames (no Unicode)</li>
    </ul>
</body>
</html>

