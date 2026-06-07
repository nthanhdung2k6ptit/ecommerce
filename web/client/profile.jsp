<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Order, dao.OrderDAO, java.util.List, java.text.NumberFormat, java.util.Locale" %>
<%
    // 1. Kiểm tra trạng thái đăng nhập hệ thống
    User account = (User) session.getAttribute("account");
    if (account == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // 2. Lấy danh sách lịch sử đơn hàng từ Database
    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getOrdersByUser(account.getUserId());

    // 3. Kiểm tra cờ báo thành công nhảy về từ trang Checkout
    boolean showSuccess = "true".equals(request.getParameter("success"));

    // 4. Bộ định dạng tiền tệ chuẩn VNĐ
    NumberFormat fmt = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang cá nhân - CDG</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css?v=2026">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="profile-container">

    <% if (showSuccess) { %>
    <div class="success-banner" id="success-banner">
        <div class="banner-content">
            <div class="icon">🎉</div>
            <div>
                <h3>Đặt hàng thành công!</h3>
                <p>Cảm ơn bạn đã mua sắm tại CDG. Đơn hàng của bạn đang được xử lý và sẽ sớm được giao đến bạn.</p>
            </div>
        </div>
        <span class="close-banner" id="close-banner-btn">&times;</span>
    </div>
    <% } %>

    <div class="profile-grid">

        <div class="user-card">
            <div class="avatar-circle">
                <%= account.getFullName() != null && !account.getFullName().isEmpty()
                    ? String.valueOf(account.getFullName().charAt(0)).toUpperCase()
                    : "?" %>
            </div>
            <h2><%= account.getFullName() != null ? account.getFullName() : "Người dùng" %></h2>
            <span class="role-badge">
                <% if ("admin".equals(account.getRole())) { %>👑 Admin
                <% } else if ("seller".equals(account.getRole())) { %>🏪 Chủ Shop
                <% } else { %>🛍️ Khách hàng<% } %>
            </span>

            <div class="user-info-list">
                <div class="info-row">
                    <span class="label">📧 Email</span>
                    <span class="value"><%= account.getEmail() != null ? account.getEmail() : "—" %></span>
                </div>
                <div class="info-row">
                    <span class="label">📱 SĐT</span>
                    <span class="value"><%= account.getPhone() != null ? account.getPhone() : "Chưa cập nhật" %></span>
                </div>
                <div class="info-row">
                    <span class="label">📅 Ngày tạo</span>
                    <span class="value">
                        <% if (account.getCreatedAt() != null) {
                            java.time.LocalDate d = account.getCreatedAt().toLocalDateTime().toLocalDate(); %>
                            <%= d.getDayOfMonth() %>/<%= d.getMonthValue() %>/<%= d.getYear() %>
                        <% } else { %>—<% } %>
                    </span>
                </div>
            </div>

            <div class="stat-row">
                <div class="stat-item">
                    <div class="num"><%= orders.size() %></div>
                    <div class="lbl">Đơn hàng</div>
                </div>
                <div class="stat-item">
                    <%
                        long completedCount = orders.stream()
                            .filter(o -> "completed".equals(o.getStatus()))
                            .count();
                    %>
                    <div class="num"><%= completedCount %></div>
                    <div class="lbl">Hoàn thành</div>
                </div>
                <div class="stat-item">
                    <%
                        java.math.BigDecimal totalSpent = orders.stream()
                            .filter(o -> "completed".equals(o.getStatus()))
                            .map(o -> o.getTotalAmount() != null ? o.getTotalAmount() : java.math.BigDecimal.ZERO)
                            .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);
                        long spent = totalSpent.longValue();
                        String spentStr = spent >= 1000000 ? (spent/1000000) + "M" :
                                          spent >= 1000    ? (spent/1000)    + "K" :
                                          String.valueOf(spent);
                    %>
                    <div class="num"><%= spentStr %>₫</div>
                    <div class="lbl">Đã chi</div>
                </div>
            </div>

            <%-- Nút Dashboard: chỉ hiện với admin và seller --%>
            <% if ("admin".equals(account.getRole()) || "seller".equals(account.getRole())) { %>
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn-dashboard">
                ⚙️ Vào Dashboard Quản Trị
            </a>
            <% } %>

            <a href="${pageContext.request.contextPath}/logout.jsp" class="logout-btn" id="btn-logout">🚪 Đăng xuất</a>
        </div>

        <div class="orders-section">
            <div class="orders-header">
                <h3>📦 Lịch sử đơn hàng</h3>
                <span class="orders-count"><%= orders.size() %> đơn</span>
            </div>

            <% if (orders.isEmpty()) { %>
            <div class="empty-orders">
                <div class="empty-icon">🛒</div>
                <p>Bạn chưa có đơn hàng nào</p>
                <small>Hãy bắt đầu mua sắm để xem lịch sử đơn hàng tại đây</small>
                <br>
                <a href="${pageContext.request.contextPath}/client/homepage.jsp" class="shop-now-btn">Mua sắm ngay</a>
            </div>

            <% } else {
                for (Order order : orders) {
                    String st = order.getStatus() != null ? order.getStatus() : "pending";
                    String badgeClass = "status-" + st;
                    String statusLabel;
                    switch (st) {
                        case "pending":   statusLabel = "⏳ Chờ xác nhận"; break;
                        case "confirmed": statusLabel = "✅ Đã xác nhận";  break;
                        case "shipping":  statusLabel = "🚚 Đang giao";    break;
                        case "completed": statusLabel = "🎉 Hoàn thành";   break;
                        case "cancelled": statusLabel = "❌ Đã hủy";       break;
                        default:          statusLabel = st;
                    }
                    String dateStr = "—";
                    if (order.getCreatedAt() != null) {
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                        dateStr = sdf.format(order.getCreatedAt());
                    }
                    long total = order.getTotalAmount() != null ? order.getTotalAmount().longValue() : 0;
                    long ship  = order.getShippingFee() != null ? order.getShippingFee().longValue() : 0;
            %>
            <div class="order-card">
                <div class="order-top">
                    <div>
                        <div class="order-id">Đơn hàng <span>#<%= order.getOrderId() %></span></div>
                        <div class="order-date">An tâm mua sắm 🕐 <%= dateStr %></div>
                    </div>
                    <span class="status-badge <%= badgeClass %>"><%= statusLabel %></span>
                </div>
                <div class="order-meta">
                    <div class="meta-item">
                        💰 Tổng tiền:&nbsp;<span class="total-price"><%= fmt.format(total) %>₫</span>
                    </div>
                    <div class="meta-item">
                        🚚 Phí ship: <strong><%= fmt.format(ship) %>₫</strong>
                    </div>
                    <% if (order.getShippingAddress() != null) { %>
                    <div class="meta-item address-meta">
                        📍 Địa chỉ: <strong><%= order.getShippingAddress() %></strong>
                    </div>
                    <% } %>
                    <% if (order.getVoucherCode() != null) { %>
                    <div class="meta-item">
                        🎟️ Voucher: <strong><%= order.getVoucherCode() %></strong>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } } %>
        </div>

    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/profile.js?v=2026"></script>
</body>
</html>
