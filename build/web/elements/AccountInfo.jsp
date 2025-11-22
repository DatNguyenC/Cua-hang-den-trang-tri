<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.NguoiDung" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin tài khoản - LightShop Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">

    <style>
        .profile-hero {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            border-radius: 18px;
            padding: 32px;
            margin-bottom: 28px;
            color: #fff;
            box-shadow: 0 20px 35px rgba(15, 23, 42, 0.35);
            text-align: center;
        }

        .profile-avatar-large {
            width: 100px;
            height: 100px;
            border-radius: 20px;
            background: linear-gradient(135deg, #38bdf8, #2563eb);
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 16px;
            border: 4px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .profile-hero h1 {
            font-size: 28px;
            margin: 0 0 8px 0;
        }

        .profile-hero p {
            margin: 0;
            opacity: 0.9;
        }

        .info-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.05);
            border: 1px solid rgba(226, 232, 240, 0.7);
            margin-bottom: 22px;
        }

        .info-card h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid rgba(226, 232, 240, 0.7);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #64748b;
            font-size: 14px;
        }

        .info-value {
            font-weight: 500;
            color: #1e293b;
            font-size: 14px;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
        }

        .btn-primary,
        .btn-secondary,
        .btn-danger {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-primary:hover,
        .btn-secondary:hover,
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-container {
            background: #fff;
            border-radius: 18px;
            width: 100%;
            max-width: 520px;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: 0 30px 60px rgba(15, 23, 42, 0.25);
        }

        .modal-header,
        .modal-footer {
            padding: 18px 22px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.7);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-footer {
            border-top: 1px solid rgba(226, 232, 240, 0.7);
            border-bottom: none;
        }

        .modal-body {
            padding: 22px;
            overflow-y: auto;
        }

        .modal-close {
            border: none;
            background: transparent;
            font-size: 18px;
            color: #94a3b8;
            cursor: pointer;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            display: block;
            color: #475569;
        }

        .form-group input {
            width: 100%;
            border-radius: 10px;
            border: 1px solid rgba(226, 232, 240, 0.9);
            padding: 10px 12px;
            font-size: 14px;
        }

        .form-group input[readonly] {
            background-color: #f8f9fa;
            color: #64748b;
            cursor: not-allowed;
        }

        .field-note {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 4px;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .alert {
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 20px;
            border: none;
        }
    </style>
</head>
<body>
<%
    NguoiDung user = (NguoiDung) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
        return;
    }

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<jsp:include page="../layouts/sidebar-admin.html"/>
<jsp:include page="../layouts/header-content-admin.jsp"/>

<div class="pc-container">
    <% if (successMessage != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (errorMessage != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <section class="profile-hero">
        <div class="profile-avatar-large">
            <%= user.getTenDangNhap() != null && !user.getTenDangNhap().isEmpty() ? user.getTenDangNhap().substring(0, 1).toUpperCase() : "U" %>
        </div>
        <h1><%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "Người dùng" %></h1>
        <p>
            <span class="badge <%= user.getVaiTro() != null && "admin".equalsIgnoreCase(user.getVaiTro()) ? "bg-danger" : "bg-success" %>">
                <%= user.getVaiTro() != null ? user.getVaiTro().toUpperCase() : "USER" %>
            </span>
        </p>
        <p class="mt-2">
            <i class="fas fa-envelope me-2"></i><%= user.getEmail() != null ? user.getEmail() : "" %>
        </p>
    </section>

    <section class="info-card">
        <h3><i class="fas fa-info-circle"></i> Thông tin chi tiết</h3>
        <div class="info-item">
            <span class="info-label">Mã người dùng</span>
            <span class="info-value">#<%= user.getMaND() %></span>
        </div>
        <div class="info-item">
            <span class="info-label">Tên đăng nhập</span>
            <span class="info-value"><%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "N/A" %></span>
        </div>
        <div class="info-item">
            <span class="info-label">Email</span>
            <span class="info-value"><%= user.getEmail() != null ? user.getEmail() : "N/A" %></span>
        </div>
        <div class="info-item">
            <span class="info-label">Vai trò</span>
            <span class="info-value">
                <span class="badge <%= user.getVaiTro() != null && "admin".equalsIgnoreCase(user.getVaiTro()) ? "bg-danger" : "bg-success" %>">
                    <%= user.getVaiTro() != null ? user.getVaiTro() : "user" %>
                </span>
            </span>
        </div>
        <div class="info-item">
            <span class="info-label">Trạng thái</span>
            <span class="info-value">
                <span class="badge bg-success">Hoạt động</span>
            </span>
        </div>

        <div class="action-buttons">
            <button id="editInfoBtn" class="btn btn-primary">
                <i class="fas fa-edit"></i> Chỉnh sửa thông tin
            </button>
            <button id="changePasswordBtn" class="btn btn-secondary">
                <i class="fas fa-key"></i> Đổi mật khẩu
            </button>
            <a href="<%=request.getContextPath()%>/LogoutServlet" class="btn btn-danger">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </section>
</div>

<!-- Modal Chỉnh sửa thông tin -->
<div id="editInfoModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-edit"></i> Chỉnh sửa thông tin</h3>
            <button class="modal-close" onclick="closeModal('editInfoModal')"><i class="fas fa-times"></i></button>
        </div>
        <form id="editInfoForm" action="<%=request.getContextPath()%>/UpdateUserInfoServlet" method="POST">
            <div class="modal-body">
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" value="<%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "" %>" readonly>
                    <div class="field-note">Tên đăng nhập không thể thay đổi</div>
                </div>
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" id="phone" name="phone" value="">
                </div>
                <div class="form-group">
                    <label for="role">Vai trò</label>
                    <input type="text" id="role" value="<%= user.getVaiTro() != null ? user.getVaiTro() : "user" %>" readonly>
                    <div class="field-note">Vai trò không thể thay đổi</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('editInfoModal')">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Đổi mật khẩu -->
<div id="changePasswordModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-key"></i> Đổi mật khẩu</h3>
            <button class="modal-close" onclick="closeModal('changePasswordModal')"><i class="fas fa-times"></i></button>
        </div>
        <form id="changePasswordForm" action="<%=request.getContextPath()%>/ChangePasswordServlet" method="POST">
            <div class="modal-body">
                <div class="form-group">
                    <label for="currentPassword">Mật khẩu hiện tại *</label>
                    <input type="password" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                </div>
                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới *</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu mới *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('changePasswordModal')">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Lưu mật khẩu
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('show');
    }

    document.getElementById('editInfoBtn').addEventListener('click', function () {
        document.getElementById('editInfoModal').classList.add('show');
    });

    document.getElementById('changePasswordBtn').addEventListener('click', function () {
        document.getElementById('changePasswordModal').classList.add('show');
    });

    document.querySelectorAll('.modal-close').forEach(button => {
        button.addEventListener('click', function () {
            const modal = this.closest('.modal-overlay');
            if (modal) {
                modal.classList.remove('show');
            }
        });
    });

    document.querySelectorAll('.modal-overlay').forEach(modal => {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('show');
            }
        });
    });

    // Xử lý kiểm tra form đổi mật khẩu
    document.getElementById('changePasswordForm').addEventListener('submit', function (e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('Mật khẩu mới và xác nhận mật khẩu không khớp');
            return;
        }

        if (newPassword.length < 6) {
            e.preventDefault();
            alert('Mật khẩu mới phải có ít nhất 6 ký tự');
            return;
        }
    });
</script>
</body>
</html>
