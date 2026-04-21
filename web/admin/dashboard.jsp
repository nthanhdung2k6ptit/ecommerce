<%-- Dashboard Admin/Seller --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Users, model.Orders, java.util.List, java.text.NumberFormat, java.util.Locale" %>
<%
    Users loggedUser = (Users) session.getAttribute("loggedUser");
    if (loggedUser == null || (!"admin".equals(loggedUser.getRole()) && !"seller".equals(loggedUser.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = loggedUser.getRole();
    boolean isAdmin = "admin".equals(role);

    Integer totalProducts = (Integer) request.getAttribute("totalProducts");
    Integer totalOrders   = (Integer) request.getAttribute("totalOrders");
    java.math.BigDecimal totalRevenue = (java.math.BigDecimal) request.getAttribute("totalRevenue");
    Integer totalVouchers = (Integer) request.getAttribute("totalVouchers");
    Integer totalUsers    = (Integer) request.getAttribute("totalUsers");
    Integer totalSellers  = (Integer) request.getAttribute("totalSellers");
    List<Orders> recentOrders = (List<Orders>) request.getAttribute("recentOrders");

    if (totalProducts == null) totalProducts = 0;
    if (totalOrders   == null) totalOrders   = 0;
    if (totalRevenue  == null) totalRevenue  = java.math.BigDecimal.ZERO;
    if (totalVouchers == null) totalVouchers = 0;
    if (totalUsers    == null) totalUsers    = 0;
    if (totalSellers  == null) totalSellers  = 0;

    NumberFormat nf = NumberFormat.getInstance(new Locale("vi", "VN"));

    // Toast message
    String toastMsg = (String) session.getAttribute("msg");
    if (toastMsg != null) session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – ShopAdmin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
</head>
<body>
<div class="admin-wrapper">

    <%@ include file="_sidebar.jsp" %>

    <main class="admin-main">
        <!-- Header -->
        <header class="admin-header">
            <h1 class="page-title">📊 Dashboard</h1>
            <div class="header-actions">
                <span style="color:var(--text-secondary);font-size:13px;">
                    Xin chào, <strong><%= loggedUser.getFullName() %></strong>
                </span>
            </div>
        </header>

        <div class="admin-content">

            <!-- Toast -->
            <% if (toastMsg != null) { %>
            <div class="toast-msg <%= toastMsg.startsWith("✅") ? "success" : "error" %>">
                <%= toastMsg %>
            </div>
            <% } %>

            <!-- Thống kê nhanh -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon indigo">📦</div>
                    <div class="stat-body">
                        <div class="stat-value"><%= nf.format(totalProducts) %></div>
                        <div class="stat-label">Sản phẩm<%= isAdmin ? " toàn sàn" : " của shop" %></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon green">🧾</div>
                    <div class="stat-body">
                        <div class="stat-value"><%= nf.format(totalOrders) %></div>
                        <div class="stat-label">Đơn hàng<%= isAdmin ? " toàn sàn" : " của shop" %></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon yellow">💰</div>
                    <div class="stat-body">
                        <div class="stat-value" style="font-size:19px;"><%= String.format("%,.0f", totalRevenue) %>đ</div>
                        <div class="stat-label">Doanh thu (đã giao)</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon red">🎟️</div>
                    <div class="stat-body">
                        <div class="stat-value"><%= totalVouchers %></div>
                        <div class="stat-label">Mã giảm giá</div>
                    </div>
                </div>

                <% if (isAdmin) { %>
                <div class="stat-card">
                    <div class="stat-icon blue">👥</div>
                    <div class="stat-body">
                        <div class="stat-value"><%= nf.format(totalUsers) %></div>
                        <div class="stat-label">Tổng tài khoản</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon indigo">🏪</div>
                    <div class="stat-body">
                        <div class="stat-value"><%= nf.format(totalSellers) %></div>
                        <div class="stat-label">Gian hàng đang hoạt động</div>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Quick Links -->
            <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap:14px; margin-bottom:28px;">
                <a href="<%= request.getContextPath() %>/admin/products?action=add" class="btn btn-primary" style="justify-content:center; padding:14px;">
                    ➕ Thêm sản phẩm
                </a>
                <a href="<%= request.getContextPath() %>/admin/vouchers?action=add" class="btn btn-success" style="justify-content:center; padding:14px;">
                    🎟 Tạo voucher
                </a>
                <a href="<%= request.getContextPath() %>/admin/orders" class="btn btn-warning" style="justify-content:center; padding:14px;">
                    🧾 Xem đơn hàng
                </a>
                <% if (isAdmin) { %>
                <a href="<%= request.getContextPath() %>/admin/users?action=sellers" class="btn btn-outline" style="justify-content:center; padding:14px;">
                    🏪 Quản lý Shop
                </a>
                <% } %>
            </div>

            <!-- Bảng đơn hàng gần đây -->
            <div class="admin-card">
                <div class="card-header">
                    <h2>🕐 Đơn hàng gần đây</h2>
                    <a href="<%= request.getContextPath() %>/admin/orders" class="btn btn-ghost btn-sm">Xem tất cả →</a>
                </div>
                <div class="table-wrapper">
                    <% if (recentOrders == null || recentOrders.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon">🧾</div>
                        <p>Chưa có đơn hàng nào</p>
                    </div>
                    <% } else { %>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>#Đơn</th>
                            <th>Khách hàng</th>
                            <% if (isAdmin) { %><th>Shop</th><% } %>
                            <th>Thành tiền</th>
                            <th>Trạng thái</th>
                            <th>Ngày đặt</th>
                            <th class="col-actions">Chi tiết</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Orders o : recentOrders) { %>
                        <tr>
                            <td><strong>#<%= o.getOrderId() %></strong></td>
                            <td><%= o.getCustomerName() != null ? o.getCustomerName() : "—" %></td>
                            <% if (isAdmin) { %><td><%= o.getShopName() != null ? o.getShopName() : "—" %></td><% } %>
                            <td><strong><%= o.getTotalAmount() != null ? String.format("%,.0f", o.getTotalAmount()) + "đ" : "—" %></strong></td>
                            <td>
                                <%
                                    String st = o.getStatus() != null ? o.getStatus() : "";
                                    String stLabel = st.equals("pending") ? "Chờ xử lý"
                                            : st.equals("confirmed") ? "Đã xác nhận"
                                            : st.equals("shipping") ? "Đang giao"
                                            : st.equals("delivered") ? "Đã giao"
                                            : st.equals("cancelled") ? "Đã hủy" : st;
                                %>
                                <span class="badge badge-<%= st %>"><%= stLabel %></span>
                            </td>
                            <td><%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "—" %></td>
                            <td class="col-actions">
                                <a href="<%= request.getContextPath() %>/admin/orders?action=detail&id=<%= o.getOrderId() %>" class="btn btn-ghost btn-sm">Xem →</a>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                    <% } %>
                </div>
            </div>

        </div><!-- /admin-content -->
    </main>
</div>

<script>
    // Auto hide toast after 4s
    setTimeout(() => {
        const toast = document.querySelector('.toast-msg');
        if (toast) toast.style.display = 'none';
    }, 4000);
</script>
</body>
</html>
