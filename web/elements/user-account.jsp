<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.NguoiDung" %>
<%@ include file="/layouts/header_user.jsp" %>
<%
    // Biến user đã được khai báo trong header_user.jsp
    // Chỉ lấy từ request attribute nếu có (từ servlet), nếu không thì dùng biến từ header
    NguoiDung userFromRequest = (NguoiDung) request.getAttribute("user");
    if (userFromRequest != null) {
        user = userFromRequest;
    }
    
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/View/userLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin tài khoản | LightStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .account-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .account-header {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .account-header h1 {
            font-size: 32px;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .account-header p {
            color: #666;
            font-size: 16px;
        }
        
        .account-content {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 30px;
        }
        
        .account-sidebar {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin-bottom: 10px;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 15px;
            color: #666;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .sidebar-menu a:hover {
            background: #f0f0f0;
            color: #ffd700;
        }
        
        .sidebar-menu a.active {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .sidebar-menu a i {
            width: 20px;
            text-align: center;
        }
        
        .account-main {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 25px;
            color: #1a1a1a;
            padding-bottom: 15px;
            border-bottom: 2px solid #ffd700;
        }
        
        .info-group {
            margin-bottom: 25px;
        }
        
        .info-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #666;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-value {
            font-size: 18px;
            color: #1a1a1a;
            padding: 12px 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .info-value input {
            width: 100%;
            padding: 12px 15px;
            font-size: 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background: #fff;
            transition: border-color 0.3s;
            font-family: inherit;
        }
        
        .info-value input:focus {
            outline: none;
            border-color: #ffd700;
        }
        
        .info-value input:disabled {
            background: #f8f9fa;
            cursor: not-allowed;
        }
        
        .edit-mode .info-value {
            background: #fff;
            padding: 0;
        }
        
        .view-mode .info-value input {
            display: none;
        }
        
        .edit-mode .info-value span {
            display: none;
        }
        
        .info-value.static-field span,
        .edit-mode .info-value.static-field span {
            display: block;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        /* Mặc định ẩn nhóm nút Lưu/Hủy, chỉ hiện khi ở chế độ edit */
        .action-buttons.edit-buttons {
            display: none;
        }
        
        .edit-mode .action-buttons.edit-buttons {
            display: flex;
        }
        
        .edit-mode .action-buttons.view-buttons {
            display: none;
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
        
        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
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
        
        .user-avatar-section {
            text-align: center;
            padding: 30px 0;
            border-bottom: 2px solid #f0f0f0;
            margin-bottom: 30px;
        }
        
        .user-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ffd700, #ffa500);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1a1a1a;
            font-weight: 700;
            font-size: 48px;
            margin: 0 auto 20px;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
        }
        
        .user-name-large {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .user-email-large {
            font-size: 16px;
            color: #666;
        }
        
        @media (max-width: 768px) {
            .account-content {
                grid-template-columns: 1fr;
            }
            
            .account-sidebar {
                position: static;
            }
            
            .sidebar-menu {
                display: flex;
                overflow-x: auto;
                gap: 10px;
            }
            
            .sidebar-menu li {
                margin-bottom: 0;
                flex-shrink: 0;
            }
        }
    </style>
</head>
<body>
    <div class="account-container">
        <div class="account-header">
            <h1><i class="fas fa-user-circle"></i> Thông tin tài khoản</h1>
            <p>Quản lý thông tin cá nhân của bạn</p>
        </div>
        
        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> <%= successMessage %>
        </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
        </div>
        <% } %>
        
        <div class="account-content">
            <div class="account-sidebar">
                <ul class="sidebar-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/UserAccountServlet" class="active">
                            <i class="fas fa-user"></i>
                            <span>Thông tin tài khoản</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/UserChangePasswordServlet">
                            <i class="fas fa-key"></i>
                            <span>Đổi mật khẩu</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/MyOrderServlet">
                            <i class="fas fa-shopping-bag"></i>
                            <span>Đơn hàng của tôi</span>
                        </a>
                    </li>
                </ul>
            </div>
            
            <div class="account-main">
                <div class="user-avatar-section">
                    <div class="user-avatar-large">
                        <%= user.getTenDangNhap() != null && !user.getTenDangNhap().isEmpty() 
                            ? user.getTenDangNhap().substring(0, 1).toUpperCase() : "U" %>
                    </div>
                    <div class="user-name-large"><%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "User" %></div>
                    <div class="user-email-large"><%= user.getEmail() != null ? user.getEmail() : "" %></div>
                </div>
                
                <h2 class="section-title">Chi tiết tài khoản</h2>
                
                <form id="userInfoForm" action="${pageContext.request.contextPath}/UpdateUserInfoServlet" method="POST" class="view-mode">
                    <div class="info-group">
                        <label class="info-label">Tên đăng nhập</label>
                        <div class="info-value">
                            <span><%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "Chưa có" %></span>
                            <input type="text" 
                                   name="tenDangNhap" 
                                   value="<%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "" %>"
                                   required
                                   pattern="[a-zA-Z0-9_]{3,50}"
                                   title="Tên đăng nhập phải có từ 3-50 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới"
                                   disabled>
                            <small style="display: block; margin-top: 5px; color: #666; font-size: 13px; display: none;" class="edit-hint">
                                Tên đăng nhập phải có từ 3-50 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới (_)
                            </small>
                        </div>
                    </div>
                    
                    <div class="info-group">
                        <label class="info-label">Email</label>
                        <div class="info-value static-field">
                            <!-- Chỉ hiển thị, không cho phép chỉnh sửa -->
                            <span><%= user.getEmail() != null ? user.getEmail() : "Chưa có" %></span>
                        </div>
                    </div>
                    
                    <div class="info-group">
                        <label class="info-label">Vai trò</label>
                        <div class="info-value">
                            <%= user.getVaiTro() != null && user.getVaiTro().equalsIgnoreCase("admin") ? "Quản trị viên" : "Khách hàng" %>
                        </div>
                    </div>
                    
                    <div class="action-buttons view-buttons">
                        <button type="button" class="btn btn-primary" onclick="enableEdit()">
                            <i class="fas fa-edit"></i> Chỉnh sửa thông tin
                        </button>
                        <a href="${pageContext.request.contextPath}/UserChangePasswordServlet" class="btn btn-secondary">
                            <i class="fas fa-key"></i> Đổi mật khẩu
                        </a>
                        <a href="${pageContext.request.contextPath}/UserProductServlet" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                    
                    <div class="action-buttons edit-buttons">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="cancelEdit()">
                            <i class="fas fa-times"></i> Hủy
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%@ include file="/layouts/footer_user.jsp" %>
    
    <script>
        let originalValues = {};
        
        function enableEdit() {
            const form = document.getElementById('userInfoForm');
            form.classList.remove('view-mode');
            form.classList.add('edit-mode');
            
            // Chỉ cho phép chỉnh sửa tên đăng nhập
            const usernameInput = form.querySelector('input[name="tenDangNhap"]');
            if (usernameInput) {
                originalValues['tenDangNhap'] = usernameInput.value; // Lưu giá trị hiện tại
                usernameInput.disabled = false;
            }
            
            // Hiển thị hint cho tên đăng nhập
            const hints = form.querySelectorAll('.edit-hint');
            hints.forEach(hint => {
                hint.style.display = 'block';
            });
        }
        
        function cancelEdit() {
            const form = document.getElementById('userInfoForm');
            form.classList.remove('edit-mode');
            form.classList.add('view-mode');
            
            // Disable input và reset giá trị về ban đầu
            const usernameInput = form.querySelector('input[name="tenDangNhap"]');
            if (usernameInput) {
                usernameInput.disabled = true;
                if (originalValues['tenDangNhap'] !== undefined) {
                    usernameInput.value = originalValues['tenDangNhap'];
                }
            }
            
            // Ẩn hint
            const hints = form.querySelectorAll('.edit-hint');
            hints.forEach(hint => {
                hint.style.display = 'none';
            });
            
            // Xóa giá trị đã lưu
            originalValues = {};
        }
    </script>
</body>
</html>

