<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - Giỏ Hàng</title>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/web/assets/css/cart.css">

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
                <span class="cart-icon">&#128722;<span class="cart-badge" id="cart-count-badge">0</span></span>
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

<div class="container" id="cart-container">
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
            <span class="shop-name">🏪 VAMI Shop Phụ Kiện</span>
            <button class="chat-btn">💬 Chat Now</button>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh46.jpg" alt="Dây chuyền"></div>
                <div class="prod-meta">
                    <div class="prod-name">VAMI Dây Chuyền Bạc Nữ Mặt Trái Tim Đính Đá</div>
                    <div class="prod-variant">Phân loại hàng: Bạc Ý 925</div>
                </div>
            </div>
            <div class="price-col">
                <span class="price-original">₫150.000</span>
                <span class="price-sale prod-price" data-price="99000">₫99.000</span>
            </div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="1" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫99.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh41.jpg" alt="Khuyên tai"></div>
                <div class="prod-meta">
                    <div class="prod-name">VAMI Khuyên Tai Bạc Nữ Phong Cách Hàn Quốc</div>
                    <div class="prod-variant">Phân loại hàng: Bạc Ý 925</div>
                </div>
            </div>
            <div class="price-col">
                <span class="price-original">₫80.000</span>
                <span class="price-sale prod-price" data-price="45000">₫45.000</span>
            </div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="1" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫45.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh42.jpg" alt="Nhẫn"></div>
                <div class="prod-meta">
                    <div class="prod-name">VAMI Nhẫn Bạc Nữ Khắc Chữ Theo Yêu Cầu</div>
                    <div class="prod-variant">Phân loại hàng: Size 12</div>
                </div>
            </div>
            <div class="price-col">
                <span class="price-original">₫180.000</span>
                <span class="price-sale prod-price" data-price="120000">₫120.000</span>
            </div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="1" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫120.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
        <div class="voucher-bar">
            <div class="voucher-bar-left">🏷 Voucher Shop: Giảm ₫10k cho đơn từ ₫200k</div>
            <div class="voucher-bar-right">Lưu</div>
        </div>
        <div class="shipping-note">🚚 Miễn phí vận chuyển cho đơn hàng từ ₫50.000 (Giảm tối đa ₫15.000)</div>
    </div>

    <div class="shop-block">
        <div class="shop-header">
            <input type="checkbox" class="shop-checkbox shop-parent" checked>
            <span class="shop-name">🏪 Sneaker Hub Official</span>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh47.jpg" alt="Áo thun"></div>
                <div class="prod-meta">
                    <div class="prod-name">Áo Thun Nam Nữ Unisex Cổ Tròn Basic Cotton 100%</div>
                    <div class="prod-variant">Phân loại hàng: Trắng, L</div>
                </div>
            </div>
            <div class="price-col"><span class="price-sale prod-price" data-price="120000">₫120.000</span></div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="2" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫240.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh48.jpg" alt="Quần short"></div>
                <div class="prod-meta">
                    <div class="prod-name">Quần Short Thể Thao Nam Vải Dù Thoáng Khí</div>
                    <div class="prod-variant">Phân loại hàng: Đen, XL</div>
                </div>
            </div>
            <div class="price-col"><span class="price-sale prod-price" data-price="150000">₫150.000</span></div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="1" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫150.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
    </div>

    <div class="shop-block">
        <div class="shop-header">
            <input type="checkbox" class="shop-checkbox shop-parent" checked>
            <span class="shop-name">🏪 Tech Gadgets Store</span>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh49.jpg" alt="Tai nghe"></div>
                <div class="prod-meta">
                    <div class="prod-name">Tai Nghe Bluetooth Không Dây Chống Ồn</div>
                    <div class="prod-variant">Phân loại hàng: Trắng</div>
                </div>
            </div>
            <div class="price-col">
                <span class="price-original">₫500.000</span>
                <span class="price-sale prod-price" data-price="350000">₫350.000</span>
            </div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="1" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫350.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh50.jpg" alt="Cáp sạc"></div>
                <div class="prod-meta">
                    <div class="prod-name">Cáp Sạc Nhanh 20W Bọc Dù Siêu Bền</div>
                    <div class="prod-variant">Phân loại hàng: 2m, Đen</div>
                </div>
            </div>
            <div class="price-col"><span class="price-sale prod-price" data-price="80000">₫80.000</span></div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="1" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫80.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
    </div>

    <div class="shop-block">
        <div class="shop-header">
            <input type="checkbox" class="shop-checkbox shop-parent" checked>
            <span class="shop-name">🏪 K-Beauty Official</span>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh53.jpg" alt="Sữa rửa mặt"></div>
                <div class="prod-meta">
                    <div class="prod-name">Sữa Rửa Mặt Tạo Bọt Chiết Xuất Trà Xanh K-Beauty</div>
                    <div class="prod-variant">Phân loại hàng: 150ml</div>
                </div>
            </div>
            <div class="price-col"><span class="price-sale prod-price" data-price="220000">₫220.000</span></div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="2" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫440.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
        <div class="product-row">
            <div class="prod-check"><input type="checkbox" class="prod-checkbox" checked></div>
            <div class="prod-info">
                <div class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh51.png" alt="Kem chống nắng"></div>
                <div class="prod-meta">
                    <div class="prod-name">Kem Chống Nắng Phổ Rộng SPF 50+ PA++++</div>
                    <div class="prod-variant">Phân loại hàng: 50ml</div>
                </div>
            </div>
            <div class="price-col"><span class="price-sale prod-price" data-price="310000">₫310.000</span></div>
            <div class="qty-col"><div class="qty-ctrl"><button onclick="changeQty(this,-1)">−</button><input type="number" value="1" readonly><button onclick="changeQty(this,1)">+</button></div></div>
            <div class="subtotal-col prod-subtotal">₫310.000</div>
            <div class="action-col"><button class="btn-delete" onclick="showDeleteModal(this)">🗑</button></div>
        </div>
    </div>

</div>

<div class="bottom-bar">
    <div class="container">
        <div class="bottom-left">
            <input type="checkbox" id="chk-all-bottom" class="shop-checkbox" checked>
            <label for="chk-all-bottom" style="cursor:pointer;">Chọn tất cả (<span id="selected-count">0</span>)</label>
            <button style="border:none; background:none; cursor:pointer; color:#666;" onclick="removeSelected()">Xoá</button>
        </div>
        <div class="bottom-right" style="display:flex; align-items:center;">
            <div class="bottom-total">
                <span class="label" style="font-size:14px;">Tổng thanh toán (<span id="total-items">0</span> Sản phẩm):</span>
                <span class="amount" id="grand-total">₫0</span>
            </div>
            <button class="btn-checkout">Mua hàng</button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="deleteModal">
    <div class="modal-content">
        <h3>Xác nhận xoá</h3>
        <p style="color:#555; margin-bottom:20px;">Bạn có chắc chắn muốn xoá sản phẩm này khỏi giỏ hàng?</p>
        <div class="modal-btns">
            <button class="btn-modal btn-cancel" onclick="closeModal()">Hủy</button>
            <button class="btn-modal btn-confirm" id="confirmDeleteBtn">Xoá</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>

</body>
</html>