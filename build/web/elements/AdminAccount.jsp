<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.NguoiDung" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="DAO.NguoiDungDAO" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhân viên - LightShop Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">

    <style>
        .user-hero {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            border-radius: 18px;
            padding: 28px;
            margin-bottom: 28px;
            color: #fff;
            box-shadow: 0 20px 35px rgba(15, 23, 42, 0.35);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            flex-wrap: wrap;
        }

        .user-hero h1 {
            font-size: 26px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .hero-meta {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .hero-pill {
            padding: 8px 16px;
            background: rgba(148, 163, 184, 0.18);
            border-radius: 999px;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .filter-shell {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.05);
            border: 1px solid rgba(226, 232, 240, 0.7);
            margin-bottom: 22px;
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
        }

        .filter-row input,
        .filter-row select {
            border-radius: 12px;
            border: 1px solid rgba(226, 232, 240, 0.8);
            padding: 10px 14px;
        }

        .table-container .badge {
            font-size: 12px;
            border-radius: 999px;
            padding: 6px 10px;
        }

        .user-avatar {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 12px;
        }

        .btn-primary,
        .btn-secondary,
        .btn-danger {
            display: inline-flex;
            align-items: center;
            gap: 8px;
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
            margin-bottom: 14px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            display: block;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            border-radius: 10px;
            border: 1px solid rgba(226, 232, 240, 0.9);
            padding: 10px 12px;
            font-size: 14px;
        }

        @media (max-width: 768px) {
            .user-hero {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
<%
    NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
    List<NguoiDung> allUsers = nguoiDungDAO.getAll();
    if (allUsers == null) allUsers = new ArrayList<>();
    
    // Lọc chỉ lấy admin
    List<NguoiDung> listUser = new ArrayList<>();
    for (NguoiDung user : allUsers) {
        if (user.getVaiTro() != null && "admin".equalsIgnoreCase(user.getVaiTro())) {
            listUser.add(user);
        }
    }
    
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    String infoMessage = (String) session.getAttribute("infoMessage");
    
    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");
    if (infoMessage != null) session.removeAttribute("infoMessage");
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
    
    <% if (infoMessage != null) { %>
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        <%= infoMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <section class="user-hero">
        <div>
            <h1><i class="fas fa-user-shield"></i> Nhân viên</h1>
            <p>Quản lý danh sách tài khoản quản trị viên trên hệ thống.</p>
        </div>
        <div class="hero-meta">
            <span class="hero-pill"><i class="fas fa-user-check"></i><%= listUser.size() %> nhân viên</span>
        </div>
    </section>

    <section class="filter-shell">
        <div class="filter-row align-items-end">
            <div>
                <label class="form-label">Tìm theo tên hoặc email</label>
                <div class="search-box" style="width:100%;">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Nhập tên nhân viên..." onkeyup="filterUsers()">
                </div>
            </div>
            <div>
                <label class="form-label">Lọc theo trạng thái</label>
                <select id="statusFilter" onchange="filterUsers()">
                    <option value="all">Tất cả</option>
                    <option value="active">Hoạt động</option>
                    <option value="inactive">Tạm khóa</option>
                </select>
            </div>
            <div class="text-end">
                <label class="form-label"> </label>
                <button class="btn btn-primary" onclick="showAddModal()">
                    <i class="fas fa-plus-circle"></i> Thêm nhân viên
                </button>
            </div>
        </div>
    </section>

    <section class="table-container">
        <div class="table-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h3>Danh sách nhân viên</h3>
                <small id="tableSubtitle">Có <%= listUser.size() %> nhân viên</small>
            </div>
        </div>
        <div class="table-responsive">
            <table class="products-table" id="userTable">
                <thead>
                <tr>
                    <th>Tài khoản</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% if (listUser.isEmpty()) { %>
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">
                            <i class="fas fa-user-slash fa-2x mb-2"></i>
                            <div>Chưa có nhân viên nào.</div>
                        </td>
                    </tr>
                <% } else {
                    for (NguoiDung user : listUser) {
                        String keywords = (user.getTenDangNhap() + " " + (user.getEmail() != null ? user.getEmail() : "")).toLowerCase();
                        String role = user.getVaiTro() != null ? user.getVaiTro() : "Admin";
                %>
                <tr data-keywords="<%= keywords %>" data-status="active">
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="user-avatar"><%= user.getTenDangNhap() != null && !user.getTenDangNhap().isEmpty() ? user.getTenDangNhap().substring(0, 1).toUpperCase() : "A" %></div>
                            <div>
                                <strong><%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "N/A" %></strong><br>
                                <small class="text-muted">ID: <%= user.getMaND() %></small>
                            </div>
                        </div>
                    </td>
                    <td>
                        <%= user.getEmail() != null ? user.getEmail() : "—" %>
                    </td>
                    <td>
                        <span class="badge bg-danger">Quản trị viên</span>
                    </td>
                    <td>
                        <span class="badge bg-success">Hoạt động</span>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-action btn-edit" 
                                data-id="<%= user.getMaND() %>"
                                data-username="<%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "" %>"
                                data-email="<%= user.getEmail() != null ? user.getEmail() : "" %>"
                                onclick="showEditModal(this)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn-action btn-delete" 
                                data-id="<%= user.getMaND() %>"
                                data-username="<%= user.getTenDangNhap() != null ? user.getTenDangNhap() : "" %>"
                                onclick="confirmDelete(this)">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <%  }
                    } %>
                </tbody>
            </table>
        </div>
    </section>
</div>

<div id="addModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i> Thêm nhân viên</h3>
            <button class="modal-close" onclick="closeModal('addModal')"><i class="fas fa-times"></i></button>
        </div>
        <form action="<%=request.getContextPath()%>/UserManagerServlet" method="POST">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="userType" value="admin">
            <div class="modal-body">
                <div class="form-group">
                    <label>Tên đăng nhập *</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Mật khẩu *</label>
                    <input type="password" name="password" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('addModal')">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> Thêm mới
                </button>
            </div>
        </form>
    </div>
</div>

<div id="editModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-edit"></i> Cập nhật nhân viên</h3>
            <button class="modal-close" onclick="closeModal('editModal')"><i class="fas fa-times"></i></button>
        </div>
        <form id="editForm" action="<%=request.getContextPath()%>/UserManagerServlet" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userType" value="admin">
            <input type="hidden" id="editUserId" name="id">
            <div class="modal-body">
                <div class="form-group">
                    <label>Tên đăng nhập *</label>
                    <input type="text" id="editUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label>Vai trò</label>
                    <input type="text" value="Quản trị viên" readonly style="background-color: #f8f9fa;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('editModal')">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> Cập nhật
                </button>
            </div>
        </form>
    </div>
</div>

<div id="deleteModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-exclamation-triangle"></i> Xác nhận xóa</h3>
            <button class="modal-close" onclick="closeModal('deleteModal')"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa nhân viên <strong id="deleteUserName"></strong>?</p>
            <p class="text-muted small">Hành động này không thể hoàn tác.</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-secondary" onclick="closeModal('deleteModal')">
                <i class="fas fa-times"></i> Hủy
            </button>
            <button type="button" class="btn-danger" id="confirmDeleteBtn">
                <i class="fas fa-trash"></i> Xóa
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const searchInput = document.getElementById('searchInput');
    const statusFilter = document.getElementById('statusFilter');
    const tableSubtitle = document.getElementById('tableSubtitle');
    const userRows = document.querySelectorAll('#userTable tbody tr');
    let deleteId = null;

    function filterUsers() {
        const term = searchInput.value.toLowerCase().trim();
        const status = statusFilter.value;
        let visible = 0;

        userRows.forEach(row => {
            const keywords = row.dataset.keywords || '';
            const rowStatus = row.dataset.status || '';
            const matchesSearch = !term || keywords.includes(term);
            const matchesStatus = status === 'all' || rowStatus === status;
            const matches = matchesSearch && matchesStatus;
            
            row.style.display = matches ? '' : 'none';
            if (matches) visible++;
        });

        tableSubtitle.textContent = visible ? `Đang hiển thị ${visible} nhân viên` : 'Không tìm thấy nhân viên phù hợp';
    }

    function showAddModal() {
        document.getElementById('addModal').classList.add('show');
    }

    function showEditModal(btn) {
        const id = btn.getAttribute('data-id');
        const username = btn.getAttribute('data-username') || '';
        const email = btn.getAttribute('data-email') || '';
        document.getElementById('editUserId').value = id;
        document.getElementById('editUsername').value = username;
        document.getElementById('editEmail').value = email;
        document.getElementById('editModal').classList.add('show');
    }

    function confirmDelete(btn) {
        const id = btn.getAttribute('data-id');
        const name = btn.getAttribute('data-username') || '';
        deleteId = id;
        document.getElementById('deleteUserName').textContent = name;
        document.getElementById('confirmDeleteBtn').disabled = false;
        document.getElementById('confirmDeleteBtn').innerHTML = '<i class="fas fa-trash"></i> Xóa';
        document.getElementById('deleteModal').classList.add('show');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('show');
        if (modalId === 'deleteModal') {
            deleteId = null;
        }
    }

    document.getElementById('confirmDeleteBtn').addEventListener('click', () => {
        if (!deleteId) return;
        const btn = document.getElementById('confirmDeleteBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xóa...';
        window.location.href = '<%=request.getContextPath()%>/UserManagerServlet?action=delete&userType=admin&id=' + deleteId;
    });

    document.querySelectorAll('.modal-overlay').forEach(modal => {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('show');
            }
        });
    });
</script>
</body>
</html>
