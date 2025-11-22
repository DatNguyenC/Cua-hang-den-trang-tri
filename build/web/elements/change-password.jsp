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
    <title>Đổi mật khẩu | LightStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8f9fa; color: #333; }
        
        .password-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .password-header {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .password-header h1 {
            font-size: 32px;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .password-header p {
            color: #666;
            font-size: 16px;
        }
        
        .password-content {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 30px;
        }
        
        .password-sidebar {
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
        
        .password-main {
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
        
        .form-group {
            margin-bottom: 25px;
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
        
        .password-hint {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
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
        
        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
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
        
        .password-strength {
            margin-top: 8px;
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            transition: all 0.3s;
            border-radius: 2px;
        }
        
        .strength-weak {
            background: #dc2626;
            width: 33%;
        }
        
        .strength-medium {
            background: #f59e0b;
            width: 66%;
        }
        
        .strength-strong {
            background: #10b981;
            width: 100%;
        }
        
        @media (max-width: 768px) {
            .password-content {
                grid-template-columns: 1fr;
            }
            
            .password-sidebar {
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
    <div class="password-container">
        <div class="password-header">
            <h1><i class="fas fa-key"></i> Đổi mật khẩu</h1>
            <p>Thay đổi mật khẩu để bảo vệ tài khoản của bạn</p>
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
        
        <div class="password-content">
            <div class="password-sidebar">
                <ul class="sidebar-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/UserAccountServlet">
                            <i class="fas fa-user"></i>
                            <span>Thông tin tài khoản</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/UserChangePasswordServlet" class="active">
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
            
            <div class="password-main">
                <h2 class="section-title">Thay đổi mật khẩu</h2>
                
                <form method="post" action="${pageContext.request.contextPath}/UserChangePasswordServlet" id="changePasswordForm">
                    <div class="form-group">
                        <label class="form-label">
                            Mật khẩu hiện tại <span class="required">*</span>
                        </label>
                        <input type="password" name="currentPassword" class="form-input" 
                               required placeholder="Nhập mật khẩu hiện tại">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            Mật khẩu mới <span class="required">*</span>
                        </label>
                        <input type="password" name="newPassword" id="newPassword" class="form-input" 
                               required placeholder="Nhập mật khẩu mới" minlength="6">
                        <div class="password-hint">Mật khẩu phải có ít nhất 6 ký tự</div>
                        <div class="password-strength" id="passwordStrength" style="display: none;">
                            <div class="password-strength-bar" id="passwordStrengthBar"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            Xác nhận mật khẩu mới <span class="required">*</span>
                        </label>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-input" 
                               required placeholder="Nhập lại mật khẩu mới" minlength="6">
                        <div class="password-hint" id="passwordMatch" style="display: none;"></div>
                    </div>
                    
                    <div class="action-buttons">
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="fas fa-save"></i> Lưu mật khẩu
                        </button>
                        <a href="${pageContext.request.contextPath}/UserAccountServlet" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordStrengthBar = document.getElementById('passwordStrengthBar');
        const passwordMatch = document.getElementById('passwordMatch');
        
        // Kiểm tra độ mạnh mật khẩu
        newPasswordInput.addEventListener('input', function() {
            const password = this.value;
            if (password.length === 0) {
                passwordStrength.style.display = 'none';
                return;
            }
            
            passwordStrength.style.display = 'block';
            let strength = 0;
            
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            passwordStrengthBar.className = 'password-strength-bar';
            if (strength <= 2) {
                passwordStrengthBar.classList.add('strength-weak');
            } else if (strength <= 3) {
                passwordStrengthBar.classList.add('strength-medium');
            } else {
                passwordStrengthBar.classList.add('strength-strong');
            }
        });
        
        // Kiểm tra mật khẩu khớp
        confirmPasswordInput.addEventListener('input', function() {
            const newPassword = newPasswordInput.value;
            const confirmPassword = this.value;
            
            if (confirmPassword.length === 0) {
                passwordMatch.style.display = 'none';
                return;
            }
            
            passwordMatch.style.display = 'block';
            if (newPassword === confirmPassword) {
                passwordMatch.textContent = '✓ Mật khẩu khớp';
                passwordMatch.style.color = '#10b981';
            } else {
                passwordMatch.textContent = '✗ Mật khẩu không khớp';
                passwordMatch.style.color = '#dc2626';
            }
        });
        
        // Validate form
        document.getElementById('changePasswordForm')?.addEventListener('submit', function(e) {
            const newPassword = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                return false;
            }
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Mật khẩu mới phải có ít nhất 6 ký tự!');
                return false;
            }
            
            const submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            }
        });
    </script>
    
    <%@ include file="/layouts/footer_user.jsp" %>
</body>
</html>

