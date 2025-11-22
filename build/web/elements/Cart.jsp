<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.GioHang" %>
<%@ page import="Model.CartItemViewModel" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    // Lấy cartItems từ request (đã được load đầy đủ thông tin từ CartServlet)
    List<CartItemViewModel> cartItems = (List<CartItemViewModel>) request.getAttribute("cartItems");
    GioHang userCart = (GioHang) request.getAttribute("cart");
    
    // Fallback nếu không có từ request
    if (cartItems == null) {
        cartItems = new java.util.ArrayList<>();
    }
    if (userCart == null) {
        userCart = (Model.GioHang) session.getAttribute("cart");
        if (userCart == null) {
            userCart = new Model.GioHang();
            session.setAttribute("cart", userCart);
        }
    }
    
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<%@ include file="/layouts/header_user.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | LightStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .cart-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .cart-header {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .cart-header h1 {
            font-size: 32px;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .cart-header p {
            color: #666;
            font-size: 16px;
        }
        
        .cart-content {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 30px;
        }
        
        .cart-items {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .cart-item {
            display: grid;
            grid-template-columns: 120px 1fr auto auto;
            gap: 20px;
            padding: 20px;
            border-bottom: 1px solid #e0e0e0;
            align-items: center;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .item-info {
            flex: 1;
        }
        
        .item-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #1a1a1a;
        }
        
        .item-name a {
            color: #1a1a1a;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .item-name a:hover {
            color: #ffd700;
        }
        
        .item-description {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .item-variant {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }
        
        .variant-item {
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .color-swatch {
            display: inline-block;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid #ddd;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }
        
        .item-price {
            font-size: 20px;
            font-weight: 700;
            color: #ff6b6b;
            margin-top: 8px;
        }
        
        .item-meta {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
        }
        
        .item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-btn {
            width: 35px;
            height: 35px;
            border: 1px solid #ddd;
            background: #fff;
            border-radius: 4px;
            cursor: pointer;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }
        
        .quantity-btn:hover {
            background: #f0f0f0;
            border-color: #ffd700;
        }
        
        .quantity-input {
            width: 60px;
            height: 35px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
            font-size: 16px;
            font-weight: 600;
        }
        
        .item-total {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            min-width: 120px;
            text-align: right;
        }
        
        .item-remove {
            color: #dc2626;
            cursor: pointer;
            font-size: 20px;
            padding: 10px;
            transition: all 0.3s;
        }
        
        .item-remove:hover {
            color: #ff0000;
            transform: scale(1.1);
        }
        
        .cart-summary {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .summary-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #1a1a1a;
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
        
        .checkout-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: all 0.3s;
        }
        
        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
        }
        
        .checkout-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .empty-cart {
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-cart-icon {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-cart h2 {
            font-size: 28px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-cart p {
            font-size: 16px;
            color: #999;
            margin-bottom: 30px;
        }
        
        .continue-shopping {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .continue-shopping:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
        }
        
        .clear-cart {
            text-align: right;
            padding: 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .clear-cart-btn {
            padding: 10px 20px;
            background: #dc2626;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .clear-cart-btn:hover {
            background: #b91c1c;
        }
        
        @media (max-width: 968px) {
            .cart-content {
                grid-template-columns: 1fr;
            }
            
            .cart-item {
                grid-template-columns: 100px 1fr;
                gap: 15px;
            }
            
            .item-quantity, .item-total, .item-remove {
                grid-column: 2;
            }
        }
    </style>
</head>
<body>
    <div class="cart-container">
        <div class="cart-header">
            <h1><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h1>
            <p>Bạn có <%= cartItems.size() %> sản phẩm trong giỏ hàng</p>
        </div>
        
        <% if (cartItems.isEmpty()) { %>
        <div class="empty-cart">
            <div class="empty-cart-icon"><i class="fas fa-shopping-cart"></i></div>
            <h2>Giỏ hàng trống</h2>
            <p>Bạn chưa có sản phẩm nào trong giỏ hàng</p>
            <a href="${pageContext.request.contextPath}/UserProductServlet" class="continue-shopping">
                Tiếp tục mua sắm
            </a>
        </div>
        <% } else { %>
        
        <% if (!cartItems.isEmpty()) { %>
        <div class="clear-cart">
            <form method="post" action="${pageContext.request.contextPath}/CartServlet" onsubmit="return confirm('Bạn có chắc chắn muốn xóa tất cả sản phẩm trong giỏ hàng?');">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="clear-cart-btn">
                    <i class="fas fa-trash"></i> Xóa tất cả
                </button>
            </form>
        </div>
        <% } %>
        
        <div class="cart-content">
            <div class="cart-items">
                <% for (CartItemViewModel item : cartItems) { 
                    // Hình ảnh từ Den (sản phẩm chính)
                    String imagePath = "assets/images/product/den_tran.png"; // Fallback mặc định
                    String hinhAnh = item.getHinhAnh();
                    if (hinhAnh != null && !hinhAnh.trim().isEmpty()) {
                        hinhAnh = hinhAnh.trim();
                        // Tên file đã không có dấu, không cần encode
                        imagePath = "assets/images/product/" + hinhAnh;
                    }
                    String itemKey = item.getKey();
                %>
                <div class="cart-item">
                    <a href="${pageContext.request.contextPath}/UserProductDetailServlet?id=<%= item.getMaDen() %>">
                        <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                             alt="<%= item.getTenDen() != null ? item.getTenDen() : "Sản phẩm" %>" 
                             class="item-image"
                             onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:80px;height:80px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i></div>';">
                    </a>
                    
                    <div class="item-info">
                        <!-- Tên sản phẩm từ Den -->
                        <div class="item-name">
                            <a href="${pageContext.request.contextPath}/UserProductDetailServlet?id=<%= item.getMaDen() %>">
                                <%= item.getTenDen() != null ? item.getTenDen() : "Sản phẩm #" + item.getMaDen() %>
                            </a>
                        </div>
                        
                        <!-- Mô tả từ Den (sản phẩm chính) -->
                        <% if (item.getMoTa() != null && !item.getMoTa().trim().isEmpty()) { %>
                        <div class="item-description">
                            <%= item.getMoTa().length() > 100 ? item.getMoTa().substring(0, 100) + "..." : item.getMoTa() %>
                        </div>
                        <% } %>
                        
                        <!-- Màu sắc và kích thước từ BienTheDen -->
                        <div class="item-variant">
                            <% if (item.getTenMau() != null) { %>
                            <div class="variant-item">
                                <span>Màu:</span>
                                <strong><%= item.getTenMau() %></strong>
                                <% if (item.getMaHex() != null && !item.getMaHex().isEmpty()) { %>
                                <span class="color-swatch" style="background-color: <%= item.getMaHex() %>;" title="<%= item.getTenMau() %>"></span>
                                <% } %>
                            </div>
                            <% } %>
                            <% if (item.getTenKichThuoc() != null) { %>
                            <div class="variant-item">
                                <span>Kích thước:</span>
                                <strong><%= item.getTenKichThuoc() %></strong>
                            </div>
                            <% } %>
                        </div>
                        
                        <!-- Giá từ Den (sản phẩm chính) -->
                        <div class="item-price">
                            <%= nf.format(item.getGia()) %> / sản phẩm
                        </div>
                        
     
                    </div>
                    
                    <div class="item-quantity">
                        <button class="quantity-btn" onclick="updateQuantity('<%= itemKey %>', <%= item.getSoLuong() - 1 %>)">-</button>
                        <input type="number" class="quantity-input" 
                               value="<%= item.getSoLuong() %>" 
                               min="1" 
                               onchange="updateQuantity('<%= itemKey %>', this.value)">
                        <button class="quantity-btn" onclick="updateQuantity('<%= itemKey %>', <%= item.getSoLuong() + 1 %>)">+</button>
                    </div>
                    
                    <div class="item-total">
                        <%= nf.format(item.getTongTien()) %>
                    </div>
                    
                    <div class="item-remove" onclick="removeItem('<%= itemKey %>')" title="Xóa sản phẩm">
                        <i class="fas fa-times"></i>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="cart-summary">
                <h2 class="summary-title">Tóm tắt đơn hàng</h2>
                
                <div class="summary-row">
                    <span class="summary-label">Tạm tính:</span>
                    <span class="summary-value"><%= nf.format(userCart.getTotalPrice()) %></span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Phí vận chuyển:</span>
                    <span class="summary-value">Miễn phí</span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Tổng cộng:</span>
                    <span class="summary-value summary-total"><%= nf.format(userCart.getTotalPrice()) %></span>
                </div>
                
                <button class="checkout-btn" onclick="checkout()">
                    <i class="fas fa-credit-card"></i> Thanh toán
                </button>
                
                <a href="${pageContext.request.contextPath}/UserProductServlet" class="continue-shopping" style="display: block; text-align: center; margin-top: 15px;">
                    <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                </a>
            </div>
        </div>
        <% } %>
    </div>
    
    <script>
        function updateQuantity(key, quantity) {
            if (quantity < 1) {
                if (confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                    removeItem(key);
                }
                return;
            }
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/CartServlet';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'update';
            form.appendChild(actionInput);
            
            const keyInput = document.createElement('input');
            keyInput.type = 'hidden';
            keyInput.name = 'key';
            keyInput.value = key;
            form.appendChild(keyInput);
            
            const quantityInput = document.createElement('input');
            quantityInput.type = 'hidden';
            quantityInput.name = 'quantity';
            quantityInput.value = quantity;
            form.appendChild(quantityInput);
            
            document.body.appendChild(form);
            form.submit();
        }
        
        function removeItem(key) {
            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/CartServlet';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'remove';
                form.appendChild(actionInput);
                
                const keyInput = document.createElement('input');
                keyInput.type = 'hidden';
                keyInput.name = 'key';
                keyInput.value = key;
                form.appendChild(keyInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function checkout() {
            window.location.href = '${pageContext.request.contextPath}/CheckoutServlet';
        }
    </script>
    
    <%@ include file="/layouts/footer_user.jsp" %>
</body>
</html>

