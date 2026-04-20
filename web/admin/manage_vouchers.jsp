<%-- Quản lý Mã giảm giá (Voucher) --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Users, model.Vouchers, java.util.List" %>
<%
    Users loggedUser = (Users) session.getAttribute("loggedUser");
    if (loggedUser == null || (!"admin".equals(loggedUser.getRole()) && !"seller".equals(loggedUser.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    boolean isAdmin   = "admin".equals(loggedUser.getRole());
    String action     = (String) request.getAttribute("action");
    if (action == null) action = "list";

    List<Vouchers> vouchers    = (List<Vouchers>) request.getAttribute("vouchers");
    Vouchers       editVoucher = (Vouchers)       request.getAttribute("editVoucher");

    String toastMsg = (String) session.getAttribute("msg");
    if (toastMsg != null) session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Quản lý Voucher – ShopAdmin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <%@ include file="_sidebar.jsp" %>
    <main class="admin-main">
        <header class="admin-header">
            <h1 class="page-title">🎟️ Quản lý Mã giảm giá</h1>
            <button class="btn btn-primary" onclick="openModal('addModal')">➕ Tạo mã</button>
        </header>

        <div class="admin-content">
            <% if (toastMsg != null) { %>
            <div class="toast-msg <%= toastMsg.startsWith("✅") ? "success" : "error" %>"><%= toastMsg %></div>
            <% } %>

            <div class="admin-card">
                <div class="card-header">
                    <h2>Danh sách mã giảm giá <%= isAdmin ? "(Toàn sàn)" : "(Shop của tôi)" %></h2>
                </div>
                <div class="table-wrapper">
                    <% if (vouchers == null || vouchers.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon">🎟️</div>
                        <p>Chưa có mã giảm giá nào</p>
                        <button class="btn btn-primary" onclick="openModal('addModal')">➕ Tạo ngay</button>
                    </div>
                    <% } else { %>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>Mã</th>
                            <% if (isAdmin) { %><th>Shop</th><% } %>
                            <th>Loại</th>
                            <th>Mức giảm</th>
                            <th>Max giảm</th>
                            <th>ĐH tối thiểu</th>
                            <th>Đã dùng / Giới hạn</th>
                            <th>Hiệu lực</th>
                            <th>Trạng thái</th>
                            <th class="col-actions">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Vouchers v : vouchers) { %>
                        <tr>
                            <td><strong style="letter-spacing:.5px; font-family:monospace; font-size:13px;"><%= v.getCode() %></strong></td>
                            <% if (isAdmin) { %><td><%= v.getShopName() != null ? v.getShopName() : "<span class='badge badge-admin'>Toàn sàn</span>" %></td><% } %>
                            <td>
                                <span class="badge <%= "percentage".equals(v.getDiscountType()) ? "badge-percentage" : "badge-fixed" %>">
                                    <%= "percentage".equals(v.getDiscountType()) ? "% Phần trăm" : "Số tiền cố định" %>
                                </span>
                            </td>
                            <td>
                                <strong><%= v.getDiscountValue() != null ? 
                                    ("percentage".equals(v.getDiscountType()) ? v.getDiscountValue()+"%"
                                    : String.format("%,.0f",v.getDiscountValue())+"đ") : "—" %></strong>
                            </td>
                            <td><%= v.getMaxDiscountValue() != null ? String.format("%,.0f",v.getMaxDiscountValue())+"đ" : "—" %></td>
                            <td><%= v.getMinOrderValue() != null ? String.format("%,.0f",v.getMinOrderValue())+"đ" : "0đ" %></td>
                            <td>
                                <span style="font-weight:600;"><%= v.getUsedCount() %></span>
                                / <%= v.getUsageLimit() == 0 ? "∞" : v.getUsageLimit() %>
                            </td>
                            <td style="font-size:12px; color:var(--text-secondary);">
                                <%= v.getStartDate() != null ? v.getStartDate().toString() : "—" %><br>
                                → <%= v.getEndDate() != null ? v.getEndDate().toString() : "—" %>
                            </td>
                            <td>
                                <span class="badge <%= v.isActive() ? "badge-active" : "badge-inactive" %>">
                                    <%= v.isActive() ? "Hoạt động" : "Tạm dừng" %>
                                </span>
                            </td>
                            <td class="col-actions">
                                <div class="action-btns">
                                    <button class="btn btn-warning btn-sm"
                                            onclick='openEditModal(<%= v.getVoucherId() %>,
                                                "<%= v.getCode() %>",
                                                "<%= v.getDiscountType() %>",
                                                "<%= v.getDiscountValue() %>",
                                                "<%= v.getMaxDiscountValue() != null ? v.getMaxDiscountValue() : "" %>",
                                                "<%= v.getMinOrderValue() != null ? v.getMinOrderValue() : "" %>",
                                                "<%= v.getUsageLimit() %>",
                                                "<%= v.getStartDate() != null ? v.getStartDate().toString() : "" %>",
                                                "<%= v.getEndDate() != null ? v.getEndDate().toString() : "" %>",
                                                <%= v.isActive() %>)'>
                                        ✏️
                                    </button>
                                    <form action="<%= request.getContextPath() %>/admin/vouchers" method="post"
                                          onsubmit="return confirm('Xóa mã «<%= v.getCode() %>»?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="voucherId" value="<%= v.getVoucherId() %>">
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

<!-- Modal Tạo voucher -->
<div class="modal-overlay" id="addModal">
    <div class="modal-box modal-lg">
        <div class="modal-header">
            <h3>➕ Tạo mã giảm giá mới</h3>
            <button class="modal-close" onclick="closeModal('addModal')">✕</button>
        </div>
        <form action="<%= request.getContextPath() %>/admin/vouchers" method="post">
            <input type="hidden" name="action" value="insert">
            <div class="modal-body">
                <div class="form-grid" style="gap:14px;">
                    <div class="form-group">
                        <label>Mã giảm giá <span class="req">*</span></label>
                        <input type="text" name="code" class="form-control" placeholder="VD: SALE20" required
                               style="font-family:monospace; letter-spacing:1px; text-transform:uppercase;">
                    </div>
                    <div class="form-group">
                        <label>Loại giảm giá <span class="req">*</span></label>
                        <select name="discountType" class="form-control" id="addDiscountType" onchange="toggleMaxDiscount('add')">
                            <option value="percentage">Phần trăm (%)</option>
                            <option value="fixed">Số tiền cố định (đ)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mức giảm <span class="req">*</span></label>
                        <input type="number" name="discountValue" class="form-control" min="0" step="0.01" required>
                    </div>
                    <div class="form-group" id="addMaxBlock">
                        <label>Giảm tối đa (đ)</label>
                        <input type="number" name="maxDiscountValue" class="form-control" min="0">
                    </div>
                    <div class="form-group">
                        <label>Đơn hàng tối thiểu (đ)</label>
                        <input type="number" name="minOrderValue" class="form-control" min="0" value="0">
                    </div>
                    <div class="form-group">
                        <label>Giới hạn lượt dùng (0 = không giới hạn)</label>
                        <input type="number" name="usageLimit" class="form-control" min="0" value="0">
                    </div>
                    <div class="form-group">
                        <label>Ngày bắt đầu <span class="req">*</span></label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Ngày kết thúc <span class="req">*</span></label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>
                    <div class="form-group span-2">
                        <label class="form-check">
                            <input type="checkbox" name="isActive" value="true" checked>
                            Kích hoạt ngay
                        </label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost" onclick="closeModal('addModal')">Hủy</button>
                <button type="submit" class="btn btn-primary">🎟 Tạo mã</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Sửa voucher -->
<div class="modal-overlay" id="editModal">
    <div class="modal-box modal-lg">
        <div class="modal-header">
            <h3>✏️ Chỉnh sửa mã giảm giá</h3>
            <button class="modal-close" onclick="closeModal('editModal')">✕</button>
        </div>
        <form action="<%= request.getContextPath() %>/admin/vouchers" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="voucherId" id="editVoucherId">
            <div class="modal-body">
                <div class="form-grid" style="gap:14px;">
                    <div class="form-group">
                        <label>Mã giảm giá <span class="req">*</span></label>
                        <input type="text" name="code" id="editCode" class="form-control" required
                               style="font-family:monospace; letter-spacing:1px; text-transform:uppercase;">
                    </div>
                    <div class="form-group">
                        <label>Loại giảm giá</label>
                        <select name="discountType" id="editDiscountType" class="form-control" onchange="toggleMaxDiscount('edit')">
                            <option value="percentage">Phần trăm (%)</option>
                            <option value="fixed">Số tiền cố định (đ)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mức giảm <span class="req">*</span></label>
                        <input type="number" name="discountValue" id="editDiscountValue" class="form-control" required>
                    </div>
                    <div class="form-group" id="editMaxBlock">
                        <label>Giảm tối đa (đ)</label>
                        <input type="number" name="maxDiscountValue" id="editMaxDiscount" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>Đơn hàng tối thiểu (đ)</label>
                        <input type="number" name="minOrderValue" id="editMinOrder" class="form-control" value="0">
                    </div>
                    <div class="form-group">
                        <label>Giới hạn lượt dùng</label>
                        <input type="number" name="usageLimit" id="editUsageLimit" class="form-control" value="0">
                    </div>
                    <div class="form-group">
                        <label>Ngày bắt đầu <span class="req">*</span></label>
                        <input type="date" name="startDate" id="editStartDate" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Ngày kết thúc <span class="req">*</span></label>
                        <input type="date" name="endDate" id="editEndDate" class="form-control" required>
                    </div>
                    <div class="form-group span-2">
                        <label class="form-check">
                            <input type="checkbox" name="isActive" id="editIsActive" value="true">
                            Đang kích hoạt
                        </label>
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
function openModal(id)  { document.getElementById(id).classList.add('show'); }
function closeModal(id) { document.getElementById(id).classList.remove('show'); }

function toggleMaxDiscount(prefix) {
    const sel   = document.getElementById(prefix + 'DiscountType');
    const block = document.getElementById(prefix + 'MaxBlock');
    if (sel && block) block.style.display = sel.value === 'percentage' ? 'flex' : 'none';
}

function openEditModal(id, code, dtype, dval, maxdisc, minorder, limit, sdate, edate, active) {
    document.getElementById('editVoucherId').value     = id;
    document.getElementById('editCode').value          = code;
    document.getElementById('editDiscountType').value  = dtype;
    document.getElementById('editDiscountValue').value = dval;
    document.getElementById('editMaxDiscount').value   = maxdisc;
    document.getElementById('editMinOrder').value      = minorder;
    document.getElementById('editUsageLimit').value    = limit;
    document.getElementById('editStartDate').value     = sdate;
    document.getElementById('editEndDate').value       = edate;
    document.getElementById('editIsActive').checked    = active;
    toggleMaxDiscount('edit');
    openModal('editModal');
}

document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', e => { if (e.target === m) m.classList.remove('show'); });
});

// Init
toggleMaxDiscount('add');

setTimeout(() => {
    const t = document.querySelector('.toast-msg');
    if (t) { t.style.opacity='0'; setTimeout(()=>t.remove(),400); }
}, 4000);
</script>
</body>
</html>
