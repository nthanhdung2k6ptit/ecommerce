<%-- Quản lý Sản phẩm --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User, model.Product, model.Category, java.util.List" %>
<%
    User account = (User) session.getAttribute("account");
    if (account == null || (!"admin".equals(account.getRole()) && !"seller".equals(account.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    boolean isAdmin = "admin".equals(account.getRole());
    String action   = (String) request.getAttribute("action");
    if (action == null) action = "list";

    List<Product>   products   = (List<Product>)   request.getAttribute("products");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    Product editProduct = (Product) request.getAttribute("product");

    String keyword  = (String) request.getAttribute("keyword");

    String toastMsg = (String) session.getAttribute("msg");
    if (toastMsg != null) session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Quản lý Sản phẩm – ShopAdmin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <%@ include file="_sidebar.jsp" %>
    <main class="admin-main">

        <!-- Header -->
        <header class="admin-header">
            <h1 class="page-title">📦 Quản lý Sản phẩm</h1>
            <div class="header-actions">
                <a href="<%= request.getContextPath() %>/admin/products?action=add" class="btn btn-primary">
                    ➕ Thêm sản phẩm
                </a>
            </div>
        </header>

        <div class="admin-content">

            <!-- Toast -->
            <% if (toastMsg != null) { %>
            <div class="toast-msg <%= toastMsg.startsWith("✅") ? "success" : "error" %>"><%= toastMsg %></div>
            <% } %>

            <% if ("add".equals(action) || "edit".equals(action)) { %>
            <!-- ===== FORM THÊM/SỬA ===== -->
            <div class="admin-card">
                <div class="card-header">
                    <h2><%= "add".equals(action) ? "➕ Thêm sản phẩm mới" : "✏️ Chỉnh sửa sản phẩm" %></h2>
                    <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-ghost btn-sm">← Quay lại</a>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/products" method="post">
                        <input type="hidden" name="action" value="<%= "add".equals(action) ? "insert" : "update" %>">
                        <% if ("edit".equals(action) && editProduct != null) { %>
                        <input type="hidden" name="productId" value="<%= editProduct.getProductId() %>">
                        <% } %>

                        <div class="form-grid">
                            <div class="form-group span-2">
                                <label>Tên sản phẩm <span class="req">*</span></label>
                                <input type="text" name="productName" class="form-control"
                                       value="<%= editProduct != null ? editProduct.getProductName() : "" %>"
                                       placeholder="Nhập tên sản phẩm..." required>
                            </div>

                            <div class="form-group">
                                <label>Danh mục <span class="req">*</span></label>
                                <select name="categoryId" class="form-control" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <% if (categories != null) for (Category c : categories) { %>
                                    <option value="<%= c.getCategoryId() %>"
                                        <%= (editProduct != null && editProduct.getCategoryId() == c.getCategoryId()) ? "selected" : "" %>>
                                        <%= c.getCategoryName() %>
                                    </option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Giá niêm yết (đ) <span class="req">*</span></label>
                                <input type="number" name="basePrice" class="form-control" min="0" step="1000"
                                       value="<%= editProduct != null ? editProduct.getBasePrice() : "" %>"
                                       placeholder="VD: 250000" required>
                            </div>

                            <div class="form-group">
                                <label>Số lượng tồn kho <span class="req">*</span></label>
                                <input type="number" name="stockQuantity" class="form-control" min="0"
                                       value="<%= editProduct != null ? editProduct.getStockQuantity() : "0" %>" required>
                            </div>

                            <div class="form-group">
                                <label>URL hình ảnh</label>
                                <input type="text" name="imageUrl" class="form-control"
                                       value="<%= editProduct != null && editProduct.getImageUrl() != null ? editProduct.getImageUrl() : "" %>"
                                       placeholder="https://...">
                            </div>

                            <div class="form-group span-2">
                                <label>Mô tả sản phẩm</label>
                                <textarea name="description" class="form-control" rows="4"
                                          placeholder="Mô tả chi tiết sản phẩm..."><%= editProduct != null && editProduct.getDescription() != null ? editProduct.getDescription() : "" %></textarea>
                            </div>

                            <div class="form-group">
                                <label class="form-check">
                                    <input type="checkbox" name="isActive" value="true"
                                        <%= (editProduct == null || editProduct.isActive()) ? "checked" : "" %>>
                                    Đang bán (hiện thị trên cửa hàng)
                                </label>
                            </div>
                        </div>

                        <div style="margin-top:22px; display:flex; gap:10px;">
                            <button type="submit" class="btn btn-primary">
                                <%= "add".equals(action) ? "➕ Thêm sản phẩm" : "💾 Lưu thay đổi" %>
                            </button>
                            <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-ghost">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>

            <% } else { %>
            <!-- ===== DANH SÁCH ===== -->
            <div class="admin-card">
                <div class="card-header">
                    <h2>Danh sách sản phẩm <%= isAdmin ? "(Toàn sàn)" : "(Shop của tôi)" %></h2>
                    <form action="<%= request.getContextPath() %>/admin/products" method="get" class="filter-bar">
                        <input type="hidden" name="action" value="list">
                        <div class="search-input">
                            <span class="search-icon">🔍</span>
                            <input type="text" name="keyword" placeholder="Tìm sản phẩm..."
                                   value="<%= keyword != null ? keyword : "" %>">
                        </div>
                        <button type="submit" class="btn btn-outline btn-sm">Tìm</button>
                        <% if (keyword != null) { %>
                        <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-ghost btn-sm">Xóa lọc</a>
                        <% } %>
                    </form>
                </div>

                <div class="table-wrapper">
                    <% if (products == null || products.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon">📦</div>
                        <p>Chưa có sản phẩm nào</p>
                        <a href="<%= request.getContextPath() %>/admin/products?action=add" class="btn btn-primary">➕ Thêm ngay</a>
                    </div>
                    <% } else { %>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Danh mục</th>
                            <% if (isAdmin) { %><th>Shop</th><% } %>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Trạng thái</th>
                            <th class="col-actions">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Product p : products) { %>
                        <tr>
                            <td><%= p.getProductId() %></td>
                            <td>
                                <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                                <img src="<%= p.getImageUrl() %>" class="product-thumb" alt="">
                                <% } else { %>
                                <div class="product-thumb-placeholder">📷</div>
                                <% } %>
                            </td>
                            <td>
                                <strong><%= p.getProductName() %></strong>
                                <% if (p.getDescription() != null && p.getDescription().length() > 0) { %>
                                <div style="color:var(--text-muted);font-size:12px;margin-top:2px;">
                                    <%= p.getDescription().length() > 60 ? p.getDescription().substring(0,60) + "..." : p.getDescription() %>
                                </div>
                                <% } %>
                            </td>
                            <td><%= p.getCategoryName() != null ? p.getCategoryName() : "—" %></td>
                            <% if (isAdmin) { %><td><%= p.getShopName() != null ? p.getShopName() : "—" %></td><% } %>
                            <td><strong><%= String.format("%,.0f", p.getBasePrice()) %>đ</strong></td>
                            <td>
                                <span style="font-weight:600; color:<%= p.getStockQuantity() < 10 ? "var(--danger)" : "var(--text-primary)" %>">
                                    <%= p.getStockQuantity() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge <%= p.isActive() ? "badge-active" : "badge-inactive" %>">
                                    <%= p.isActive() ? "Đang bán" : "Ẩn" %>
                                </span>
                            </td>
                            <td class="col-actions">
                                <div class="action-btns">
                                    <!-- Sửa tồn kho nhanh -->
                                    <button class="btn btn-ghost btn-sm" title="Cập nhật tồn kho"
                                            onclick="openStockModal(<%= p.getProductId() %>, <%= p.getStockQuantity() %>, '<%= p.getProductName().replace("'", "\\'") %>')">
                                        📊
                                    </button>
                                    <a href="<%= request.getContextPath() %>/admin/products?action=edit&id=<%= p.getProductId() %>"
                                       class="btn btn-warning btn-sm">✏️</a>
                                    <form action="<%= request.getContextPath() %>/admin/products" method="post"
                                          onsubmit="return confirm('Xóa sản phẩm «<%= p.getProductName().replace("'", "\\'") %>»?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                    <% } %>
                </div>
            </div>
            <% } %>

        </div><!-- /admin-content -->
    </main>
</div>

<!-- Modal Cập nhật tồn kho -->
<div class="modal-overlay" id="stockModal">
    <div class="modal-box modal-sm">
        <div class="modal-header">
            <h3>📊 Cập nhật tồn kho</h3>
            <button class="modal-close" onclick="closeStockModal()">✕</button>
        </div>
        <div class="modal-body">
            <p id="stockProductName" style="color:var(--text-secondary);margin-bottom:14px;"></p>
            <form action="<%= request.getContextPath() %>/admin/products" method="post" id="stockForm">
                <input type="hidden" name="action" value="updateStock">
                <input type="hidden" name="productId" id="stockProductId">
                <div class="form-group">
                    <label>Số lượng tồn kho mới <span class="req">*</span></label>
                    <input type="number" name="quantity" id="stockQuantity" class="form-control" min="0" required>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn btn-ghost" onclick="closeStockModal()">Hủy</button>
            <button class="btn btn-primary" onclick="document.getElementById('stockForm').submit()">💾 Lưu</button>
        </div>
    </div>
</div>

<script>
function openStockModal(id, qty, name) {
    document.getElementById('stockProductId').value = id;
    document.getElementById('stockQuantity').value = qty;
    document.getElementById('stockProductName').textContent = '📦 ' + name;
    document.getElementById('stockModal').classList.add('show');
}
function closeStockModal() {
    document.getElementById('stockModal').classList.remove('show');
}
document.getElementById('stockModal').addEventListener('click', function(e) {
    if (e.target === this) closeStockModal();
});
setTimeout(() => {
    const t = document.querySelector('.toast-msg');
    if (t) t.style.opacity = '0', setTimeout(() => t.remove(), 400);
}, 4000);
</script>
</body>
</html>
