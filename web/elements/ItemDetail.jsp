<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="Model.*"%>
<%@page import="DAO.*"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biến thể sản phẩm - LightShop Admin</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">

        <style>
        .variant-hero {
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

        .variant-hero h1 {
            font-size: 26px;
            margin: 0;
                display: flex;
                align-items: center;
            gap: 12px;
        }

        .variant-hero p {
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
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 14px;
        }

        .filter-row select,
        .filter-row input {
            width: 100%;
            border-radius: 12px;
            border: 1px solid rgba(226, 232, 240, 0.8);
            padding: 10px 14px;
        }

        .no-data {
            text-align: center;
            padding: 40px 20px;
            color: #94a3b8;
        }

        .no-data i {
            font-size: 28px;
            margin-bottom: 6px;
                display: block;
        }

        @media (max-width: 768px) {
            .variant-hero {
                padding: 20px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
            }
        </style>
    </head>
    <body>
<%
    BienTheDenDAO variantDAO = new BienTheDenDAO();
    DenDAO denDAO = new DenDAO();
    MauSacDAO colorDAO = new MauSacDAO();
    KichThuocDAO sizeDAO = new KichThuocDAO();

    List<BienTheDen> allVariants = variantDAO.getAll();
    if (allVariants == null) {
        allVariants = new ArrayList<>();
    }

    int itemsPerPage = 10;
                            int currentPage = 1;
                            String pageParam = request.getParameter("page");
    if (pageParam != null) {
                                try {
            currentPage = Math.max(1, Integer.parseInt(pageParam));
        } catch (NumberFormatException ignored) {
                                    currentPage = 1;
                                }
                            }
                            
    int totalVariants = allVariants.size();
    int totalPages = (int) Math.ceil(totalVariants / (double) itemsPerPage);
    if (totalPages == 0) totalPages = 1;
    if (currentPage > totalPages) currentPage = totalPages;

    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = Math.min(startIndex + itemsPerPage, totalVariants);
    List<BienTheDen> variantPage = totalVariants > 0 ? allVariants.subList(startIndex, endIndex) : Collections.emptyList();
    int displayStart = totalVariants == 0 ? 0 : startIndex + 1;
    int displayEnd = totalVariants == 0 ? 0 : endIndex;

    List<Den> lampList = denDAO.getAll();
    if (lampList == null) lampList = new ArrayList<>();
    Map<Integer, String> lampNameMap = new HashMap<>();
    for (Den den : lampList) {
        lampNameMap.put(den.getMaDen(), den.getTenDen());
    }

    List<MauSac> colorList = colorDAO.getAll();
    if (colorList == null) colorList = new ArrayList<>();
    Map<Integer, String> colorNameMap = new HashMap<>();
    for (MauSac color : colorList) {
        colorNameMap.put(color.getMaMau(), color.getTenMau());
    }

    List<KichThuoc> sizeList = sizeDAO.getAll();
    if (sizeList == null) sizeList = new ArrayList<>();
    Map<Integer, String> sizeNameMap = new HashMap<>();
    for (KichThuoc size : sizeList) {
        sizeNameMap.put(size.getMaKichThuoc(), size.getTenKichThuoc());
    }
%>

<jsp:include page="../layouts/sidebar-admin.html"/>
<jsp:include page="../layouts/header-content-admin.jsp"/>

<div class="pc-container variant-page">
    <section class="variant-hero">
        <div>
            <h1><i class="fas fa-layer-group"></i>Quản lý biến thể sản phẩm</h1>
            <p>Quản lý màu sắc, kích thước cho từng sản phẩm.</p>
                        </div>
        <div class="hero-meta">
            <span class="hero-pill"><i class="fas fa-boxes"></i><%= totalVariants %> biến thể</span>
            <span class="hero-pill"><i class="fas fa-lightbulb"></i><%= lampList.size() %> sản phẩm</span>
            <span class="hero-pill"><i class="fas fa-palette"></i><%= colorList.size() %> màu sắc</span>
            <span class="hero-pill"><i class="fas fa-ruler"></i><%= sizeList.size() %> kích thước</span>
                        </div>
    </section>

    <section class="stats-grid">
                            <div class="stat-card">
            <h3><%= totalVariants %></h3>
            <p>Biến thể đang hoạt động</p>
                            </div>
                            <div class="stat-card">
            <h3><%= lampList.size() %></h3>
            <p>Sản phẩm có biến thể</p>
                            </div>
                            <div class="stat-card">
            <h3><%= colorList.size() %></h3>
            <p>Màu sắc sử dụng</p>
                            </div>
                            <div class="stat-card">
            <h3><%= sizeList.size() %></h3>
            <p>Kích thước sử dụng</p>
                            </div>
    </section>

    <section class="filter-shell">
        <div class="filter-row">
            <div>
                <label class="form-label">Tìm kiếm</label>
                <div class="search-box" style="width:100%;">
                                                <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Nhập tên sản phẩm hoặc màu sắc..." onkeyup="filterVariants()">
                                        </div>
                                    </div>
            <div>
                <label class="form-label">Sản phẩm</label>
                <select id="lampFilter" onchange="filterVariants()">
                    <option value="">Tất cả</option>
                    <% for (Den den : lampList) { %>
                        <option value="<%= den.getMaDen() %>"><%= den.getTenDen() %></option>
                    <% } %>
                </select>
                                </div>
            <div>
                <label class="form-label">Màu sắc</label>
                <select id="colorFilter" onchange="filterVariants()">
                    <option value="">Tất cả</option>
                    <% for (MauSac color : colorList) { %>
                        <option value="<%= color.getMaMau() %>"><%= color.getTenMau() %></option>
                    <% } %>
                </select>
                            </div>
            <div>
                <label class="form-label">Kích thước</label>
                <select id="sizeFilter" onchange="filterVariants()">
                    <option value="">Tất cả</option>
                    <% for (KichThuoc size : sizeList) { %>
                        <option value="<%= size.getMaKichThuoc() %>"><%= size.getTenKichThuoc() %></option>
                    <% } %>
                </select>
                                        </div>
                                    </div>
    </section>

    <section class="table-container">
        <div class="table-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h3>Danh sách biến thể</h3>
                <small id="tableSubtitle">Hiển thị <%= displayStart %> - <%= displayEnd %> / <%= totalVariants %> biến thể</small>
                                </div>
            <button class="btn-primary" onclick="showAddModal()">
                <i class="fas fa-plus-circle"></i> Thêm biến thể
            </button>
                        </div>
                        <div class="table-responsive">
            <table class="products-table" id="variantTable">
                <thead>
                                    <tr>
                    <th>STT</th>
                    <th>Thông tin biến thể</th>
                                        <th>Màu sắc</th>
                                        <th>Kích thước</th>
                    <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                <% if (variantPage.isEmpty()) { %>
                    <tr>
                        <td colspan="5">
                            <div class="no-data">
                                <i class="fas fa-box-open"></i>
                                Không có biến thể nào trong trang này.
                            </div>
                                        </td>
                                    </tr>
                                    <% } else { 
                    int stt = startIndex + 1;
                    for (BienTheDen variant : variantPage) {
                        String productName = lampNameMap.getOrDefault(variant.getMaDen(), "Không xác định");
                        String colorName = "-";
                        if (variant.getMaMau() != null) {
                            colorName = colorNameMap.getOrDefault(variant.getMaMau(), "-");
                        }
                        String sizeName = "-";
                        if (variant.getMaKichThuoc() != null) {
                            sizeName = sizeNameMap.getOrDefault(variant.getMaKichThuoc(), "-");
                        }
                        String colorValue = variant.getMaMau() != null ? String.valueOf(variant.getMaMau()) : "";
                        String sizeValue = variant.getMaKichThuoc() != null ? String.valueOf(variant.getMaKichThuoc()) : "";
                %>
                <tr data-den="<%= variant.getMaDen() %>"
                    data-color="<%= colorValue %>"
                    data-size="<%= sizeValue %>">
                    <td><%= stt++ %></td>
                    <td>
                        <div class="product-info">
                            <h4 class="product-name">Mã biến thể: <%= variant.getMaBienThe() %></h4>
                            <div class="product-details">
                                <span class="category"><i class="fas fa-lightbulb"></i> <%= productName %></span>
                                <span class="supplier"><i class="fas fa-barcode"></i> Đèn #<%= variant.getMaDen() %></span>
                            </div>
                                            </div>
                                        </td>
                                        <td>
                        <% if (!"-".equals(colorName)) { %>
                            <span class="badge bg-light text-dark"><i class="fas fa-palette"></i> <%= colorName %></span>
                                            <% } else { %>
                                            <span class="text-muted">-</span>
                                            <% } %>
                                        </td>
                                        <td>
                        <% if (!"-".equals(sizeName)) { %>
                            <span class="badge bg-info text-white"><i class="fas fa-ruler"></i> <%= sizeName %></span>
                                            <% } else { %>
                                            <span class="text-muted">-</span>
                                            <% } %>
                                        </td>
                    <td>
                                            <div class="action-buttons">
                            <button class="btn-action btn-edit"
                                    data-id="<%= variant.getMaBienThe() %>"
                                    data-den="<%= variant.getMaDen() %>"
                                    data-mau="<%= colorValue %>"
                                    data-kt="<%= sizeValue %>">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn-action btn-delete"
                                    data-id="<%= variant.getMaBienThe() %>"
                                    data-name="<%= productName.replace("\"", "&quot;") %>">
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

                        <div class="pagination-container">
            <div class="page-info">
                Hiển thị <%= displayStart %> - <%= displayEnd %> / <%= totalVariants %> biến thể
                            </div>
            <nav class="pagination-nav">
                            <ul class="pagination">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= Math.max(1, currentPage - 1) %>">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                                </li>
                    <%
                        int window = 2;
                        int startPage = Math.max(1, currentPage - window);
                        int endPage = Math.min(totalPages, currentPage + window);
                        if (startPage > 1) {
                    %>
                        <li class="page-item"><a class="page-link" href="?page=1">1</a></li>
                        <% if (startPage > 2) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                    <% } %>
                    <% for (int i = startPage; i <= endPage; i++) { %>
                                <li class="page-item <%= i == currentPage ? "active" : "" %>">
                            <% if (i == currentPage) { %>
                                <span class="page-link current"><%= i %></span>
                            <% } else { %>
                                <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                                <% } %>
                                </li>
                                <% } %>
                    <% if (endPage < totalPages) { %>
                        <% if (endPage < totalPages - 1) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <li class="page-item"><a class="page-link" href="?page=<%= totalPages %>"><%= totalPages %></a></li>
                    <% } %>
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= Math.min(totalPages, currentPage + 1) %>">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </section>
                        </div>

<div id="variantModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3 id="modalTitle"><i class="fas fa-plus-circle"></i> Thêm biến thể</h3>
            <button class="close-btn" onclick="closeModal()"><i class="fas fa-times"></i></button>
                                    </div>
        <form id="variantForm" method="post">
            <div class="modal-body">
                <input type="hidden" id="maBienThe" name="maBienThe">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="maDen">Sản phẩm *</label>
                        <select id="maDen" name="maDen" required>
                            <option value="">Chọn sản phẩm</option>
                            <% for (Den den : lampList) { %>
                                <option value="<%= den.getMaDen() %>"><%= den.getTenDen() %></option>
                                            <% } %>
                                        </select>
                                    </div>
                    <div class="form-group">
                        <label for="maMau">Màu sắc</label>
                        <select id="maMau" name="maMau">
                            <option value="">Không chọn</option>
                            <% for (MauSac color : colorList) { %>
                                <option value="<%= color.getMaMau() %>"><%= color.getTenMau() %></option>
                                            <% } %>
                                        </select>
                                    </div>
                    <div class="form-group">
                        <label for="maKichThuoc">Kích thước</label>
                        <select id="maKichThuoc" name="maKichThuoc">
                            <option value="">Không chọn</option>
                            <% for (KichThuoc size : sizeList) { %>
                                <option value="<%= size.getMaKichThuoc() %>"><%= size.getTenKichThuoc() %></option>
                                            <% } %>
                                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn-primary" id="variantSubmitBtn">
                    <i class="fas fa-save"></i> Lưu biến thể
                </button>
            </div>
        </form>
    </div>
</div>

<div id="deleteModal" class="modal-overlay">
    <div class="modal-container small">
        <div class="modal-header danger">
            <h3><i class="fas fa-exclamation-triangle"></i> Xác nhận xóa</h3>
        </div>
        <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa biến thể <strong id="deleteVariantName"></strong> không?</p>
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
    let currentVariantId = null;
    let deleteVariantId = null;

    function showAddModal() {
        currentVariantId = null;
        document.getElementById('variantForm').action = '<%=request.getContextPath()%>/them-bien-the';
        document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> Thêm biến thể';
        document.getElementById('variantSubmitBtn').innerHTML = '<i class="fas fa-save"></i> Thêm biến thể';
        document.getElementById('variantSubmitBtn').disabled = false;
        document.getElementById('variantForm').reset();
        document.getElementById('maBienThe').value = '';
        document.getElementById('variantModal').classList.add('show');
    }

    function showEditModal(button) {
        currentVariantId = button.getAttribute('data-id');
        document.getElementById('variantForm').action = '<%=request.getContextPath()%>/sua-bien-the';
        document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Cập nhật biến thể';
        document.getElementById('variantSubmitBtn').innerHTML = '<i class="fas fa-save"></i> Cập nhật';
        document.getElementById('variantSubmitBtn').disabled = false;

        document.getElementById('maBienThe').value = currentVariantId;
        document.getElementById('maDen').value = button.getAttribute('data-den') || '';
        document.getElementById('maMau').value = button.getAttribute('data-mau') || '';
        document.getElementById('maKichThuoc').value = button.getAttribute('data-kt') || '';

        document.getElementById('variantModal').classList.add('show');
    }

    function closeModal() {
        document.getElementById('variantModal').classList.remove('show');
        document.getElementById('variantForm').reset();
        document.getElementById('maBienThe').value = '';
        currentVariantId = null;
    }

    function showDeleteModal(button) {
        deleteVariantId = button.getAttribute('data-id');
        const name = button.getAttribute('data-name') || 'biến thể này';
        document.getElementById('deleteVariantName').textContent = 'Mã ' + deleteVariantId + ' - ' + name;
        document.getElementById('confirmDeleteBtn').disabled = false;
        document.getElementById('confirmDeleteBtn').innerHTML = '<i class="fas fa-trash"></i> Xóa';
        document.getElementById('deleteModal').classList.add('show');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.remove('show');
        deleteVariantId = null;
    }

    function filterVariants() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const lampFilter = document.getElementById('lampFilter').value;
        const colorFilter = document.getElementById('colorFilter').value;
        const sizeFilter = document.getElementById('sizeFilter').value;
        const subtitle = document.getElementById('tableSubtitle');

        const rows = document.querySelectorAll('#variantTable tbody tr');
        let visible = 0;
                        
                        rows.forEach(row => {
            const name = row.querySelector('.product-name') ? row.querySelector('.product-name').textContent.toLowerCase() : '';
            const colorCell = row.cells.length > 2 ? row.cells[2].textContent.toLowerCase() : '';
            const sizeCell = row.cells.length > 3 ? row.cells[3].textContent.toLowerCase() : '';
            const matchesSearch = !searchTerm || name.includes(searchTerm) || colorCell.includes(searchTerm) || sizeCell.includes(searchTerm);
            const matchesLamp = !lampFilter || row.getAttribute('data-den') === lampFilter;
            const matchesColor = !colorFilter || row.getAttribute('data-color') === colorFilter;
            const matchesSize = !sizeFilter || row.getAttribute('data-size') === sizeFilter;
            const show = matchesSearch && matchesLamp && matchesColor && matchesSize;
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        if (subtitle) {
            if (searchTerm || lampFilter || colorFilter || sizeFilter) {
                subtitle.textContent = 'Đang hiển thị ' + visible + ' biến thể (đã lọc)';
            } else {
                subtitle.textContent = 'Hiển thị <%= displayStart %> - <%= displayEnd %> / <%= totalVariants %> biến thể';
            }
        }
    }

    function clearFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('lampFilter').value = '';
        document.getElementById('colorFilter').value = '';
        document.getElementById('sizeFilter').value = '';
        document.querySelectorAll('#variantTable tbody tr').forEach(row => row.style.display = '');
        const subtitle = document.getElementById('tableSubtitle');
        if (subtitle) {
            subtitle.textContent = 'Hiển thị <%= displayStart %> - <%= displayEnd %> / <%= totalVariants %> biến thể';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('.btn-edit').forEach(btn => {
            btn.addEventListener('click', function () {
                showEditModal(this);
                    });
                });

                document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', function () {
                showDeleteModal(this);
                    });
                });

        document.getElementById('confirmDeleteBtn').addEventListener('click', function () {
            if (!deleteVariantId) return;
            this.disabled = true;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xóa...';
            window.location.href = '<%=request.getContextPath()%>/xoa-bien-the?id=' + encodeURIComponent(deleteVariantId);
        });

        document.getElementById('variantForm').addEventListener('submit', function () {
            const btn = document.getElementById('variantSubmitBtn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
        });
            });
        </script>
    </body>
</html> 

