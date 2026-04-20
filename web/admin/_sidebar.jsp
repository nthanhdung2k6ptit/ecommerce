<%-- Sidebar Admin – fragment dùng chung cho tất cả trang admin --%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Users, model.Sellers" %>
<%
    Users _user  = (Users)  session.getAttribute("loggedUser");
    Sellers _seller = (Sellers) session.getAttribute("currentSeller");
    String _role  = (_user != null) ? _user.getRole() : "guest";
    String _name  = (_user != null) ? _user.getFullName() : "Người dùng";
    String _avatar = (_name.length() > 0) ? String.valueOf(_name.charAt(0)).toUpperCase() : "A";
    String _shopName = (_seller != null) ? _seller.getShopName() : "";
    String _ctx   = request.getContextPath();

    // Xác định trang hiện tại để highlight menu
    String _uri   = request.getRequestURI();
    boolean _isDashboard = _uri.contains("/admin/dashboard") || _uri.endsWith("/admin");
    boolean _isProducts  = _uri.contains("/admin/products");
    boolean _isCategories= _uri.contains("/admin/categories");
    boolean _isOrders    = _uri.contains("/admin/orders");
    boolean _isVouchers  = _uri.contains("/admin/vouchers");
    boolean _isUsers     = _uri.contains("/admin/users");
%>
<aside class="admin-sidebar" id="adminSidebar">
    <div class="sidebar-logo">
        <a href="<%= _ctx %>/admin/dashboard" class="logo-brand">
            <span class="logo-icon">🛍</span>
            <span>ShopAdmin</span>
        </a>
        <% if ("admin".equals(_role)) { %>
            <span class="role-badge">🛡 Quản trị viên</span>
        <% } else if ("seller".equals(_role)) { %>
            <span class="role-badge">🏪 Chủ Shop</span>
        <% } %>
        <% if (!_shopName.isEmpty()) { %>
            <div style="margin-top:6px; color:#64748b; font-size:12px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="<%= _shopName %>">
                📦 <%= _shopName %>
            </div>
        <% } %>
    </div>

    <nav class="sidebar-nav">
        <div class="sidebar-section-title">Tổng quan</div>
        <a href="<%= _ctx %>/admin/dashboard" class="<%= _isDashboard ? "active" : "" %>">
            <span class="nav-icon">📊</span> Dashboard
        </a>

        <div class="sidebar-section-title" style="margin-top:8px;">Kho hàng</div>
        <a href="<%= _ctx %>/admin/products" class="<%= _isProducts ? "active" : "" %>">
            <span class="nav-icon">📦</span> Sản phẩm
        </a>
        <a href="<%= _ctx %>/admin/categories" class="<%= _isCategories ? "active" : "" %>">
            <span class="nav-icon">🏷️</span> Danh mục
        </a>

        <div class="sidebar-section-title" style="margin-top:8px;">Bán hàng</div>
        <a href="<%= _ctx %>/admin/orders" class="<%= _isOrders ? "active" : "" %>">
            <span class="nav-icon">🧾</span> Đơn hàng
        </a>
        <a href="<%= _ctx %>/admin/vouchers" class="<%= _isVouchers ? "active" : "" %>">
            <span class="nav-icon">🎟️</span> Mã giảm giá
        </a>

        <% if ("admin".equals(_role)) { %>
        <div class="sidebar-section-title" style="margin-top:8px;">Quản trị</div>
        <a href="<%= _ctx %>/admin/users" class="<%= _isUsers ? "active" : "" %>">
            <span class="nav-icon">👥</span> Tài khoản & Shop
        </a>
        <% } %>
    </nav>

    <div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar"><%= _avatar %></div>
            <div class="user-details">
                <strong><%= _name %></strong>
                <small><%= _user != null ? _user.getEmail() : "" %></small>
            </div>
        </div>
        <a href="<%= _ctx %>/logout.jsp" class="logout-btn">
            <span>🚪</span> Đăng xuất
        </a>
    </div>
</aside>
