<%-- 
    Document   : product
    Created on : Apr 22, 2026, 1:38:42 AM
    Author     : Dell
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - Thời Trang Nữ</title>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/web/assets/css/product.css">

</head>
<body>

<header>
    <div class="header-top">
        <div class="header-top-container">
        <div class="logo">
    <a href="${pageContext.request.contextPath}/homepage.jsp">CDG</a>
        </div>            
        <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm sản phẩm, thương hiệu, danh mục...">
                <button>&#128269;</button>
            </div>
            <div class="header-right">
                <span>All Promotions</span>
                <span>Sell on CDG</span>
                <span>Help</span>
                <span>Login</span>
                <span class="cart-icon">&#128722;<span class="cart-badge">0</span></span>
            </div>
        </div>
    </div>
    <nav class="header-nav">
        <div class="header-nav-container">
            <a href="#">FEEDBACK</a>
            <a href="#">SELL ON CDG</a>
            <a href="#">CUSTOMER CARE</a>
            <a href="#">LOGIN</a>
            <a href="#">SIGNUP</a>
        </div>
    </nav>
</header>

<div class="container">
    <div class="breadcrumb-wrap">
      <div class="breadcrumb">
        <a href="homepage.jsp">Trang chủ</a>
        <span>›</span>
        <span style="color:#111;font-weight:600;">Thời Trang Nữ</span>
      </div>
    </div>

    <div class="page-layout">

      <aside class="sidebar">
        <div class="sidebar-block">
          <div class="sidebar-title">☰ Tất cả danh mục</div>
          <ul class="cat-list">
            <li><a href="#">Thời Trang Nam</a></li>
            <li><a href="#">Điện Thoại &amp; Phụ Kiện</a></li>
            <li><a href="#">Thiết Bị Điện Tử</a></li>
            <li><a href="#">Máy Tính &amp; Laptop</a></li>
            <li><a href="#">Máy Ảnh &amp; Máy Quay Phim</a></li>
            <li><a href="#">Đồng Hồ</a></li>
            <li><a href="#">Giày Dép Nam</a></li>
            <li><a href="#">Thiết Bị Điện Gia Dụng</a></li>
              <li><a href="#">Thể Thao &amp; Du Lịch</a></li>
            <li><a href="#">Ô Tô &amp; Xe Máy &amp; Xe Đạp</a></li>
            <li><a href="#">Thời Trang Nữ</a></li>
            <li><a href="#">Mẹ &amp; Bé</a></li>
            <li><a href="#">Nhà Cửa &amp; Đời Sống</a></li>
            <li><a href="#">Sắc Đẹp</a></li>
            <li><a href="#">Sức Khỏe</a></li>
            <li><a href="#">Giày Dép Nữ</a></li>
            <li><a href="#">Túi Ví Nữ</a></li>
            <li><a href="#">Phụ Kiện &amp; Trang Sức Nữ</a></li>
            <li><a href="#">Bách Hóa Online</a></li>
            <li><a href="#">Nhà Sách Online</a></li>
           </ul>
        </div>

        <div class="sidebar-block">
          <div class="sidebar-title">🔍 Bộ lọc tìm kiếm</div>
          <div class="sidebar-block">
    

    <div class="filter-category">Nơi Bán</div>
    <div class="filter-list">
        <label class="filter-checkbox"><input type="checkbox"> <span>Hà Nội</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>TP. Hồ Chí Minh</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Hà Đông</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Hoàng Mai</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Thanh Xuân</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Nam Từ Liêm</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Đống Đa</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Bắc Từ Liêm</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Cầu Giấy</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Hai Bà Trưng</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Long Biên</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Ba Đình</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Tây Hồ</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Quận Hoàn Kiếm</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Huyện Hoài Đức</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Huyện Gia Lâm</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Huyện Thanh Trì</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Huyện Thanh Oai</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Huyện Thường Tín</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Huyện Đông Anh</span></label>
        <div class="filter-more">Khác &gt;</div>
    </div>

    <hr class="filter-divider">

    <div class="filter-category">Đơn Vị Vận Chuyển</div>
    <div class="filter-list">
        <label class="filter-checkbox"><input type="checkbox"> <span>Hỏa Tốc</span></label>
        <label class="filter-checkbox"><input type="checkbox"> <span>Nhanh</span></label>
    </div>
