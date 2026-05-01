<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Order, dao.OrderDAO, java.util.List, java.text.NumberFormat, java.util.Locale" %>
<%
    // 1. Kiểm tra đăng nhập
    User account = (User) session.getAttribute("account");
    if (account == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // 2. Lấy lịch sử đơn hàng
    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getOrdersByUser(account.getUserId());

    // 3. Kiểm tra cờ thành công từ Checkout
    boolean showSuccess = "true".equals(request.getParameter("success"));

    // 4. Bộ định dạng tiền tệ VNĐ
    NumberFormat fmt = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang cá nhân - CDG Marketplace</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f4f6f9; color: #1a1a2e; }

        /* ===== HEADER ===== */
        .profile-header {
            background: #1a1a2e;
            padding: 16px 0;
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 12px rgba(0,0,0,0.3);
        }
        .header-inner { max-width: 1200px; margin: 0 auto; padding: 0 24px;
            display: flex; align-items: center; justify-content: space-between; }
        .logo-text { font-size: 28px; font-weight: 900; color: #e63946;
            letter-spacing: 2px; text-decoration: none; }
        .header-nav-links a { color: #ccc; text-decoration: none; margin-left: 24px;
            font-size: 14px; font-weight: 500; transition: color .2s; }
        .header-nav-links a:hover { color: #e63946; }

        /* ===== SUCCESS BANNER ===== */
        .success-banner {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white; padding: 20px 24px; margin-bottom: 32px;
            border-radius: 16px; display: flex; align-items: center; gap: 16px;
            box-shadow: 0 4px 20px rgba(46,204,113,0.35);
            animation: slideDown .4s ease;
        }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        .success-banner .icon { font-size: 40px; }
        .success-banner h3 { font-size: 20px; font-weight: 800; margin-bottom: 4px; }
        .success-banner p { font-size: 14px; opacity: .9; }

        /* ===== MAIN LAYOUT ===== */
        .profile-container { max-width: 1200px; margin: 40px auto; padding: 0 24px; }
        .profile-grid { display: grid; grid-template-columns: 300px 1fr; gap: 28px; align-items: start; }

        /* ===== USER CARD ===== */
        .user-card {
            background: white; border-radius: 20px; padding: 32px 24px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.07); text-align: center;
            position: sticky; top: 80px;
        }
        .avatar-circle {
            width: 90px; height: 90px; border-radius: 50%;
            background: linear-gradient(135deg, #e63946, #c1121f);
            display: flex; align-items: center; justify-content: center;
            font-size: 36px; font-weight: 800; color: white;
            margin: 0 auto 20px; box-shadow: 0 6px 20px rgba(230,57,70,0.4);
        }
        .user-card h2 { font-size: 20px; font-weight: 800; color: #1a1a2e; margin-bottom: 6px; }
        .user-card .role-badge {
            display: inline-block; padding: 4px 14px; border-radius: 20px;
            font-size: 12px; font-weight: 700; margin-bottom: 24px;
            background: #fff0f1; color: #e63946; border: 1px solid #fcc;
        }
        .user-info-list { text-align: left; border-top: 1px solid #f0f0f0; padding-top: 20px; }
        .info-row { display: flex; gap: 10px; padding: 10px 0;
            border-bottom: 1px solid #f8f8f8; align-items: flex-start; }
        .info-row .label { font-size: 12px; color: #999; font-weight: 600;
            min-width: 70px; padding-top: 2px; }
        .info-row .value { font-size: 14px; color: #333; font-weight: 500; word-break: break-all; }
        .stat-row { display: flex; justify-content: space-around; margin-top: 24px;
            padding-top: 20px; border-top: 1px solid #f0f0f0; }
        .stat-item { text-align: center; }
        .stat-item .num { font-size: 26px; font-weight: 800; color: #e63946; }
        .stat-item .lbl { font-size: 12px; color: #999; font-weight: 500; margin-top: 2px; }
        .logout-btn {
            display: block; width: 100%; margin-top: 24px; padding: 12px;
            background: #fff0f1; color: #e63946; border: 2px solid #fcc;
            border-radius: 10px; font-size: 14px; font-weight: 700;
            text-decoration: none; text-align: center; transition: all .2s;
        }
        .logout-btn:hover { background: #e63946; color: white; border-color: #e63946; }

        /* ===== ORDER HISTORY ===== */
        .orders-section { background: white; border-radius: 20px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.07); overflow: hidden; }
        .orders-header {
            padding: 24px 28px; border-bottom: 1px solid #f0f0f0;
            display: flex; align-items: center; justify-content: space-between;
        }
        .orders-header h3 { font-size: 18px; font-weight: 800; color: #1a1a2e; }
        .orders-count { background: #e63946; color: white; border-radius: 20px;
            padding: 3px 12px; font-size: 13px; font-weight: 700; }

        /* ORDER CARD */
        .order-card { padding: 20px 28px; border-bottom: 1px solid #f5f5f5;
            transition: background .15s; }
        .order-card:last-child { border-bottom: none; }
        .order-card:hover { background: #fafafa; }
        .order-top { display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 12px; }
        .order-id { font-size: 15px; font-weight: 700; color: #1a1a2e; }
        .order-id span { color: #e63946; }
        .order-date { font-size: 13px; color: #aaa; margin-top: 2px; }

        /* STATUS BADGES */
        .status-badge { padding: 5px 14px; border-radius: 20px;
            font-size: 12px; font-weight: 700; white-space: nowrap; }
        .status-pending  { background: #fff8e1; color: #f39c12; border: 1px solid #fce4a0; }
        .status-confirmed{ background: #e3f2fd; color: #1565c0; border: 1px solid #bbdefb; }
        .status-shipping { background: #fff3e0; color: #e65100; border: 1px solid #ffcc80; }
        .status-completed{ background: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
        .status-cancelled{ background: #fce4ec; color: #c62828; border: 1px solid #f48fb1; }

        .order-meta { display: flex; gap: 24px; flex-wrap: wrap; }
        .meta-item { font-size: 13px; color: #666; }
        .meta-item strong { color: #333; font-weight: 700; }
        .meta-item .total-price { color: #e63946; font-size: 15px; font-weight: 800; }

        /* EMPTY STATE */
        .empty-orders { padding: 60px 24px; text-align: center; color: #bbb; }
        .empty-orders .empty-icon { font-size: 64px; margin-bottom: 16px; }
        .empty-orders p { font-size: 16px; font-weight: 600; margin-bottom: 8px; color: #999; }
        .empty-orders small { font-size: 13px; }
        .shop-now-btn {
            display: inline-block; margin-top: 20px; padding: 12px 32px;
            background: #e63946; color: white; border-radius: 10px;
            text-decoration: none; font-weight: 700; font-size: 14px;
            transition: background .2s;
        }
        .shop-now-btn:hover { background: #c1121f; }

        /* RESPONSIVE */
        @media (max-width: 860px) {
            .profile-grid { grid-template-columns: 1fr; }
            .user-card { position: static; }
        }
    </style>
</head>
<body>

<!-- ===== HEADER ===== -->
<header class="profile-header">
    <div class="header-inner">
        <a href="${pageContext.request.contextPath}/client/homepage.jsp" class="logo-text">CDG</a>
        <div class="header-nav-links">
            <a href="${pageContext.request.contextPath}/client/homepage.jsp">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/cart/view">🛒 Giỏ hàng</a>
            <a href="${pageContext.request.contextPath}/logout.jsp">Đăng xuất</a>
        </div>
    </div>
</header>

<div class="profile-container">

    <!-- ===== BANNER ĐẶT HÀNG THÀNH CÔNG ===== -->
    <% if (showSuccess) { %>
    <div class="success-banner">
        <div class="icon">🎉</div>
        <div>
            <h3>Đặt hàng thành công!</h3>
            <p>Cảm ơn bạn đã mua sắm tại CDG. Đơn hàng của bạn đang được xử lý và sẽ sớm được giao đến bạn.</p>
        </div>
    </div>
    <% } %>

    <div class="profile-grid">

        <!-- ===== CỘT TRÁI: THÔNG TIN CÁ NHÂN ===== -->
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

            <a href="${pageContext.request.contextPath}/logout.jsp" class="logout-btn">🚪 Đăng xuất</a>
        </div>

        <!-- ===== CỘT PHẢI: LỊCH SỬ ĐƠN HÀNG ===== -->
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
                        <div class="order-date">🕐 <%= dateStr %></div>
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
                    <div class="meta-item">
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

    </div><!-- /profile-grid -->
</div><!-- /profile-container -->

</body>
</html>
