<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CDG - Marketplace</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/web/assets/css/home.css">
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
    <div class="banner">
        <a href="cdg_product_detail.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/banner.png" alt="Flash Sale" class="banner-main-img">
        </a>
    </div>

    <div class="section">
        <div class="sec-heading"><span class="bar"></span><h2>Danh Mục</h2></div>
        <div class="cat-grid">
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/nam.png" alt="Nam"></div><span>Thời Trang Nam</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/phone.png" alt="Phone"></div><span>Điện Thoại</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/elec.png" alt="Elec"></div><span>Điện Tử</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/laptop.png" alt="Laptop"></div><span>Laptop</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/cam.png" alt="Cam"></div><span>Máy Ảnh</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/watch.png" alt="Watch"></div><span>Đồng Hồ</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/shoe.png" alt="Shoe"></div><span>Giày Nam</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/home.png" alt="Home"></div><span>Gia Dụng</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/sport.png" alt="Sport"></div><span>Thể Thao</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/moto.png" alt="Moto"></div><span>Ô Tô</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/nu.png" alt="Nữ"></div><span>Thời Trang Nữ</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/baby.png" alt="Baby"></div><span>Mẹ & Bé</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/living.png" alt="Living"></div><span>Nhà Cửa</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/beauty.png" alt="Beauty"></div><span>Sắc Đẹp</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/health.png" alt="Health"></div><span>Sức Khỏe</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/wshoe.png" alt="W-Shoe"></div><span>Giày Nữ</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/wallet.png" alt="Bag"></div><span>Túi Ví</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/jewel.png" alt="Jewel"></div><span>Phụ Kiện</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/grocer.png" alt="Grocer"></div><span>Bách Hóa</span></div>
            <div class="cat-item"><div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/book.png" alt="Book"></div><span>Nhà Sách</span></div>
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
                    <span id="fs-hours">02</span>
                    <span class="fs-colon">:</span>
                    <span id="fs-minutes">45</span>
                    <span class="fs-colon">:</span>
                    <span id="fs-seconds">18</span>
                </div>
            </div>
        </div>
        
        <div class="product-grid-5">
            <div class="product-card">
                <div class="product-img"><div class="badge">-7%</div><img src="${pageContext.request.contextPath}/assets/img/anh22.png"></div>
                <div class="product-info">
                    <div class="name">Son kem lì mịn mới siêu nhẹ màu đỏ cam</div>
                    <div class="price">₫105.000</div>
                    <div class="sold">Đã bán: 79</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh23.png"></div>
                <div class="product-info">
                    <div class="name">Album ảnh 100 túi đựng ảnh 6x9</div>
                    <div class="price">₫35.000</div>
                    <div class="sold">Đã bán: 789</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh24.png"></div>
                <div class="product-info">
                    <div class="name">Túi tote vải canvas in hình theo yêu cầu</div>
                    <div class="price">₫15.000</div>
                    <div class="sold">Đã bán: 789</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh25.png"></div>
                <div class="product-info">
                    <div class="name">Kẹp giấy hình thú dễ thương</div>
                    <div class="price">₫5.000</div>
                    <div class="sold">Đã bán: 789</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh26.png"></div>
                <div class="product-info">
                    <div class="name">Son kem lì mịn mới siêu nhẹ màu đỏ cam</div>
                    <div class="price">₫45.000</div>
                    <div class="sold">Đã bán: 785</div>
                </div>
            </div>
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
                <div class="mall-sm"><div class="ph"><img src="${pageContext.request.contextPath}/assets/img/anh29.png"></div><div class="lbl">APPLE</div></div>
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
        <div class="product-grid-5">
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh32.png"></div>
                <div class="product-info">
                    <div class="name">Phấn phủ bột kiềm dầu suốt 12h</div>
                    <div class="price">₫445.000</div>
                    <div class="sold">Đã bán: 1789</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh33.png"></div>
                <div class="product-info">
                    <div class="name">Áo thun cotton form rộng unisex</div>
                    <div class="price">₫145.000</div>
                    <div class="sold">Đã bán: 123</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh34.png"></div>
                <div class="product-info">
                    <div class="name">Bộ hộp cơm thủy tinh chịu nhiệt</div>
                    <div class="price">₫456.000</div>
                    <div class="sold">Đã bán: 7k+</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh35.png"></div>
                <div class="product-info">
                    <div class="name">Giỏ hoa văn phòng để bàn xinh xắn</div>
                    <div class="price">₫36.000</div>
                    <div class="sold">Đã bán: 7.1k</div>
                </div>
            </div>
            <div class="product-card">
                <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh36.png"></div>
                <div class="product-info">
                    <div class="name">Son kem lì mịn màu đỏ cam</div>
                    <div class="price">₫45.000</div>
                    <div class="sold">Đã bán: 789</div>
                </div>
            </div>
        </div>
        <button class="load-more">XEM THÊM</button>
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
                <a href="#">Terms of Service</a>
            </div>
            <div class="footer-col">
                <h4>Support</h4>
                <a href="#">Contact Us</a>
                <a href="#">FAQs</a>
            </div>
            <div class="footer-col">
                <h4>Newsletter</h4>
                <div class="newsletter-input">
                    <input type="email" placeholder="Email...">
                    <button>JOIN</button>
                </div>
            </div>
        </div>
        <div class="footer-bottom">© 2026 THE CDG CURATOR. ALL RIGHTS RESERVED.</div>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>