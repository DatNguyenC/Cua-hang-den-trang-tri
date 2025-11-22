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
    <title>Quản lý sản phẩm đèn - LightShop Admin</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/admin-main-content.css">
    <link rel="stylesheet" href="../assets/css/admin-animations.css">
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="../assets/css/shop-item.css">
</head>
<body>
    <%
        DenDAO denDAO = new DenDAO();
        LoaiDenDAO loaiDenDAO = new LoaiDenDAO();
        NhaCungCapDAO nhaCungCapDAO = new NhaCungCapDAO();
        
    List<Den> allDenList = denDAO.getAll();
    if (allDenList == null) {
        allDenList = new ArrayList<>();
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
        
        int totalItems = allDenList.size();
    int totalPages = (int) Math.ceil(totalItems / (double) itemsPerPage);
    if (totalPages == 0) {
        totalPages = 1;
    }
    if (currentPage > totalPages) {
        currentPage = totalPages;
    }

        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
    List<Den> denList = totalItems > 0 ? allDenList.subList(startIndex, endIndex) : Collections.emptyList();
    int displayStart = totalItems == 0 ? 0 : startIndex + 1;
    int displayEnd = totalItems == 0 ? 0 : endIndex;
        
        List<LoaiDen> loaiDenList = loaiDenDAO.getAll();
    if (loaiDenList == null) {
        loaiDenList = new ArrayList<>();
    }
        List<NhaCungCap> nhaCungCapList = nhaCungCapDAO.getAll();
    if (nhaCungCapList == null) {
        nhaCungCapList = new ArrayList<>();
    }

    NumberFormat currencyFormat = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
%>

<jsp:include page="../layouts/sidebar-admin.html"/>
<jsp:include page="../layouts/header-content-admin.jsp"/>

    <div class="pc-container">
    <section class="page-header">
            <div class="header-content">
            <div>
                    <h1 class="page-title">
                        <i class="fas fa-lightbulb"></i>
                        Quản lý sản phẩm đèn
                    </h1>
                <p class="page-subtitle">Theo dõi, tìm kiếm, thêm mới và chỉnh sửa sản phẩm nhanh chóng.</p>
                </div>
            <div class="d-flex gap-3 flex-wrap">
                <button class="btn-filter" onclick="clearFilters()">
                    <i class="fas fa-eraser"></i>
                    Xóa bộ lọc
                </button>
                <button class="btn-primary" onclick="showAddModal()">
                    <i class="fas fa-plus-circle"></i>
                        Thêm sản phẩm
                    </button>
                </div>
            </div>
    </section>

    <section class="filter-section">
            <div class="filter-row">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                <input id="searchInput" type="text" placeholder="Tìm theo tên sản phẩm..." onkeyup="filterProducts()">
                </div>
            <div class="filter-group flex-grow-1">
                <label for="categoryFilter" class="form-label mb-1">Loại đèn</label>
                    <select id="categoryFilter" onchange="filterProducts()">
                    <option value="">Tất cả</option>
                        <% for (LoaiDen loai : loaiDenList) { %>
                            <option value="<%= loai.getMaLoai() %>"><%= loai.getTenLoai() %></option>
                        <% } %>
                    </select>
                </div>
            <div class="filter-group flex-grow-1">
                <label for="supplierFilter" class="form-label mb-1">Nhà cung cấp</label>
                    <select id="supplierFilter" onchange="filterProducts()">
                    <option value="">Tất cả</option>
                        <% for (NhaCungCap ncc : nhaCungCapList) { %>
                            <option value="<%= ncc.getMaNCC() %>"><%= ncc.getTenNCC() %></option>
                        <% } %>
                    </select>
                </div>
        </div>
    </section>

    <section class="table-container">
        <header class="table-header">
            <div>
                <h3>Danh sách sản phẩm</h3>
                <small id="tableSubtitle">Hiển thị <%= displayStart %> - <%= displayEnd %> / <%= totalItems %> sản phẩm</small>
            </div>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <span class="badge bg-primary text-white">Trang <%= currentPage %> / <%= totalPages %></span>
                <span class="badge bg-secondary text-white" id="productCount"><%= totalItems %></span>
        </div>
        </header>

            <div class="table-responsive">
                <table class="products-table" id="productsTable">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Hình ảnh</th>
                    <th>Thông tin</th>
                            <th>Giá bán</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                <% if (denList.isEmpty()) { %>
                    <tr>
                        <td colspan="6" class="text-center py-5">
                            <i class="fas fa-box-open fa-2x mb-2 text-muted"></i>
                            <p class="mb-0 text-muted">Không có sản phẩm nào trong trang này.</p>
                        </td>
                    </tr>
                <% } else {
                    int stt = startIndex + 1;
                        for (Den den : denList) {
                            String tenLoai = "Chưa phân loại";
                            for (LoaiDen loai : loaiDenList) {
                                if (loai.getMaLoai() == den.getMaLoai()) {
                                    tenLoai = loai.getTenLoai();
                                    break;
                                }
                            }
                            String tenNCC = "Chưa có";
                            if (den.getMaNCC() != null) {
                                for (NhaCungCap ncc : nhaCungCapList) {
                                    if (ncc.getMaNCC() == den.getMaNCC()) {
                                        tenNCC = ncc.getTenNCC();
                                        break;
                                    }
                                }
                            }
                        %>
                        <tr data-category="<%= den.getMaLoai() %>" data-supplier="<%= den.getMaNCC() != null ? den.getMaNCC() : "" %>">
                    <td><%= stt++ %></td>
                            <td>
                                <div class="product-image-container">
                            <% if (den.getHinhAnh() != null && !den.getHinhAnh().trim().isEmpty()) { %>
                                        <img src="../assets/images/product/<%= den.getHinhAnh() %>" 
                                             alt="<%= den.getTenDen() %>" 
                                             class="product-image"
                                     onerror="this.classList.add('d-none'); this.nextElementSibling.classList.remove('d-none');">
                                <div class="no-image d-none"><i class="fas fa-image"></i></div>
                                    <% } else { %>
                                <div class="no-image"><i class="fas fa-image"></i></div>
                                    <% } %>
                                </div>
                            </td>
                            <td>
                                <div class="product-info">
                                    <h4 class="product-name"><%= den.getTenDen() %></h4>
                                    <div class="product-details">
                                <span class="category">
                                    <i class="fas fa-tag"></i>
                                    <%= tenLoai %>
                                </span>
                                <span class="supplier">
                                    <i class="fas fa-industry"></i>
                                    <%= tenNCC %>
                                </span>
                                    </div>
                                    <% if (den.getMoTa() != null && !den.getMoTa().isEmpty()) { %>
                                <p class="product-description"><%= den.getMoTa().length() > 120 ? den.getMoTa().substring(0, 120) + "..." : den.getMoTa() %></p>
                                    <% } %>
                                </div>
                            </td>
                            <td>
                        <div class="price-display"><%= currencyFormat.format(den.getGia()) %> VNĐ</div>
                            </td>
                            <td>
                                <span class="status-badge active">
                                    <i class="fas fa-check-circle"></i>
                                    Đang bán
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                            <button class="btn-action btn-view" onclick="viewProduct(<%= den.getMaDen() %>)" title="Xem chi tiết sản phẩm">
                                        <i class="fas fa-eye"></i>
                                    </button>
                            <button class="btn-action btn-edit" onclick="showEditModal(<%= den.getMaDen() %>)" title="Chỉnh sửa sản phẩm">
                                        <i class="fas fa-edit"></i>
                                    </button>
                            <button class="btn-action btn-delete"
                                    data-id="<%= den.getMaDen() %>"
                                    data-name="<%= den.getTenDen().replace("\"", "&quot;") %>"
                                    onclick="confirmDeleteBtn(this)"
                                    title="Xóa sản phẩm">
                                <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                <%  } } %>
                    </tbody>
                </table>
            </div>
            
            <div class="pagination-container">
            <div class="page-info">
                Hiển thị <%= displayStart %> - <%= displayEnd %> / <%= totalItems %> sản phẩm
            </div>
                <nav class="pagination-nav">
                    <ul class="pagination">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= Math.max(1, currentPage - 1) %>" aria-label="Trang trước">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                    <%
                        int windowSize = 2;
                        int startPage = Math.max(1, currentPage - windowSize);
                        int endPage = Math.min(totalPages, currentPage + windowSize);
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
                        <a class="page-link" href="?page=<%= Math.min(totalPages, currentPage + 1) %>" aria-label="Trang sau">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                    </ul>
                </nav>
                </div>
    </section>
    </div>

