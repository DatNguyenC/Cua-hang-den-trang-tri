<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.*" %>
<%@ page import="DAO.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%
    String maHdStr = request.getParameter("maHd");
    if (maHdStr == null || maHdStr.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
        return;
    }

    int maHd;
    try {
        maHd = Integer.parseInt(maHdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
        return;
    }

    HoaDonDAO hoaDonDAO = new HoaDonDAO();
    ChiTietHoaDonDAO chiTietDAO = new ChiTietHoaDonDAO();
    DenDAO denDAO = new DenDAO();
    BienTheDenDAO bienTheDAO = new BienTheDenDAO();
    MauSacDAO mauDAO = new MauSacDAO();
    KichThuocDAO sizeDAO = new KichThuocDAO();
    NguoiDungDAO userDAO = new NguoiDungDAO();

    HoaDon hoaDon = hoaDonDAO.getById(maHd);
    if (hoaDon == null) {
        response.sendRedirect(request.getContextPath() + "/elements/OrderManagement.jsp");
        return;
    }

    List<ChiTietHoaDon> chiTietList = chiTietDAO.getByHoaDon(maHd);
    List<OrderDetailViewModel> orderDetails = new ArrayList<>();

    for (ChiTietHoaDon chiTiet : chiTietList) {
        BienTheDen variant = bienTheDAO.getById(chiTiet.getMaBienThe());
        Den product = variant != null ? denDAO.getById(variant.getMaDen()) : null;
        MauSac mau = variant != null && variant.getMaMau() != null ? mauDAO.getById(variant.getMaMau()) : null;
        KichThuoc kichThuoc = variant != null && variant.getMaKichThuoc() != null ? sizeDAO.getById(variant.getMaKichThuoc()) : null;
        OrderDetailViewModel viewModel = new OrderDetailViewModel(chiTiet, product, variant, mau, kichThuoc);
        orderDetails.add(viewModel);
    }

    NguoiDung customer = userDAO.getById(hoaDon.getMaNd());

    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    String status = hoaDon.getTrangThaiGiaoHang() != null ? hoaDon.getTrangThaiGiaoHang() : "chờ xử lý";
    String statusClass = "status-pending";
    if (status.contains("đang giao")) statusClass = "status-processing";
    else if (status.contains("đã giao")) statusClass = "status-delivered";
    else if (status.contains("đã nhận")) statusClass = "status-received";
    else if (status.contains("hủy")) statusClass = "status-cancelled";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #<%= maHd %> - LightShop Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">
</head>
<body>
<jsp:include page="../layouts/sidebar-admin.html"/>
<jsp:include page="../layouts/header-content-admin.jsp"/>

<div class="pc-container">
    <section class="page-header">
        <div class="header-content">
            <div>
                <h1 class="page-title">
                    <i class="fas fa-receipt"></i>
                    Chi tiết đơn hàng #<%= maHd %>
                </h1>
                <p class="page-subtitle">Thông tin chi tiết đơn hàng và khách hàng.</p>
            </div>
            <div>
                <a href="<%=request.getContextPath()%>/elements/OrderManagement.jsp" class="btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </section>

    <section class="table-container">
        <div class="table-header">
            <div>
                <h3>Thông tin đơn hàng</h3>
                <small>Khách hàng: <%= customer != null ? customer.getTenDangNhap() : "N/A" %></small>
            </div>
            <div>
                <span class="status-badge <%= statusClass %>"><%= status %></span>
            </div>
        </div>
        <div class="table-responsive">
            <table class="products-table">
                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Biến thể</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <% for (OrderDetailViewModel item : orderDetails) { %>
                <tr>
                    <td><%= item.getTenDen() != null ? item.getTenDen() : "N/A" %></td>
                    <td>
                        <% if (item.getTenMau() != null) { %>Màu: <%= item.getTenMau() %><% } %>
                        <% if (item.getTenKichThuoc() != null) { %> | Size: <%= item.getTenKichThuoc() %><% } %>
                    </td>
                    <td><%= item.getSoLuong() %></td>
                    <td><%= nf.format(item.getDonGia()) %></td>
                    <td><strong><%= nf.format(item.getThanhTien()) %></strong></td>
                </tr>
                <% } %>
                <tr style="background: #f8f9fa; font-weight: 700;">
                    <td colspan="4" class="text-end">Tổng cộng:</td>
                    <td><%= nf.format(hoaDon.getTongTien()) %></td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>
</div>
</body>
</html>

