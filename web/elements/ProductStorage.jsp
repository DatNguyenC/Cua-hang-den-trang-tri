<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="Model.*"%>
<%@page import="DAO.*"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kho hàng - LightShop Admin</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">

        <style>
        .stock-hero {
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

        .stock-hero h1 {
            font-size: 26px;
            margin: 0;
                display: flex;
                align-items: center;
                gap: 12px;
            }

        .stock-hero p {
            margin: 6px 0 0;
            opacity: .85;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
            margin-bottom: 22px;
            }

        .stat-card {
                background: #fff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(226, 232, 240, 0.8);
            }

        .stat-card h3 {
                margin: 0;
            font-size: 32px;
            font-weight: 700;
            color: #0f172a;
            }

        .stat-card p {
            margin: 4px 0 0;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
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
            
        .filter-row input {
            border-radius: 12px;
            border: 1px solid rgba(226, 232, 240, 0.8);
            padding: 10px 14px;
            }
            
        .status-filter {
                display: flex;
            gap: 10px;
                flex-wrap: wrap;
            }
            
        .status-filter button {
            border: 1px solid rgba(226, 232, 240, 0.9);
            background: #fff;
            border-radius: 999px;
            padding: 6px 14px;
            font-size: 13px;
            cursor: pointer;
            transition: all .2s ease;
            }
            
        .status-filter button.active {
            background: rgba(56, 189, 248, 0.12);
            border-color: rgba(56, 189, 248, 0.6);
            color: #0369a1;
            }
            
        .table-container .btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        @media (max-width: 768px) {
            .stock-hero {
                padding: 20px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        .no-data {
            text-align: center;
            padding: 40px 20px;
            color: #94a3b8;
            }
        </style>
    </head>
    <body>
<%
    KhoDenDAO stockDAO = new KhoDenDAO();
    BienTheDenDAO variantDAO = new BienTheDenDAO();
    DenDAO denDAO = new DenDAO();
    MauSacDAO colorDAO = new MauSacDAO();
    KichThuocDAO sizeDAO = new KichThuocDAO();

    List<KhoDen> stockList = stockDAO.getAll();
    if (stockList == null) stockList = new ArrayList<>();
    List<BienTheDen> variantList = variantDAO.getAll();
    if (variantList == null) variantList = new ArrayList<>();
    List<MauSac> colorList = colorDAO.getAll();
    if (colorList == null) colorList = new ArrayList<>();
    List<KichThuoc> sizeList = sizeDAO.getAll();
    if (sizeList == null) sizeList = new ArrayList<>();
    List<Den> lampList = denDAO.getAll();
    if (lampList == null) lampList = new ArrayList<>();

    Map<Integer, String> lampNameMap = new HashMap<>();
    for (Den den : lampList) {
        lampNameMap.put(den.getMaDen(), den.getTenDen());
    }
    Map<Integer, String> colorNameMap = new HashMap<>();
    for (MauSac color : colorList) {
        colorNameMap.put(color.getMaMau(), color.getTenMau());
    }
    Map<Integer, String> sizeNameMap = new HashMap<>();
    for (KichThuoc size : sizeList) {
        sizeNameMap.put(size.getMaKichThuoc(), size.getTenKichThuoc());
    }
    Map<Integer, BienTheDen> variantMap = new HashMap<>();
    for (BienTheDen variant : variantList) {
        variantMap.put(variant.getMaBienThe(), variant);
    }
    Set<Integer> variantInStock = new HashSet<>();
    for (KhoDen stock : stockList) {
        variantInStock.add(stock.getMaBienThe());
    }

    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));

    int totalRecords = stockList.size();
    int totalImported = 0;
    int totalSold = 0;
    int lowStockCount = 0;
    for (KhoDen item : stockList) {
        totalImported += item.getSoLuongNhap();
        totalSold += item.getSoLuongBan();
        int remain = item.getSoLuongNhap() - item.getSoLuongBan();
        if (remain > 0 && remain <= 5) {
            lowStockCount++;
        }
    }
    int totalRemain = totalImported - totalSold;
%>

<jsp:include page="../layouts/sidebar-admin.html"/>
<jsp:include page="../layouts/header-content-admin.jsp"/>

<div class="pc-container stock-page">
    <section class="stock-hero">
        <div>
            <h1><i class="fas fa-warehouse"></i> Kho hàng</h1>
            <p>Theo dõi nhập - xuất và tồn kho cho từng biến thể.</p>
                            </div>
        <div class="hero-meta">
            <span class="hero-pill"><i class="fas fa-boxes"></i><%= totalRecords %> mục kho</span>
            <span class="hero-pill"><i class="fas fa-arrow-down"></i><%= nf.format(totalImported) %> nhập</span>
            <span class="hero-pill"><i class="fas fa-arrow-up"></i><%= nf.format(totalSold) %> bán</span>
            <span class="hero-pill"><i class="fas fa-battery-quarter"></i><%= lowStockCount %> còn ít</span>
                            </div>
    </section>

    <section class="stats-grid">
                                <div class="stat-card">
            <h3><%= nf.format(totalImported) %></h3>
            <p>Tổng số lượng nhập</p>
                                </div>
                                <div class="stat-card">
            <h3><%= nf.format(totalSold) %></h3>
            <p>Tổng số lượng bán</p>
                                </div>
                                <div class="stat-card">
            <h3 class="<%= totalRemain <= 10 ? "text-danger" : "text-success" %>"><%= nf.format(totalRemain) %></h3>
            <p>Số lượng tồn</p>
                                </div>
                                <div class="stat-card">
            <h3 class="<%= lowStockCount > 0 ? "text-warning" : "text-success" %>"><%= lowStockCount %></h3>
            <p>Sản phẩm gần hết</p>
                                    </div>
    </section>

    <section class="filter-shell">
        <div class="filter-row align-items-end">
            <div>
                <label class="form-label">Tìm kiếm</label>
                <div class="search-box" style="width:100%;">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Tìm theo tên đèn, màu sắc, kích thước..." onkeyup="applyFilters()">
                                </div>
                            </div>
            <div>
                <label class="form-label"> </label>
                <button class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                    <i class="fas fa-broom"></i> Xóa bộ lọc
                </button>
            </div>
            <div class="text-end">
                <label class="form-label"> </label>
                <button class="btn-primary" onclick="showAddModal()">
                    <i class="fas fa-plus-circle"></i> Thêm kho
                                                </button>
                                            </div>
                                        </div>
        <div class="mt-3 status-filter">
            <button class="active" data-filter="all" onclick="setStatusFilter(this)">Tất cả</button>
            <button data-filter="high" onclick="setStatusFilter(this)">Tồn kho cao</button>
            <button data-filter="medium" onclick="setStatusFilter(this)">Tồn kho trung bình</button>
            <button data-filter="low" onclick="setStatusFilter(this)">Tồn kho thấp</button>
            <button data-filter="out" onclick="setStatusFilter(this)">Hết hàng</button>
                                    </div>
    </section>
                                
    <section class="table-container">
        <div class="table-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h3>Danh sách kho</h3>
                <small id="tableSubtitle">Có <%= totalRecords %> mục trong kho</small>
                                </div>
                            </div>
                            <div class="table-responsive">
            <table class="products-table" id="stockTable">
                <thead>
                                        <tr>
                    <th>Kho</th>
                    <th>Biến thể</th>
                                            <th>Số lượng nhập</th>
                                            <th>Số lượng bán</th>
                                            <th>Tồn kho</th>
                    <th>Cập nhật</th>
                    <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                <% if (stockList.isEmpty()) { %>
                    <tr>
                        <td colspan="7">
                            <div class="no-data">
                                <i class="fas fa-box-open"></i>
                                Chưa có dữ liệu kho.
                            </div>
                        </td>
                    </tr>
                <% } else {
                    for (KhoDen stock : stockList) {
                        int imported = stock.getSoLuongNhap();
                        int sold = stock.getSoLuongBan();
                        int remain = imported - sold;
                        String status = remain <= 0 ? "out" : remain <= 5 ? "low" : remain <= 20 ? "medium" : "high";
                        BienTheDen variant = variantMap.get(stock.getMaBienThe());
                        String productName = "Không xác định";
                        String colorName = "-";
                        String sizeName = "-";
                        if (variant != null) {
                            productName = lampNameMap.getOrDefault(variant.getMaDen(), "Không xác định");
                            if (variant.getMaMau() != null && variant.getMaMau() != 0) {
                                colorName = colorNameMap.getOrDefault(variant.getMaMau(), "Không màu");
                            }
                            if (variant.getMaKichThuoc() != null && variant.getMaKichThuoc() != 0) {
                                sizeName = sizeNameMap.getOrDefault(variant.getMaKichThuoc(), "Không kích thước");
                            }
                        }
                        String keywords = (productName + " " + colorName + " " + sizeName).toLowerCase();
                                        %>
                <tr data-status="<%= status %>" data-keywords="<%= keywords %>">
                    <td><strong>#<%= stock.getMaKho() %></strong></td>
                                            <td>
                        <div class="product-info">
                            <h4 class="product-name"><%= productName %></h4>
                            <div class="product-details">
                                <span class="category"><i class="fas fa-palette"></i> <%= colorName %></span>
                                <span class="supplier"><i class="fas fa-ruler"></i> <%= sizeName %></span>
                            </div>
                            <small class="text-muted">Mã biến thể: <%= stock.getMaBienThe() %></small>
                                                </div>
                                            </td>
                    <td><span class="badge bg-primary"><%= imported %></span></td>
                    <td><span class="badge bg-info text-dark"><%= sold %></span></td>
                                            <td>
                        <span class="badge <%= remain <= 0 ? "bg-danger" : remain <= 5 ? "bg-warning text-dark" : "bg-success" %>">
                            <%= remain %>
                                                </span>
                                            </td>
                    <td><small><%= stock.getCapNhatGanNhat() != null ? stock.getCapNhatGanNhat() : "Chưa cập nhật" %></small></td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-action btn-edit"
                                    data-id="<%= stock.getMaKho() %>"
                                    data-variant="<%= stock.getMaBienThe() %>"
                                    data-imported="<%= imported %>"
                                    data-sold="<%= sold %>">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn-action btn-delete"
                                    data-id="<%= stock.getMaKho() %>"
                                    data-name="<%= productName.replace("\"","&quot;") %>">
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

<div id="stockModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3 id="modalTitle"><i class="fas fa-plus-circle"></i> Thêm kho</h3>
            <button class="close-btn" onclick="closeModal()"><i class="fas fa-times"></i></button>
        </div>
        <form id="stockForm" method="post">
            <div class="modal-body">
                <input type="hidden" id="maKho" name="maKho">
                <div class="form-group">
                    <label for="maBienThe">Biến thể</label>
                    <select id="maBienThe" name="maBienThe" required>
                        <option value="">Chọn biến thể</option>
                        <% for (BienTheDen variant : variantList) {
                            String productName = lampNameMap.getOrDefault(variant.getMaDen(), "Không xác định");
                            String colorName = "-";
                            String sizeName = "-";
                            if (variant.getMaMau() != null && variant.getMaMau() != 0) {
                                colorName = colorNameMap.getOrDefault(variant.getMaMau(), "Không màu");
                            }
                            if (variant.getMaKichThuoc() != null && variant.getMaKichThuoc() != 0) {
                                sizeName = sizeNameMap.getOrDefault(variant.getMaKichThuoc(), "Không kích thước");
                            }
                            boolean already = variantInStock.contains(variant.getMaBienThe());
                                %>
                        <option value="<%= variant.getMaBienThe() %>">
                            <%= productName %> - Màu: <%= colorName %> - KT: <%= sizeName %><%= already ? " (đã có)" : "" %>
                                </option>
                        <% } %>
                            </select>
                        </div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="soLuongNhap">Số lượng nhập *</label>
                        <input type="number" id="soLuongNhap" name="soLuongNhap" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="soLuongBan">Số lượng bán *</label>
                        <input type="number" id="soLuongBan" name="soLuongBan" min="0" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn-primary" id="stockSubmitBtn">
                    <i class="fas fa-save"></i> Lưu
                </button>
                    </div>
                </form>
            </div>
        </div>

<div id="deleteModal" class="modal-overlay">
    <div class="modal-container small">
        <div class="modal-header danger">
            <h3><i class="fas fa-exclamation-triangle"></i> Xóa mục kho</h3>
        </div>
        <div class="modal-body">
            <p>Bạn chắc chắn muốn xóa kho <strong id="deleteStockName"></strong>?</p>
            <p class="warning">Hành động này không thể hoàn tác.</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-secondary" onclick="closeDeleteModal()">
                <i class="fas fa-times"></i> Hủy
            </button>
            <button type="button" class="btn-danger" id="confirmDeleteBtn">
                <i class="fas fa-trash"></i> Xóa
            </button>
        </div>
    </div>
</div>

        <script>
                const searchInput = document.getElementById('searchInput');
    const tableSubtitle = document.getElementById('tableSubtitle');
    const rows = document.querySelectorAll('#stockTable tbody tr');
    const statusButtons = document.querySelectorAll('.status-filter button');
    const stockModal = document.getElementById('stockModal');
    const stockForm = document.getElementById('stockForm');
    const modalTitle = document.getElementById('modalTitle');
    const stockSubmitBtn = document.getElementById('stockSubmitBtn');
    const deleteModal = document.getElementById('deleteModal');
    const deleteName = document.getElementById('deleteStockName');
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

    let deleteId = null;

    function setStatusFilter(btn) {
        statusButtons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        applyFilters();
    }

    function clearFilters() {
                        searchInput.value = '';
        setStatusFilter(statusButtons[0]);
    }

    function applyFilters() {
        const term = searchInput.value.trim().toLowerCase();
        const status = document.querySelector('.status-filter button.active').dataset.filter;
        let visible = 0;
                        
                        rows.forEach(row => {
            const matchesSearch = !term || row.dataset.keywords.includes(term);
            const matchesStatus = status === 'all' || row.dataset.status === status;
            const show = matchesSearch && matchesStatus;
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        if (tableSubtitle) {
            tableSubtitle.textContent = `Đang hiển thị ${visible} mục kho`;
                        }
    }

    function showAddModal() {
        stockForm.reset();
        document.getElementById('maKho').value = '';
        modalTitle.innerHTML = '<i class="fas fa-plus-circle"></i> Thêm kho';
        stockForm.action = '<%=request.getContextPath()%>/them-kho';
        stockSubmitBtn.innerHTML = '<i class="fas fa-save"></i> Thêm kho';
        stockSubmitBtn.disabled = false;
        stockModal.classList.add('show');
    }

    function showEditModal(button) {
        stockForm.reset();
        document.getElementById('maKho').value = button.getAttribute('data-id');
        document.getElementById('maBienThe').value = button.getAttribute('data-variant');
        document.getElementById('soLuongNhap').value = button.getAttribute('data-imported');
        document.getElementById('soLuongBan').value = button.getAttribute('data-sold');
        modalTitle.innerHTML = '<i class="fas fa-edit"></i> Cập nhật kho';
        stockForm.action = '<%=request.getContextPath()%>/sua-kho';
        stockSubmitBtn.innerHTML = '<i class="fas fa-save"></i> Cập nhật';
        stockSubmitBtn.disabled = false;
        stockModal.classList.add('show');
                }

    function closeModal() {
        stockModal.classList.remove('show');
                }

    function showDeleteModal(button) {
        deleteId = button.getAttribute('data-id');
        deleteName.textContent = button.getAttribute('data-name');
        confirmDeleteBtn.disabled = false;
        confirmDeleteBtn.innerHTML = '<i class="fas fa-trash"></i> Xóa';
        deleteModal.classList.add('show');
                }

    function closeDeleteModal() {
        deleteModal.classList.remove('show');
        deleteId = null;
    }

    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', () => showEditModal(btn));
                    });

    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', () => showDeleteModal(btn));
    });

    confirmDeleteBtn.addEventListener('click', () => {
        if (!deleteId) return;
        confirmDeleteBtn.disabled = true;
        confirmDeleteBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xóa...';
        window.location.href = '<%=request.getContextPath()%>/xoa-kho?id=' + encodeURIComponent(deleteId);
                    });

    stockForm.addEventListener('submit', function (e) {
        stockSubmitBtn.disabled = true;
        stockSubmitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
    });

    stockModal.addEventListener('click', (e) => {
        if (e.target === stockModal) closeModal();
                                });
    deleteModal.addEventListener('click', (e) => {
        if (e.target === deleteModal) closeDeleteModal();
            });
        </script>
    </body>
</html>