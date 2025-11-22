<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Den" %>
<%@ page import="Model.LoaiDen" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="DAO.*" %>
<%@ include file="/layouts/header_user.jsp" %>
<%
    // Kiểm tra nếu không có dữ liệu từ servlet, tự động load
    List<Den> products = (List<Den>) request.getAttribute("products");
    List<LoaiDen> categories = (List<LoaiDen>) request.getAttribute("categories");
    String keyword = (String) request.getAttribute("keyword");
    Integer selectedCategory = (Integer) request.getAttribute("selectedCategory");
    Double minPrice = (Double) request.getAttribute("minPrice");
    Double maxPrice = (Double) request.getAttribute("maxPrice");
    String sortBy = (String) request.getAttribute("sortBy");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalProducts = (Integer) request.getAttribute("totalProducts");
    
    // Nếu không có dữ liệu từ servlet, tự động load từ DAO
    if (products == null || categories == null) {
        DenDAO denDAO = new DenDAO();
        LoaiDenDAO loaiDenDAO = new LoaiDenDAO();
        
        // Lấy tham số từ request
        String keywordParam = request.getParameter("keyword");
        String categoryParam = request.getParameter("category");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String sortByParam = request.getParameter("sort");
        String pageParam = request.getParameter("page");
        
        // Parse các tham số
        Integer maLoai = null;
        if (categoryParam != null && !categoryParam.isEmpty() && !categoryParam.equals("0")) {
            try {
                maLoai = Integer.parseInt(categoryParam);
            } catch (NumberFormatException e) {
                maLoai = null;
            }
        }
        
        Double minPriceValue = null;
        if (minPriceParam != null && !minPriceParam.isEmpty()) {
            try {
                minPriceValue = Double.parseDouble(minPriceParam);
            } catch (NumberFormatException e) {
                minPriceValue = null;
            }
        }
        
        Double maxPriceValue = null;
        if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
            try {
                maxPriceValue = Double.parseDouble(maxPriceParam);
            } catch (NumberFormatException e) {
                maxPriceValue = null;
            }
        }
        
        int pageNum = 1;
        int itemsPerPage = 12;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                pageNum = Integer.parseInt(pageParam);
                if (pageNum < 1) pageNum = 1;
            } catch (NumberFormatException e) {
                pageNum = 1;
            }
        }
        
        int offset = (pageNum - 1) * itemsPerPage;
        
        // Lấy danh sách sản phẩm
        products = denDAO.searchAndFilter(keywordParam, maLoai, minPriceValue, maxPriceValue, sortByParam, offset, itemsPerPage);
        
        // Đếm tổng số sản phẩm
        totalProducts = denDAO.countSearchAndFilter(keywordParam, maLoai, minPriceValue, maxPriceValue);
        totalPages = (int) Math.ceil((double) totalProducts / itemsPerPage);
        
        // Lấy danh sách loại đèn
        categories = loaiDenDAO.getAll();
        
        // Set các giá trị
        keyword = keywordParam != null ? keywordParam : "";
        selectedCategory = maLoai != null ? maLoai : 0;
        minPrice = minPriceValue != null ? minPriceValue : 0.0;
        maxPrice = maxPriceValue != null ? maxPriceValue : 0.0;
        sortBy = sortByParam != null ? sortByParam : "";
        currentPage = pageNum;
    }
    
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    if (products == null) products = new java.util.ArrayList<>();
    if (categories == null) categories = new java.util.ArrayList<>();
    if (keyword == null) keyword = "";
    if (selectedCategory == null) selectedCategory = 0;
    if (minPrice == null) minPrice = 0.0;
    if (maxPrice == null) maxPrice = 0.0;
    if (sortBy == null) sortBy = "";
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (totalProducts == null) totalProducts = 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm | LightStore - Cửa hàng đèn trang trí cao cấp</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .products-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        
        .page-header {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: #fff;
            padding: 40px 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .page-header h1 {
            font-size: 42px;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .page-header p {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .products-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 30px;
        }
        
        /* Sidebar Filters */
        .filters-sidebar {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .filter-section {
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .filter-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .filter-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #1a1a1a;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-title i {
            color: #ffd700;
        }
        
        .category-list {
            list-style: none;
        }
        
        .category-item {
            margin-bottom: 10px;
        }
        
        .category-item a {
            display: block;
            padding: 10px 15px;
            color: #555;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .category-item a:hover,
        .category-item a.active {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .price-filter {
            display: flex;
            gap: 10px;
            flex-direction: column;
        }
        
        .price-input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .btn-filter {
            background: linear-gradient(135deg, #1a1a1a, #2d2d2d);
            color: #fff;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
        }
        
        .btn-filter:hover {
            background: linear-gradient(135deg, #2d2d2d, #1a1a1a);
            transform: translateY(-2px);
        }
        
        /* Main Content */
        .products-main {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .products-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 12px 45px 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #ffd700;
        }
        
        .search-box button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(135deg, #ffd700, #ffa500);
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .toolbar-right {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .sort-select,
        .view-toggle {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            background: #fff;
            transition: all 0.3s;
        }
        
        .sort-select:focus,
        .view-toggle:focus {
            outline: none;
            border-color: #ffd700;
        }
        
        .view-toggle {
            display: flex;
            gap: 8px;
        }
        
        .view-btn {
            padding: 8px 12px;
            border: none;
            background: #f0f0f0;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .view-btn.active {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
        }
        
        .products-count {
            color: #666;
            font-size: 14px;
        }
        
        /* Products Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .products-list {
            display: none;
            flex-direction: column;
            gap: 20px;
        }
        
        .products-list.active {
            display: flex;
        }
        
        .products-grid.active {
            display: grid;
        }
        
        .product-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .product-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            background: #f0f0f0;
            display: block;
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-category {
            font-size: 12px;
            color: #999;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        
        .product-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #1a1a1a;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-price {
            font-size: 24px;
            font-weight: 700;
            color: #ff6b6b;
            margin-bottom: 15px;
        }
        
        .product-description {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-view,
        .btn-cart {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-view {
            background: #f0f0f0;
            color: #333;
        }
        
        .btn-view:hover {
            background: #e0e0e0;
        }
        
        .btn-cart {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
        }
        
        .btn-cart:hover {
            transform: scale(1.05);
        }
        
        /* List View */
        .product-item-list {
            display: grid;
            grid-template-columns: 200px 1fr auto;
            gap: 20px;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        
        .product-item-list:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        
        .product-item-list .product-image {
            height: 200px;
            width: 100%;
            object-fit: cover;
            background: #f0f0f0;
            display: block;
        }
        
        .product-item-list .product-info {
            padding: 20px;
        }
        
        .product-item-list .product-actions {
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 10px;
        }
        
        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }
        
        .pagination a,
        .pagination span {
            padding: 10px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            border-color: #ffd700;
            color: #1a1a1a;
        }
        
        .pagination .active {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            border-color: #ffd700;
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .pagination .disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .no-products {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .no-products i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .products-layout {
                grid-template-columns: 1fr;
            }
            
            .filters-sidebar {
                position: static;
            }
        }
        
        @media (max-width: 768px) {
            .products-toolbar {
                flex-direction: column;
            }
            
            .search-box {
                width: 100%;
            }
            
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 15px;
            }
            
            .product-item-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="page-header">
        <h1>🛍️ Sản Phẩm</h1>
        <p>Khám phá bộ sưu tập đèn trang trí cao cấp của chúng tôi</p>
    </div>
    
    <div class="products-container">
        <div class="products-layout">
            <!-- Sidebar Filters -->
            <aside class="filters-sidebar">
                <form method="get" action="${pageContext.request.contextPath}/UserProductServlet" id="filterForm">
                    <input type="hidden" name="keyword" value="<%= keyword %>">
                    <input type="hidden" name="sort" value="<%= sortBy %>">
                    
                    <!-- Category Filter -->
                    <div class="filter-section">
                        <h3 class="filter-title">
                            <i class="fas fa-th-large"></i>
                            Danh mục
                        </h3>
                        <ul class="category-list">
                            <li class="category-item">
                                <a href="${pageContext.request.contextPath}/UserProductServlet?category=0&keyword=<%= keyword %>&sort=<%= sortBy %>" 
                                   class="<%= selectedCategory == 0 ? "active" : "" %>">
                                    Tất cả sản phẩm
                                </a>
                            </li>
                            <% for (LoaiDen category : categories) { %>
                            <li class="category-item">
                                <a href="${pageContext.request.contextPath}/UserProductServlet?category=<%= category.getMaLoai() %>&keyword=<%= keyword %>&sort=<%= sortBy %>" 
                                   class="<%= selectedCategory == category.getMaLoai() ? "active" : "" %>">
                                    <%= category.getTenLoai() %>
                                </a>
                            </li>
                            <% } %>
                        </ul>
                    </div>
                    
                    <!-- Price Filter -->
                    <div class="filter-section">
                        <h3 class="filter-title">
                            <i class="fas fa-dollar-sign"></i>
                            Khoảng giá
                        </h3>
                        <div class="price-filter">
                            <input type="number" name="minPrice" class="price-input" 
                                   placeholder="Giá tối thiểu" value="<%= minPrice > 0 ? String.format("%.0f", minPrice) : "" %>">
                            <input type="number" name="maxPrice" class="price-input" 
                                   placeholder="Giá tối đa" value="<%= maxPrice > 0 ? String.format("%.0f", maxPrice) : "" %>">
                            <button type="submit" class="btn-filter">Áp dụng</button>
                        </div>
                    </div>
                </form>
            </aside>
            
            <!-- Main Content -->
            <main class="products-main">
                <!-- Toolbar -->
                <div class="products-toolbar">
                    <form method="get" action="${pageContext.request.contextPath}/UserProductServlet" class="search-box">
                        <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..." 
                               value="<%= keyword %>">
                        <input type="hidden" name="category" value="<%= selectedCategory %>">
                        <input type="hidden" name="sort" value="<%= sortBy %>">
                        <button type="submit"><i class="fas fa-search"></i> Tìm</button>
                    </form>
                    
                    <div class="toolbar-right">
                        <span class="products-count">
                            Hiển thị <%= products.size() %> / <%= totalProducts %> sản phẩm
                        </span>
                        
                        <select name="sort" class="sort-select" onchange="changeSort(this.value)">
                            <option value="" <%= sortBy.isEmpty() ? "selected" : "" %>>Sắp xếp mặc định</option>
                            <option value="name_asc" <%= sortBy.equals("name_asc") ? "selected" : "" %>>Tên A-Z</option>
                            <option value="name_desc" <%= sortBy.equals("name_desc") ? "selected" : "" %>>Tên Z-A</option>
                            <option value="price_asc" <%= sortBy.equals("price_asc") ? "selected" : "" %>>Giá tăng dần</option>
                            <option value="price_desc" <%= sortBy.equals("price_desc") ? "selected" : "" %>>Giá giảm dần</option>
                        </select>
                        
                        <div class="view-toggle">
                            <button class="view-btn active" onclick="changeView('grid')" title="Lưới">
                                <i class="fas fa-th"></i>
                            </button>
                            <button class="view-btn" onclick="changeView('list')" title="Danh sách">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Products Display -->
                <% if (products.isEmpty()) { %>
                <div class="no-products">
                    <i class="fas fa-box-open"></i>
                    <h3>Không tìm thấy sản phẩm nào</h3>
                    <p>Vui lòng thử lại với từ khóa hoặc bộ lọc khác</p>
                </div>
                <% } else { %>
                
                <!-- Grid View -->
                <div class="products-grid active" id="gridView">
                    <% for (Den product : products) { %>
                    <div class="product-card" onclick="viewProduct(<%= product.getMaDen() %>)">
                        <%
                            String imagePath = "assets/images/product/den_tran.png"; // Fallback mặc định
                            String hinhAnh = product.getHinhAnh();
                            if (hinhAnh != null && !hinhAnh.trim().isEmpty()) {
                                hinhAnh = hinhAnh.trim();
                                // Tên file đã không có dấu, không cần encode
                                imagePath = "assets/images/product/" + hinhAnh;
                            }
                        %>
                        <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                             alt="<%= product.getTenDen() != null ? product.getTenDen() : "Sản phẩm" %>" 
                             class="product-image"
                             onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100%;height:250px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i> Không có ảnh</div>';"
                             loading="lazy">
                        <div class="product-info">
                            <div class="product-category">
                                <% 
                                    String categoryName = "Sản phẩm";
                                    for (LoaiDen cat : categories) {
                                        if (cat.getMaLoai() == product.getMaLoai()) {
                                            categoryName = cat.getTenLoai();
                                            break;
                                        }
                                    }
                                %>
                                <%= categoryName %>
                            </div>
                            <h3 class="product-name"><%= product.getTenDen() %></h3>
                            <div class="product-price"><%= nf.format(product.getGia()) %></div>
                            <p class="product-description"><%= product.getMoTa() != null ? product.getMoTa() : "" %></p>
                            <div class="product-actions">
                                <button class="btn-view" onclick="event.stopPropagation(); viewProduct(<%= product.getMaDen() %>)">
                                    <i class="fas fa-eye"></i> Xem
                                </button>
                                <button class="btn-cart" onclick="event.stopPropagation(); addToCart(<%= product.getMaDen() %>)">
                                    <i class="fas fa-cart-plus"></i> Giỏ hàng
                                </button>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <!-- List View -->
                <div class="products-list" id="listView">
                    <% for (Den product : products) { %>
                    <div class="product-item-list" onclick="viewProduct(<%= product.getMaDen() %>)">
                        <%
                            String imagePath = "assets/images/product/den_tran.png"; // Fallback mặc định
                            String hinhAnh = product.getHinhAnh();
                            if (hinhAnh != null && !hinhAnh.trim().isEmpty()) {
                                hinhAnh = hinhAnh.trim();
                                // Tên file đã không có dấu, không cần encode
                                imagePath = "assets/images/product/" + hinhAnh;
                            }
                        %>
                        <img src="${pageContext.request.contextPath}/<%= imagePath %>" 
                             alt="<%= product.getTenDen() != null ? product.getTenDen() : "Sản phẩm" %>" 
                             class="product-image"
                             onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div style=\\'width:100%;height:250px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#999;\\'><i class=\\'fas fa-image\\'></i> Không có ảnh</div>';"
                             loading="lazy">
                        <div class="product-info">
                            <div class="product-category">
                                <% 
                                    String categoryName = "Sản phẩm";
                                    for (LoaiDen cat : categories) {
                                        if (cat.getMaLoai() == product.getMaLoai()) {
                                            categoryName = cat.getTenLoai();
                                            break;
                                        }
                                    }
                                %>
                                <%= categoryName %>
                            </div>
                            <h3 class="product-name"><%= product.getTenDen() %></h3>
                            <div class="product-price"><%= nf.format(product.getGia()) %></div>
                            <p class="product-description"><%= product.getMoTa() != null ? product.getMoTa() : "" %></p>
                        </div>
                        <div class="product-actions">
                            <button class="btn-view" onclick="event.stopPropagation(); viewProduct(<%= product.getMaDen() %>)">
                                <i class="fas fa-eye"></i> Xem chi tiết
                            </button>
                            <button class="btn-cart" onclick="event.stopPropagation(); addToCart(<%= product.getMaDen() %>)">
                                <i class="fas fa-cart-plus"></i> Thêm giỏ hàng
                            </button>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <% } %>
                
                <!-- Pagination -->
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="${pageContext.request.contextPath}/UserProductServlet?page=<%= currentPage - 1 %>&category=<%= selectedCategory %>&keyword=<%= keyword %>&sort=<%= sortBy %>&minPrice=<%= minPrice > 0 ? String.format("%.0f", minPrice) : "" %>&maxPrice=<%= maxPrice > 0 ? String.format("%.0f", maxPrice) : "" %>">
                        <i class="fas fa-chevron-left"></i> Trước
                    </a>
                    <% } else { %>
                    <span class="disabled"><i class="fas fa-chevron-left"></i> Trước</span>
                    <% } %>
                    
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <% if (i == currentPage) { %>
                        <span class="active"><%= i %></span>
                        <% } else if (i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) { %>
                        <a href="${pageContext.request.contextPath}/UserProductServlet?page=<%= i %>&category=<%= selectedCategory %>&keyword=<%= keyword %>&sort=<%= sortBy %>&minPrice=<%= minPrice > 0 ? String.format("%.0f", minPrice) : "" %>&maxPrice=<%= maxPrice > 0 ? String.format("%.0f", maxPrice) : "" %>">
                            <%= i %>
                        </a>
                        <% } else if (i == currentPage - 3 || i == currentPage + 3) { %>
                        <span>...</span>
                        <% } %>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                    <a href="${pageContext.request.contextPath}/UserProductServlet?page=<%= currentPage + 1 %>&category=<%= selectedCategory %>&keyword=<%= keyword %>&sort=<%= sortBy %>&minPrice=<%= minPrice > 0 ? String.format("%.0f", minPrice) : "" %>&maxPrice=<%= maxPrice > 0 ? String.format("%.0f", maxPrice) : "" %>">
                        Sau <i class="fas fa-chevron-right"></i>
                    </a>
                    <% } else { %>
                    <span class="disabled">Sau <i class="fas fa-chevron-right"></i></span>
                    <% } %>
                </div>
                <% } %>
            </main>
        </div>
    </div>
    
    <script>
        function changeSort(sortBy) {
            const url = new URL(window.location.href);
            url.searchParams.set('sort', sortBy);
            url.searchParams.set('page', '1');
            window.location.href = url.toString();
        }
        
        function changeView(view) {
            const gridView = document.getElementById('gridView');
            const listView = document.getElementById('listView');
            const viewBtns = document.querySelectorAll('.view-btn');
            
            viewBtns.forEach(btn => btn.classList.remove('active'));
            
            if (view === 'grid') {
                gridView.classList.add('active');
                listView.classList.remove('active');
                viewBtns[0].classList.add('active');
                localStorage.setItem('productView', 'grid');
            } else {
                gridView.classList.remove('active');
                listView.classList.add('active');
                viewBtns[1].classList.add('active');
                localStorage.setItem('productView', 'list');
            }
        }
        
        function viewProduct(maDen) {
            window.location.href = '${pageContext.request.contextPath}/UserProductDetailServlet?id=' + maDen;
        }
        
        function addToCart(maDen) {
            // Chuyển đến trang chi tiết để chọn variant (màu sắc, kích thước)
            // Vì cần phải có variant mới thêm được vào giỏ hàng
            window.location.href = '${pageContext.request.contextPath}/UserProductDetailServlet?id=' + maDen;
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
        
        // Load saved view preference
        window.addEventListener('DOMContentLoaded', function() {
            const savedView = localStorage.getItem('productView');
            if (savedView) {
                changeView(savedView);
            }
        });
    </script>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>

