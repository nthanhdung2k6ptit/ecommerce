<%-- Quản lý Danh mục --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User, model.Category, java.util.List" %>
<%
    User account = (User) session.getAttribute("account");
    if (account == null || (!"admin".equals(account.getRole()) && !"seller".equals(account.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    String action = (String) request.getAttribute("action");
    if (action == null) action = "list";

    List<Category> categories     = (List<Category>) request.getAttribute("categories");
    List<Category> rootCategory = (List<Category>) request.getAttribute("rootCategory");
    Category editCategory = (Category) request.getAttribute("editCategory");

    String toastMsg = (String) session.getAttribute("msg");
    if (toastMsg != null) session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Quản lý Danh mục – ShopAdmin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <%@ include file="_sidebar.jsp" %>
    <main class="admin-main">
        <header class="admin-header">
            <h1 class="page-title">🏷️ Quản lý Danh mục</h1>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="openAddModal()">➕ Thêm danh mục</button>
            </div>
        </header>

        <div class="admin-content">
            <% if (toastMsg != null) { %>
            <div class="toast-msg <%= toastMsg.startsWith("✅") ? "success" : "error" %>"><%= toastMsg %></div>
            <% } %>

            <div class="admin-card">
                <div class="card-header">
                    <h2>Tất cả danh mục (<%= categories != null ? categories.size() : 0 %>)</h2>
                </div>
                <div class="table-wrapper">
                    <% if (categories == null || categories.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon">🏷️</div>
                        <p>Chưa có danh mục nào</p>
                        <button class="btn btn-primary" onclick="openAddModal()">➕ Thêm ngay</button>
                    </div>
                    <% } else { %>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Tên danh mục</th>
                            <th>Danh mục cha</th>
                            <th>Mô tả</th>
                            <th class="col-actions">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Category c : categories) { %>
                        <tr>
                            <td><%= c.getCategoryId() %></td>
                            <td>
                                <% if (c.getParentCategoryId() != null) { %>
                                <span style="color:var(--text-muted);margin-right:4px;">↳</span>
                                <% } %>
                                <strong><%= c.getCategoryName() %></strong>
                            </td>
                            <td><%= c.getParentCategoryName() != null ? c.getParentCategoryName() : "<span style='color:var(--text-muted)'>Gốc</span>" %></td>
                            <td style="max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                                —
                            </td>
                            <td class="col-actions">
                                <div class="action-btns">
                                    <button class="btn btn-warning btn-sm"
                                            onclick='openEditModal(<%= c.getCategoryId() %>, "<%= c.getCategoryName().replace("\"","\\\"") %>", "", <%= c.getParentCategoryId() != null ? c.getParentCategoryId() : "null" %>)'>
                                        ✏️ Sửa
                                    </button>
                                    <form action="<%= request.getContextPath() %>/admin/categories" method="post"
                                          onsubmit="return confirm('Xóa danh mục này?\nLưu ý: Không thể xóa nếu đang có sản phẩm.')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="categoryId" value="<%= c.getCategoryId() %>">
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

        </div>
    </main>
</div>

<!-- Modal Thêm danh mục -->
<div class="modal-overlay" id="addModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3>➕ Thêm danh mục mới</h3>
            <button class="modal-close" onclick="closeModal('addModal')">✕</button>
        </div>
        <form action="<%= request.getContextPath() %>/admin/categories" method="post">
            <input type="hidden" name="action" value="insert">
            <div class="modal-body">
                <div class="form-grid cols-1" style="gap:14px;">
                    <div class="form-group">
                        <label>Tên danh mục <span class="req">*</span></label>
                        <input type="text" name="categoryName" class="form-control" placeholder="VD: Điện thoại" required>
                    </div>
                    <div class="form-group">
                        <label>Danh mục cha</label>
                        <select name="parentCategoryId" class="form-control">
                            <option value="">-- Là danh mục gốc --</option>
                            <% if (rootCategory != null) for (Category r : rootCategory) { %>
                            <option value="<%= r.getCategoryId() %>"><%= r.getCategoryName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mô tả</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Mô tả danh mục..."></textarea>
                    </div>
                    <div class="form-group">
                        <label>URL hình ảnh</label>
                        <input type="text" name="imageUrl" class="form-control" placeholder="https://...">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost" onclick="closeModal('addModal')">Hủy</button>
                <button type="submit" class="btn btn-primary">➕ Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Sửa danh mục -->
<div class="modal-overlay" id="editModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3>✏️ Chỉnh sửa danh mục</h3>
            <button class="modal-close" onclick="closeModal('editModal')">✕</button>
        </div>
        <form action="<%= request.getContextPath() %>/admin/categories" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="categoryId" id="editCatId">
            <div class="modal-body">
                <div class="form-grid cols-1" style="gap:14px;">
                    <div class="form-group">
                        <label>Tên danh mục <span class="req">*</span></label>
                        <input type="text" name="categoryName" id="editCatName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Danh mục cha</label>
                        <select name="parentCategoryId" id="editCatParent" class="form-control">
                            <option value="">-- Là danh mục gốc --</option>
                            <% if (rootCategory != null) for (Category r : rootCategory) { %>
                            <option value="<%= r.getCategoryId() %>"><%= r.getCategoryName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mô tả</label>
                        <textarea name="description" id="editCatDesc" class="form-control" rows="3"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost" onclick="closeModal('editModal')">Hủy</button>
                <button type="submit" class="btn btn-primary">💾 Lưu</button>
            </div>
        </form>
    </div>
</div>

<script>
function openAddModal() { document.getElementById('addModal').classList.add('show'); }
function openEditModal(id, name, desc, parentId) {
    document.getElementById('editCatId').value = id;
    document.getElementById('editCatName').value = name;
    document.getElementById('editCatDesc').value = desc;
    const sel = document.getElementById('editCatParent');
    sel.value = parentId != null ? parentId : '';
    document.getElementById('editModal').classList.add('show');
}
function closeModal(id) { document.getElementById(id).classList.remove('show'); }
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', e => { if (e.target === m) m.classList.remove('show'); });
});
setTimeout(() => {
    const t = document.querySelector('.toast-msg');
    if (t) { t.style.opacity='0'; setTimeout(()=>t.remove(),400); }
}, 4000);
</script>
</body>
</html>
