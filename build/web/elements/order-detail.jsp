<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.HoaDon" %>
<%@ page import="Model.OrderDetailViewModel" %>
<%@ page import="Model.NguoiDung" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="/layouts/header_user.jsp" %>
<%
    HoaDon hoaDon = (HoaDon) request.getAttribute("hoaDon");
    List<OrderDetailViewModel> orderDetails = (List<OrderDetailViewModel>) request.getAttribute("orderDetails");
    NguoiDung currentUser = (NguoiDung) request.getAttribute("user");
    String error = (String) request.getAttribute("error");
    
    if (orderDetails == null) {
        orderDetails = new java.util.ArrayList<>();
    }
    
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    // Parse thông tin từ ghi chú
    String hoTen = "";
    String soDienThoai = "";
    String diaChi = "";
    String phuongThucThanhToan = "Chưa xác định";
    String ghiChu = "";
    
    if (hoaDon != null && hoaDon.getGhiChu() != null) {
        String[] lines = hoaDon.getGhiChu().split("\n");
        for (String line : lines) {
            if (line.startsWith("Họ tên:")) {
                hoTen = line.replace("Họ tên:", "").trim();
            } else if (line.startsWith("Số điện thoại:")) {
                soDienThoai = line.replace("Số điện thoại:", "").trim();
            } else if (line.startsWith("Địa chỉ:")) {
                diaChi = line.replace("Địa chỉ:", "").trim();
            } else if (line.startsWith("Phương thức thanh toán:")) {
                phuongThucThanhToan = line.replace("Phương thức thanh toán:", "").trim();
            } else if (line.startsWith("Ghi chú:")) {
                ghiChu = line.replace("Ghi chú:", "").trim();
            }
        }
    }
    
    String statusClass = "status-pending";
    String statusText = hoaDon != null && hoaDon.getTrangThaiGiaoHang() != null ? hoaDon.getTrangThaiGiaoHang() : "chờ xử lý";
    
    if (statusText.contains("đang giao")) {
        statusClass = "status-processing";
    } else if (statusText.contains("đã giao") || statusText.contains("đã nhận")) {
        statusClass = "status-delivered";
    } else if (statusText.contains("hủy")) {
        statusClass = "status-cancelled";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng | LightStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .order-detail-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .order-detail-header {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .order-detail-header h1 {
            font-size: 32px;
            color: #1a1a1a;
            margin-bottom: 20px;
        }
        
        .order-info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .order-info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .order-info-item strong {
            color: #1a1a1a;
        }
        
        .order-status {
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-processing {
            background: #cfe2ff;
            color: #084298;
        }
        
        .status-delivered {
            background: #d1e7dd;
            color: #0f5132;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #842029;
        }
        
        .order-content {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }
        
        .order-items-section {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #1a1a1a;
            padding-bottom: 15px;
            border-bottom: 2px solid #ffd700;
        }
        
        .order-item {
            display: flex;
            gap: 20px;
            padding: 20px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            flex-shrink: 0;
        }
        
        .order-item-info {
            flex: 1;
        }
        
        .order-item-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #1a1a1a;
        }
        
        .order-item-variant {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
        }
        
        .color-swatch {
            display: inline-block;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid #ddd;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
            vertical-align: middle;
            margin-left: 5px;
        }
        
        .order-item-quantity {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
        }
        
        .order-item-price {
            font-size: 18px;
            font-weight: 700;
            color: #ff6b6b;
        }
        
        .order-summary-section {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .summary-row:last-of-type {
            border-bottom: none;
        }
        
        .summary-label {
            font-size: 16px;
            color: #666;
        }
        
        .summary-value {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .summary-total {
            font-size: 24px;
            font-weight: 700;
            color: #ff6b6b;
        }
        
        .shipping-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .shipping-info-item {
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .shipping-info-item:last-child {
            margin-bottom: 0;
        }
        
        .shipping-info-label {
            font-weight: 600;
            color: #333;
            display: inline-block;
            min-width: 150px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        
        .btn-back {
            margin-top: 20px;
            width: 100%;
        }
        
        @media (max-width: 968px) {
            .order-content {
                grid-template-columns: 1fr;
            }
            
            .order-info-row {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="order-detail-container">
        <% if (error != null) { %>
        <div class="alert alert-error" style="background: #f8d7da; color: #721c24; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px;">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>
        
        <% if (hoaDon != null) { %>
        <div class="order-detail-header">
            <h1><i class="fas fa-receipt"></i> Chi tiết đơn hàng</h1>
            <div class="order-info-row">
                <div class="order-info-item">
                    <strong>Mã đơn hàng:</strong> #<%= hoaDon.getMaHd() %>
                </div>
                <div class="order-info-item">
                    <i class="fas fa-calendar"></i>
                    <strong>Ngày đặt:</strong> <%= dateFormat.format(hoaDon.getNgayLap()) %>
                </div>
                <div class="order-status <%= statusClass %>">
                    <%= statusText %>
                </div>
            </div>
        </div>
        
        <div class="order-content">
            <div class="order-items-section">
                <h2 class="section-title">Sản phẩm đã đặt</h2>
                
                <% for (OrderDetailViewModel item : orderDetails) { 
                    String imagePath = "assets/images/product/den_tran.png"; // Fallback mặc định
                    String hinhAnh = item.getHinhAnh();
                    if (hinhAnh != null && !hinhAnh.trim().isEmpty()) {
                        hinhAnh = hinhAnh.trim();
                        // Tên file đã không có dấu, không cần encode
                        imagePath = "assets/images/product/" + hinhAnh;
                    }
                %>
                <div class="order-item">
                    <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                         alt="<%= item.getTenDen() != null ? item.getTenDen() : "Sản phẩm" %>" 
                         class="order-item-image"
                         onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100px;height:100px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i></div>';">
                    <div class="order-item-info">
                        <div class="order-item-name">
                            <%= item.getTenDen() != null ? item.getTenDen() : "Sản phẩm #" + item.getMaDen() %>
                        </div>
                        <div class="order-item-variant">
                            <% if (item.getTenMau() != null) { %>
                            Màu: <strong><%= item.getTenMau() %></strong>
                            <% if (item.getMaHex() != null && !item.getMaHex().isEmpty()) { %>
                            <span class="color-swatch" style="background-color: <%= item.getMaHex() %>;" title="<%= item.getTenMau() %>"></span>
                            <% } %>
                            <% } %>
                            <% if (item.getTenKichThuoc() != null) { %>
                            <% if (item.getTenMau() != null) { %> | <% } %>
                            Kích thước: <strong><%= item.getTenKichThuoc() %></strong>
                            <% } %>
                        </div>
                        <div class="order-item-quantity">
                            Số lượng: <strong><%= item.getSoLuong() %></strong>
                        </div>
                        <div class="order-item-price">
                            <%= nf.format(item.getDonGia()) %> x <%= item.getSoLuong() %> = <%= nf.format(item.getThanhTien()) %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="order-summary-section">
                <h2 class="section-title">Tóm tắt đơn hàng</h2>
                
                <div class="summary-row">
                    <span class="summary-label">Tạm tính:</span>
                    <span class="summary-value"><%= nf.format(hoaDon.getTongTien()) %></span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Phí vận chuyển:</span>
                    <span class="summary-value">Miễn phí</span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Tổng cộng:</span>
                    <span class="summary-value summary-total"><%= nf.format(hoaDon.getTongTien()) %></span>
                </div>
                
                <div class="shipping-info">
                    <h3 style="font-size: 18px; margin-bottom: 15px; color: #1a1a1a;">Thông tin giao hàng</h3>
                    <div class="shipping-info-item">
                        <span class="shipping-info-label">Họ tên:</span>
                        <%= hoTen.isEmpty() ? "Chưa có" : hoTen %>
                    </div>
                    <div class="shipping-info-item">
                        <span class="shipping-info-label">Số điện thoại:</span>
                        <%= soDienThoai.isEmpty() ? "Chưa có" : soDienThoai %>
                    </div>
                    <div class="shipping-info-item">
                        <span class="shipping-info-label">Địa chỉ:</span>
                        <%= diaChi.isEmpty() ? "Chưa có" : diaChi %>
                    </div>
                    <div class="shipping-info-item">
                        <span class="shipping-info-label">Phương thức thanh toán:</span>
                        <%= phuongThucThanhToan %>
                    </div>
                    <% if (!ghiChu.isEmpty()) { %>
                    <div class="shipping-info-item">
                        <span class="shipping-info-label">Ghi chú:</span>
                        <%= ghiChu %>
                    </div>
                    <% } %>
                </div>
                
                <% if (statusText.contains("đã giao")) { %>
                <form action="${pageContext.request.contextPath}/ConfirmReceivedServlet" method="POST" style="margin-bottom: 12px;">
                    <input type="hidden" name="maHd" value="<%= hoaDon.getMaHd() %>">
                    <button type="submit" class="btn btn-success" style="width: 100%;" onclick="return confirm('Bạn đã nhận được hàng?')">
                        <i class="fas fa-check-circle"></i> Xác nhận đã nhận hàng
                    </button>
                </form>
                <% } %>
                <a href="${pageContext.request.contextPath}/MyOrderServlet" class="btn btn-primary btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách đơn hàng
                </a>
            </div>
        </div>
        <% } %>
    </div>
    
    <%@ include file="/layouts/footer_user.jsp" %>
</body>
</html>

