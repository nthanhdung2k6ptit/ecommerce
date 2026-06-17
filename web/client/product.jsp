<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - Danh sách sản phẩm</title>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product.css?v=1003">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="breadcrumb-wrap">
      <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
        <span>›</span>
        <span style="color:#111;font-weight:600;">
            <c:choose>
                <c:when test="${not empty keyword}">Kết quả tìm kiếm: '${keyword}'</c:when>
                <c:when test="${not empty categoryId}">Sản phẩm trong Danh mục</c:when>
                <c:otherwise>Tất cả sản phẩm</c:otherwise>
            </c:choose>
        </span>
      </div>
    </div>

    <div class="page-layout">
      <aside class="sidebar" id="product-sidebar">
        <form id="filterForm" class="sidebar-block" action="${pageContext.request.contextPath}/products" method="GET">
            <div class="sidebar-title">🔍 Bộ lọc tìm kiếm</div>
            
            <c:if test="${not empty keyword}">
                <input type="hidden" name="keyword" value="${keyword}">
            </c:if>
            <c:if test="${not empty categoryId}">
                <input type="hidden" name="categoryId" value="${categoryId}">
            </c:if>
            <input type="hidden" name="sort" id="sortInput" value="${sort}">

            <div class="filter-label">Khoảng Giá</div>
            <div class="price-range">
                <input class="price-input" type="number" name="minPrice" placeholder="₫ Từ" value="${param.minPrice}">
                <span>-</span>
                <input class="price-input" type="number" name="maxPrice" placeholder="₫ Đến" value="${param.maxPrice}">
            </div>
            <input type="submit" class="btn-apply" value="ÁP DỤNG">
            
            <hr class="filter-divider">
            <a href="${pageContext.request.contextPath}/products${not empty categoryId ? '?categoryId='.concat(categoryId) : ''}" class="btn-reset" style="display:block; text-align:center; text-decoration:none;">XÓA TẤT CẢ</a>
        </form>
      </aside>

      <div class="main-content">
        <div class="topbar">
          <button type="button" class="sort-btn ${sort == 'newest' ? 'active' : ''}" onclick="changeSort('newest')">Mới nhất</button>
          <button type="button" class="sort-btn ${sort == 'price_asc' ? 'active' : ''}" onclick="changeSort('price_asc')">Giá Thấp ➔ Cao</button>
          <button type="button" class="sort-btn ${sort == 'price_desc' ? 'active' : ''}" onclick="changeSort('price_desc')">Giá Cao ➔ Thấp</button>
        </div>

        <div class="product-grid">
            <c:choose>
                <c:when test="${empty productList}">
                    <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
                        <h3 style="color: #666;">Không tìm thấy sản phẩm nào phù hợp!</h3>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${productList}" var="p">
                        <a href="${pageContext.request.contextPath}/product_detail?id=${p.productId}" class="product-card">
                            <div class="product-img">
                                <img src="${empty p.imageUrl ? 'https://placehold.co/300x300?text=CDG' : pageContext.request.contextPath.concat('/assets/img/products/').concat(p.imageUrl)}" alt="${p.name}" class="full-img">
                            </div>
                            <div class="product-info">
                                <div class="name">${p.name}</div>
                                <div class="price-row">
                                    <span class="price-sale">₫<fmt:formatNumber value="${p.basePrice}" pattern="#,###"/></span>
                                </div>
                                <div class="sold" style="font-size: 13px; color: #757575; margin-top: 8px;">Kho: ${p.stockQuantity}</div>
                            </div>
                        </a>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/products?page=${currentPage - 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${sort}" class="page-btn">‹</a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)}">
                            <a href="${pageContext.request.contextPath}/products?page=${i}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${sort}" 
                               class="page-btn ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:when>
                        <c:when test="${i == currentPage - 2 || i == currentPage + 2}">
                            <span class="page-btn" style="pointer-events: none; border: none; background: transparent;">...</span>
                        </c:when>
                    </c:choose>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/products?page=${currentPage + 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${sort}" class="page-btn">›</a>
                </c:if>
            </div>
        </c:if>
      </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script>
    function changeSort(sortValue) {
        document.getElementById('sortInput').value = sortValue;
        document.getElementById('filterForm').submit();
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/product.js?v=1003"></script>
</body>
</html>