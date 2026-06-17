<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CDG - Marketplace</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=2"> 
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    
    <div class="banner">
        <div class="slider-container">
            <div class="slide active">
                <a href="#"><img src="${pageContext.request.contextPath}/assets/img/banner.png" alt="Flash Sale 1" class="banner-main-img"></a>
            </div>
            <div class="slide">
                <a href="#"><img src="${pageContext.request.contextPath}/assets/img/banner1.png" alt="Flash Sale 2" class="banner-main-img" style="filter: hue-rotate(45deg);"></a>
            </div>
            <div class="slide">
                <a href="#"><img src="${pageContext.request.contextPath}/assets/img/banner2.png" alt="Flash Sale 3" class="banner-main-img" style="filter: hue-rotate(90deg);"></a>
            </div>

            <button type="button" class="slider-btn prev-btn">&#10094;</button>
            <button type="button" class="slider-btn next-btn">&#10095;</button>

            <div class="slider-dots">
                <span class="dot active"></span>
                <span class="dot"></span>
                <span class="dot"></span>
            </div>
        </div>
    </div>

    <div class="section">
        <div class="sec-heading"><span class="bar"></span><h2>Danh Mục</h2></div>
        
        <div class="cat-grid" id="categoryGrid">
            <c:forEach items="${listCategories}" var="c">
                <a href="${pageContext.request.contextPath}/products?categoryId=${c.categoryId}" class="cat-item">
                    <div class="cat-icon">
                        <img src="${c.imageUrl}" alt="${c.name}">
                    </div>
                    <span>${c.name}</span>
                </a>
            </c:forEach>
        </div>
        
        <div class="cat-toggle-btn" id="catToggleBtn">
            <span class="arrow-icon"></span>
        </div>
    </div>

    <div class="section">
        <div class="flash-sale-banner">
            <div class="fs-left">
                <span class="fs-icon">⚡</span>
                <span class="fs-text">FLASH SALE</span>
            </div>
            <div class="fs-right">
                <span class="fs-label">Kết thúc trong:</span>
                <div class="countdown-timer">
                    <span id="fs-hours">02</span><span class="fs-colon">:</span>
                    <span id="fs-minutes">45</span><span class="fs-colon">:</span>
                    <span id="fs-seconds">18</span>
                </div>
            </div>
        </div>
        
        <div class="product-grid-5 fs-product-grid">
            <c:forEach items="${flashSaleList}" var="fs">
                <c:set var="discountedPrice" value="${fs.basePrice * 0.85}" />
                
                <a href="${pageContext.request.contextPath}/product_detail?id=${fs.productId}" class="product-card-link">
                    <div class="product-card">
                        <div class="product-img">
                            <span class="badge">-15%</span>
                            <img src="${empty fs.imageUrl ? 'https://placehold.co/300x300?text=Flash+Sale' : fs.imageUrl}" alt="${fs.name}">
                        </div>
                        <div class="product-info">
                            <div class="name">${fs.name}</div>
                            <div class="price">
                                <span style="text-decoration: line-through; color: #999; font-size: 13px; margin-right: 6px;">
                                    ₫<fmt:formatNumber value="${fs.basePrice}" pattern="#,###"/>
                                </span>
                                <span style="color: var(--red); font-size: 18px; font-weight: bold;">
                                    ₫<fmt:formatNumber value="${discountedPrice}" pattern="#,###"/>
                                </span>
                            </div>
                            
                            <div class="sold" style="margin-top: 8px;">
                                <div style="width: 100%; background: #ffbaba; border-radius: 10px; height: 18px; position: relative; overflow: hidden;">
                                    <div style="background: var(--red); width: 60%; height: 100%; position: absolute; left: 0; top: 0;"></div>
                                    <span style="position: absolute; width: 100%; text-align: center; color: #fff; font-size: 11px; font-weight: bold; line-height: 18px; z-index: 2;">
                                        Còn lại: ${fs.stockQuantity}
                                    </span>
                                </div>
                            </div>
                            
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>

    <div class="section">
        <div class="sec-heading"><span class="bar"></span><h2>CDG Mall</h2></div>
        <div class="mall-grid">
            <div class="mall-big">
                <div class="ph"><img src="${pageContext.request.contextPath}/assets/img/anh27.png"></div>
                <div class="lbl"><small>Collection</small><h3>GENTLE MONSTER</h3></div>
            </div>
            <div class="mall-right">
                <div class="mall-sm"><div class="ph"><img src="${pageContext.request.contextPath}/assets/img/anh28.png"></div><div class="lbl">STREETWEAR</div></div>
                <div class="mall-sm"><div class="ph"><img src="${pageContext.request.contextPath}/assets/img/anh29.jpg"></div><div class="lbl">APPLE</div></div>
                <div class="mall-sm"><div class="ph"><img src="${pageContext.request.contextPath}/assets/img/anh30.png"></div><div class="lbl">BRAND 4</div></div>
                <div class="mall-sm red-card">
                    <div>☆</div>
                    <div style="font-weight:900">CURATED BUNDLES</div>
                    <a class="shop-btn" href="#">SHOP ALL</a>
                </div>
            </div>
        </div>
    </div>

    <div class="section">
        <div style="text-align:center;margin-bottom:25px;">
            <h2 style="font-size:22px;font-weight:900;color:var(--red);">DÀNH CHO BẠN</h2>
        </div>
        
        <c:if test="${not empty keyword}">
            <div style="text-align:center;margin-bottom:15px;">
                <strong>Kết quả tìm kiếm cho "${keyword}":</strong>
                <span>${fn:length(listProducts)} sản phẩm</span>
            </div>
        </c:if>
        
        <div class="product-grid-5" id="product-container">
            <c:forEach items="${listProducts}" var="p">
                <a href="product_detail?id=${p.productId}" class="product-card-link">
                    <div class="product-card">
                        <div class="product-img">
                            <img src="${empty p.imageUrl ? 'https://placehold.co/300x300?text=CDG+Marketplace' : p.imageUrl}" alt="${p.name}">
                        </div>
                        <div class="product-info">
                            <div class="name">${p.name}</div>
                            <div class="price">
                                ₫<fmt:formatNumber value="${p.basePrice}" pattern="#,###"/>
                            </div>
                            <div class="sold">Kho: ${p.stockQuantity}</div>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
        
        <button class="load-more" id="load-more-btn" data-offset="5">XEM THÊM</button>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>