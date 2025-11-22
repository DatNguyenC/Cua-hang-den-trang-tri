<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="/layouts/header_user.jsp" %>
<%
    Den product = (Den) request.getAttribute("product");
    LoaiDen category = (LoaiDen) request.getAttribute("category");
    List<BienTheDen> variants = (List<BienTheDen>) request.getAttribute("variants");
    List<MauSac> colors = (List<MauSac>) request.getAttribute("colors");
    List<KichThuoc> sizes = (List<KichThuoc>) request.getAttribute("sizes");
    Map<Integer, Integer> variantStock = (Map<Integer, Integer>) request.getAttribute("variantStock");
    List<Den> relatedProducts = (List<Den>) request.getAttribute("relatedProducts");
    
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/UserProductServlet");
        return;
    }
    if (variants == null) variants = new ArrayList<>();
    if (colors == null) colors = new ArrayList<>();
    if (sizes == null) sizes = new ArrayList<>();
    if (variantStock == null) variantStock = new HashMap<>();
    if (relatedProducts == null) relatedProducts = new ArrayList<>();
    
    String imagePath = "assets/images/product/den_tran.png"; // Fallback mặc định
    String hinhAnh = product.getHinhAnh();
    if (hinhAnh != null && !hinhAnh.trim().isEmpty()) {
        hinhAnh = hinhAnh.trim();
        // Tên file đã không có dấu, không cần encode
        imagePath = "assets/images/product/" + hinhAnh;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= product.getTenDen() %> | LightStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .product-detail-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        
        .breadcrumb {
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .breadcrumb a {
            color: #666;
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            color: #ffd700;
        }
        
        .product-detail-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 40px;
        }
        
        /* Image Gallery */
        .product-gallery {
            position: relative;
        }
        
        .main-image {
            width: 100%;
            height: 600px;
            object-fit: cover;
            border-radius: 12px;
            cursor: zoom-in;
            background: #f0f0f0;
            margin-bottom: 15px;
            transition: transform 0.3s;
        }
        
        .main-image:hover {
            transform: scale(1.02);
        }
        
        .thumbnail-images {
            display: flex;
            gap: 10px;
            overflow-x: auto;
        }
        
        .thumbnail {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.3s;
        }
        
        .thumbnail:hover,
        .thumbnail.active {
            border-color: #ffd700;
        }
        
        /* Product Info */
        .product-info {
            position: sticky;
            top: 20px;
            height: fit-content;
        }
        
        .product-category {
            font-size: 14px;
            color: #999;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        
        .product-title {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        
        .product-price {
            font-size: 36px;
            font-weight: 700;
            color: #ff6b6b;
            margin-bottom: 20px;
        }
        
        .product-rating {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 25px;
        }
        
        .stars {
            color: #ffd700;
            font-size: 18px;
        }
        
        .product-description {
            font-size: 16px;
            line-height: 1.6;
            color: #666;
            margin-bottom: 30px;
        }
        
        /* Variants */
        .variant-section {
            margin-bottom: 25px;
        }
        
        .variant-label {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
        }
        
        .color-options,
        .size-options {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .color-option {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: 3px solid transparent;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
        }
        
        .color-option:hover {
            transform: scale(1.1);
        }
        
        .color-option.active {
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.3);
        }
        
        .color-option[data-stock="0"] {
            opacity: 0.3;
            cursor: not-allowed;
        }
        
        .color-option[data-stock="0"]::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(45deg);
            width: 2px;
            height: 60px;
            background: #dc2626;
        }
        
        .size-option {
            padding: 12px 24px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            background: #fff;
        }
        
        .size-option:hover {
            border-color: #ffd700;
        }
        
        .size-option.active {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            border-color: #ffd700;
            color: #1a1a1a;
        }
        
        .size-option[data-stock="0"] {
            opacity: 0.3;
            cursor: not-allowed;
            text-decoration: line-through;
        }
        
        /* Quantity & Stock */
        .quantity-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .quantity-btn {
            width: 40px;
            height: 40px;
            border: none;
            background: #f0f0f0;
            cursor: pointer;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .quantity-btn:hover {
            background: #e0e0e0;
        }
        
        .quantity-input {
            width: 60px;
            height: 40px;
            border: none;
            text-align: center;
            font-size: 16px;
            font-weight: 600;
        }
        
        .stock-info {
            font-size: 14px;
            color: #666;
        }
        
        .stock-info.in-stock {
            color: #16a34a;
        }
        
        .stock-info.out-of-stock {
            color: #dc2626;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .btn-add-cart,
        .btn-buy-now {
            flex: 1;
            padding: 16px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-add-cart {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
        }
        
        .btn-add-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
        }
        
        .btn-buy-now {
            background: linear-gradient(135deg, #1a1a1a, #2d2d2d);
            color: #fff;
        }
        
        .btn-buy-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }
        
        /* Product Details Tabs */
        .product-tabs {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 40px;
        }
        
        .tab-headers {
            display: flex;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .tab-header {
            padding: 20px 30px;
            cursor: pointer;
            font-weight: 600;
            color: #666;
            transition: all 0.3s;
            border-bottom: 3px solid transparent;
        }
        
        .tab-header:hover {
            color: #1a1a1a;
        }
        
        .tab-header.active {
            color: #ffd700;
            border-bottom-color: #ffd700;
        }
        
        .tab-content {
            padding: 30px;
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .tab-content p {
            line-height: 1.8;
            color: #666;
            margin-bottom: 15px;
        }
        
        /* Related Products */
        .related-products {
            margin-top: 40px;
        }
        
        .section-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .related-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
        }
        
        .related-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .related-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .related-card img {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }
        
        .related-card-info {
            padding: 20px;
        }
        
        .related-card-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .related-card-price {
            font-size: 22px;
            font-weight: 700;
            color: #ff6b6b;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .product-detail-wrapper {
                grid-template-columns: 1fr;
            }
            
            .product-info {
                position: static;
            }
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }
            
            .quantity-section {
                flex-wrap: wrap;
            }
        }
    </style>
    </head>
    <body>
    <div class="product-detail-container">
        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/View/userHome.jsp">Trang chủ</a> / 
            <a href="${pageContext.request.contextPath}/UserProductServlet">Sản phẩm</a> / 
            <span><%= product.getTenDen() %></span>
        </div>
        
        <!-- Product Detail -->
        <div class="product-detail-wrapper">
            <!-- Image Gallery -->
            <div class="product-gallery">
                <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                     alt="<%= product.getTenDen() %>" 
                     class="main-image" 
                     id="mainImage"
                     onclick="zoomImage(this)"
                     onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100%;height:600px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;font-size:18px;\\'><i class=\\'fas fa-image\\' style=\\'font-size:48px;margin-bottom:10px;display:block;\\'></i> Không có ảnh</div>';">
                <div class="thumbnail-images">
                    <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                         alt="<%= product.getTenDen() %>" 
                         class="thumbnail active"
                         onclick="changeMainImage(this.src)"
                         onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100px;height:100px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i></div>';">
                    <!-- Có thể thêm thêm thumbnail nếu có nhiều ảnh -->
                </div>
            </div>
            
            <!-- Product Info -->
            <div class="product-info">
                <div class="product-category">
                    <%= category != null ? category.getTenLoai() : "Sản phẩm" %>
                </div>
                <h1 class="product-title"><%= product.getTenDen() %></h1>
                <div class="product-price"><%= nf.format(product.getGia()) %></div>
                
                <div class="product-rating">
                    <div class="stars">★★★★★</div>
                    <span>(4.8) - 124 đánh giá</span>
                </div>
                
                <div class="product-description">
                    <%= product.getMoTa() != null && !product.getMoTa().isEmpty() ? product.getMoTa() : "Không có mô tả chi tiết." %>
                </div>
                
                <!-- Color Selection -->
                <% if (!colors.isEmpty()) { %>
                <div class="variant-section">
                    <div class="variant-label">Màu sắc:</div>
                    <div class="color-options">
                        <% 
                            int selectedColor = -1;
                            if (!variants.isEmpty() && variants.get(0).getMaMau() != null) {
                                selectedColor = variants.get(0).getMaMau();
                            }
                            for (MauSac color : colors) {
                                // Tính tồn kho cho màu này
                                int colorStock = 0;
                                for (BienTheDen v : variants) {
                                    if (v.getMaMau() != null && v.getMaMau() == color.getMaMau()) {
                                        Integer stock = variantStock.get(v.getMaBienThe());
                                        if (stock != null) colorStock += stock;
                                    }
                                }
                                String activeClass = (selectedColor == color.getMaMau()) ? "active" : "";
                        %>
                        <div class="color-option <%= activeClass %>" 
                             style="background-color: <%= color.getMaHex() != null ? color.getMaHex() : "#ccc" %>"
                             data-color="<%= color.getMaMau() %>"
                             data-stock="<%= colorStock %>"
                             title="<%= color.getTenMau() %> (<%= colorStock %> sản phẩm)"
                             onclick="selectColor(<%= color.getMaMau() %>)">
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- Size Selection -->
                <% if (!sizes.isEmpty()) { %>
                <div class="variant-section">
                    <div class="variant-label">Kích thước:</div>
                    <div class="size-options">
                        <% 
                            int selectedSize = -1;
                            if (!variants.isEmpty() && variants.get(0).getMaKichThuoc() != null) {
                                selectedSize = variants.get(0).getMaKichThuoc();
                            }
                            for (KichThuoc size : sizes) {
                                // Tính tồn kho cho kích thước này
                                int sizeStock = 0;
                                for (BienTheDen v : variants) {
                                    if (v.getMaKichThuoc() != null && v.getMaKichThuoc() == size.getMaKichThuoc()) {
                                        Integer stock = variantStock.get(v.getMaBienThe());
                                        if (stock != null) sizeStock += stock;
                                    }
                                }
                                String activeClass = (selectedSize == size.getMaKichThuoc()) ? "active" : "";
                        %>
                        <div class="size-option <%= activeClass %>"
                             data-size="<%= size.getMaKichThuoc() %>"
                             data-stock="<%= sizeStock %>"
                             onclick="selectSize(<%= size.getMaKichThuoc() %>)">
                            <%= size.getTenKichThuoc() %>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- Quantity & Stock -->
                <div class="quantity-section">
                    <div class="variant-label">Số lượng:</div>
                    <div class="quantity-control">
                        <button class="quantity-btn" onclick="decreaseQuantity()">-</button>
                        <input type="number" class="quantity-input" id="quantity" value="1" min="1" max="10">
                        <button class="quantity-btn" onclick="increaseQuantity()">+</button>
                    </div>
                    <span class="stock-info in-stock" id="stockInfo">Còn hàng</span>
                </div>
                
                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button class="btn-add-cart" onclick="addToCart()">
                        <i class="fas fa-cart-plus"></i>
                        Thêm vào giỏ hàng
                    </button>
                    <button class="btn-buy-now" onclick="buyNow()">
                        <i class="fas fa-bolt"></i>
                        Mua ngay
                    </button>
                </div>
                
                <!-- Product Features -->
                <div style="border-top: 1px solid #e0e0e0; padding-top: 20px;">
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px;">
                        <div>
                            <strong>🚚 Miễn phí vận chuyển</strong>
                            <p style="font-size: 12px; color: #666; margin-top: 5px;">Cho đơn hàng trên 500k</p>
                        </div>
                        <div>
                            <strong>🔄 Đổi trả dễ dàng</strong>
                            <p style="font-size: 12px; color: #666; margin-top: 5px;">Trong 7 ngày</p>
                        </div>
                        <div>
                            <strong>✅ Bảo hành chính hãng</strong>
                            <p style="font-size: 12px; color: #666; margin-top: 5px;">12 tháng</p>
                        </div>
                        <div>
                            <strong>💳 Thanh toán linh hoạt</strong>
                            <p style="font-size: 12px; color: #666; margin-top: 5px;">Nhiều phương thức</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Product Details Tabs -->
        <div class="product-tabs">
            <div class="tab-headers">
                <div class="tab-header active" onclick="showTab('description')">Mô tả sản phẩm</div>
                <div class="tab-header" onclick="showTab('specs')">Thông số kỹ thuật</div>
                <div class="tab-header" onclick="showTab('reviews')">Đánh giá</div>
            </div>
            
            <div class="tab-content active" id="description">
                <p><strong>Mô tả chi tiết:</strong></p>
                <p><%= product.getMoTa() != null && !product.getMoTa().isEmpty() ? product.getMoTa() : "Đang cập nhật mô tả chi tiết..." %></p>
            </div>
            
            <div class="tab-content" id="specs">
                <p><strong>Thông số kỹ thuật:</strong></p>
                <table style="width: 100%; margin-top: 15px;">
                    <tr style="border-bottom: 1px solid #e0e0e0; padding: 10px 0;">
                        <td style="padding: 10px 0; font-weight: 600;">Danh mục</td>
                        <td style="padding: 10px 0;"><%= category != null ? category.getTenLoai() : "-" %></td>
                    </tr>
                    <tr style="border-bottom: 1px solid #e0e0e0;">
                        <td style="padding: 10px 0; font-weight: 600;">Giá bán</td>
                        <td style="padding: 10px 0;"><%= nf.format(product.getGia()) %></td>
                    </tr>
                    <tr style="border-bottom: 1px solid #e0e0e0;">
                        <td style="padding: 10px 0; font-weight: 600;">Mã sản phẩm</td>
                        <td style="padding: 10px 0;">#<%= product.getMaDen() %></td>
                    </tr>
                </table>
            </div>
            
            <div class="tab-content" id="reviews">
                <p>Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá sản phẩm này!</p>
            </div>
        </div>
        
        <!-- Related Products -->
        <% if (!relatedProducts.isEmpty()) { %>
        <div class="related-products">
            <h2 class="section-title">Sản phẩm liên quan</h2>
            <div class="related-grid">
                <% for (Den related : relatedProducts) { 
                    String relatedImagePath = "assets/images/product/den_tran.png"; // Fallback mặc định
                    String relatedHinhAnh = related.getHinhAnh();
                    if (relatedHinhAnh != null && !relatedHinhAnh.trim().isEmpty()) {
                        relatedHinhAnh = relatedHinhAnh.trim();
                        // Tên file đã không có dấu, không cần encode
                        relatedImagePath = "assets/images/product/" + relatedHinhAnh;
                    }
                %>
                <div class="related-card" onclick="viewProduct(<%= related.getMaDen() %>)">
                    <img src="${pageContext.request.contextPath}/<%= relatedImagePath %>" 
                         alt="<%= related.getTenDen() %>"
                         onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100%;height:200px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i></div>';">
                    <div class="related-card-info">
                        <div class="related-card-title"><%= related.getTenDen() %></div>
                        <div class="related-card-price"><%= nf.format(related.getGia()) %></div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
    
    <script>
        let selectedColor = <%= !variants.isEmpty() && variants.get(0).getMaMau() != null ? variants.get(0).getMaMau() : -1 %>;
        let selectedSize = <%= !variants.isEmpty() && variants.get(0).getMaKichThuoc() != null ? variants.get(0).getMaKichThuoc() : -1 %>;
        let selectedVariant = null;
        
        function changeMainImage(src) {
            document.getElementById('mainImage').src = src;
            document.querySelectorAll('.thumbnail').forEach(t => t.classList.remove('active'));
            event.target.classList.add('active');
        }
        
        function zoomImage(img) {
            if (img.style.transform === 'scale(2)') {
                img.style.transform = 'scale(1)';
                img.style.cursor = 'zoom-in';
            } else {
                img.style.transform = 'scale(2)';
                img.style.cursor = 'zoom-out';
            }
        }
        
        function selectColor(colorId) {
            const colorOption = event.target;
            if (colorOption.dataset.stock === '0') return;
            
            selectedColor = colorId;
            document.querySelectorAll('.color-option').forEach(c => c.classList.remove('active'));
            colorOption.classList.add('active');
            
            updateVariant();
        }
        
        function selectSize(sizeId) {
            const sizeOption = event.target;
            if (sizeOption.dataset.stock === '0') return;
            
            selectedSize = sizeId;
            document.querySelectorAll('.size-option').forEach(s => s.classList.remove('active'));
            sizeOption.classList.add('active');
            
            updateVariant();
        }
        
        function updateVariant() {
            // Tìm biến thể phù hợp với màu và kích thước đã chọn
            const variants = [
                <% for (BienTheDen v : variants) { %>
                {maBienThe: <%= v.getMaBienThe() %>, maMau: <%= v.getMaMau() != null ? v.getMaMau() : -1 %>, maKichThuoc: <%= v.getMaKichThuoc() != null ? v.getMaKichThuoc() : -1 %>, stock: <%= variantStock.get(v.getMaBienThe()) != null ? variantStock.get(v.getMaBienThe()) : 0 %>},
                <% } %>
            ];
            
            // Nếu không có variant nào, selectedVariant = null
            if (variants.length === 0) {
                selectedVariant = null;
                return;
            }
            
            selectedVariant = variants.find(v => 
                (selectedColor === -1 || v.maMau === selectedColor || v.maMau === -1) &&
                (selectedSize === -1 || v.maKichThuoc === selectedSize || v.maKichThuoc === -1)
            );
            
            // Nếu không tìm thấy variant phù hợp, lấy variant đầu tiên
            if (!selectedVariant && variants.length > 0) {
                selectedVariant = variants[0];
            }
            
            if (selectedVariant) {
                const stockInfo = document.getElementById('stockInfo');
                if (stockInfo) {
                    if (selectedVariant.stock > 0) {
                        stockInfo.textContent = 'Còn ' + selectedVariant.stock + ' sản phẩm';
                        stockInfo.className = 'stock-info in-stock';
                    } else {
                        stockInfo.textContent = 'Hết hàng';
                        stockInfo.className = 'stock-info out-of-stock';
                    }
                }
            }
        }
        
        // Khởi tạo variant khi trang load
        updateVariant();
        
        // Debug: Log selectedVariant sau khi khởi tạo
        console.log('🔍 Initial selectedVariant:', selectedVariant);
        console.log('🔍 Initial selectedColor:', selectedColor);
        console.log('🔍 Initial selectedSize:', selectedSize);
        
        function increaseQuantity() {
            const input = document.getElementById('quantity');
            let value = parseInt(input.value);
            const max = selectedVariant ? selectedVariant.stock : 10;
            if (value < max) {
                input.value = value + 1;
            }
        }
        
        function decreaseQuantity() {
            const input = document.getElementById('quantity');
            let value = parseInt(input.value);
            if (value > 1) {
                input.value = value - 1;
            }
        }
        
        function showTab(tabName) {
            document.querySelectorAll('.tab-header').forEach(h => h.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            event.target.classList.add('active');
            document.getElementById(tabName).classList.add('active');
        }
        
        function viewProduct(maDen) {
            window.location.href = '${pageContext.request.contextPath}/UserProductDetailServlet?id=' + maDen;
        }
        
        function addToCart() {
            console.log('🔍 addToCart() called');
            console.log('🔍 selectedVariant:', selectedVariant);
            console.log('🔍 selectedColor:', selectedColor);
            console.log('🔍 selectedSize:', selectedSize);
            
            // BẮT BUỘC PHẢI CÓ VARIANT TRƯỚC KHI THÊM VÀO GIỎ
            if (!selectedVariant) {
                console.error('❌ selectedVariant is null or undefined');
                alert('Vui lòng chọn màu sắc và kích thước sản phẩm!');
                return;
            }
            
            if (!selectedVariant.maBienThe || selectedVariant.maBienThe === 0) {
                console.error('❌ selectedVariant.maBienThe is invalid:', selectedVariant.maBienThe);
                alert('Vui lòng chọn màu sắc và kích thước sản phẩm!');
                return;
            }
            
            // Kiểm tra nếu variant hết hàng
            if (selectedVariant.stock === 0) {
                alert('Sản phẩm đã hết hàng!');
                return;
            }
            
            const quantityInput = document.getElementById('quantity');
            const quantity = quantityInput ? parseInt(quantityInput.value) || 1 : 1;
            
            // Lấy productId từ JSP - đảm bảo không null
            <% 
            int productIdValue = 0;
            if (product != null) {
                productIdValue = product.getMaDen();
            }
            %>
            const productId = <%= productIdValue %>;
            
            console.log('🔍 productId from JSP:', productId);
            
            // Validate productId
            if (!productId || productId === 0) {
                console.error('❌ productId không hợp lệ:', productId);
                alert('Lỗi: Không tìm thấy thông tin sản phẩm!');
                return;
            }
            
            // Lấy thông tin từ selectedVariant (BẮT BUỘC)
            const maBienThe = selectedVariant.maBienThe;
            const colorId = (selectedVariant.maMau && selectedVariant.maMau !== -1) ? selectedVariant.maMau : null;
            const sizeId = (selectedVariant.maKichThuoc && selectedVariant.maKichThuoc !== -1) ? selectedVariant.maKichThuoc : null;
            
            // Validate maBienThe
            if (!maBienThe || maBienThe === 0) {
                console.error('❌ maBienThe không hợp lệ:', maBienThe);
                alert('Lỗi: Không tìm thấy biến thể sản phẩm!');
                return;
            }
            
            // Kiểm tra số lượng không vượt quá tồn kho
            if (quantity > selectedVariant.stock) {
                alert('Số lượng yêu cầu vượt quá tồn kho! Hiện chỉ còn ' + selectedVariant.stock + ' sản phẩm.');
                return;
            }
            
            // Tạo URL-encoded form data thay vì FormData để đảm bảo server nhận được
            const params = new URLSearchParams();
            params.append('productId', String(productId));
            params.append('quantity', String(quantity));
            // BẮT BUỘC gửi maBienThe để server xác định chính xác variant
            params.append('variantId', String(maBienThe));
            if (colorId != null && colorId !== undefined && colorId !== '' && colorId !== -1) {
                params.append('colorId', String(colorId));
            }
            if (sizeId != null && sizeId !== undefined && sizeId !== '' && sizeId !== -1) {
                params.append('sizeId', String(sizeId));
            }
            
            console.log('🔍 Adding to cart:', {
                productId: productId,
                variantId: maBienThe,
                quantity: quantity,
                colorId: colorId,
                sizeId: sizeId,
                stock: selectedVariant.stock,
                selectedVariant: selectedVariant
            });
            
            // Debug: Kiểm tra params
            console.log('📦 URLSearchParams contents:');
            for (let pair of params.entries()) {
                console.log('   -', pair[0] + ':', pair[1]);
            }
            console.log('📦 URLSearchParams string:', params.toString());
            
            // Gọi servlet với application/x-www-form-urlencoded
            fetch('${pageContext.request.contextPath}/AddToCartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params.toString()
            })
            .then(response => {
                console.log('📥 Response status:', response.status);
                console.log('📥 Response headers:', response.headers);
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.text(); // Đọc text trước để debug
            })
            .then(text => {
                console.log('📥 Response text:', text);
                try {
                    const data = JSON.parse(text);
                    console.log('📥 Parsed JSON:', data);
                    
                    if (data.requireLogin) {
                        // Chưa đăng nhập - chuyển đến trang đăng nhập
                        if (confirm('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!\n\nBạn có muốn chuyển đến trang đăng nhập?')) {
                            window.location.href = '${pageContext.request.contextPath}/View/userLogin.jsp';
                        }
                    } else if (data.success) {
                        // Thành công
                        alert('Đã thêm ' + quantity + ' sản phẩm vào giỏ hàng!');
                        // Cập nhật số lượng giỏ hàng ở header
                        updateCartCount();
                    } else {
                        console.error('❌ Server error:', data);
                        alert('Có lỗi xảy ra: ' + (data.message || 'Không thể thêm sản phẩm vào giỏ hàng'));
                    }
                } catch (e) {
                    console.error('❌ JSON parse error:', e);
                    console.error('❌ Response text:', text);
                    alert('Có lỗi xảy ra khi xử lý phản hồi từ server!');
                }
            })
            .catch(error => {
                console.error('❌ Fetch error:', error);
                alert('Có lỗi xảy ra khi thêm vào giỏ hàng: ' + error.message);
            });
        }
        
        function updateCartCount() {
            // Cập nhật số lượng giỏ hàng ở header
            fetch('${pageContext.request.contextPath}/CartCountServlet')
                .then(response => response.json())
                .then(data => {
                    const cartCountElement = document.querySelector('.cart-count');
                    if (cartCountElement) {
                        cartCountElement.textContent = data.count;
                    }
                })
                .catch(error => console.error('Error updating cart count:', error));
        }
        
        function buyNow() {
            if (!selectedVariant || selectedVariant.stock === 0) {
                alert('Vui lòng chọn biến thể sản phẩm hoặc sản phẩm đã hết hàng!');
                return;
            }
            // TODO: Implement buy now
            alert('Chuyển đến trang thanh toán!');
        }
        
        // Initialize
        window.addEventListener('DOMContentLoaded', function() {
            updateVariant();
        });
    </script>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </body>
</html>
