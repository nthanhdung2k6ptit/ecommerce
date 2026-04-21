<%-- Quản lý Tài khoản & Gian hàng (chỉ Admin) --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Users, model.Sellers, java.util.List" %>
<%
    Users loggedUser = (Users) session.getAttribute("loggedUser");
    if (loggedUser == null || !"admin".equals(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    String tab    = (String) request.getAttribute("tab");
    if (tab == null) tab = "users";

    List<Users>   users   = (List<Users>)   request.getAttribute("users");
    List<Sellers> sellers = (List<Sellers>) request.getAttribute("sellers");

    String toastMsg = (String) session.getAttribute("msg");
    if (toastMsg != null) session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Quản lý Tài khoản – ShopAdmin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <%@ include file="_sidebar.jsp" %>
    <main class="admin-main">
        <header class="admin-header">
            <h1 class="page-title">👥 Quản lý Tài khoản & Gian hàng</h1>
        </header>

        <div class="admin-content">
            <% if (toastMsg != null) { %>
            <div class="toast-msg <%= toastMsg.startsWith("✅") ? "success" : (toastMsg.startsWith("⚠️") ? "info" : "error") %>"><%= toastMsg %></div>
            <% } %>

            <!-- Tab buttons -->
            <div class="tab-bar">
                <a href="<%= request.getContextPath() %>/admin/users?action=users"
                   class="tab-btn <%= "users".equals(tab) ? "active" : "" %>">👤 Tài khoản</a>
                <a href="<%= request.getContextPath() %>/admin/users?action=sellers"
                   class="tab-btn <%= "sellers".equals(tab) ? "active" : "" %>">🏪 Gian hàng (Shop)</a>
            </div>

            <% if ("users".equals(tab)) { %>
            <!-- ===== TAB USERS ===== -->
            <div class="admin-card">
                <div class="card-header">
                    <h2>Tất cả tài khoản (<%= users != null ? users.size() : 0 %>)</h2>
                </div>
                <div class="table-wrapper">
                    <% if (users == null || users.isEmpty()) { %>
                    <div class="empty-state"><div class="empty-icon">👤</div><p>Chưa có tài khoản</p></div>
                    <% } else { %>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>#</th><th>Họ tên</th><th>Email</th><th>Điện thoại</th>
                            <th>Vai trò</th><th>Trạng thái</th><th>Ngày tạo</th>
                            <th class="col-actions">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Users u : users) { %>
                        <tr>
                            <td><%= u.getUserId() %></td>
                            <td><strong><%= u.getFullName() %></strong></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
                            <td>
                                <span class="badge badge-<%= u.getRole() %>">
                                    <%= "admin".equals(u.getRole()) ? "🛡 Admin"
                                      : "seller".equals(u.getRole()) ? "🏪 Seller"
                                      : "👤 Customer" %>
                                </span>
                            </td>
                            <td>
                                <span class="badge badge-active">
                                    Hoạt động
                                </span>
                            </td>
                            <td><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0,10) : "—" %></td>
                            <td class="col-actions">
                                <% if (!String.valueOf(u.getUserId()).equals(String.valueOf(loggedUser.getUserId()))) { %>
                                <div class="action-btns">
                                    <!-- Phân quyền nhanh -->
                                    <button class="btn btn-outline btn-sm"
                                            onclick='openRoleModal(<%= u.getUserId() %>, "<%= u.getFullName().replace("\"","\\\"") %>", "<%= u.getRole() %>")'>
                                        🎭 Quyền
                                    </button>
                                    <!-- Khóa tài khoản đã bị vô hiệu hóa vì không có cột này trong DB thiết kế mới -->
                                </div>
                                <% } else { %>
                                <span style="color:var(--text-muted); font-size:12px;">(Bạn)</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                    <% } %>
                </div>
            </div>

            <% } else { %>
            <!-- ===== TAB SELLERS ===== -->
            <div class="admin-card">
                <div class="card-header">
                    <h2>Tất cả gian hàng (<%= sellers != null ? sellers.size() : 0 %>)</h2>
                </div>
                <div class="table-wrapper">
                    <% if (sellers == null || sellers.isEmpty()) { %>
                    <div class="empty-state"><div class="empty-icon">🏪</div><p>Chưa có gian hàng</p></div>
                    <% } else { %>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>#</th><th>Tên shop</th><th>Chủ shop</th><th>Email chủ</th>
                            <th>Trạng thái</th><th>Ngày đăng ký</th>
                            <th class="col-actions">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Sellers s : sellers) { %>
                        <tr>
                            <td><%= s.getSellerId() %></td>
                            <td>
                                <div style="display:flex;align-items:center;gap:8px;">
                                    <div style="width:32px;height:32px;border-radius:8px;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-size:16px;">🏪</div>
                                    <strong><%= s.getShopName() %></strong>
                                </div>
                                <% if (s.getShopDescription() != null && !s.getShopDescription().isEmpty()) { %>
                                <div style="color:var(--text-muted);font-size:12px;margin-top:2px;margin-left:40px;">
                                    <%= s.getShopDescription().length() > 60 ? s.getShopDescription().substring(0,60)+"..." : s.getShopDescription() %>
                                </div>
                                <% } %>
                            </td>
                            <td><%= s.getOwnerFullName() != null ? s.getOwnerFullName() : "—" %></td>
                            <td><%= s.getOwnerEmail() != null ? s.getOwnerEmail() : "—" %></td>
                            <td>
                                <span class="badge badge-approved">
                                    ✅ Đã duyệt
                                </span>
                            </td>
                            <td><%= s.getCreatedAt() != null ? s.getCreatedAt().toString().substring(0,10) : "—" %></td>
                            <td class="col-actions">
                                <div class="action-btns">
                                    <!-- Không có cột duyệt shop trong DB hiện tại -->
                                    <!-- Xóa shop vi phạm -->
                                    <form action="<%= request.getContextPath() %>/admin/users" method="post"
                                          onsubmit="return confirm('⚠️ XÓA SHOP «<%= s.getShopName().replace("'","\\'") %>»?\n\nHành động này sẽ:\n• Xóa toàn bộ dữ liệu shop\n• Hạ quyền chủ shop về Customer\n\nXác nhận?')">
                                        <input type="hidden" name="action" value="deleteSeller">
                                        <input type="hidden" name="sellerId" value="<%= s.getSellerId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm">🗑 Xóa shop</button>
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

        </div>
    </main>
</div>

<!-- Modal Phân quyền -->
<div class="modal-overlay" id="roleModal">
    <div class="modal-box modal-sm">
        <div class="modal-header">
            <h3>🎭 Phân quyền tài khoản</h3>
            <button class="modal-close" onclick="closeModal('roleModal')">✕</button>
        </div>
        <form action="<%= request.getContextPath() %>/admin/users" method="post">
            <input type="hidden" name="action" value="updateRole">
            <input type="hidden" name="userId" id="roleUserId">
            <div class="modal-body">
                <p id="roleUserName" style="margin-bottom:14px; color:var(--text-secondary); font-weight:600;"></p>
                <div class="form-group">
                    <label>Vai trò mới <span class="req">*</span></label>
                    <select name="role" id="roleSelect" class="form-control">
                        <option value="customer">👤 Customer (Khách hàng)</option>
                        <option value="seller">🏪 Seller (Chủ Shop)</option>
                        <option value="admin">🛡 Admin (Quản trị viên)</option>
                    </select>
                </div>
                <div style="margin-top:14px; padding:12px; background:#fef9c3; border-radius:8px; font-size:12.5px; color:#92400e;">
                    ⚠️ Lưu ý: Đổi role sang Seller yêu cầu tạo shop riêng. Đổi sang Admin cấp toàn quyền hệ thống.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost" onclick="closeModal('roleModal')">Hủy</button>
                <button type="submit" class="btn btn-primary">✅ Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<script>
function openRoleModal(id, name, role) {
    document.getElementById('roleUserId').value = id;
    document.getElementById('roleUserName').textContent = '👤 ' + name;
    document.getElementById('roleSelect').value = role;
    document.getElementById('roleModal').classList.add('show');
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
