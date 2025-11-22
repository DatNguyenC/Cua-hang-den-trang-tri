<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Den" %>
<%@ page import="Model.LoaiDen" %>
<%@ page import="DAO.DenDAO" %>
<%@ page import="DAO.LoaiDenDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="/layouts/header_user.jsp" %>
<%
    // Lấy dữ liệu từ servlet
    List<LoaiDen> categories = (List<LoaiDen>) request.getAttribute("categories");
    Map<Integer, Integer> categoryProductCount = (Map<Integer, Integer>) request.getAttribute("categoryProductCount");
    List<Den> featuredProducts = (List<Den>) request.getAttribute("featuredProducts");
    List<Den> newestProducts = (List<Den>) request.getAttribute("newestProducts");
    List<Den> bestSellingProducts = (List<Den>) request.getAttribute("bestSellingProducts");
    Integer totalProducts = (Integer) request.getAttribute("totalProducts");
    
    // Nếu không có dữ liệu từ servlet, tự động load
    if (categories == null || featuredProducts == null) {
        DenDAO denDAO = new DenDAO();
        LoaiDenDAO loaiDenDAO = new LoaiDenDAO();
        
        categories = loaiDenDAO.getAll();
        categoryProductCount = new java.util.HashMap<>();
        for (LoaiDen cat : categories) {
            categoryProductCount.put(cat.getMaLoai(), loaiDenDAO.countProductsByCategory(cat.getMaLoai()));
        }
        featuredProducts = denDAO.getFeaturedProducts(8);
        newestProducts = denDAO.getNewestProducts(8);
        bestSellingProducts = denDAO.getBestSellingProducts(8);
        totalProducts = denDAO.countSearchAndFilter(null, null, null, null);
    }
    
    // Format số tiền
    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ | LightStore - Cửa hàng đèn trang trí cao cấp</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background:#f8f9fa; color:#333; }

        /* ===== HERO BANNER ===== */
        .hero {
            position: relative;
            height: 90vh;
            min-height: 600px;
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.6)),
                        url('https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?q=80&w=2070&auto=format&fit=crop') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #fff;
        }
        .hero-content {
            max-width: 800px;
            padding: 20px;
        }
        .hero h1 {
            font-size: 56px;
            margin-bottom: 20px;
            font-weight: 700;
        }
        .hero h1 span {
            color: #ffd700;
            font-family: 'Dancing Script', cursive;
            font-size: 72px;
        }
        .hero p {
            font-size: 20px;
            margin-bottom: 30px;
            opacity: 0.9;
        }
        .btn {
            display: inline-block;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
            padding: 14px 40px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: bold;
            font-size: 18px;
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
        }
        .btn:hover { 
            background: linear-gradient(135deg, #ffa500, #ffd700); 
            transform: translateY(-3px); 
            box-shadow:0 10px 20px rgba(0,0,0,0.2); 
        }

        /* ===== SECTION TITLE ===== */
        .section-title {
            text-align: center;
            padding: 60px 20px 40px;
            font-size: 36px;
            color: #222;
            position: relative;
        }
        .section-title::after {
            content: '';
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            position: absolute;
            bottom: 25px;
            left: 50%;
            transform: translateX(-50%);
        }

        /* ===== PRODUCT GRID ===== */
        .product-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
            gap: 30px;
            margin-bottom: 80px;
        }
        .product-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: 0.4s;
            position: relative;
            cursor: pointer;
        }
        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 30px rgba(0,0,0,0.15);
        }
        .product-img {
            height: 280px;
            overflow: hidden;
            position: relative;
        }
        .product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: 0.5s;
        }
        .product-card:hover .product-img img { transform: scale(1.1); }
        
        .product-info {
            padding: 20px;
            text-align: center;
        }
        .product-info h3 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
            height: 50px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .price {
            font-size: 22px;
            color: #e74c3c;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .old-price {
            text-decoration: line-through;
            color: #999;
            font-size: 16px;
            margin-left: 8px;
        }
        .badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: #e74c3c;
            color: #fff;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: bold;
            z-index: 2;
        }
        .badge.new { background:#27ae60; }
        .badge.sale { background:#e67e22; }
        .badge.hot { background:#e74c3c; }
        
        .add-to-cart {
            background: #1a1a1a;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            margin-top: 10px;
            width: 100%;
        }
        .add-to-cart:hover {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
        }

        /* ===== FEATURES ===== */
        .features {
            background: #fff;
            padding: 50px 0;
            text-align: center;
            box-shadow: 0 -5px 20px rgba(0,0,0,0.05);
        }
        .features-container {
            max-width: 1000px;
            margin: 0 auto;
            display: flex;
            justify-content: center;
            gap: 60px;
            flex-wrap: wrap;
        }
        .feature {
            font-size: 16px;
        }
        .feature i {
            font-size: 42px;
            color: #ffd700;
            margin-bottom: 15px;
        }
        .feature h3 {
            font-size: 18px;
            margin-bottom: 8px;
        }
        
        /* ===== CATEGORIES ===== */
        .categories {
            background: #f5f5f5;
            padding: 60px 0;
        }
        .category-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
        }
        .category-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: 0.4s;
            position: relative;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }
        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 25px rgba(0,0,0,0.15);
        }
        .category-img {
            height: 200px;
            overflow: hidden;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 64px;
        }
        .category-info {
            padding: 20px;
            text-align: center;
        }
        .category-info h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #333;
        }
        .category-info p {
            color: #666;
            font-size: 14px;
        }
        
        /* ===== STATS ===== */
        .stats {
            background: #1a1a1a;
            color: #fff;
            padding: 80px 0;
            text-align: center;
        }
        .stats-container {
            max-width: 1000px;
            margin: 0 auto;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 40px;
        }
        .stat-item h2 {
            font-size: 48px;
            color: #ffd700;
            margin-bottom: 10px;
        }
        .stat-item p {
            font-size: 18px;
            opacity: 0.9;
        }
        
        /* ===== PRODUCTS SECTION ===== */
        .products-section {
            padding: 40px 0;
        }
        
        @media (max-width: 768px) {
            .hero h1 { font-size: 36px; }
            .hero h1 span { font-size: 48px; }
            .hero p { font-size: 16px; }
            .section-title { font-size: 28px; }
            .product-container { grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
            .category-container { grid-template-columns: 1fr; }
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet">
</head>
<body>

    <!-- HERO BANNER -->
    <section class="hero">
        <div class="hero-content">
            <h1>Chào mừng đến với <span>LightStore</span></h1>
            <p>Khám phá những mẫu đèn trang trí hiện đại, sang trọng – biến không gian sống thành nghệ thuật ánh sáng.</p>
            <a href="#featured-products" class="btn">Khám phá ngay</a>
        </div>
    </section>

    <!-- FEATURES -->
    <section class="features">
        <div class="features-container">
            <div class="feature">
                <i class="fa-solid fa-truck-fast"></i>
                <h3>Giao hàng nhanh chóng</h3>
                <p>Toàn quốc trong 2-5 ngày</p>
            </div>
            <div class="feature">
                <i class="fa-solid fa-shield-halved"></i>
                <h3>Bảo hành chính hãng</h3>
                <p>Đổi trả dễ dàng 1-1</p>
            </div>
            <div class="feature">
                <i class="fa-solid fa-headset"></i>
                <h3>Hỗ trợ 24/7</h3>
                <p>Tư vấn nhiệt tình mọi lúc</p>
            </div>
            <div class="feature">
                <i class="fa-solid fa-rotate-left"></i>
                <h3>Đổi trả miễn phí</h3>
                <p>Trong vòng 30 ngày</p>
            </div>
        </div>
    </section>

    <!-- DANH MỤC SẢN PHẨM -->
    <section class="categories">
        <h2 class="section-title">Danh mục sản phẩm</h2>
        <div class="category-container">
            <% if (categories != null && !categories.isEmpty()) { %>
                <% for (LoaiDen category : categories) { 
                    int productCount = categoryProductCount != null && categoryProductCount.containsKey(category.getMaLoai()) 
                        ? categoryProductCount.get(category.getMaLoai()) : 0;
                %>
                <a href="${pageContext.request.contextPath}/UserProductServlet?category=<%= category.getMaLoai() %>" class="category-card">
                    <div class="category-img">
                        <i class="fas fa-lightbulb"></i>
                    </div>
                    <div class="category-info">
                        <h3><%= category.getTenLoai() %></h3>
                        <p><%= productCount %>+ sản phẩm</p>
                    </div>
                </a>
                <% } %>
            <% } else { %>
                <p style="text-align: center; width: 100%; padding: 40px; color: #666;">Chưa có danh mục sản phẩm</p>
            <% } %>
        </div>
    </section>

    <!-- SẢN PHẨM NỔI BẬT -->
    <section class="products-section" id="featured-products">
        <h2 class="section-title">Sản phẩm nổi bật</h2>
        <div class="product-container">
            <% if (featuredProducts != null && !featuredProducts.isEmpty()) { %>
                <% for (Den product : featuredProducts) { 
                    String imagePath = "assets/images/product/den_tran.png"; // Fallback mặc định
                    String hinhAnh = product.getHinhAnh();
                    if (hinhAnh != null && !hinhAnh.trim().isEmpty()) {
                        hinhAnh = hinhAnh.trim();
                        // Tên file đã không có dấu, không cần encode
                        imagePath = "assets/images/product/" + hinhAnh;
                    }
                %>
                <div class="product-card" onclick="viewProduct(<%= product.getMaDen() %>)">
                    <span class="badge hot">Nổi bật</span>
                    <div class="product-img">
                        <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                             alt="<%= product.getTenDen() %>" 
                             onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100%;height:280px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i> Không có ảnh</div>';"
                             loading="lazy">
                    </div>
                    <div class="product-info">
                        <h3><%= product.getTenDen() %></h3>
                        <p class="price"><%= nf.format(product.getGia()) %>đ</p>
                        <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(<%= product.getMaDen() %>, 1);">
                            <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                        </button>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <p style="text-align: center; width: 100%; padding: 40px; color: #666;">Chưa có sản phẩm nổi bật</p>
            <% } %>
        </div>
    </section>

    <!-- SẢN PHẨM MỚI -->
    <section class="products-section" style="background:#f5f5f5; padding-top:40px;">
        <h2 class="section-title">Sản phẩm mới</h2>
        <div class="product-container">
            <% if (newestProducts != null && !newestProducts.isEmpty()) { %>
                <% for (Den product : newestProducts) { 
                    String imagePath = "assets/images/no-image.jpg";
                    if (product.getHinhAnh() != null && !product.getHinhAnh().trim().isEmpty()) {
                        imagePath = "assets/images/product/" + product.getHinhAnh();
                    }
                %>
                <div class="product-card" onclick="viewProduct(<%= product.getMaDen() %>)">
                    <span class="badge new">Mới</span>
                    <div class="product-img">
                        <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                             alt="<%= product.getTenDen() %>" 
                             onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100%;height:280px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i> Không có ảnh</div>';"
                             loading="lazy">
                    </div>
                    <div class="product-info">
                        <h3><%= product.getTenDen() %></h3>
                        <p class="price"><%= nf.format(product.getGia()) %>đ</p>
                        <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(<%= product.getMaDen() %>, 1);">
                            <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                        </button>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <p style="text-align: center; width: 100%; padding: 40px; color: #666;">Chưa có sản phẩm mới</p>
            <% } %>
        </div>
    </section>

    <!-- SẢN PHẨM BÁN CHẠY -->
    <section class="products-section">
        <h2 class="section-title">Sản phẩm bán chạy</h2>
        <div class="product-container">
            <% if (bestSellingProducts != null && !bestSellingProducts.isEmpty()) { %>
                <% for (Den product : bestSellingProducts) { 
                    String imagePath = "assets/images/no-image.jpg";
                    if (product.getHinhAnh() != null && !product.getHinhAnh().trim().isEmpty()) {
                        imagePath = "assets/images/product/" + product.getHinhAnh();
                    }
                %>
                <div class="product-card" onclick="viewProduct(<%= product.getMaDen() %>)">
                    <span class="badge sale">Bán chạy</span>
                    <div class="product-img">
                        <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                             alt="<%= product.getTenDen() %>" 
                             onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100%;height:280px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i> Không có ảnh</div>';"
                             loading="lazy">
                    </div>
                    <div class="product-info">
                        <h3><%= product.getTenDen() %></h3>
                        <p class="price"><%= nf.format(product.getGia()) %>đ</p>
                        <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(<%= product.getMaDen() %>, 1);">
                            <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                        </button>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <p style="text-align: center; width: 100%; padding: 40px; color: #666;">Chưa có sản phẩm bán chạy</p>
            <% } %>
        </div>
    </section>

    <!-- THỐNG KÊ -->
    <section class="stats">
        <div class="stats-container">
            <div class="stat-item">
                <h2><%= totalProducts != null ? totalProducts : 0 %>+</h2>
                <p>Sản phẩm đa dạng</p>
            </div>
            <div class="stat-item">
                <h2>10.000+</h2>
                <p>Khách hàng hài lòng</p>
            </div>
            <div class="stat-item">
                <h2>5 năm</h2>
                <p>Kinh nghiệm</p>
            </div>
            <div class="stat-item">
                <h2>63</h2>
                <p>Tỉnh thành phục vụ</p>
            </div>
        </div>
    </section>

<%@ include file="/layouts/footer_user.jsp" %>

<script>
    function viewProduct(maDen) {
        window.location.href = '${pageContext.request.contextPath}/ItemDetailServlet?maDen=' + maDen;
    }
    
    function addToCart(maDen, quantity) {
        <% if (user == null) { %>
            if (confirm('Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng. Bạn có muốn chuyển đến trang đăng nhập?')) {
                window.location.href = '${pageContext.request.contextPath}/View/userLogin.jsp?returnUrl=' + encodeURIComponent(window.location.href);
            }
            return;
        <% } %>
        
        // Gọi API thêm vào giỏ hàng
        fetch('${pageContext.request.contextPath}/CartServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=add&maDen=' + maDen + '&quantity=' + quantity
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Hiển thị thông báo
                alert('Đã thêm sản phẩm vào giỏ hàng!');
                // Cập nhật số lượng trong giỏ hàng nếu có hàm updateCartCount
                if (typeof updateCartCount === 'function') {
                    updateCartCount();
                }
            } else {
                alert('Có lỗi xảy ra: ' + (data.message || 'Vui lòng thử lại'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng');
        });
    }
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
</body>
</html>
