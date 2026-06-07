<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <a href="product_detail.jsp">
                    <img src="${pageContext.request.contextPath}/assets/img/banner.png" alt="Flash Sale 1" class="banner-main-img">
                </a>
            </div>
            <div class="slide">
                <a href="#">
                    <img src="${pageContext.request.contextPath}/assets/img/banner1.png" alt="Flash Sale 2" class="banner-main-img" style="filter: hue-rotate(45deg);">
                </a>
            </div>
            <div class="slide">
                <a href="#">
                    <img src="${pageContext.request.contextPath}/assets/img/banner2.png" alt="Flash Sale 3" class="banner-main-img" style="filter: hue-rotate(90deg);">
                </a>
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
            <a href="${pageContext.request.contextPath}/products?categoryId=1" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/nam.png" alt="Nam"></div>
                <span>Thời Trang Nam</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=2" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/phone.png" alt="Phone"></div>
                <span>Điện Thoại</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=3" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/elec.png" alt="Elec"></div>
                <span>Điện Tử</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=4" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/laptop.png" alt="Laptop"></div>
                <span>Laptop</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=5" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/cam.png" alt="Cam"></div>
                <span>Máy Ảnh</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=6" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/watch.png" alt="Watch"></div>
                <span>Đồng Hồ</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=7" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/shoe.png" alt="Shoe"></div>
                <span>Giày Nam</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=8" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/home.png" alt="Home"></div>
                <span>Gia Dụng</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=9" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/sport.png" alt="Sport"></div>
                <span>Thể Thao</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=10" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/moto.png" alt="Moto"></div>
                <span>Ô Tô</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=11" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/nu.png" alt="Nữ"></div>
                <span>Thời Trang Nữ</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=12" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/baby.png" alt="Baby"></div>
                <span>Mẹ & Bé</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=13" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/living.png" alt="Living"></div>
                <span>Nhà Cửa</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=14" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/beauty.png" alt="Beauty"></div>
                <span>Sắc Đẹp</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=15" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/health.png" alt="Health"></div>
                <span>Sức Khỏe</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=16" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/wshoe.png" alt="W-Shoe"></div>
                <span>Giày Nữ</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=17" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/wallet.png" alt="Bag"></div>
                <span>Túi Ví</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=18" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/jewel.png" alt="Jewel"></div>
                <span>Phụ Kiện</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=19" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/grocer.png" alt="Grocer"></div>
                <span>Bách Hóa</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?categoryId=20" class="cat-item">
                <div class="cat-icon"><img src="${pageContext.request.contextPath}/assets/img/book.png" alt="Book"></div>
                <span>Nhà Sách</span>
            </a>
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
                    <span id="fs-hours">02</span>
                    <span class="fs-colon">:</span>
                    <span id="fs-minutes">45</span>
                    <span class="fs-colon">:</span>
                    <span id="fs-seconds">18</span>
                </div>
            </div>
        </div>
        
        <div class="product-grid-5 fs-product-grid">
            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img">
                        <span class="badge">-7%</span>
                        <img src="${pageContext.request.contextPath}/assets/img/anh22.png">
                    </div>
                    <div class="product-info">
                        <div class="name">Son kem lì mịn mới siêu nhẹ màu đỏ cam</div>
                        <div class="price">₫105.000</div>
                        <div class="sold">Đã bán: 79</div>
                    </div>
                </div>
            </a>
            
            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img">
                        <span class="badge">-30%</span>
                        <img src="${pageContext.request.contextPath}/assets/img/anh23.png">
                    </div>
                    <div class="product-info">
                        <div class="name">Album ảnh 100 túi đựng ảnh 6x9</div>
                        <div class="price">₫35.000</div>
                        <div class="sold">Đã bán: 789</div>
                    </div>
                </div>
            </a>
            
            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img">
                        <span class="badge">-40%</span>
                        <img src="${pageContext.request.contextPath}/assets/img/anh24.png">
                    </div>
                    <div class="product-info">
                        <div class="name">Túi tote vải canvas in hình theo yêu cầu Túi tote vải canvas in hình theo yêu cầu</div>
                        <div class="price">₫15.000</div>
                        <div class="sold">Đã bán: 789</div>
                    </div>
                </div>
            </a>
            
            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img">
                        <span class="badge">-50%</span>
                        <img src="${pageContext.request.contextPath}/assets/img/anh25.png">
                    </div>
                    <div class="product-info">
                        <div class="name">Kẹp giấy hình thú dễ thương</div>
                        <div class="price">₫5.000</div>
                        <div class="sold">Đã bán: 789</div>
                    </div>
                </div>
            </a>
            
            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img">
                        <span class="badge">-25%</span>
                        <img src="${pageContext.request.contextPath}/assets/img/anh26.png">
                    </div>
                    <div class="product-info">
                        <div class="name">Son kem lì mịn mới siêu nhẹ màu đỏ cam</div>
                        <div class="price">₫45.000</div>
                        <div class="sold">Đã bán: 785</div>
                    </div>
                </div>
            </a>
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
        
        <div class="product-grid-5" id="product-container">
            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh32.png"></div>
                    <div class="product-info">
                        <div class="name">Phấn phủ bột kiềm dầu suốt 12h</div>
                        <div class="price">₫445.000</div>
                        <div class="sold">Đã bán: 1789</div>
                    </div>
                </div>
            </a>

            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh33.png"></div>
                    <div class="product-info">
                        <div class="name">Áo thun cotton form rộng unisex</div>
                        <div class="price">₫145.000</div>
                        <div class="sold">Đã bán: 123</div>
                    </div>
                </div>
            </a>

            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh34.png"></div>
                    <div class="product-info">
                        <div class="name">Bộ hộp cơm thủy tinh chịu nhiệt</div>
                        <div class="price">₫456.000</div>
                        <div class="sold">Đã bán: 7k+</div>
                    </div>
                </div>
            </a>

            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh35.png"></div>
                    <div class="product-info">
                        <div class="name">Giỏ hoa văn phòng để bàn xinh xắn</div>
                        <div class="price">₫36.000</div>
                        <div class="sold">Đã bán: 7.1k</div>
                    </div>
                </div>
            </a>

            <a href="product_detail.jsp" class="product-card-link">
                <div class="product-card">
                    <div class="product-img"><img src="${pageContext.request.contextPath}/assets/img/anh36.png"></div>
                    <div class="product-info">
                        <div class="name">Son kem lì mịn màu đỏ cam Son kem lì mịn màu đỏ cam Son kem lì mịn màu đỏ cam</div>
                        <div class="price">₫45.000</div>
                        <div class="sold">Đã bán: 789</div>
                    </div>
                </div>
            </a>
        </div>
        
        <button class="load-more" id="load-more-btn" data-offset="5">XEM THÊM</button>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>