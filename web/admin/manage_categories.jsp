<%-- Quản lý Danh mục --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User, model.Category, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    User account = (User) session.getAttribute("account");
    if (account == null || (!"admin".equals(account.getRole()) && !"seller".equals(account.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
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
            <c:if test="${not empty toastMsg}">
                <div class="toast-msg ${fn:startsWith(toastMsg, '✅') ? 'success' : 'error'}">${toastMsg}</div>
            </c:if>

            <div class="admin-card">
                <div class="card-header">
                    <h2>Tất cả danh mục (<%= categories != null ? categories.size() : 0 %>)</h2>
                </div>
                <div class="table-wrapper">
                    <c:choose>
                        <c:when test="${empty categories}">
                            <div class="empty-state">
                                <div class="empty-icon">🏷️</div>
                                <p>Chưa có danh mục nào</p>
                                <button class="btn btn-primary" onclick="openAddModal()">➕ Thêm ngay</button>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <table class="admin-table">
                                <thead>
                                <tr>
                                    <th>#ID</th>
                                    <th>Ảnh</th>
                                    <th>Tên danh mục</th>
                                    <th>Danh mục cha</th>
                                    <th class="col-actions">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${categories}" var="c">
                                    <tr>
                                        <td><strong>#${c.categoryId}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty c.imageUrl}">
                                                    <img src="${fn:startsWith(c.imageUrl, 'http') ? c.imageUrl : pageContext.request.contextPath.concat('/').concat(c.imageUrl)}" style="width:40px;height:40px;object-fit:cover;border-radius:4px;" alt="Img">
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="width:40px;height:40px;background:#eee;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:16px;">📷</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${not empty c.parentId}">
                                                <span style="color:var(--text-muted);margin-right:4px;">↳</span>
                                            </c:if>
                                            <strong>${c.name}</strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty c.parentName}">
                                                    ${c.parentName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style='color:var(--text-muted)'>Gốc</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-actions">
                                            <div class="action-btns">
                                                
                                                <button class="btn btn-warning btn-sm"
                                                        data-id="${c.categoryId}"
                                                        data-name="${fn:escapeXml(c.name)}"
                                                        data-img="${fn:escapeXml(c.imageUrl)}"
                                                        data-parent="${not empty c.parentId ? c.parentId : ''}"
                                                        onclick="openEditModal(this.getAttribute('data-id'), this.getAttribute('data-name'), this.getAttribute('data-img'), this.getAttribute('data-parent'))">
                                                    ✏️ Sửa
                                                </button>

                                                <form action="${pageContext.request.contextPath}/admin/categories" method="post"
                                                      onsubmit="return confirm('Xóa danh mục này?\nLưu ý: Không thể xóa nếu đang có sản phẩm.')" style="display:inline-block;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="categoryId" value="${c.categoryId}">
                                                    <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </main>
</div>

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
                            <option value="<%= r.getCategoryId() %>"><%= r.getName() %></option>
                            <% } %>
                        </select>
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
                            <option value="<%= r.getCategoryId() %>"><%= r.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>URL hình ảnh</label>
                        <input type="text" name="imageUrl" id="editImageUrl" class="form-control" placeholder="https://...">
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
function openEditModal(id, name, imageUrl, parentId) {
    document.getElementById('editCatId').value = id;
    document.getElementById('editCatName').value = name;
    document.getElementById('editImageUrl').value = imageUrl;
    const sel = document.getElementById('editCatParent');
    sel.value = parentId ? parentId : '';
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