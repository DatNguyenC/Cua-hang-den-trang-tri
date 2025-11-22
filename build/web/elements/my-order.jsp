<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.HoaDon" %>
<%@ page import="Model.NguoiDung" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="/layouts/header_user.jsp" %>
<%
    List<HoaDon> orders = (List<HoaDon>) request.getAttribute("orders");
    NguoiDung currentUser = (NguoiDung) request.getAttribute("user");
    
    // Kiểm tra thông báo thành công
    String success = request.getParameter("success");
    String maHd = request.getParameter("maHd");
    
    if (orders == null) {
        orders = new java.util.ArrayList<>();
    }
    
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi | LightStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .orders-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .orders-header {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .orders-header h1 {
            font-size: 32px;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .orders-header p {
            color: #666;
            font-size: 16px;
        }
        
        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .order-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
            transition: all 0.3s;
        }
        
        .order-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .order-info {
            flex: 1;
        }
        
        .order-number {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .order-date {
            font-size: 14px;
            color: #666;
        }
        
        .order-status {
            padding: 8px 16px;
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
        
        .order-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
        
        .order-total {
            font-size: 24px;
            font-weight: 700;
            color: #ff6b6b;
        }
        
        .order-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        
        .empty-orders {
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-orders-icon {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-orders h2 {
            font-size: 28px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-orders p {
            font-size: 16px;
            color: #999;
            margin-bottom: 30px;
        }
        
        .payment-method-info {
            font-size: 14px;
            color: #666;
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                gap: 15px;
            }
            
            .order-summary {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .order-actions {
                width: 100%;
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="orders-container">
        <div class="orders-header">
            <h1><i class="fas fa-shopping-bag"></i> Đơn hàng của tôi</h1>
            <p>Quản lý và theo dõi đơn hàng của bạn</p>
        </div>
        
        <% if ("true".equals(success) && maHd != null) { %>
        <div class="alert alert-success" style="background: #d4edda; color: #155724; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
            <i class="fas fa-check-circle"></i> <strong>Đặt hàng thành công!</strong> Đơn hàng #<%= maHd %> đã được tạo. Chúng tôi sẽ xử lý đơn hàng của bạn sớm nhất có thể.
        </div>
        <% } %>
        
        <% if (orders.isEmpty()) { %>
        <div class="empty-orders">
            <div class="empty-orders-icon"><i class="fas fa-inbox"></i></div>
            <h2>Chưa có đơn hàng nào</h2>
            <p>Bạn chưa có đơn hàng nào. Hãy bắt đầu mua sắm ngay!</p>
            <a href="${pageContext.request.contextPath}/UserProductServlet" class="btn btn-primary">
                <i class="fas fa-shopping-cart"></i> Mua sắm ngay
            </a>
        </div>
        <% } else { %>
        
        <div class="orders-list">
            <% for (HoaDon order : orders) { 
                String statusClass = "status-pending";
                String statusText = order.getTrangThaiGiaoHang() != null ? order.getTrangThaiGiaoHang() : "chờ xử lý";
                
                if (statusText.contains("đang giao")) {
                    statusClass = "status-processing";
                } else if (statusText.contains("đã giao") || statusText.contains("đã nhận")) {
                    statusClass = "status-delivered";
                } else if (statusText.contains("hủy")) {
                    statusClass = "status-cancelled";
                }
                
                // Parse phương thức thanh toán từ ghi chú
                String phuongThucThanhToan = "Chưa xác định";
                if (order.getGhiChu() != null && order.getGhiChu().contains("Phương thức thanh toán:")) {
                    String[] lines = order.getGhiChu().split("\n");
                    for (String line : lines) {
                        if (line.contains("Phương thức thanh toán:")) {
                            phuongThucThanhToan = line.replace("Phương thức thanh toán:", "").trim();
                            break;
                        }
                    }
                }
            %>
            <div class="order-card">
                <div class="order-header">
                    <div class="order-info">
                        <div class="order-number">Đơn hàng #<%= order.getMaHd() %></div>
                        <div class="order-date">
                            <i class="fas fa-calendar"></i> <%= dateFormat.format(order.getNgayLap()) %>
                        </div>
                        <div class="payment-method-info">
                            <i class="fas fa-credit-card"></i> <%= phuongThucThanhToan %>
                        </div>
                    </div>
                    <div class="order-status <%= statusClass %>">
                        <%= statusText %>
                    </div>
                </div>
                
                <div class="order-summary">
                    <div class="order-total">
                        Tổng tiền: <%= nf.format(order.getTongTien()) %>
                    </div>
                    <div class="order-actions">
                        <a href="${pageContext.request.contextPath}/OrderDetailServlet?maHd=<%= order.getMaHd() %>" class="btn btn-primary">
                            <i class="fas fa-eye"></i> Xem chi tiết
                        </a>
                        <% if (statusText.contains("đã giao")) { %>
                        <form action="${pageContext.request.contextPath}/ConfirmReceivedServlet" method="POST" style="display:inline;">
                            <input type="hidden" name="maHd" value="<%= order.getMaHd() %>">
                            <button type="submit" class="btn btn-success" onclick="return confirm('Bạn đã nhận được hàng?')">
                                <i class="fas fa-check-circle"></i> Xác nhận đã nhận
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
    
    <%@ include file="/layouts/footer_user.jsp" %>
</body>
</html>

