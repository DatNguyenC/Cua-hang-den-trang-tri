<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Model.*"%>
<%@page import="DAO.*"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LightShop Admin – Dashboard</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">

    <style>
        .dashboard-hero {
            background: linear-gradient(135deg, #1d3354 0%, #264b7e 100%);
            border-radius: 18px;
            padding: 30px;
            color: #fff;
            box-shadow: 0 15px 35px rgba(29, 51, 84, 0.35);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
        }

        .dashboard-hero h1 {
            font-size: 28px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .dashboard-hero p {
            margin: 6px 0 0;
            opacity: 0.85;
        }

        .hero-meta {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .hero-pill {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 999px;
            padding: 8px 16px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
        }

        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(15, 23, 42, 0.05);
            position: relative;
            overflow: hidden;
        }

        .stat-card::after {
            content: "";
            position: absolute;
            inset: 0;
            border-radius: 16px;
            border: 2px solid transparent;
            background: linear-gradient(135deg, rgba(255,255,255,0) 40%, rgba(255,255,255,0.4)) border-box;
            mask: linear-gradient(#000 0 0) padding-box, linear-gradient(#000 0 0);
            mask-composite: exclude;
            pointer-events: none;
        }

        .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
            color: #111827;
        }

        .stat-label {
            margin: 4px 0 0;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
            color: #6b7280;
        }

        .content-sections {
            margin-top: 30px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }

        .section-card {
            background: #fff;
            border-radius: 18px;
            padding: 24px;
            box-shadow: 0 15px 30px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(15, 23, 42, 0.05);
        }

        .section-card + .section-card {
            margin-top: 24px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
        }

        .action-tile {
            border-radius: 14px;
            padding: 18px;
            border: 1px solid rgba(15, 23, 42, 0.08);
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: all 0.2s ease;
        }

        .action-tile:hover {
            transform: translateY(-4px);
            border-color: rgba(59, 130, 246, 0.6);
            box-shadow: 0 15px 30px rgba(59, 130, 246, 0.15);
            text-decoration: none;
        }

        .action-tile .fa-arrow-right {
            margin-left: auto;
            color: #94a3b8;
            transition: transform 0.2s ease;
        }

        .action-tile:hover .fa-arrow-right {
            transform: translateX(3px);
            color: #2563eb;
        }

        .snapshot-list {
            margin: 0;
            padding: 0;
            list-style: none;
            display: grid;
            gap: 14px;
        }

        .snapshot-list li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 16px;
            background: #f8fafc;
            border-radius: 12px;
            border: 1px solid rgba(15, 23, 42, 0.05);
        }

        .trend-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .trend-up {
            background: #dcfce7;
            color: #166534;
        }

        .trend-down {
            background: #fee2e2;
            color: #991b1b;
        }

        .alert-banner {
            background: #fef3c7;
            border: 1px solid #fcd34d;
            border-radius: 16px;
            padding: 18px;
            display: flex;
            gap: 15px;
            align-items: flex-start;
            margin-bottom: 24px;
        }

        .alert-banner i {
            color: #b45309;
            font-size: 20px;
            margin-top: 2px;
        }

        @media (max-width: 992px) {
            .content-sections {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%
    DenDAO denDAO = new DenDAO();
    BienTheDenDAO bienTheDAO = new BienTheDenDAO();
    MauSacDAO mauDAO = new MauSacDAO();
    KichThuocDAO sizeDAO = new KichThuocDAO();
    NhaCungCapDAO supplierDAO = new NhaCungCapDAO();
    LoaiDenDAO categoryDAO = new LoaiDenDAO();
    KhoDenDAO stockDAO = new KhoDenDAO();
    NguoiDungDAO userDAO = new NguoiDungDAO();

    List<KhoDen> stockList = stockDAO.getAll();
    int totalProducts = denDAO.getAll().size();
    int totalVariants = bienTheDAO.getAll().size();
    int totalColors = mauDAO.getAll().size();
    int totalSizes = sizeDAO.getAll().size();
    int totalSuppliers = supplierDAO.getAll().size();
    int totalCategories = categoryDAO.getAll().size();
    int totalUsers = userDAO.getAll().size();

    int totalStockQty = 0;
    int lowStockCount = 0;
    for (KhoDen item : stockList) {
        int available = item.getSoLuongNhap() - item.getSoLuongBan();
        totalStockQty += available;
        if (available > 0 && available < 10) {
            lowStockCount++;
        }
    }

    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
%>

<jsp:include page="../layouts/sidebar-admin.html"/>
<jsp:include page="../layouts/header-content-admin.jsp"/>

<div class="pc-container">
    <section class="dashboard-hero">
        <div>
            <h1><i class="fas fa-chart-line"></i> Tổng Quan Hoạt Động</h1>
            <p>Cập nhật nhanh tình trạng sản phẩm, kho và người dùng.</p>
        </div>
        <div class="hero-meta">
            <div class="hero-pill">
                <i class="fas fa-calendar-day"></i>
                <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
            </div>
            <div class="hero-pill">
                <i class="fas fa-layer-group"></i>
                <%= totalCategories %> danh mục
            </div>
            <div class="hero-pill">
                <i class="fas fa-store"></i>
                <%= totalSuppliers %> nhà cung cấp
            </div>
        </div>
    </section>

    <% if (lowStockCount > 0) { %>
    <div class="alert-banner">
        <i class="fas fa-exclamation-triangle"></i>
        <div>
            <strong>Cảnh báo tồn kho:</strong>
            <p class="mb-0">Có <%= lowStockCount %> sản phẩm sắp hết hàng. Vui lòng kiểm tra và nhập thêm.</p>
        </div>
    </div>
    <% } %>

    <section class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e0f2fe;color:#0284c7;">
                <i class="fas fa-lightbulb"></i>
            </div>
            <h3 class="stat-number"><%= nf.format(totalProducts) %></h3>
            <p class="stat-label">Sản phẩm</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#dcfce7;color:#16a34a;">
                <i class="fas fa-grip-horizontal"></i>
            </div>
            <h3 class="stat-number"><%= nf.format(totalVariants) %></h3>
            <p class="stat-label">Biến thể</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#ede9fe;color:#7c3aed;">
                <i class="fas fa-boxes-stacked"></i>
            </div>
            <h3 class="stat-number"><%= nf.format(totalStockQty) %></h3>
            <p class="stat-label">Tồn kho</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#fee2e2;color:#dc2626;">
                <i class="fas fa-users"></i>
            </div>
            <h3 class="stat-number"><%= nf.format(totalUsers) %></h3>
            <p class="stat-label">Người dùng</p>
        </div>
    </section>

    <section class="content-sections">
        <div>
            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-bolt text-warning"></i>
                    Thao tác nhanh
                </div>
                <div class="quick-actions">
                    <a href="../elements/ShopItem.jsp" class="action-tile">
                        <div class="d-flex align-items-center gap-10">
                            <i class="fas fa-lightbulb text-primary"></i>
                            <div>
                                <strong>Quản lý sản phẩm</strong>
                                <p class="mb-0 text-muted small">Thêm, sửa, xóa đèn</p>
                            </div>
                        </div>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                    <a href="../elements/ItemDetail.jsp" class="action-tile">
                        <div class="d-flex align-items-center gap-10">
                            <i class="fas fa-cubes text-success"></i>
                            <div>
                                <strong>Biến thể sản phẩm</strong>
                                <p class="mb-0 text-muted small">Màu sắc, kích thước</p>
                            </div>
                        </div>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                    <a href="../elements/ProductStorage.jsp" class="action-tile">
                        <div class="d-flex align-items-center gap-10">
                            <i class="fas fa-warehouse text-warning"></i>
                            <div>
                                <strong>Kho hàng</strong>
                                <p class="mb-0 text-muted small">Theo dõi nhập/xuất</p>
                            </div>
                        </div>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                    <a href="../elements/statistics.jsp" class="action-tile">
                        <div class="d-flex align-items-center gap-10">
                            <i class="fas fa-chart-line text-purple"></i>
                            <div>
                                <strong>Thống kê</strong>
                                <p class="mb-0 text-muted small">Doanh thu & đơn hàng</p>
                            </div>
                        </div>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>

            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-clipboard-list text-primary"></i>
                    Tổng quan hệ thống
                </div>
                <ul class="snapshot-list">
                    <li>
                        <span>Danh mục sản phẩm</span>
                        <strong><%= totalCategories %></strong>
                    </li>
                    <li>
                        <span>Màu sắc đang sử dụng</span>
                        <strong><%= totalColors %></strong>
                    </li>
                    <li>
                        <span>Kích thước đang sử dụng</span>
                        <strong><%= totalSizes %></strong>
                    </li>
                    <li>
                        <span>Nhà cung cấp</span>
                        <strong><%= totalSuppliers %></strong>
                    </li>
                </ul>
            </div>
        </div>

        <div>
            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-box-open text-danger"></i>
                    Tình trạng kho
                </div>
                <p class="text-muted mb-2">Tổng số lượng tồn: <strong><%= nf.format(totalStockQty) %></strong></p>
                <p class="text-muted mb-3">Sản phẩm sắp hết hàng: <strong class="<%= lowStockCount > 0 ? "text-danger" : "text-success" %>">
                    <%= lowStockCount %>
                </strong></p>
                <div class="d-flex flex-column gap-2">
                    <span class="trend-pill <%= totalStockQty > 0 ? "trend-up" : "trend-down" %>">
                        <i class="fas fa-arrow-<%= totalStockQty > 0 ? "up" : "down" %>"></i>
                        <%= totalStockQty > 0 ? "Tồn kho an toàn" : "Cần nhập hàng" %>
                    </span>
                    <span class="trend-pill <%= lowStockCount > 0 ? "trend-down" : "trend-up" %>">
                        <i class="fas fa-<%= lowStockCount > 0 ? "exclamation-circle" : "check-circle" %>"></i>
                        <%= lowStockCount > 0 ? "Có sản phẩm cần lưu ý" : "Tất cả ổn định" %>
                    </span>
                </div>
            </div>

            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-life-ring text-info"></i>
                    Hỗ trợ nhanh
                </div>
                <p class="text-muted mb-3">Cần hỗ trợ thêm, vui lòng gửi email cho đội kỹ thuật.</p>
                <a href="mailto:support@lightshop.vn" class="btn btn-outline-primary w-100">
                    <i class="fas fa-envelope"></i> Liên hệ hỗ trợ
                </a>
            </div>
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.stat-number').forEach(el => {
            const target = parseInt(el.textContent.replace(/\./g, ''), 10);
            if (isNaN(target)) return;
            el.textContent = '0';
            const duration = 1200;
            const start = performance.now();
            const format = new Intl.NumberFormat('vi-VN');

            function update(now) {
                const progress = Math.min((now - start) / duration, 1);
                const value = Math.floor(progress * target);
                el.textContent = format.format(value);
                if (progress < 1) requestAnimationFrame(update);
            }

            requestAnimationFrame(update);
        });
    });
</script>
</body>
</html>

