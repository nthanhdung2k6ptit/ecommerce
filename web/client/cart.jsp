<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - Giỏ Hàng</title>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css?v=2">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container" id="cart-container" style="margin-top: 30px; margin-bottom: 50px;">
    
    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="empty-cart" style="display: block; text-align: center; padding: 50px 0;">
                <div class="empty-cart-icon" style="font-size: 60px;">🛒</div>
                <p class="empty-cart-msg" style="margin: 20px 0;">Giỏ hàng của bạn còn trống</p>
                <a href="${pageContext.request.contextPath}/home" class="btn-shopping" style="padding: 10px 20px; background: var(--red); color: white; text-decoration: none; border-radius: 4px;">Tiếp tục mua sắm</a>
            </div>
        </c:when>

        <c:otherwise>
            <form action="${pageContext.request.contextPath}/checkout" method="POST" id="cart-form">
                
                <div class="cart-table-header">
                    <input type="checkbox" id="chk-all-top" class="shop-checkbox" checked>
                    <span>Sản phẩm</span>
                    <span class="text-center">Đơn giá</span>
                    <span class="text-center">Số lượng</span>
                    <span class="text-right">Số tiền</span>
                    <span class="text-right">Thao tác</span>
                </div>

                <div class="shop-block">
                    <div class="shop-header">
                        <input type="checkbox" class="shop-checkbox shop-parent" checked>
                        <span class="shop-name">🏪 CDG Mall</span>
                    </div>

                    <c:forEach items="${cartItems}" var="item">
                        <div class="product-row">
                            <div class="prod-check">
                                <input type="checkbox" name="selectedItems" value="${item.productId}" class="prod-checkbox" checked>
                            </div>
                            <div class="prod-info">
                                <a href="${pageContext.request.contextPath}/product_detail?id=${item.productId}" class="prod-thumb">
                                    <img src="${empty item.imageUrl ? 'https://placehold.co/100x100?text=CDG' : pageContext.request.contextPath.concat('/assets/img/').concat(item.imageUrl)}" alt="${item.productName}" class="full-img">
                                </a>
                                <div class="prod-meta">
                                    <a href="${pageContext.request.contextPath}/product_detail?id=${item.productId}" class="prod-name">${item.productName}</a>
                                </div>
                            </div>
                            <div class="price-col">
                                <span class="price-sale prod-price" data-price="${item.basePrice}">
                                    ₫<fmt:formatNumber value="${item.basePrice}" pattern="#,###"/>
                                </span>
                            </div>
                            <div class="qty-col">
                                <div class="qty-ctrl">
                                    <button type="button" class="cart-qty-minus">−</button>
                                    <input type="number" name="quantity_${item.productId}" value="${item.quantity}" min="1" class="cart-qty-input">
                                    <button type="button" class="cart-qty-plus">+</button>
                                </div>
                            </div>
                            <div class="subtotal-col prod-subtotal">
                                ₫<fmt:formatNumber value="${item.itemTotal}" pattern="#,###"/>
                            </div>
                            <div class="action-col">
                                <button type="button" class="btn-delete-trigger" data-id="${item.productId}">🗑</button>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <div class="shipping-note">🚚 Miễn phí vận chuyển cho đơn hàng từ ₫50.000 (Giảm tối đa ₫15.000)</div>
                </div>

                <div class="bottom-bar">
                    <div class="bottom-left">
                        <input type="checkbox" id="chk-all-bottom" class="shop-checkbox" checked>
                        <label for="chk-all-bottom" class="lbl-chk-all">Chọn tất cả (<span id="selected-count">0</span>)</label>
                        <button type="button" class="btn-delete-selected">Xoá mục đã chọn</button>
                    </div>
                    <div class="bottom-right">
                        <div class="bottom-total">
                            <span class="total-label">Tổng thanh toán (<span id="total-items">0</span> Sản phẩm):</span>
                            <span class="amount" id="grand-total">
                                ₫<fmt:formatNumber value="${cartTotal}" pattern="#,###"/>
                            </span>
                        </div>
                        <button type="submit" class="btn-checkout">Mua hàng</button>
                    </div>
                </div>
            </form>
        </c:otherwise>
    </c:choose>

    <div class="modal-overlay" id="deleteModal">
        <div class="modal-content">
            <input type="hidden" id="delete-item-id" name="deleteItemId">
            <h3>Xác nhận xoá</h3>
            <p class="modal-desc">Bạn có chắc chắn muốn xoá sản phẩm này khỏi giỏ hàng?</p>
            <div class="modal-btns">
                <button type="button" class="btn-modal btn-cancel">Hủy</button>
                <button type="button" class="btn-modal btn-confirm" id="confirmDeleteBtn">Xoá</button>
            </div>
        </div>
    </div>

</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/cart.js?v=2"></script>
</body>
</html>