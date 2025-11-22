<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập Admin - LightShop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.1) 0%, transparent 70%);
            animation: float 20s ease-in-out infinite;
        }

        body::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -50%;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(139, 92, 246, 0.1) 0%, transparent 70%);
            animation: float 25s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(30px, -30px) rotate(180deg); }
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            position: relative;
            z-index: 1;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }

        .login-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 70px rgba(0, 0, 0, 0.35);
        }

        .login-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .login-logo {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #3b82f6, #8b5cf6);
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
        }

        .login-logo i {
            font-size: 40px;
            color: #fff;
        }

        .login-title {
            font-size: 28px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .login-subtitle {
            font-size: 14px;
            color: #64748b;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 16px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.2s;
            background: #fff;
        }

        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .form-control::placeholder {
            color: #cbd5e1;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 14px;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-check-input {
            width: 18px;
            height: 18px;
            accent-color: #3b82f6;
            cursor: pointer;
        }

        .form-check-label {
            color: #64748b;
            cursor: pointer;
            user-select: none;
        }

        .forgot-link {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .forgot-link:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #8b5cf6);
            color: #fff;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb, #7c3aed);
            box-shadow: 0 6px 20px rgba(59, 130, 246, 0.5);
            transform: translateY(-2px);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .error-message {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid #dc2626;
        }

        .error-message i {
            font-size: 18px;
        }

        .toggle-container {
            text-align: center;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid #e2e8f0;
            font-size: 14px;
            color: #64748b;
        }

        .toggle-link {
            color: #3b82f6;
            font-weight: 600;
            cursor: pointer;
            margin-left: 6px;
            transition: color 0.2s;
        }

        .toggle-link:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        .auth-card {
            display: none;
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.4s ease, transform 0.4s ease;
        }

        .auth-card.active {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }

        .grid {
            display: grid;
            gap: 16px;
        }

        .grid-cols-2 {
            grid-template-columns: repeat(2, 1fr);
        }

        @media (max-width: 768px) {
            .login-card {
                padding: 32px 24px;
            }

            .login-title {
                font-size: 24px;
            }

            .grid-cols-2 {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
        Boolean showRegister = (Boolean) request.getAttribute("showRegister");
        String registerError = (String) request.getAttribute("registerError");
    %>

    <div class="login-container">
        <!-- FORM LOGIN -->
        <div id="loginForm" class="auth-card active">
            <div class="login-card">
                <div class="login-header">
                    <div class="login-logo">
                        <i class="fas fa-lightbulb"></i>
                    </div>
                    <h1 class="login-title">Đăng nhập Admin</h1>
                    <p class="login-subtitle">Chào mừng trở lại với LightShop</p>
                </div>

                <% String error = (String) request.getAttribute("error");
                   if (error != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= error %></span>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
                    <div class="form-group">
                        <div class="input-wrapper">
                            <i class="fas fa-envelope"></i>
                            <input type="email" class="form-control" name="email" placeholder="Địa chỉ Email" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" class="form-control" name="password" placeholder="Mật khẩu" required>
                        </div>
                    </div>

                    <div class="form-options">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="remember" name="remember" checked>
                            <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                        </div>
                        <a href="#" class="forgot-link">Quên mật khẩu?</a>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i>
                        Đăng nhập
                    </button>
                </form>

                <div class="toggle-container">
                    <span>Chưa có tài khoản?</span>
                    <span class="toggle-link" onclick="toggleForm('registerForm', 'loginForm')">Đăng ký ngay</span>
                </div>
            </div>
        </div>

        <!-- FORM REGISTER -->
        <div id="registerForm" class="auth-card">
            <div class="login-card">
                <div class="login-header">
                    <div class="login-logo">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h1 class="login-title">Tạo tài khoản</h1>
                    <p class="login-subtitle">Tham gia cùng LightShop Admin</p>
                </div>

                <% if (registerError != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= registerError %></span>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/AdminRegisterServlet" method="post">
                    <div class="grid grid-cols-2">
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="fas fa-user"></i>
                                <input type="text" class="form-control" name="firstName" placeholder="Họ" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="fas fa-user"></i>
                                <input type="text" class="form-control" name="lastName" placeholder="Tên" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-wrapper">
                            <i class="fas fa-envelope"></i>
                            <input type="email" class="form-control" name="email" placeholder="Địa chỉ Email" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" class="form-control" name="password" placeholder="Mật khẩu" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" class="form-control" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                        </div>
                    </div>

                    <div class="form-check" style="margin-bottom: 24px;">
                        <input class="form-check-input" type="checkbox" id="terms" name="terms" required>
                        <label class="form-check-label" for="terms">Tôi đồng ý với điều khoản sử dụng</label>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i>
                        Đăng ký
                    </button>
                </form>

                <div class="toggle-container">
                    <span>Đã có tài khoản?</span>
                    <span class="toggle-link" onclick="toggleForm('loginForm', 'registerForm')">Đăng nhập ngay</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleForm(showId, hideId) {
            const showForm = document.getElementById(showId);
            const hideForm = document.getElementById(hideId);
            
            hideForm.classList.remove('active');
            
            setTimeout(() => {
                showForm.classList.add('active');
            }, 200);
        }

        const shouldShowRegister = '<%= (showRegister != null && showRegister) ? "true" : "false" %>' === 'true';
        if (shouldShowRegister) {
            toggleForm('registerForm', 'loginForm');
        }
    </script>
</body>
</html>
