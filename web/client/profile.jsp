<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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

    <c:if test="${not empty showSuccess and showSuccess}">
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
    </c:if>

    <div class="profile-grid">
        
        <div class="user-card">
            <div class="avatar-circle">
                ${empty account.fullName ? '?' : fn:toUpperCase(fn:substring(account.fullName, 0, 1))}
            </div>
            <h2>${empty account.fullName ? 'Người dùng' : account.fullName}</h2>
            
            <span class="role-badge">
                <c:choose>
                    <c:when test="${account.role == 'admin'}">👑 Admin</c:when>
                    <c:when test="${account.role == 'seller'}">🏪 Chủ Shop</c:when>
                    <c:otherwise>🛍️ Khách hàng</c:otherwise>
                </c:choose>
            </span>

            <div class="user-info-list">
                <div class="info-row">
                    <span class="label">📧 Email</span>
                    <span class="value">${empty account.email ? '—' : account.email}</span>
                </div>
                <div class="info-row">
                    <span class="label">📱 SĐT</span>
                    <span class="value">${empty account.phone ? 'Chưa cập nhật' : account.phone}</span>
                </div>
                <div class="info-row">
                    <span class="label">📅 Ngày tạo</span>
                    <span class="value">
                        <c:choose>
                            <c:when test="${not empty account.createdAt}">
                                <fmt:formatDate value="${account.createdAt}" pattern="dd/MM/yyyy"/>
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <div class="stat-row">
                <div class="stat-item">
                    <div class="num">${fn:length(orders)}</div>
                    <div class="lbl">Đơn hàng</div>
                </div>
                <div class="stat-item">
                    <div class="num">${completedCount}</div>
                    <div class="lbl">Hoàn thành</div>
                </div>
                <div class="stat-item">
                    <div class="num">${spentStr}₫</div>
                    <div class="lbl">Đã chi</div>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" id="btn-logout">🚪 Đăng xuất</a>
        </div>

        <div class="orders-section">
            <div class="orders-header">
                <h3>📦 Lịch sử đơn hàng</h3>
                <span class="orders-count">${fn:length(orders)} đơn</span>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-orders">
                        <div class="empty-icon">🛒</div>
                        <p>Bạn chưa có đơn hàng nào</p>
                        <small>Hãy bắt đầu mua sắm để xem lịch sử đơn hàng tại đây</small>
                        <br>
                        <a href="${pageContext.request.contextPath}/home" class="shop-now-btn">Mua sắm ngay</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <c:forEach items="${orders}" var="order">
                        
                        <c:set var="statusLabel" value="${order.status}" />
                        <c:choose>
                            <c:when test="${order.status == 'pending'}"><c:set var="statusLabel" value="⏳ Chờ xác nhận" /></c:when>
                            <c:when test="${order.status == 'confirmed'}"><c:set var="statusLabel" value="✅ Đã xác nhận" /></c:when>
                            <c:when test="${order.status == 'shipping'}"><c:set var="statusLabel" value="🚚 Đang giao" /></c:when>
                            <c:when test="${order.status == 'completed'}"><c:set var="statusLabel" value="🎉 Hoàn thành" /></c:when>
                            <c:when test="${order.status == 'cancelled'}"><c:set var="statusLabel" value="❌ Đã hủy" /></c:when>
                        </c:choose>

                        <div class="order-card">
                            <div class="order-top">
                                <div>
                                    <div class="order-id">Đơn hàng <span>#${order.orderId}</span></div>
                                    <div class="order-date">An tâm mua sắm 🕐 <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></div>
                                </div>
                                <span class="status-badge status-${order.status}">${statusLabel}</span>
                            </div>
                            
                            <div class="order-meta">
                                <div class="meta-item">
                                    💰 Tổng tiền:&nbsp;<span class="total-price"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>₫</span>
                                </div>
                                <div class="meta-item">
                                    🚚 Phí ship: <strong><fmt:formatNumber value="${order.shippingFee}" pattern="#,###"/>₫</strong>
                                </div>
                                <c:if test="${not empty order.shippingAddress}">
                                    <div class="meta-item address-meta">
                                        📍 Địa chỉ: <strong>${order.shippingAddress}</strong>
                                    </div>
                                </c:if>
                                <c:if test="${not empty order.voucherCode}">
                                    <div class="meta-item">
                                        🎟️ Voucher: <strong>${order.voucherCode}</strong>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

        </div>

    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/profile.js?v=2026"></script>
</body>
</html>