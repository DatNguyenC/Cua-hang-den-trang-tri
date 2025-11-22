<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.*" %>
<%@ page import="DAO.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hóa đơn - LightShop Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">

    <style>
        .order-hero {
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

        .order-hero h1 {
            font-size: 26px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-pending {
            background: #fef3c7;
            color: #d97706;
        }

        .status-processing {
            background: #dbeafe;
            color: #2563eb;
        }

        .status-delivered {
            background: #dcfce7;
            color: #16a34a;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #dc2626;
        }

        .status-received {
            background: #e0e7ff;
            color: #6366f1;
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
            max-width: 600px;
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

        .form-group {
            margin-bottom: 16px;
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

        .order-item-row {
            display: flex;
            gap: 12px;
            align-items: end;
            margin-bottom: 12px;
        }

        .order-item-row select,
        .order-item-row input {
            flex: 1;
        }

        .btn-remove-item {
            padding: 10px 16px;
            background: #fee2e2;
            color: #dc2626;
            border: none;
            border-radius: 10px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<%
    HoaDonDAO hoaDonDAO = new HoaDonDAO();
    NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
    DenDAO denDAO = new DenDAO();
    BienTheDenDAO bienTheDAO = new BienTheDenDAO();
    ChiTietHoaDonDAO chiTietDAO = new ChiTietHoaDonDAO();

    List<HoaDon> allOrders = hoaDonDAO.getAll();
    if (allOrders == null) allOrders = new ArrayList<>();

    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");

    // Lấy danh sách sản phẩm và biến thể cho form tạo hóa đơn
    List<Den> allProducts = denDAO.getAll();
    if (allProducts == null) allProducts = new ArrayList<>();
    List<BienTheDen> allVariants = bienTheDAO.getAll();
    if (allVariants == null) allVariants = new ArrayList<>();
    List<NguoiDung> allUsers = nguoiDungDAO.getAll();
    if (allUsers == null) allUsers = new ArrayList<>();
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

    <section class="order-hero">
        <div>
            <h1><i class="fas fa-receipt"></i> Quản lý hóa đơn</h1>
            <p>Theo dõi và xử lý đơn hàng của khách hàng.</p>
        </div>
        <div class="hero-meta">
            <span class="hero-pill"><i class="fas fa-shopping-cart"></i><%= allOrders.size() %> đơn hàng</span>
            <button class="btn btn-primary" onclick="showCreateOrderModal()">
                <i class="fas fa-plus-circle"></i> Tạo hóa đơn mới
            </button>
        </div>
    </section>

    <section class="filter-shell">
        <div class="filter-row">
            <div>
                <label class="form-label">Tìm kiếm</label>
                <div class="search-box" style="width:100%;">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Mã đơn, khách hàng..." onkeyup="filterOrders()">
                </div>
            </div>
            <div>
                <label class="form-label">Lọc theo trạng thái</label>
                <select id="statusFilter" onchange="filterOrders()">
                    <option value="all">Tất cả</option>
                    <option value="chờ xử lý">Chờ xử lý</option>
                    <option value="đang giao">Đang giao</option>
                    <option value="đã giao">Đã giao</option>
                    <option value="đã nhận">Đã nhận</option>
                    <option value="hủy">Đã hủy</option>
                </select>
            </div>
        </div>
    </section>

    <section class="table-container">
        <div class="table-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h3>Danh sách hóa đơn</h3>
                <small id="tableSubtitle">Có <%= allOrders.size() %> đơn hàng</small>
            </div>
        </div>
        <div class="table-responsive">
            <table class="products-table" id="ordersTable">
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% if (allOrders.isEmpty()) { %>
                    <tr>
                        <td colspan="6" class="text-center py-4 text-muted">
                            <i class="fas fa-inbox fa-2x mb-2"></i>
                            <div>Chưa có đơn hàng nào.</div>
                        </td>
                    </tr>
                <% } else {
                    for (HoaDon order : allOrders) {
                        NguoiDung customer = null;
                        for (NguoiDung u : allUsers) {
                            if (u.getMaND() == order.getMaNd()) {
                                customer = u;
                                break;
                            }
                        }
                        String customerName = customer != null ? customer.getTenDangNhap() : "N/A";
                        String status = order.getTrangThaiGiaoHang() != null ? order.getTrangThaiGiaoHang() : "chờ xử lý";
                        String statusClass = "status-pending";
                        if (status.contains("đang giao")) statusClass = "status-processing";
                        else if (status.contains("đã giao")) statusClass = "status-delivered";
                        else if (status.contains("đã nhận")) statusClass = "status-received";
                        else if (status.contains("hủy")) statusClass = "status-cancelled";
                %>
                <tr data-keywords="<%= order.getMaHd() + " " + customerName.toLowerCase() %>" data-status="<%= status %>">
                    <td><strong>#<%= order.getMaHd() %></strong></td>
                    <td><%= customerName %></td>
                    <td><%= dateFormat.format(order.getNgayLap()) %></td>
                    <td><strong><%= nf.format(order.getTongTien()) %> đ</strong></td>
                    <td>
                        <span class="status-badge <%= statusClass %>"><%= status %></span>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-action btn-edit" onclick="showUpdateStatusModal(<%= order.getMaHd() %>, '<%= status.replace("'", "\\'") %>')">
                                <i class="fas fa-edit"></i>
                            </button>
                            <a href="<%=request.getContextPath()%>/elements/OrderDetailAdmin.jsp?maHd=<%= order.getMaHd() %>" class="btn-action btn-view">
                                <i class="fas fa-eye"></i>
                            </a>
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

<!-- Modal cập nhật trạng thái -->
<div id="updateStatusModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fas fa-edit"></i> Cập nhật trạng thái</h3>
            <button class="modal-close" onclick="closeModal('updateStatusModal')"><i class="fas fa-times"></i></button>
        </div>
        <form action="<%=request.getContextPath()%>/UpdateOrderStatusServlet" method="POST">
            <input type="hidden" id="updateOrderId" name="maHd">
            <div class="modal-body">
                <div class="form-group">
                    <label>Trạng thái mới</label>
                    <select id="newStatus" name="trangThai" required>
                        <option value="chờ xử lý">Chờ xử lý</option>
                        <option value="đang giao">Đang giao</option>
                        <option value="đã giao">Đã giao</option>
                        <option value="đã nhận">Đã nhận</option>
                        <option value="hủy">Đã hủy</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('updateStatusModal')">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> Cập nhật
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal tạo hóa đơn mới -->
<div id="createOrderModal" class="modal-overlay">
    <div class="modal-container" style="max-width: 800px;">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i> Tạo hóa đơn thanh toán trực tiếp</h3>
            <button class="modal-close" onclick="closeModal('createOrderModal')"><i class="fas fa-times"></i></button>
        </div>
        <form id="createOrderForm" action="<%=request.getContextPath()%>/CreateOrderServlet" method="POST">
            <div class="modal-body">
                <div class="form-group">
                    <label>Khách hàng *</label>
                    <select name="maNd" required>
                        <option value="">Chọn khách hàng</option>
                        <% for (NguoiDung user : allUsers) {
                            if (user.getVaiTro() == null || !"admin".equalsIgnoreCase(user.getVaiTro())) {
                        %>
                        <option value="<%= user.getMaND() %>"><%= user.getTenDangNhap() %> (<%= user.getEmail() != null ? user.getEmail() : "N/A" %>)</option>
                        <%  }
                            } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ghi chú</label>
                    <textarea name="ghiChu" rows="3" style="width:100%; border-radius:10px; border:1px solid rgba(226,232,240,0.9); padding:10px 12px;"></textarea>
                </div>
                <hr>
                <h5>Chi tiết đơn hàng</h5>
                <div id="orderItems">
                    <div class="order-item-row">
                        <select name="maBienThe[]" required>
                            <option value="">Chọn sản phẩm</option>
                            <% for (BienTheDen variant : allVariants) {
                                Den product = denDAO.getById(variant.getMaDen());
                                String productName = product != null ? product.getTenDen() : "Sản phẩm #" + variant.getMaDen();
                                double price = product != null ? product.getGia() : 0;
                            %>
                            <option value="<%= variant.getMaBienThe() %>" data-price="<%= price %>">
                                <%= productName %> - Mã: #<%= variant.getMaBienThe() %> - Giá: <%= nf.format(price) %> đ
                            </option>
                            <% } %>
                        </select>
                        <input type="number" name="soLuong[]" placeholder="Số lượng" min="1" value="1" required style="width:120px;">
                        <button type="button" class="btn-remove-item" onclick="removeOrderItem(this)" style="display:none;">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
                <button type="button" class="btn-secondary" onclick="addOrderItem()" style="margin-top:12px;">
                    <i class="fas fa-plus"></i> Thêm sản phẩm
                </button>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('createOrderModal')">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> Tạo hóa đơn
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterOrders() {
        const term = document.getElementById('searchInput').value.toLowerCase().trim();
        const status = document.getElementById('statusFilter').value;
        const rows = document.querySelectorAll('#ordersTable tbody tr');
        let visible = 0;

        rows.forEach(row => {
            const keywords = row.dataset.keywords || '';
            const rowStatus = row.dataset.status || '';
            const matchesSearch = !term || keywords.includes(term);
            const matchesStatus = status === 'all' || rowStatus === status;
            const matches = matchesSearch && matchesStatus;
            
            row.style.display = matches ? '' : 'none';
            if (matches) visible++;
        });

        document.getElementById('tableSubtitle').textContent = visible ? `Đang hiển thị ${visible} đơn hàng` : 'Không tìm thấy đơn hàng phù hợp';
    }

    function showUpdateStatusModal(orderId, currentStatus) {
        document.getElementById('updateOrderId').value = orderId;
        document.getElementById('newStatus').value = currentStatus;
        document.getElementById('updateStatusModal').classList.add('show');
    }

    function showCreateOrderModal() {
        document.getElementById('createOrderModal').classList.add('show');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('show');
    }

    function addOrderItem() {
        const container = document.getElementById('orderItems');
        const firstRow = container.querySelector('.order-item-row');
        const newRow = firstRow.cloneNode(true);
        newRow.querySelector('select').value = '';
        newRow.querySelector('input').value = '1';
        newRow.querySelector('.btn-remove-item').style.display = 'block';
        container.appendChild(newRow);
    }

    function removeOrderItem(btn) {
        const rows = document.querySelectorAll('.order-item-row');
        if (rows.length > 1) {
            btn.closest('.order-item-row').remove();
        }
    }

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