</div>
          
          <div class="filter-label">Khoảng Giá</div>
          <div class="price-range">
            <input class="price-input" type="text" placeholder="₫ Từ">
            <span>-</span>
            <input class="price-input" type="text" placeholder="₫ Đến">
          </div>
          <button class="btn-apply">ÁP DỤNG</button>

          <div class="filter-label">Đánh Giá</div>
          <label class="filter-option"><input type="radio" name="star"> ⭐⭐⭐⭐⭐</label>
          <label class="filter-option"><input type="radio" name="star"> ⭐⭐⭐⭐</label>
          <label class="filter-option"><input type="radio" name="star"> ⭐⭐⭐</label>
          <label class="filter-option"><input type="radio" name="star"> ⭐⭐</label>
          <label class="filter-option"><input type="radio" name="star"> ⭐</label>

          <button style="width:100%; background:none; border:1px solid #ddd; padding:8px; margin-top:15px; cursor:pointer; font-size:12px;">XÓA TẤT CẢ</button>
        </div>
      </aside>

      <div class="main-content">
        <div class="topbar">
          <span class="topbar-label">Sắp xếp theo</span>
          <button class="sort-btn active">Phổ biến</button>
          <button class="sort-btn">Mới nhất</button>
          <button class="sort-btn">Bán chạy</button>
          <select class="sort-select">
            <option>Giá: Thấp đến Cao</option>
            <option>Giá: Cao đến Thấp</option>
          </select>
        </div>

        <div class="product-grid">
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">BANAABI</span><img src="${pageContext.request.contextPath}/assets/img/anh1.jpg" alt=""></div>
        <div class="product-info"><div class="name">Áy Ngủ Body Thun Lạnh Mặc Nhà Cực Mát</div><div class="price-row"><span class="price-sale">₫88.000</span></div><div class="sold">Đã bán 200+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh2.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ đồ ngủ 3 dây Cottege phong cách Hàn Quốc</div><div class="price-row"><span class="price-sale">₫129.000</span></div><div class="sold">Đã bán 15k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-40%</span><img src="${pageContext.request.contextPath}/assets/img/anh3.jpg" alt=""></div>
        <div class="product-info"><div class="name">+AW+ Áo Ngủ Bộ Nữ Silk Lụa Cao Cấp 2 Dây</div><div class="price-row"><span class="price-sale">₫97.300</span><span class="price-original">₫162.000</span></div><div class="sold">Đã bán 15k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">thubalien</span><img src="${pageContext.request.contextPath}/assets/img/anh4.jpg" alt=""></div>
        <div class="product-info"><div class="name">INKC203 Áo Ngủ Nữ 2 Dây Pyjama Set Đồ Bộ</div><div class="price-row"><span class="price-sale">₫62.000</span></div><div class="sold">Đã bán 40k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh5.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Pyjama Hai Dây Dễ Thương Set Đồ Bộ Nữ</div><div class="price-row"><span class="price-sale">₫88.000</span></div><div class="sold">Đã bán 55k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-30%</span><img src="${pageContext.request.contextPath}/assets/img/anh6.jpg" alt=""></div>
        <div class="product-info"><div class="name">Áo mặc nhà nữ cotton 2 dây đơn giản</div><div class="price-row"><span class="price-sale">₫112.000</span><span class="price-original">₫160.000</span></div><div class="sold">Đã bán 45k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">thubalien</span><img src="${pageContext.request.contextPath}/assets/img/anh7.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ đồ bộ nữ họa tiết dễ thương mặc nhà</div><div class="price-row"><span class="price-sale">₫100.000</span></div><div class="sold">Đã bán 29k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh8.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ đồ mặc nhà ngắn nữ cotton mềm mại</div><div class="price-row"><span class="price-sale">₫134.000</span></div><div class="sold">Đã bán 55k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh9.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ đồ PIJAMA nữ set đồ bộ nữ mặc nhà</div><div class="price-row"><span class="price-sale">₫266.000</span></div><div class="sold">Đã bán 8k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge hot">HOT</span><img src="${pageContext.request.contextPath}/assets/img/anh10.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ 2 VÀY Đồ Ngủ nữ cotton dài thoáng mát</div><div class="price-row"><span class="price-sale">₫98.000</span><span class="price-original">₫140.000</span></div><div class="sold">Đã bán 13k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh11.jpg" alt=""></div>
        <div class="product-info"><div class="name">Đồ ngủ nữ pijama bộ quần áo mặc nhà cotton</div><div class="price-row"><span class="price-sale">₫140.000</span></div><div class="sold">Đã bán 13k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-25%</span><img src="${pageContext.request.contextPath}/assets/img/anh12.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Ngủ Nữ Cộc Tay Cotton Dễ Thương Thoáng</div><div class="price-row"><span class="price-sale">₫156.000</span><span class="price-original">₫195.000</span></div><div class="sold">Đã bán 15k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh13.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ đồ Ngủ Pyjama dài nữ cotton Hàn Quốc</div><div class="price-row"><span class="price-sale">₫159.000</span></div><div class="sold">Đã bán 40k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">thubalien</span><img src="${pageContext.request.contextPath}/assets/img/anh14.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Ngủ Nữ Cổ Cài Nút Kẻ Sọc Caro Pyjamas</div><div class="price-row"><span class="price-sale">₫132.000</span></div><div class="sold">Đã bán 13k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh15.jpg" alt=""></div>
        <div class="product-info"><div class="name">Vanh vanh Bộ Đồ Ngủ Nữ Pyjama 2 Mảnh</div><div class="price-row"><span class="price-sale">₫52.000</span></div><div class="sold">Đã bán 40k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge new">NEW</span><img src="${pageContext.request.contextPath}/assets/img/anh16.jpg" alt=""></div>
        <div class="product-info"><div class="name">Áo Ngủ Nữ Tay Ngắn Mặc Nhà Phong Cách</div><div class="price-row"><span class="price-sale">₫48.000</span></div><div class="sold">Đã bán 40k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh17.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Đồ Ngủ Nữ Cộc Tay Cotton In Hoa Dễ Thương</div><div class="price-row"><span class="price-sale">₫149.000</span></div><div class="sold">Đã bán 55k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-20%</span><img src="${pageContext.request.contextPath}/assets/img/anh18.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Đồ Ngủ Nữ Mặc Nhà Vải Cotton Xốp Mềm</div><div class="price-row"><span class="price-sale">₫119.000</span><span class="price-original">₫149.000</span></div><div class="sold">Đã bán 33k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh19.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Đồ Bộ Nữ Cotton Mặc Nhà Cực Mát Thoáng</div><div class="price-row"><span class="price-sale">₫145.000</span></div><div class="sold">Đã bán 21k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">thubalien</span><img src="${pageContext.request.contextPath}/assets/img/anh20.jpg" alt=""></div>
        <div class="product-info"><div class="name">Phong Đồ Ngủ Lụa Nữ 2 Dây Phối Ren Cao Cấp</div><div class="price-row"><span class="price-sale">₫139.000</span></div><div class="sold">Đã bán 12k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh21.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ đồ ngủ nữ PHUOC áo tay ngắn quần dài</div><div class="price-row"><span class="price-sale">₫279.000</span></div><div class="sold">Đã bán 15k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-35%</span><img src="${pageContext.request.contextPath}/assets/img/anh22.jpg" alt=""></div>
        <div class="product-info"><div class="name">JIKE S.S.B Set Đồ Ngủ 2 Mảnh Nữ Cộc Tay</div><div class="price-row"><span class="price-sale">₫136.000</span><span class="price-original">₫209.000</span></div><div class="sold">Đã bán 7k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh23.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Đồ Bộ Nữ Hai Dây Phong Cách Nhật</div><div class="price-row"><span class="price-sale">₫149.000</span></div><div class="sold">Đã bán 9k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge hot">HOT</span><img src="${pageContext.request.contextPath}/assets/img/anh24.jpg" alt=""></div>
        <div class="product-info"><div class="name">Chân váy cổ bộ ngủ mặc nhà thoáng mát</div><div class="price-row"><span class="price-sale">₫145.000</span></div><div class="sold">Đã bán 15k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh25.jpg" alt=""></div>
        <div class="product-info"><div class="name">Phong đồ ngủ Mayhome Homeswear Bộ đồ nhà</div><div class="price-row"><span class="price-sale">₫136.000</span></div><div class="sold">Đã bán 15k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-22%</span><img src="${pageContext.request.contextPath}/assets/img/anh26.jpg" alt=""></div>
        <div class="product-info"><div class="name">DAY VÁY CỔ BÉO áo ngủ nữ set bộ nhà siêu cute</div><div class="price-row"><span class="price-sale">₫159.000</span><span class="price-original">₫204.000</span></div><div class="sold">Đã bán 8k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh27.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ Ngủ Nữ Vải Lụa Gấm Mặc Nhà Cao Cấp</div><div class="price-row"><span class="price-sale">₫152.000</span></div><div class="sold">Đã bán 11k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">LOOK</span><img src="${pageContext.request.contextPath}/assets/img/anh28.jpg" alt=""></div>
        <div class="product-info"><div class="name">Đồ ngủ nữ sịn sò mặc nhà phuoc áo ngủ tay 2</div><div class="price-row"><span class="price-sale">₫159.000</span></div><div class="sold">Đã bán 9k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh29.jpg" alt=""></div>
        <div class="product-info"><div class="name">Vanh vanh Bộ Đồ Ngủ Nữ VAMI Body Thun Lạnh</div><div class="price-row"><span class="price-sale">₫75.000</span><span class="price-original">₫88.000</span></div><div class="sold">Đã bán 55k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-18%</span><img src="${pageContext.request.contextPath}/assets/img/anh30.jpg" alt=""></div>
        <div class="product-info"><div class="name">Phong Đồ Đầm Bikini nữ 2 dây phối ren</div><div class="price-row"><span class="price-sale">₫78.000</span><span class="price-original">₫95.000</span></div><div class="sold">Đã bán 13k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh31.jpg" alt=""></div>
        <div class="product-info"><div class="name">Đồ bộ mặc nhà nữ vải cotton mềm mại đơn giản</div><div class="price-row"><span class="price-sale">₫94.000</span></div><div class="sold">Đã bán 7k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">thubalien</span><img src="${pageContext.request.contextPath}/assets/img/anh32.jpg" alt=""></div>
        <div class="product-info"><div class="name">VÂ 1 MÃI 80k đồ 2 dây mặc nhà đơn giản</div><div class="price-row"><span class="price-sale">₫48.000</span><span class="price-original">₫80.000</span></div><div class="sold">Đã bán 18k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh33.jpg" alt=""></div>
        <div class="product-info"><div class="name">Áo Ngủ Pyjama Đầm Ngủ Nữ Tay Dài Vải Lụa</div><div class="price-row"><span class="price-sale">₫120.000</span></div><div class="sold">Đã bán 22k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-33%</span><img src="${pageContext.request.contextPath}/assets/img/anh34.jpg" alt=""></div>
        <div class="product-info"><div class="name">Bộ đồ nữ 2 dây mặc nhà đơn giản thoáng mát</div><div class="price-row"><span class="price-sale">₫65.000</span><span class="price-original">₫97.000</span></div><div class="sold">Đã bán 31k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh35.jpg" alt=""></div>
        <div class="product-info"><div class="name">ảo VÌT 80K❤️ bộ 2 dây mặc nhà đơn giản</div><div class="price-row"><span class="price-sale">₫69.000</span></div><div class="sold">Đã bán 11k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge hot">HOT</span><img src="${pageContext.request.contextPath}/assets/img/anh36.jpg" alt=""></div>
        <div class="product-info"><div class="name">Áo ngủ đầm ngủ nữ đơn giản họa tiết cute</div><div class="price-row"><span class="price-sale">₫5.900</span><span class="price-original">₫8.000</span></div><div class="sold">Đã bán 21k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh37.jpg" alt=""></div>
        <div class="product-info"><div class="name">Lợi Cô liên hoa Pyjama phong cách đồ bộ nữ</div><div class="price-row"><span class="price-sale">₫120.000</span></div><div class="sold">Đã bán 8k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge shop">thubalien</span><img src="${pageContext.request.contextPath}/assets/img/anh38.jpg" alt=""></div>
        <div class="product-info"><div class="name">INKC Áo Ngủ Pyjama Đầm Nữ Tay Dài Phong Cách</div><div class="price-row"><span class="price-sale">₫69.000</span></div><div class="sold">Đã bán 14k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh39.jpg" alt=""></div>
        <div class="product-info"><div class="name">ẢY VÍT 80K đơn đồ 2 dây mặc nhà cute dễ thương</div><div class="price-row"><span class="price-sale">₫7.900</span></div><div class="sold">Đã bán 18k+</div></div>
      </a>
 
      <a href="cdg_product_detail.html" class="product-card">
        <div class="product-img"><span class="img-badge sale">-28%</span><img src="${pageContext.request.contextPath}/assets/img/anh40.jpg" alt=""></div>
        <div class="product-info"><div class="name">Áo ngủ kẻ sọc bộ Pyjama dài Nhật Bản Hàn</div><div class="price-row"><span class="price-sale">₫227.870</span><span class="price-original">₫316.000</span></div><div class="sold">Đã bán 7k+</div></div>
      </a>
 
    </div>

        <div class="pagination">
          <div class="page-btn">‹</div>
          <div class="page-btn active">1</div>
          <div class="page-btn">2</div>
          <div class="page-btn">3</div>
          <div class="page-btn">...</div>
          <div class="page-btn">›</div>
        </div>
      </div>
    </div>
</div>

<footer>
    <div class="container">
        <div class="footer-grid">
            <div>
                <div class="footer-logo">CDG</div>
                <p class="footer-desc">CDG is Asia’s leading online department store offering a fast, secure and convenient online shopping experience with a broad product offering in categories ranging from fashion, consumer electronics to household goods, toys and sports equipment.</p>
            </div>
            <div class="footer-col">
                <h4>Navigation</h4>
                <a href="#">Privacy Policy</a>
                <a href="#">Refund Policy</a>
                <a href="#">Terms of Service</a>
            </div>
            <div class="footer-col">
                <h4>Support</h4>
                <a href="#">Contact Us</a>
                <a href="#">Sustainability</a>
                <a href="#">FAQs</a>
            </div>
            <div class="footer-col">
                <h4>Newsletter</h4>
                <p style="font-size:12px; margin-bottom:10px">Subscribe for exclusive access.</p>
                <div class="newsletter-input">
                    <input type="email" placeholder="email address">
                    <button>JOIN</button>
                </div>
            </div>
        </div>
        <div class="footer-bottom">© 2026 THE CDG CURATOR. ALL RIGHTS RESERVED.</div>
    </div>
</footer>

</body>
</html>