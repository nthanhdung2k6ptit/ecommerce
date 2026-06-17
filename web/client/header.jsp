<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="model.CartItemDTO" %>
<%@ page import="java.util.List" %>
<%
    // 1. Lấy thông tin user từ Session
    User auth = (User) session.getAttribute("account");
    
    // 2. Tính toán số lượng sản phẩm đang có trong giỏ hàng
    int totalCartItems = 0;
    if (auth != null) {
        try {
            CartDAO cartDAO = new CartDAO();
            List<CartItemDTO> cartItems = cartDAO.getCartItems(auth.getUserId());
            if (cartItems != null) {
                totalCartItems = cartItems.size();
            }
        } catch (Exception e) {
            System.err.println("Lỗi đếm giỏ hàng ở Header: " + e.getMessage());
        }
    }
%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css?v=final_pro">

<header class="cdg-header">
    <div class="header-top">
        <div class="header-top-container">
            
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home">CDG</a>
            </div>
            
            <form action="${pageContext.request.contextPath}/products" method="GET" class="search-bar">
                <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..." value="${keyword}" required>
                <button type="submit">&#128269;</button>
            </form>

            <div class="header-right">
                <% if (auth != null) { %>
                    <a href="${pageContext.request.contextPath}/profile" class="header-link user-greeting">
                        👋 <%= auth.getFullName() %>
                    </a>
                    <span class="header-divider-sm">|</span>
                    <a href="${pageContext.request.contextPath}/logout" class="header-link btn-logout">Đăng xuất</a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/register" class="header-link">Đăng ký</a>
                    <span class="header-divider-sm">|</span>
                    <a href="${pageContext.request.contextPath}/login" class="header-link">Đăng nhập</a>
                <% } %>
                
                <a href="${pageContext.request.contextPath}/cart/view" class="cart-icon">
                    🛒<span class="cart-badge" id="header-cart-badge"><%= totalCartItems %></span>
                </a>
            </div>

        </div>
    </div>

    <nav class="header-nav">
        <div class="header-nav-container">
            <a href="${pageContext.request.contextPath}/client/info.jsp#contact">Liên hệ CSKH</a>
            <a href="${pageContext.request.contextPath}/client/info.jsp#faq">Câu hỏi thường gặp</a>
            <a href="${pageContext.request.contextPath}/client/info.jsp#privacy">Chính sách bảo mật</a>
            <a href="${pageContext.request.contextPath}/client/info.jsp#terms">Điều khoản dịch vụ</a>
        </div>
    </nav>
</header>

<script src="${pageContext.request.contextPath}/assets/js/header.js?v=final"></script>