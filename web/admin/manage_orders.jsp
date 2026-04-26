<%-- Quản lý Đơn hàng --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User, model.Order, model.OrderItem, java.util.List" %>
<%
    User account = (User) session.getAttribute("account");
    if (account == null || (!"admin".equals(account.getRole()) && !"seller".equals(account.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    boolean isAdmin    = "admin".equals(account.getRole());
    String  action     = (String) request.getAttribute("action");
    if (action == null) action = "list";
    String  statusFilter = (String) request.getAttribute("statusFilter");

    List<Order>     orders     = (List<Order>)     request.getAttribute("orders");
    Order           order      = (Order)           request.getAttribute("order");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");

    String toastMsg = (String) session.getAttribute("msg");
    if (toastMsg != null) session.removeAttribute("msg");

    String[] statuses      = {"pending","confirmed","shipping","delivered","cancelled"};
    String[] statusLabels  = {"Chờ xử lý","Đã xác nhận","Đang giao","Đã giao","Đã hủy"};
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Quản lý Đơn hàng – ShopAdmin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <%@ include file="_sidebar.jsp" %>
    <main class="admin-main">
        <header class="admin-header">
            <h1 class="page-title">🧾 Quản lý Đơn hàng</h1>
            <% if ("detail".equals(action)) { %>
            <a href="<%= request.getContextPath() %>/admin/orders" class="btn btn-ghost btn-sm">← Quay lại</a>
            <% } %>
        </header>

        <div class="admin-content">
            <% if (toastMsg != null) { %>
            <div class="toast-msg <%= toastMsg.startsWith("✅") ? "success" : "error" %>"><%= toastMsg %></div>
            <% } %>

            <% if ("detail".equals(action) && order != null) { %>
            <!-- ===== CHI TIẾT ĐƠN HÀNG ===== -->
            <div class="admin-card" style="margin-bottom:20px;">
                <div class="card-header">
                    <h2>📋 Chi tiết đơn hàng #<%= order.getOrderId() %></h2>
                    <span class="badge badge-<%= order.getStatus() %>">
                        <%
                            String stl = "";
                            for(int i=0;i<statuses.length;i++) if(statuses[i].equals(order.getStatus())) stl=statusLabels[i];
                            out.print(stl);
                        %>
                    </span>
                </div>
                <div class="card-body">
                    <div class="order-info-grid">
                        <div class="info-item">
                            <span class="label">Khách hàng</span>
                            <span class="value"><%= order.getCustomerName() != null ? order.getCustomerName() : "—" %></span>
                        </div>
                        <% if (isAdmin) { %>
                        <div class="info-item">
                            <span class="label">Shop</span>
                            <span class="value"><%= order.getShopName() != null ? order.getShopName() : "—" %></span>
                        </div>
                        <% } %>
                        <div class="info-item">
                            <span class="label">Tổng đơn</span>
                            <span class="value"><%= order.getTotalAmount() != null ? String.format("%,.0f",order.getTotalAmount())+"đ" : "—" %></span>
                        </div>
                        <div class="info-item">
                            <span class="label">Giảm giá</span>
                            <span class="value" style="color:var(--success)">
                                -<%= order.getDiscountAmount() != null ? String.format("%,.0f",order.getDiscountAmount()) : "0" %>đ
                                <% if (order.getVoucherCode() != null) { %> (<%= order.getVoucherCode() %>)<% } %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="label">Thành tiền</span>
                            <span class="value" style="font-size:18px;color:var(--primary);font-weight:800;">
                                <%= order.getFinalAmount() != null ? String.format("%,.0f",order.getFinalAmount())+"đ" : "—" %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="label">Địa chỉ giao</span>
                            <span class="value"><%= order.getShippingAddress() != null ? order.getShippingAddress() : "—" %></span>
                        </div>
                        <div class="info-item">
                            <span class="label">Ngày đặt</span>
                            <span class="value"><%= order.getCreatedAt() != null ? order.getCreatedAt().toString().substring(0,16) : "—" %></span>
                        </div>
                    </div>

                    <!-- Đổi trạng thái -->
                    <% if (!"delivered".equals(order.getStatus()) && !"cancelled".equals(order.getStatus())) { %>
                    <div style="margin-top:16px; padding-top:16px; border-top:1px solid var(--border-color);">
                        <form action="<%= request.getContextPath() %>/admin/orders" method="post" class="filter-bar">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                            <label style="font-weight:600; color:var(--text-secondary);">Cập nhật trạng thái:</label>
                            <select name="status" class="filter-select">
                                <% for (int i=0; i < statuses.length; i++) { %>
                                <option value="<%= statuses[i] %>" <%= statuses[i].equals(order.getStatus()) ? "selected" : "" %>>
                                    <%= statusLabels[i] %>
                                </option>
                                <% } %>
                            </select>
                            <button type="submit" class="btn btn-primary btn-sm">Cập nhật</button>
                        </form>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Bảng sản phẩm trong đơn -->
            <div class="admin-card">
                <div class="card-header"><h2>🛒 Sản phẩm trong đơn</h2></div>
                <div class="table-wrapper">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>Ảnh</th><th>Sản phẩm</th><th>Đơn giá</th><th>Số lượng</th><th>Tổng</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (orderItems != null) for (OrderItem item : orderItems) { %>
                        <tr>
                            <td>
                                <% if (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) { %>
                                <img src="<%= item.getImageUrl() %>" class="product-thumb" alt="">
                                <% } else { %><div class="product-thumb-placeholder">📷</div><% } %>
                            </td>
                            <td><%= item.getProductName() != null ? item.getProductName() : "#"+item.getProductId() %></td>
                            <td><%= item.getUnitPrice() != null ? String.format("%,.0f",item.getUnitPrice())+"đ" : "—" %></td>
                            <td>x<%= item.getQuantity() %></td>
                            <td><strong><%= String.format("%,.0f",item.getSubtotal()) %>đ</strong></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <% } else { %>
            <!-- ===== DANH SÁCH ĐƠN HÀNG ===== -->
            <div class="admin-card">
                <div class="card-header">
                    <h2>Danh sách đơn hàng <%= isAdmin ? "(Toàn sàn)" : "(Shop của tôi)" %></h2>
                    <form action="<%= request.getContextPath() %>/admin/orders" method="get" class="filter-bar">
                        <label style="font-weight:600; color:var(--text-secondary);">Lọc:</label>
                        <select name="status" class="filter-select" onchange="this.form.submit()">
                            <option value="">Tất cả trạng thái</option>
                            <% for (int i=0; i<statuses.length; i++) { %>
                            <option value="<%= statuses[i] %>" <%= statuses[i].equals(statusFilter) ? "selected" : "" %>>
                                <%= statusLabels[i] %>
                            </option>
                            <% } %>
                        </select>
                        <% if (statusFilter != null) { %>
                        <a href="<%= request.getContextPath() %>/admin/orders" class="btn btn-ghost btn-sm">Xóa lọc</a>
                        <% } %>
                    </form>
                </div>

                <div class="table-wrapper">
                    <% if (orders == null || orders.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon">🧾</div>
                        <p>Chưa có đơn hàng nào</p>
                    </div>
                    <% } else { %>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Khách hàng</th>
                            <% if (isAdmin) { %><th>Shop</th><% } %>
                            <th>Thành tiền</th>
                            <th>Voucher</th>
                            <th>Trạng thái</th>
                            <th>Ngày đặt</th>
                            <th class="col-actions">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Order o : orders) {
                            String st = o.getStatus() != null ? o.getStatus() : "";
                            String stLabel = "";
                            for (int i=0;i<statuses.length;i++) if(statuses[i].equals(st)) stLabel=statusLabels[i];
                        %>
                        <tr>
                            <td><strong>#<%= o.getOrderId() %></strong></td>
                            <td><%= o.getCustomerName() != null ? o.getCustomerName() : "—" %></td>
                            <% if (isAdmin) { %><td><%= o.getShopName() != null ? o.getShopName() : "—" %></td><% } %>
                            <td><strong><%= o.getFinalAmount() != null ? String.format("%,.0f",o.getFinalAmount())+"đ" : "—" %></strong></td>
                            <td>
                                <% if (o.getVoucherCode() != null) { %>
                                <span class="badge badge-percentage"><%= o.getVoucherCode() %></span>
                                <% } else { %><span style="color:var(--text-muted)">—</span><% } %>
                            </td>
                            <td><span class="badge badge-<%= st %>"><%= stLabel %></span></td>
                            <td><%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0,16) : "—" %></td>
                            <td class="col-actions">
                                <div class="action-btns">
                                    <a href="<%= request.getContextPath() %>/admin/orders?action=detail&id=<%= o.getOrderId() %>"
                                       class="btn btn-outline btn-sm">🔍 Chi tiết</a>
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

<script>
setTimeout(() => {
    const t = document.querySelector('.toast-msg');
    if (t) { t.style.opacity='0'; setTimeout(()=>t.remove(),400); }
}, 4000);
</script>
</body>
</html>
