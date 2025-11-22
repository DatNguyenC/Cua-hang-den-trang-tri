<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.*" %>
<%@ page import="DAO.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.LinkedHashMap" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê - LightShop Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <style>
        .stats-hero {
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

        .stats-hero h1 {
            font-size: 26px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .filter-tabs {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .filter-tab {
            padding: 10px 20px;
            border-radius: 10px;
            border: 1px solid rgba(226, 232, 240, 0.7);
            background: #fff;
            color: #64748b;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .filter-tab:hover {
            background: #f8f9fa;
            border-color: #cbd5e1;
        }

        .filter-tab.active {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: #fff;
            border-color: transparent;
        }

        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.05);
            border: 1px solid rgba(226, 232, 240, 0.7);
            margin-bottom: 22px;
        }

        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .stat-card-header h3 {
            font-size: 18px;
            margin: 0;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #1e293b;
            margin: 8px 0;
        }

        .stat-label {
            font-size: 14px;
            color: #64748b;
        }

        .stat-change {
            font-size: 13px;
            padding: 4px 8px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .stat-change.positive {
            background: #dcfce7;
            color: #16a34a;
        }

        .stat-change.negative {
            background: #fee2e2;
            color: #dc2626;
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-top: 20px;
        }

        .top-products-table {
            width: 100%;
            border-collapse: collapse;
        }

        .top-products-table th {
            text-align: left;
            padding: 12px;
            background: #f8f9fa;
            font-weight: 600;
            color: #475569;
            font-size: 13px;
            border-bottom: 2px solid #e2e8f0;
        }

        .top-products-table td {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
        }

        .top-products-table tr:hover {
            background: #f8f9fa;
        }

        .product-rank {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 13px;
        }

        .product-rank.rank-1 {
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            color: #fff;
        }

        .product-rank.rank-2 {
            background: linear-gradient(135deg, #94a3b8, #64748b);
            color: #fff;
        }

        .product-rank.rank-3 {
            background: linear-gradient(135deg, #f97316, #ea580c);
            color: #fff;
        }

        .product-rank.other {
            background: #f1f5f9;
            color: #64748b;
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
    </style>
</head>
<body>
<%
    HoaDonDAO hoaDonDAO = new HoaDonDAO();
    ChiTietHoaDonDAO chiTietDAO = new ChiTietHoaDonDAO();
    DenDAO denDAO = new DenDAO();
    BienTheDenDAO bienTheDAO = new BienTheDenDAO();
    NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    List<HoaDon> allOrders = hoaDonDAO.getAll();
    if (allOrders == null) allOrders = new ArrayList<>();

    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat monthFormat = new SimpleDateFormat("MM/yyyy");

    // Tính toán thống kê
    double totalRevenue = 0;
    int totalOrders = allOrders.size();
    int totalCustomers = nguoiDungDAO.getAll().size();
    
    Map<String, Double> revenueByMonth = new LinkedHashMap<>();
    Map<String, Integer> ordersByStatus = new HashMap<>();
    Map<Integer, Integer> productSales = new HashMap<>(); // ma_bien_the -> so_luong
    
    Calendar cal = Calendar.getInstance();
    for (int i = 11; i >= 0; i--) {
        cal.setTime(new Date());
        cal.add(Calendar.MONTH, -i);
        String monthKey = monthFormat.format(cal.getTime());
        revenueByMonth.put(monthKey, 0.0);
    }

    for (HoaDon order : allOrders) {
        totalRevenue += order.getTongTien();
        
        // Doanh thu theo tháng
        if (order.getNgayLap() != null) {
            String monthKey = monthFormat.format(order.getNgayLap());
            if (revenueByMonth.containsKey(monthKey)) {
                revenueByMonth.put(monthKey, revenueByMonth.get(monthKey) + order.getTongTien());
            }
        }
        
        // Đơn hàng theo trạng thái
        String status = order.getTrangThaiGiaoHang() != null ? order.getTrangThaiGiaoHang() : "chờ xử lý";
        ordersByStatus.put(status, ordersByStatus.getOrDefault(status, 0) + 1);
        
        // Top sản phẩm bán chạy
        List<ChiTietHoaDon> chiTietList = chiTietDAO.getByHoaDon(order.getMaHd());
        for (ChiTietHoaDon ct : chiTietList) {
            int maBienThe = ct.getMaBienThe();
            productSales.put(maBienThe, productSales.getOrDefault(maBienThe, 0) + ct.getSoLuong());
        }
    }

    // Top 10 sản phẩm bán chạy
    List<Map.Entry<Integer, Integer>> topProducts = new ArrayList<>(productSales.entrySet());
    topProducts.sort((a, b) -> b.getValue().compareTo(a.getValue()));
    topProducts = topProducts.subList(0, Math.min(10, topProducts.size()));

    // Tính doanh thu tháng trước và tháng này
    cal.setTime(new Date());
    String currentMonth = monthFormat.format(cal.getTime());
    cal.add(Calendar.MONTH, -1);
    String lastMonth = monthFormat.format(cal.getTime());
    double currentMonthRevenue = revenueByMonth.getOrDefault(currentMonth, 0.0);
    double lastMonthRevenue = revenueByMonth.getOrDefault(lastMonth, 0.0);
    double revenueChange = lastMonthRevenue > 0 ? ((currentMonthRevenue - lastMonthRevenue) / lastMonthRevenue) * 100 : 0;
%>

<jsp:include page="../layouts/sidebar-admin.html"/>
<jsp:include page="../layouts/header-content-admin.jsp"/>

<div class="pc-container">
    <section class="stats-hero">
        <div>
            <h1><i class="fas fa-chart-line"></i> Thống kê & Báo cáo</h1>
            <p>Theo dõi doanh thu, đơn hàng và hiệu suất kinh doanh.</p>
        </div>
        <div class="hero-meta">
            <span class="hero-pill">
                <i class="fas fa-calendar-day"></i>
                <%= dateFormat.format(new Date()) %>
            </span>
        </div>
    </section>

    <!-- Stat Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-money-bill-wave text-success"></i> Tổng doanh thu</h3>
                </div>
                <div class="stat-value"><%= nf.format(totalRevenue) %> đ</div>
                <div class="stat-label">Tất cả thời gian</div>
                <div class="mt-2">
                    <span class="stat-change <%= revenueChange >= 0 ? "positive" : "negative" %>">
                        <i class="fas fa-arrow-<%= revenueChange >= 0 ? "up" : "down" %>"></i>
                        <%= String.format("%.1f", Math.abs(revenueChange)) %>%
                    </span>
                    <span class="text-muted small ms-2">so với tháng trước</span>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-shopping-cart text-primary"></i> Tổng đơn hàng</h3>
                </div>
                <div class="stat-value"><%= totalOrders %></div>
                <div class="stat-label">Đơn hàng đã xử lý</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-users text-info"></i> Khách hàng</h3>
                </div>
                <div class="stat-value"><%= totalCustomers %></div>
                <div class="stat-label">Tổng số tài khoản</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-chart-bar text-warning"></i> Doanh thu tháng này</h3>
                </div>
                <div class="stat-value"><%= nf.format(currentMonthRevenue) %> đ</div>
                <div class="stat-label"><%= currentMonth %></div>
            </div>
        </div>
    </div>

    <!-- Chart Section -->
    <div class="row g-3 mb-4">
        <div class="col-md-8">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-chart-area"></i> Doanh thu theo tháng</h3>
                </div>
                <div class="chart-container">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-pie-chart"></i> Đơn hàng theo trạng thái</h3>
                </div>
                <div class="chart-container">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Top Products & Status Table -->
    <div class="row g-3">
        <div class="col-md-7">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-trophy"></i> Top 10 sản phẩm bán chạy</h3>
                </div>
                <div class="table-responsive">
                    <table class="top-products-table">
                        <thead>
                            <tr>
                                <th width="50">#</th>
                                <th>Sản phẩm</th>
                                <th width="120" class="text-end">Số lượng bán</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (topProducts.isEmpty()) { %>
                            <tr>
                                <td colspan="3" class="text-center py-4 text-muted">
                                    <i class="fas fa-box-open fa-2x mb-2"></i>
                                    <div>Chưa có dữ liệu bán hàng.</div>
                                </td>
                            </tr>
                            <% } else {
                                int rank = 1;
                                for (Map.Entry<Integer, Integer> entry : topProducts) {
                                    BienTheDen bienThe = bienTheDAO.getById(entry.getKey());
                                    if (bienThe != null) {
                                        Den den = denDAO.getById(bienThe.getMaDen());
                                        String productName = den != null ? den.getTenDen() : "Sản phẩm #" + entry.getKey();
                            %>
                            <tr>
                                <td>
                                    <span class="product-rank <%= rank <= 3 ? "rank-" + rank : "other" %>">
                                        <%= rank %>
                                    </span>
                                </td>
                                <td>
                                    <strong><%= productName %></strong><br>
                                    <small class="text-muted">Mã: #<%= entry.getKey() %></small>
                                </td>
                                <td class="text-end">
                                    <strong><%= entry.getValue() %></strong> sản phẩm
                                </td>
                            </tr>
                            <% 
                                        rank++;
                                    }
                                }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-5">
            <div class="stat-card">
                <div class="stat-card-header">
                    <h3><i class="fas fa-list-alt"></i> Thống kê đơn hàng</h3>
                </div>
                <div>
                    <% 
                        int pending = ordersByStatus.getOrDefault("chờ xử lý", 0);
                        int processing = ordersByStatus.getOrDefault("đang giao", 0);
                        int delivered = ordersByStatus.getOrDefault("đã giao", 0);
                        int received = ordersByStatus.getOrDefault("đã nhận", 0);
                        int cancelled = ordersByStatus.getOrDefault("hủy", 0);
                    %>
                    <div class="mb-3 p-3" style="background: #f8f9fa; border-radius: 10px;">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="stat-label">Chờ xử lý</span>
                            <span class="status-badge status-pending"><%= pending %></span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="stat-label">Đang giao</span>
                            <span class="status-badge status-processing"><%= processing %></span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="stat-label">Đã giao</span>
                            <span class="status-badge status-delivered"><%= delivered %></span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="stat-label">Đã nhận</span>
                            <span class="status-badge status-received"><%= received %></span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="stat-label">Đã hủy</span>
                            <span class="status-badge status-cancelled"><%= cancelled %></span>
                        </div>
                    </div>
                    <div class="mt-3 p-3" style="background: linear-gradient(135deg, #f0f9ff, #e0f2fe); border-radius: 10px;">
                        <div class="stat-label mb-1">Tổng đơn hàng</div>
                        <div class="stat-value" style="font-size: 28px;"><%= totalOrders %></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Doanh thu theo tháng
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    const revenueChart = new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: [<%
                boolean first = true;
                for (String month : revenueByMonth.keySet()) {
                    if (!first) out.print(",");
                    out.print("'" + month + "'");
                    first = false;
                }
            %>],
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: [<%
                    first = true;
                    for (Double revenue : revenueByMonth.values()) {
                        if (!first) out.print(",");
                        out.print(revenue);
                        first = false;
                    }
                %>],
                borderColor: 'rgb(59, 130, 246)',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' đ';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return new Intl.NumberFormat('vi-VN', { 
                                notation: 'compact',
                                maximumFractionDigits: 1
                            }).format(value) + ' đ';
                        }
                    }
                }
            }
        }
    });

    // Đơn hàng theo trạng thái
    const statusCtx = document.getElementById('statusChart').getContext('2d');
    const statusChart = new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Chờ xử lý', 'Đang giao', 'Đã giao', 'Đã nhận', 'Đã hủy'],
            datasets: [{
                data: [<%= pending %>, <%= processing %>, <%= delivered %>, <%= received %>, <%= cancelled %>],
                backgroundColor: [
                    'rgb(251, 191, 36)',
                    'rgb(59, 130, 246)',
                    'rgb(34, 197, 94)',
                    'rgb(99, 102, 241)',
                    'rgb(220, 38, 38)'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
</script>
</body>
</html>
