<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.GioHang" %>
<%@ page import="Model.CartItemViewModel" %>
<%@ page import="Model.NguoiDung" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="/layouts/header_user.jsp" %>
<%
    // Lấy thông tin từ request
    List<CartItemViewModel> cartItems = (List<CartItemViewModel>) request.getAttribute("cartItems");
    GioHang userCart = (GioHang) request.getAttribute("cart");
    // Lấy user từ request attribute hoặc từ session (đã được khai báo trong header)
    NguoiDung checkoutUser = (NguoiDung) request.getAttribute("user");
    if (checkoutUser == null) {
        checkoutUser = user; // Sử dụng biến user từ header
    }
    
    // Kiểm tra success message
    String success = request.getParameter("success");
    String maHd = request.getParameter("maHd");
    String error = (String) request.getAttribute("error");
    
    // Fallback
    if (cartItems == null) {
        cartItems = new java.util.ArrayList<>();
    }
    if (userCart == null) {
        userCart = (Model.GioHang) session.getAttribute("cart");
        if (userCart == null) {
            userCart = new Model.GioHang();
        }
    }
    
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán | LightStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .checkout-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .checkout-header {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .checkout-header h1 {
            font-size: 32px;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .checkout-content {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }
        
        .checkout-form-section {
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
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }
        
        .form-label .required {
            color: #dc2626;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }
        
        .form-textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            font-family: inherit;
            resize: vertical;
            min-height: 100px;
            transition: all 0.3s;
        }
        
        .form-textarea:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }
        
        .payment-methods {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .payment-method-option {
            display: block;
            cursor: pointer;
        }
        
        .payment-method-option input[type="radio"] {
            display: none;
        }
        
        .payment-method-card {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            transition: all 0.3s;
            background: #fff;
        }
        
        .payment-method-option input[type="radio"]:checked + .payment-method-card {
            border-color: #ffd700;
            background: #fffef0;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }
        
        .payment-method-card:hover {
            border-color: #ffd700;
        }
        
        .payment-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1a1a1a;
            font-size: 24px;
            flex-shrink: 0;
        }
        
        .payment-info {
            flex: 1;
        }
        
        .payment-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .payment-desc {
            font-size: 14px;
            color: #666;
        }
        
        .order-summary {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .order-items {
            margin-bottom: 20px;
        }
        
        .order-item {
            display: flex;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .order-item-info {
            flex: 1;
        }
        
        .order-item-name {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #1a1a1a;
        }
        
        .order-item-variant {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .order-item-quantity {
            font-size: 14px;
            color: #666;
        }
        
        .order-item-price {
            font-size: 18px;
            font-weight: 700;
            color: #ff6b6b;
            min-width: 120px;
            text-align: right;
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
        
        .submit-btn {
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
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
        }
        
        .submit-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 16px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .success-message {
            text-align: center;
            padding: 60px 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .success-icon {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
        }
        
        .success-message h2 {
            font-size: 28px;
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        
        .success-message p {
            font-size: 18px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .order-number {
            font-size: 24px;
            font-weight: 700;
            color: #ff6b6b;
            margin: 20px 0;
        }
        
        @media (max-width: 968px) {
            .checkout-content {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="checkout-container">
        <% if ("true".equals(success) && maHd != null) { %>
        <div class="success-message">
            <div class="success-icon"><i class="fas fa-check-circle"></i></div>
            <h2>Đặt hàng thành công!</h2>
            <p>Cảm ơn bạn đã đặt hàng tại LightStore</p>
            <div class="order-number">Mã đơn hàng: #<%= maHd %></div>
            <p>Đơn hàng của bạn đang được xử lý. Chúng tôi sẽ liên hệ với bạn sớm nhất có thể.</p>
            <a href="${pageContext.request.contextPath}/UserProductServlet" class="submit-btn" style="text-decoration: none; display: inline-block; margin-top: 30px; max-width: 300px;">
                <i class="fas fa-shopping-bag"></i> Tiếp tục mua sắm
            </a>
        </div>
        <% } else { %>
        
        <div class="checkout-header">
            <h1><i class="fas fa-credit-card"></i> Thanh toán</h1>
            <p>Vui lòng điền thông tin giao hàng để hoàn tất đơn hàng</p>
        </div>
        
        <% if (error != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>
        
        <form method="post" action="${pageContext.request.contextPath}/CheckoutServlet" id="checkoutForm">
            <div class="checkout-content">
                <div class="checkout-form-section">
                    <h2 class="section-title">Thông tin giao hàng</h2>
                    
                    <div class="form-group">
                        <label class="form-label">
                            Họ và tên <span class="required">*</span>
                        </label>
                        <input type="text" name="hoTen" class="form-input" 
                               value="<%= checkoutUser != null && checkoutUser.getTenDangNhap() != null ? checkoutUser.getTenDangNhap() : "" %>" 
                               required placeholder="Nhập họ và tên người nhận">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            Số điện thoại <span class="required">*</span>
                        </label>
                        <input type="tel" name="soDienThoai" class="form-input" 
                               required placeholder="Nhập số điện thoại liên hệ">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            Địa chỉ giao hàng <span class="required">*</span>
                        </label>
                        <textarea name="diaChi" class="form-textarea" 
                                  required placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố)"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Ghi chú (tùy chọn)</label>
                        <textarea name="ghiChu" class="form-textarea" 
                                  placeholder="Ghi chú thêm cho đơn hàng (ví dụ: giao hàng vào giờ hành chính, để ở cổng...)"></textarea>
                    </div>
                    
                    <h2 class="section-title" style="margin-top: 30px;">Phương thức thanh toán</h2>
                    
                    <div class="form-group">
                        <div class="payment-methods">
                            <label class="payment-method-option">
                                <input type="radio" name="phuongThucThanhToan" value="1" checked required>
                                <div class="payment-method-card">
                                    <div class="payment-icon"><i class="fas fa-credit-card"></i></div>
                                    <div class="payment-info">
                                        <div class="payment-title">Thanh toán online / Chuyển khoản</div>
                                        <div class="payment-desc">Thanh toán qua thẻ ngân hàng hoặc chuyển khoản</div>
                                    </div>
                                </div>
                            </label>
                            
                            <label class="payment-method-option">
                                <input type="radio" name="phuongThucThanhToan" value="2" required>
                                <div class="payment-method-card">
                                    <div class="payment-icon"><i class="fas fa-money-bill-wave"></i></div>
                                    <div class="payment-info">
                                        <div class="payment-title">Thanh toán khi nhận hàng (COD)</div>
                                        <div class="payment-desc">Thanh toán bằng tiền mặt khi nhận được hàng</div>
                                    </div>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>
                
                <div class="order-summary">
                    <h2 class="section-title">Đơn hàng của bạn</h2>
                    
                    <div class="order-items">
                        <% for (CartItemViewModel item : cartItems) { 
                            String imagePath = "assets/images/no-image.jpg";
                            if (item.getHinhAnh() != null && !item.getHinhAnh().trim().isEmpty()) {
                                imagePath = "assets/images/product/" + item.getHinhAnh();
                            }
                        %>
                        <div class="order-item">
                            <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                                 alt="<%= item.getTenDen() != null ? item.getTenDen() : "Sản phẩm" %>" 
                                 class="order-item-image"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.jpg'">
                            <div class="order-item-info">
                                <div class="order-item-name"><%= item.getTenDen() != null ? item.getTenDen() : "Sản phẩm #" + item.getMaDen() %></div>
                                <div class="order-item-variant">
                                    <% if (item.getTenMau() != null) { %>
                                    Màu: <strong><%= item.getTenMau() %></strong>
                                    <% } %>
                                    <% if (item.getTenKichThuoc() != null) { %>
                                    <% if (item.getTenMau() != null) { %> | <% } %>
                                    Kích thước: <strong><%= item.getTenKichThuoc() %></strong>
                                    <% } %>
                                </div>
                                <div class="order-item-quantity">Số lượng: <%= item.getSoLuong() %></div>
                            </div>
                            <div class="order-item-price">
                                <%= nf.format(item.getTongTien()) %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
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
                    
                    <button type="submit" class="submit-btn" id="submitBtn">
                        <i class="fas fa-check"></i> Xác nhận đặt hàng
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/CartServlet" style="display: block; text-align: center; margin-top: 15px; color: #666; text-decoration: none;">
                        <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
                    </a>
                </div>
            </div>
        </form>
        <% } %>
    </div>
    
    <script>
        document.getElementById('checkoutForm')?.addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                // Cho phép form submit bình thường
                return true;
            }
        });
        
        // Nếu có lỗi, đảm bảo nút được enable lại
        window.addEventListener('load', function() {
            const submitBtn = document.getElementById('submitBtn');
            if (submitBtn && submitBtn.disabled) {
                // Nếu có lỗi và quay lại trang, enable lại nút
                const errorMsg = document.querySelector('.alert-error');
                if (errorMsg) {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-check"></i> Xác nhận đặt hàng';
                }
            }
        });
    </script>
    
    <%@ include file="/layouts/footer_user.jsp" %>
</body>
</html>