<div id="productModal" class="modal-overlay" aria-hidden="true">
    <div class="modal-container" role="dialog" aria-modal="true">
            <div class="modal-header">
                <h3 id="modalTitle">
                    <i class="fas fa-plus-circle"></i>
                    Thêm sản phẩm mới
                </h3>
            <button type="button" class="close-btn" onclick="closeModal()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="productForm" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="tenDen">Tên sản phẩm *</label>
                        <input id="tenDen" name="tenDen" type="text" required>
                        </div>
                        <div class="form-group">
                            <label for="maLoai">Loại đèn *</label>
                            <select id="maLoai" name="maLoai" required>
                            <option value="">-- Chọn loại --</option>
                                <% for (LoaiDen loai : loaiDenList) { %>
                                    <option value="<%= loai.getMaLoai() %>"><%= loai.getTenLoai() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="maNCC">Nhà cung cấp</label>
                            <select id="maNCC" name="maNCC">
                            <option value="">-- Chọn nhà cung cấp --</option>
                                <% for (NhaCungCap ncc : nhaCungCapList) { %>
                                    <option value="<%= ncc.getMaNCC() %>"><%= ncc.getTenNCC() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="gia">Giá bán (VNĐ) *</label>
                        <input id="gia" name="gia" type="number" min="0" step="1000" required>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label for="moTa">Mô tả sản phẩm</label>
                    <textarea id="moTa" name="moTa" rows="4" placeholder="Nhập mô tả ngắn gọn..."></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="hinhAnh">Hình ảnh sản phẩm</label>
                        <div class="file-upload">
                        <input id="hinhAnh" name="hinhAnh" type="file" accept="image/*" onchange="previewImage(this)">
                            <div class="upload-area" onclick="document.getElementById('hinhAnh').click()">
                                <div class="upload-content">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                <p>Kéo thả hoặc nhấp để tải ảnh lên</p>
                                <small>Định dạng JPG/PNG/GIF, tối đa 5MB</small>
                                </div>
                                <div id="imagePreview" class="image-preview"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal()">
                        <i class="fas fa-times"></i>
                        Hủy
                    </button>
                    <button type="submit" class="btn-primary" id="submitBtn">
                        <i class="fas fa-save"></i>
                        Lưu sản phẩm
                    </button>
                </div>
            </form>
        </div>
    </div>

<div id="deleteModal" class="modal-overlay" aria-hidden="true">
    <div class="modal-container small" role="dialog" aria-modal="true">
            <div class="modal-header danger">
                <h3>
                    <i class="fas fa-exclamation-triangle"></i>
                    Xác nhận xóa
                </h3>
            <button type="button" class="close-btn" onclick="closeDeleteModal()" aria-label="Đóng">
                <i class="fas fa-times"></i>
            </button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa sản phẩm <strong id="deleteProductName"></strong> không?</p>
            <p class="warning">Hành động này không thể hoàn tác.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeDeleteModal()">
                    <i class="fas fa-times"></i>
                    Hủy
                </button>
                <button type="button" class="btn-danger" id="confirmDeleteBtn">
                <i class="fas fa-trash-alt"></i>
                    Xóa
                </button>
            </div>
        </div>
    </div>

    <script>
        let currentEditId = null;
        
        function showAddModal() {
        currentEditId = null;
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> Thêm sản phẩm mới';
            document.getElementById('productForm').action = '../them-den';
            document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Thêm sản phẩm';
        document.getElementById('submitBtn').disabled = false;
            document.getElementById('productForm').reset();
            document.getElementById('imagePreview').innerHTML = '';
        removeHiddenInput('maDen');
        removeHiddenInput('oldHinhAnh');
            document.getElementById('productModal').classList.add('show');
        }
        
        function showEditModal(id) {
            currentEditId = id;
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa sản phẩm';
            document.getElementById('productForm').action = '../sua-den';
            document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Cập nhật';
        document.getElementById('submitBtn').disabled = false;

        setHiddenInput('maDen', id);

        fetch('../get-product?id=' + id)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                    alert(data.error);
                        return;
                    }
                    
                    document.getElementById('tenDen').value = data.tenDen || '';
                    document.getElementById('maLoai').value = data.maLoai || '';
                    document.getElementById('maNCC').value = data.maNCC || '';
                    document.getElementById('gia').value = data.gia || '';
                    document.getElementById('moTa').value = data.moTa || '';
                    
                    const preview = document.getElementById('imagePreview');
                    if (data.hinhAnh) {
                    preview.innerHTML = '<img src="../assets/images/product/' + data.hinhAnh + '" alt="Ảnh sản phẩm hiện tại">';
                    setHiddenInput('oldHinhAnh', data.hinhAnh);
                } else {
                    preview.innerHTML = '';
                    removeHiddenInput('oldHinhAnh');
                    }
                    
                    document.getElementById('productModal').classList.add('show');
                })
            .catch(() => {
                alert('Không thể tải thông tin sản phẩm, vui lòng thử lại.');
            });
    }

    function removeHiddenInput(id) {
        const el = document.getElementById(id);
        if (el) {
            el.remove();
        }
    }

    function setHiddenInput(id, value) {
        let input = document.getElementById(id);
        if (!input) {
            input = document.createElement('input');
            input.type = 'hidden';
            input.id = id;
            input.name = id;
            document.getElementById('productForm').appendChild(input);
        }
        input.value = value;
    }
        
        function closeModal() {
            document.getElementById('productModal').classList.remove('show');
            document.getElementById('productForm').reset();
            document.getElementById('imagePreview').innerHTML = '';
            currentEditId = null;
        }
        
        function confirmDeleteBtn(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');
            confirmDelete(id, name);
        }

    function confirmDelete(id, name) {
        document.getElementById('deleteProductName').textContent = name;
        document.getElementById('confirmDeleteBtn').onclick = function () {
            executeDelete(id);
        };
        document.getElementById('deleteModal').classList.add('show');
    }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }
        
        function executeDelete(id) {
        const btn = document.getElementById('confirmDeleteBtn');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xóa...';
        btn.disabled = true;
        window.location.href = '../xoa-den?maDen=' + id;
    }

        function viewProduct(id) {
        window.location.href = '../item-detail?id=' + id;
        }
        
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
            reader.onload = function (e) {
                preview.innerHTML = '<img src="' + e.target.result + '" alt="Preview">';
                };
                reader.readAsDataURL(input.files[0]);
        } else {
            preview.innerHTML = '';
            }
        }
        
        function filterProducts() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const categoryFilter = document.getElementById('categoryFilter').value;
            const supplierFilter = document.getElementById('supplierFilter').value;
            
        let visible = 0;
        document.querySelectorAll('#productsTable tbody tr').forEach(row => {
            const productName = row.querySelector('.product-name') ? row.querySelector('.product-name').textContent.toLowerCase() : '';
            const matchesSearch = productName.includes(searchTerm);
            const matchesCategory = !categoryFilter || row.dataset.category === categoryFilter;
            const matchesSupplier = !supplierFilter || row.dataset.supplier === supplierFilter;
            const show = matchesSearch && matchesCategory && matchesSupplier;
                row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        document.getElementById('productCount').textContent = visible + ' / <%= totalItems %>';
        }
        
        function clearFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('categoryFilter').value = '';
            document.getElementById('supplierFilter').value = '';
        document.querySelectorAll('#productsTable tbody tr').forEach(row => row.style.display = '');
        document.getElementById('productCount').textContent = '<%= totalItems %>';
    }

    document.getElementById('productForm').addEventListener('submit', function () {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    });

    document.addEventListener('DOMContentLoaded', function () {
        const params = new URLSearchParams(window.location.search);
        const error = params.get('error');
            if (error === 'update') {
            alert('Có lỗi xảy ra khi cập nhật sản phẩm. Vui lòng thử lại.');
            } else if (error === '1') {
            alert('Có lỗi xảy ra khi thêm sản phẩm. Vui lòng thử lại.');
            }
            if (error) {
            params.delete('error');
            const query = params.toString();
            const newUrl = window.location.pathname + (query ? ('?' + query) : '');
                window.history.replaceState({}, document.title, newUrl);
            }
        });
        
    document.addEventListener('click', function (event) {
        if (event.target.classList.contains('modal-overlay')) {
            if (event.target.id === 'productModal') {
                closeModal();
            }
            if (event.target.id === 'deleteModal') {
                closeDeleteModal();
            }
            }
        });
    </script>
</body>
</html>

