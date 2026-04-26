<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - Chi Tiết Sản Phẩm</title>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product_detail.css">

</head>
<body>

<header>
    <div class="header-top">
        <div class="header-top-container">
            <div class="logo">CDG</div>
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
    <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/homepage.jsp">Trang chủ</a><span>›</span>      
    <a href="#">Điện tử</a><span>›</span>
      <a href="#">Âm thanh</a><span>›</span>
      <span style="color:#222">Tai Nghe Chống Ồn Cao Cấp Pro Max</span>
    </div>

    <div class="product-top">
      <div class="gallery">
        <div class="main-img"><img id="main-image" src="${pageContext.request.contextPath}/assets/img/anh65.jpg" alt="Ảnh chính" style="width: 100%; height: 100%; object-fit: cover;"></div>
        <div class="thumb-row">
          <div class="thumb active"><img src="${pageContext.request.contextPath}/assets/img/anh66.jpg" alt="Ảnh 1" style="width: 100%; height: 100%; object-fit: cover;"></div>
          <div class="thumb"><img src="${pageContext.request.contextPath}/assets/img/anh67.jpg" alt="Ảnh 2" style="width: 100%; height: 100%; object-fit: cover;"></div>
          <div class="thumb"><img src="${pageContext.request.contextPath}/assets/img/anh68.jpg" alt="Ảnh 3" style="width: 100%; height: 100%; object-fit: cover;"></div>
          <div class="thumb"><img src="${pageContext.request.contextPath}/assets/img/anh69.jpg" alt="Ảnh 4" style="width: 100%; height: 100%; object-fit: cover;"></div>
          <div class="thumb"><img src="${pageContext.request.contextPath}/assets/img/70.jpg" alt="Ảnh 5" style="width: 100%; height: 100%; object-fit: cover;"></div>
        </div>
      </div>

      <div class="product-info">
        <div class="brand-badge">Mall</div>
        <h1 class="product-title">Tai Nghe Chống Ồn Chủ Động Không Dây Bluetooth 5.3 Cao Cấp Pro Max - Pin 40H</h1>
        
        <div class="rating-row">
          <div class="stars">★★★★★</div>
          <div class="rating-count">4.9 <span>(412 Đánh giá)</span></div>
          <div class="rating-count">1.2k <span>Đã bán</span></div>
        </div>

        <div class="price-bg">
          <span class="price-original">₫3.390.000</span>
          <span class="price-main">₫2.490.000</span>
          <span class="price-discount">Giảm 26%</span>
        </div>

        <div class="variant-row">
          <div class="variant-label">Màu sắc</div>
          <div class="variant-options">
            <button class="variant-btn active">Đen Nhám</button>
            <button class="variant-btn">Trắng Sứ</button>
            <button class="variant-btn">Xanh Navy</button>
          </div>
        </div>

        <div class="qty-row">
          <div class="qty-label">Số lượng</div>
          <div class="qty-ctrl">
            <button onclick="var i=document.getElementById('qty');i.value=Math.max(1,+i.value-1)">−</button>
            <input id="qty" type="text" value="1" min="1">
            <button onclick="var i=document.getElementById('qty');i.value=+i.value+1">+</button>
          </div>
          <span class="qty-stock">428 sản phẩm có sẵn</span>
        </div>

        <div class="btn-row">
          <button class="btn-cart">🛒 Thêm Vào Giỏ Hàng</button>
          <button class="btn-buy">Mua Ngay</button>
        </div>
      </div>
    </div>

    <div class="middle-section">
      
      <div>
        <div class="content-box" style="margin-bottom: 15px;">
            <div class="seller-header">
                <div class="seller-avatar"><img src="${pageContext.request.contextPath}/assets/img/anh70.jpg" alt="Logo Shop" style="width: 100%; height: 100%; object-fit: cover;"></div>
                <div style="flex:1;">
                    <div class="seller-name">TechNova Official Store</div>
                    <div class="seller-sub">Active 3 giờ trước</div>
                    <div class="seller-btns">
                        <button class="btn-follow">+ Theo Dõi</button>
                        <button class="btn-shop">🏪 Xem Shop</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="content-box">
            <div class="box-title">CHI TIẾT SẢN PHẨM</div>
            <div class="specs-grid">
                <div class="spec-row"><div class="spec-k">Thương hiệu</div><div class="spec-v">TechNova</div></div>
                <div class="spec-row"><div class="spec-k">Mẫu mã</div><div class="spec-v">Pro Max X1</div></div>
                <div class="spec-row"><div class="spec-k">Kết nối</div><div class="spec-v">Bluetooth 5.3</div></div>
                <div class="spec-row"><div class="spec-k">Tương thích</div><div class="spec-v">Mọi thiết bị</div></div>
                <div class="spec-row"><div class="spec-k">Bảo hành</div><div class="spec-v">12 Tháng</div></div>
                <div class="spec-row"><div class="spec-k">Kho hàng</div><div class="spec-v">Hà Nội</div></div>
            </div>

            <div class="box-title">MÔ TẢ SẢN PHẨM</div>
            <div class="desc-text">
                Trải nghiệm âm thanh chưa từng có với Tai nghe chống ồn Pro Max. Được thiết kế với màng loa titan 40mm tùy chỉnh, chiếc tai nghe này mang đến âm trường rộng mở đáng kinh ngạc với âm trầm sâu lắng và âm bổng trong trẻo.
            </div>
            <div class="desc-img-wrap"><img src="${pageContext.request.contextPath}/assets/img/anh65.jpg" alt="Ảnh mô tả 1" style="width: 100%; height: 100%; object-fit: cover;"></div>
            <div class="desc-text">
                Công nghệ Khử tiếng ồn chủ động (ANC) hàng đầu sử dụng 6 micro để liên tục theo dõi và triệt tiêu tiếng ồn xung quanh, giúp bạn hoàn toàn đắm chìm vào âm nhạc dù đang đi tàu xe hay làm việc trong văn phòng ồn ào.
            </div>
        </div>
      </div>

      <div>
        <div class="content-box">
            <div class="box-title" style="background: none; padding: 0; border: none;">ĐÁNH GIÁ SẢN PHẨM</div>
            <div class="rating-summary">
                <div class="rating-big">
                    <div class="num">4.9</div>
                    <div class="stars">★★★★★</div>
                </div>
            </div>

            <div class="review-item">
                <div class="review-user">
                    <div class="review-avatar"><img src="${pageContext.request.contextPath}/assets/img/65.jpg" alt="User 1" style="width: 100%; height: 100%; object-fit: cover;"></div>
                    <span class="review-uname">James K.</span>
                    <span class="review-date">2 ngày trước</span>
                </div>
                <div class="review-stars">★★★★★</div>
                <div class="review-text">Chất âm cực kỳ ấn tượng. ANC hoạt động quá tốt, đeo vào gần như không nghe thấy tiếng ồn bên ngoài.</div>
            </div>

            <div class="review-item">
                <div class="review-user">
                    <div class="review-avatar"><img src="${pageContext.request.contextPath}/assets/img/66.jpg" alt="User 2" style="width: 100%; height: 100%; object-fit: cover;"></div>
                    <span class="review-uname">Sarah M.</span>
                    <span class="review-date">5 ngày trước</span>
                </div>
                <div class="review-stars">★★★★★</div>
                <div class="review-text">Tai nghe tốt nhất mình từng xài. Cầm rất chắc tay, đeo lâu không bị đau tai. Giao hàng nhanh.</div>
            </div>
        </div>
      </div>
    </div><div class="suggestion-header">CÓ THỂ BẠN CŨNG THÍCH</div>
    <div class="product-grid">
        <a href="#" class="product-card">
            <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh60.jpg" alt="Gợi ý 1" style="width: 100%; height: 100%; object-fit: cover;"></div>
            <div class="product-info">
                <div class="name">Ốp Lưng Silicone Đen Chống Bám Vân Tay iPhone</div>
                <div class="price">₫35.000</div>
                <div class="sold">Đã bán 1.5k</div>
            </div>
        </a>
        <a href="#" class="product-card">
            <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh61.jpg" alt="Gợi ý 2" style="width: 100%; height: 100%; object-fit: cover;"></div>
            <div class="product-info">
                <div class="name">Kính Cường Lực 9D Full Màn Hình</div>
                <div class="price">₫20.000</div>
                <div class="sold">Đã bán 5.2k</div>
            </div>
        </a>
        <a href="#" class="product-card">
            <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh62.jpg" alt="Gợi ý 3" style="width: 100%; height: 100%; object-fit: cover;"></div>
            <div class="product-info">
                <div class="name">Tai Nghe Bluetooth True Wireless TWS</div>
                <div class="price">₫150.000</div>
                <div class="sold">Đã bán 800</div>
            </div>
        </a>
        <a href="#" class="product-card">
            <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh63.jpg" alt="Gợi ý 4" style="width: 100%; height: 100%; object-fit: cover;"></div>
            <div class="product-info">
                <div class="name">Cáp Sạc Nhanh 20W Bọc Dù Siêu Bền</div>
                <div class="price">₫55.000</div>
                <div class="sold">Đã bán 2.1k</div>
            </div>
        </a>
        <a href="#" class="product-card">
            <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh64.jpg" alt="Gợi ý 5" style="width: 100%; height: 100%; object-fit: cover;"></div>
            <div class="product-info">
                <div class="name">Ốp Lưng Nhám Chống Vân Tay Cao Cấp</div>
                <div class="price">₫49.000</div>
                <div class="sold">Đã bán 950</div>
            </div>
        </a>
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
        <div class="footer-bottom">© 2026 THE KINETIC CURATOR. ALL RIGHTS RESERVED.</div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/product_detail.js"></script>

</body>
</html>