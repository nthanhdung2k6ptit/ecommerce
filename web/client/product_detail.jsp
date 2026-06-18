<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - ${product.name}</title> 
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product_detail.css?v=4">
</head>
<body>

<jsp:include page="header.jsp" />

<c:if test="${not empty sessionScope.msg}">
    <div id="toast-message" style="position: fixed; top: 80px; right: 20px; background-color: #f44336; color: white; padding: 15px 25px; border-radius: 5px; z-index: 9999; box-shadow: 0 4px 6px rgba(0,0,0,0.2); font-weight: 600; animation: slideIn 0.5s ease-out;">
        ${sessionScope.msg}
    </div>
    <c:remove var="msg" scope="session" />
    <script>
        setTimeout(function() {
            var toast = document.getElementById('toast-message');
            if(toast) {
                toast.style.transition = "opacity 0.5s";
                toast.style.opacity = "0";
                setTimeout(() => toast.style.display = 'none', 500);
            }
        }, 4000);
    </script>
</c:if>

<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a><span>›</span>      
        <a href="#">${product.categoryName}</a><span>›</span>
        <span style="color:#222">${product.name}</span>
    </div>

    <div class="product-top">
        <div class="gallery">
            <div class="main-img">
                <img id="main-image" src="${empty product.imageUrl ? 'https://placehold.co/500x500?text=CDG+Product' : product.imageUrl}" alt="${product.name}" class="full-img">
            </div>
            <div class="thumb-row">
                <div class="thumb active"><img src="${empty product.imageUrl ? 'https://placehold.co/500x500?text=CDG+Product' : product.imageUrl}" alt="Ảnh 1" class="full-img"></div>
                <div class="thumb"><img src="${pageContext.request.contextPath}/assets/img/anh66.jpg" alt="Ảnh 2" class="full-img"></div>
                <div class="thumb"><img src="${pageContext.request.contextPath}/assets/img/anh67.jpg" alt="Ảnh 3" class="full-img"></div>
            </div>
        </div>

        <div class="product-info">
            <div class="brand-badge">Mall</div>
            <h1 class="product-title">${product.name}</h1>
            
            <div class="rating-row">
                <div class="stars">★★★★★</div>
                <div class="rating-count">5.0 <span>(Đánh giá)</span></div>
                <div class="rating-count">1.2k <span>Đã bán</span></div>
            </div>

            <div class="price-bg">
                <span class="price-original"></span> <span class="price-main">₫<fmt:formatNumber value="${product.basePrice}" pattern="#,###"/></span>
            </div>

            <form action="${pageContext.request.contextPath}/cart/add" method="POST" id="product-form">
                
                <input type="hidden" name="productId" value="${product.productId}"> 

                <div class="variant-row">
                    <div class="variant-label">Màu sắc</div>
                    <div class="variant-options">
                        <label class="variant-label-btn">
                            <input type="radio" name="color" value="Mặc định" required checked>
                            <span class="variant-text">Mặc định</span>
                        </label>
                    </div>
                </div>

                <div class="qty-row">
                    <div class="qty-label">Số lượng</div>
                    <div class="qty-ctrl">
                        <button type="button" class="qty-minus" onclick="adjustQuantity(-1)">−</button>
                        <input id="qty" name="quantity" type="number" min="1" value="1" data-max="${product.stockQuantity}">
                        <button type="button" class="qty-plus" onclick="adjustQuantity(1)">+</button>
                    </div>
                    <span class="qty-stock">${product.stockQuantity} sản phẩm có sẵn</span>
                </div>

                <div class="btn-row">
                    <button type="submit" class="btn-cart" name="actionType" value="addCart">🛒 Thêm Vào Giỏ Hàng</button>
                    <button type="submit" class="btn-buy" name="actionType" value="buyNow">Mua Ngay</button>
                </div>
            </form>
        </div>
    </div>

    <div class="middle-section">
        <div>
            <div class="content-box" style="margin-bottom: 15px;">
                <div class="seller-header">
                    <div class="seller-avatar"><img src="${pageContext.request.contextPath}/assets/img/anh22.png" alt="Logo Shop" class="full-img"></div>
                    <div style="flex:1;">
                        <div class="seller-name">${empty product.shopName ? 'CDG Official Store' : product.shopName}</div>
                        <div class="seller-sub">Active 1 giờ trước</div>
                        <div class="seller-btns">
                            <button type="button" class="btn-follow">+ Theo Dõi</button>
                            <a href="#" class="btn-shop">🏪 Xem Shop</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="content-box">
                <div class="box-title">CHI TIẾT SẢN PHẨM</div>
                <div class="specs-grid">
                    <div class="spec-row"><div class="spec-k">Danh mục</div><div class="spec-v">${product.categoryName}</div></div>
                    <div class="spec-row"><div class="spec-k">Kho hàng</div><div class="spec-v">${product.stockQuantity}</div></div>
                    <div class="spec-row"><div class="spec-k">Bảo hành</div><div class="spec-v">12 Tháng</div></div>
                </div>

                <div class="box-title">MÔ TẢ SẢN PHẨM</div>
                <div class="desc-text">${product.description}</div>
            </div>
        </div>

        <div>
            <div class="content-box">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px;">
                    <div class="box-title" style="background: none; padding: 0; border: none; margin: 0;">ĐÁNH GIÁ SẢN PHẨM</div>
                    <a href="#" class="view-all-link">Xem tất cả &gt;</a>
                </div>
                <div class="rating-summary">
                    <div class="rating-big">
                        <div class="num">5.0</div>
                        <div class="stars">★★★★★</div>
                    </div>
                </div>
                <div class="review-item">
                    <div class="review-user">
                        <span class="review-uname">Người dùng ẩn danh</span>
                        <span class="review-date">Vừa xong</span>
                    </div>
                    <div class="review-stars">★★★★★</div>
                    <div class="review-text">Sản phẩm rất tốt, đóng gói cẩn thận!</div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="suggestion-header">CÓ THỂ BẠN CŨNG THÍCH</div>
    <div class="product-grid">
        <a href="#" class="product-card">
            <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh23.png" alt="Gợi ý" class="full-img"></div>
            <div class="product-info">
                <div class="name">Ốp Lưng Silicone Đen Chống Bám Vân Tay</div>
                <div class="price">₫35.000</div>
                <div class="sold">Đã bán 1.5k</div>
            </div>
        </a>
    </div>
</div>

<jsp:include page="footer.jsp" />

<c:if test="${not empty addSuccess and addSuccess}">
    <div id="toast-success" class="toast-success">
        <div class="toast-icon">✅</div>
        <div class="toast-msg">Thêm vào giỏ hàng thành công!</div>
    </div>

    <style>
        .toast-success { position: fixed; top: 90px; right: 24px; background: #fff; border-left: 4px solid #2ecc71; box-shadow: 0 4px 15px rgba(0,0,0,0.1); padding: 16px 20px; border-radius: 8px; display: flex; align-items: center; gap: 12px; z-index: 9999; animation: slideInRight 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards; transition: opacity 0.4s ease; }
        .toast-icon { font-size: 22px; }
        .toast-msg { font-size: 14px; font-weight: 600; color: #333; }
        @keyframes slideInRight { from { transform: translateX(120%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>

    <script>
        setTimeout(function() {
            var toast = document.getElementById("toast-success");
            if(toast) { toast.style.opacity = '0'; setTimeout(function(){ toast.remove(); }, 400); }
        }, 3000);
    </script>
</c:if>
<script src="${pageContext.request.contextPath}/assets/js/product_detail.js?v=5"></script>
</body>
</html>