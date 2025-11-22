<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.NguoiDung" %>
<%@ page import="Model.GioHang" %>
<%@ page import="DAO.NguoiDungDAO" %>
<%
    // Kiểm tra session user
    NguoiDung user = null;
    if (session != null) {
        user = (NguoiDung) session.getAttribute("user");
    }
    
    // Nếu chưa có session, kiểm tra cookie
    if (user == null) {
        Cookie[] cookies = request.getCookies();
        String email = null;
        String password = null;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userEmail")) {
                    email = cookie.getValue();
                }
                if (cookie.getName().equals("userPassword")) {
                    password = cookie.getValue();
                }
            }
        }
        
        // Nếu có cookie, thử đăng nhập lại
        if (email != null && password != null) {
            NguoiDungDAO dao = new NguoiDungDAO();
            user = dao.checkLogin(email, password);
            
            if (user != null && (user.getVaiTro() == null || !user.getVaiTro().equalsIgnoreCase("admin"))) {
                // Tạo session mới từ cookie
                session = request.getSession(true);
                session.setAttribute("user", user);
            } else {
                user = null;
            }
        }
    }
    
    // Kiểm tra nếu là admin thì không hiển thị
    if (user != null && user.getVaiTro() != null && user.getVaiTro().equalsIgnoreCase("admin")) {
        user = null;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>LightStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        /* Header chính */
        .header-top {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: #fff;
            padding: 10px 0;
            font-size: 14px;
            text-align: center;
            border-bottom: 1px solid #333;
        }

        .header-main {
            background: #1a1a1a;
            padding: 15px 0;
            position: relative;
        }

        .container {
            width: 1200px;
            max-width: 92%;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
        }

        /* Logo mới - thiết kế tinh tế phù hợp với LightStore */
        .logo-container {
            display: flex;
            align-items: center;
            text-decoration: none;
            transition: transform 0.3s ease;
        }
        
        .logo-container:hover {
            transform: translateY(-2px);
        }
        
        .logo-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            border-radius: 8px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
            margin-right: 15px;
            overflow: hidden;
        }
        
        .logo-icon::before {
            content: "";
            position: absolute;
            width: 30px;
            height: 30px;
            background: #fff;
            border-radius: 50%;
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.7);
            opacity: 0.9;
        }
        
        .logo-icon::after {
            content: "";
            position: absolute;
            width: 15px;
            height: 15px;
            background: #ffd700;
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(255, 215, 0, 0.8);
            z-index: 2;
        }
        
        .logo-text {
            display: flex;
            flex-direction: column;
        }
        
        .logo-main {
            color: #fff;
            font-size: 28px;
            font-weight: 700;
            letter-spacing: 1px;
            line-height: 1;
        }
        
        .logo-subtitle {
            color: #ffd700;
            font-size: 12px;
            letter-spacing: 3px;
            margin-top: 2px;
            font-weight: 500;
        }

        /* Search bar */
        .search-box-header {
            flex: 1;
            max-width: 500px;
            margin: 0 30px;
            position: relative;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-box-header input {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 30px;
            font-size: 15px;
            background: #2d2d2d;
            color: #fff;
            border: 1px solid #444;
        }

        .search-box-header input:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 2px rgba(255, 215, 0, 0.2);
        }

        .search-box-header input::placeholder {
            color: #aaa;
        }

        .search-box-header button {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
            border: none;
            padding: 12px 25px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 30px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .search-box-header button:hover {
            background: linear-gradient(135deg, #ffa500, #ffd700);
            transform: scale(1.05);
        }

        /* Tài khoản & Giỏ hàng */
        .user-actions {
            display: flex;
            align-items: center;
            gap: 20px;
            color: #fff;
            font-size: 14px;
        }

        .account-link a {
            color: #fff;
            text-decoration: none;
            transition: color 0.3s;
        }

        .account-link a:hover { 
            color: #ffd700;
        }
        
        /* User Dropdown */
        .user-profile {
            position: relative;
        }
        
        .user-profile-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #fff;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 25px;
            transition: all 0.3s;
            cursor: pointer;
            background: rgba(255, 255, 255, 0.1);
        }
        
        .user-profile-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            color: #ffd700;
        }
        
        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1a1a1a;
            font-weight: 700;
            font-size: 14px;
        }
        
        .user-name {
            font-weight: 600;
            font-size: 14px;
        }
        
        .user-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 10px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            min-width: 220px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
            z-index: 1000;
            overflow: hidden;
        }
        
        .user-dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        
        .dropdown-header {
            background: linear-gradient(135deg, #1a1a1a, #2d2d2d);
            padding: 20px;
            color: #fff;
        }
        
        .dropdown-header-user {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .dropdown-header-user .user-avatar {
            width: 50px;
            height: 50px;
            font-size: 18px;
        }
        
        .dropdown-header-info {
            flex: 1;
        }
        
        .dropdown-header-name {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 4px;
        }
        
        .dropdown-header-email {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .dropdown-menu {
            list-style: none;
            padding: 8px 0;
        }
        
        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 14px;
        }
        
        .dropdown-item i {
            width: 20px;
            color: #666;
        }
        
        .dropdown-item:hover {
            background: #f5f5f5;
            color: #ffd700;
        }
        
        .dropdown-item:hover i {
            color: #ffd700;
        }
        
        .dropdown-divider {
            height: 1px;
            background: #e0e0e0;
            margin: 8px 0;
        }

        .cart {
            position: relative;
        }

        .cart a {
            color: #fff;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s;
        }

        .cart a:hover {
            color: #ffd700;
        }

        .cart-icon {
            font-size: 20px;
        }

        .cart-count {
            position: absolute;
            top: -10px;
            right: -12px;
            background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
            color: #fff;
            font-size: 12px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        /* Menu chính */
        .main-menu {
            background: #222;
            padding: 12px 0;
            border-top: 1px solid #333;
        }

        .main-menu ul {
            list-style: none;
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
        }

        .main-menu a {
            color: #fff;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            text-transform: uppercase;
            padding: 8px 0;
            position: relative;
            transition: color 0.3s;
        }

        .main-menu a:hover {
            color: #ffd700;
        }

        .main-menu a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: #ffd700;
            transition: width 0.3s ease;
        }

        .main-menu a:hover::after {
            width: 100%;
        }

        /* Icon dịch vụ */
        .service-bar {
            background: #f8f8f8;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .services {
            display: flex;
            justify-content: center;
            gap: 60px;
            flex-wrap: wrap;
            font-size: 14px;
            color: #333;
        }

        .service-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .service-item i {
            font-size: 20px;
            color: #e74c3c;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .user-name {
                display: none;
            }
            
            .user-dropdown {
                right: -50px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        function toggleUserDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }
        
        function viewAccount() {
            window.location.href = '${pageContext.request.contextPath}/UserAccountServlet';
        }
        
        function changePassword() {
            window.location.href = '${pageContext.request.contextPath}/UserChangePasswordServlet';
        }
        
        function viewOrders() {
            window.location.href = '${pageContext.request.contextPath}/MyOrderServlet';
        }
        
        // Đóng dropdown khi click ra ngoài
        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('userDropdown');
            const profileBtn = document.querySelector('.user-profile-btn');
            
            if (dropdown && profileBtn && !dropdown.contains(event.target) && !profileBtn.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        });
    </script>
</head>
<body>

    <!-- Header -->
    <header>
        <!-- Top bar chào mừng -->
        <div class="header-top">
            Chào mừng bạn đến với cửa hàng đèn trang trí LightStore - Nghệ thuật ánh sáng cho không gian sống!
        </div>

        <!-- Header chính -->
        <div class="header-main">
            <div class="container">
                <!-- Logo mới với biểu tượng bóng đèn tinh tế -->
                <a href="/View/userHome.jsp" class="logo-container">
                    <div class="logo-icon"></div>
                    <div class="logo-text">
                        <div class="logo-main">LightStore</div>
                        <div class="logo-subtitle">ÁNH SÁNG & NGHỆ THUẬT</div>
                    </div>
                </a>

                <!-- Ô tìm kiếm -->
                <form action="${pageContext.request.contextPath}/UserProductServlet" method="get" class="search-box-header">
                    <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm...">
                    <button type="submit">TÌM KIẾM</button>
                </form>

                <!-- Tài khoản & Giỏ hàng -->
                <div class="user-actions">
                    <% if (user == null) { %>
                    <!-- Chưa đăng nhập -->
                    <div class="account-link">
                        <a href="${pageContext.request.contextPath}/View/userLogin.jsp">Đăng nhập</a> / 
                        <a href="${pageContext.request.contextPath}/View/userRegister.jsp">Đăng ký</a>
                    </div>
                    <% } else { %>
                    <!-- Đã đăng nhập -->
                    <div class="user-profile">
                        <div class="user-profile-btn" onclick="toggleUserDropdown()">
                            <div class="user-avatar">
                                <%= user.getTenDangNhap() != null && !user.getTenDangNhap().isEmpty() 
                                    ? user.getTenDangNhap().substring(0, 1).toUpperCase() : "U" %>
                            </div>
                            <span class="user-name"><%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "User" %></span>
                            <i class="fas fa-chevron-down" style="font-size: 12px;"></i>
                        </div>
                        <div class="user-dropdown" id="userDropdown">
                            <div class="dropdown-header">
                                <div class="dropdown-header-user">
                                    <div class="user-avatar">
                                        <%= user.getTenDangNhap() != null && !user.getTenDangNhap().isEmpty() 
                                            ? user.getTenDangNhap().substring(0, 1).toUpperCase() : "U" %>
                                    </div>
                                    <div class="dropdown-header-info">
                                        <div class="dropdown-header-name"><%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "User" %></div>
                                        <div class="dropdown-header-email"><%= user.getEmail() != null ? user.getEmail() : "" %></div>
                                    </div>
                                </div>
                            </div>
                            <ul class="dropdown-menu">
                                <li>
                                    <a href="#" class="dropdown-item" onclick="viewAccount()">
                                        <i class="fas fa-user-circle"></i>
                                        <span>Thông tin tài khoản</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="#" class="dropdown-item" onclick="changePassword()">
                                        <i class="fas fa-key"></i>
                                        <span>Đổi mật khẩu</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/MyOrderServlet" class="dropdown-item">
                                        <i class="fas fa-shopping-bag"></i>
                                        <span>Đơn hàng của tôi</span>
                                    </a>
                                </li>
                                <li class="dropdown-divider"></li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="dropdown-item" style="color: #dc2626;">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Đăng xuất</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <% } %>
                    <div class="cart">
                        <a href="${pageContext.request.contextPath}/CartServlet">
                            <i class="fas fa-shopping-cart cart-icon"></i>
                            <span>Giỏ hàng</span>
                            <span class="cart-count" id="cartCount">
                                <%
                                    Model.GioHang cart = null;
                                    if (user != null && session != null) {
                                        cart = (Model.GioHang) session.getAttribute("cart");
                                    }
                                    int cartCount = (cart != null) ? cart.getTotalItems() : 0;
                                %>
                                <%= cartCount %>
                            </span>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Menu chính -->
        <nav class="main-menu">
            <div class="container">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/View/userHome.jsp">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/elements/about.jsp">Giới thiệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/elements/UserProduct.jsp">Sản phẩm</a></li>
                    <li><a href="#">Bộ sưu tập</a></li>
                    <li><a href="${pageContext.request.contextPath}/elements/news.jsp">Tin tức</a></li>
                    <li><a href="${pageContext.request.contextPath}/elements/contact.jsp">Liên hệ</a></li>
                </ul>
            </div>
        </nav>
    </header>

</body>
</html>