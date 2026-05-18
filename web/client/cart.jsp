<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

 <header class="site-header">
  <div class="container">
    <div class="header-logo-wrap">
      <div class="logo">
        <a href="${pageContext.request.contextPath}/client/homepage.jsp" class="logo-link">CDG</a>
      </div>
      <div class="header-divider"></div>
      <div class="header-page-title">Giỏ hàng</div>
    </div>
  </div>
</header>

<div class="container" id="cart-container">
    
    <div class="empty-cart">
        <div class="empty-cart-icon">🛒</div>
        <p class="empty-cart-msg">Giỏ hàng của bạn còn trống</p>
        <a href="${pageContext.request.contextPath}/client/homepage.jsp" class="btn-shopping">Tiếp tục mua sắm</a>
    </div>

    <form action="${pageContext.request.contextPath}/client/checkout.jsp" method="POST" id="cart-form">
        
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
                <button type="button" class="chat-btn">💬 Chat Now</button>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP001" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh46.jpg" alt="Dây chuyền" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">VAMI Dây Chuyền Bạc Nữ Mặt Trái Tim Đính Đá</a>
                        <div class="prod-variant">Phân loại hàng: Bạc Ý 925</div>
                    </div>
                </div>
                <div class="price-col">
                    <span class="price-original">₫150.000</span>
                    <span class="price-sale prod-price" data-price="99000">₫99.000</span>
                </div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="1" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫99.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP001">🗑</button></div>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP002" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh41.jpg" alt="Khuyên tai" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">VAMI Khuyên Tai Bạc Nữ Phong Cách Hàn Quốc</a>
                        <div class="prod-variant">Phân loại hàng: Bạc Ý 925</div>
                    </div>
                </div>
                <div class="price-col">
                    <span class="price-original">₫80.000</span>
                    <span class="price-sale prod-price" data-price="45000">₫45.000</span>
                </div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="1" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫45.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP002">🗑</button></div>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP003" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh42.jpg" alt="Nhẫn" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">VAMI Nhẫn Bạc Nữ Khắc Chữ Theo Yêu Cầu</a>
                        <div class="prod-variant">Phân loại hàng: Size 12</div>
                    </div>
                </div>
                <div class="price-col">
                    <span class="price-original">₫180.000</span>
                    <span class="price-sale prod-price" data-price="120000">₫120.000</span>
                </div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="1" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫120.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP003">🗑</button></div>
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
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP004" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh47.jpg" alt="Áo thun" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">Áo Thun Nam Nữ Unisex Cổ Tròn Basic Cotton 100%</a>
                        <div class="prod-variant">Phân loại hàng: Trắng, L</div>
                    </div>
                </div>
                <div class="price-col"><span class="price-sale prod-price" data-price="120000">₫120.000</span></div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="2" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫240.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP004">🗑</button></div>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP005" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh48.jpg" alt="Quần short" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">Quần Short Thể Thao Nam Vải Dù Thoáng Khí</a>
                        <div class="prod-variant">Phân loại hàng: Đen, XL</div>
                    </div>
                </div>
                <div class="price-col"><span class="price-sale prod-price" data-price="150000">₫150.000</span></div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="1" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫150.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP005">🗑</button></div>
            </div>
        </div>

        <div class="shop-block">
            <div class="shop-header">
                <input type="checkbox" class="shop-checkbox shop-parent" checked>
                <span class="shop-name">🏪 Tech Gadgets Store</span>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP006" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh49.jpg" alt="Tai nghe" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">Tai Nghe Bluetooth Không Dây Chống Ồn</a>
                        <div class="prod-variant">Phân loại hàng: Trắng</div>
                    </div>
                </div>
                <div class="price-col">
                    <span class="price-original">₫500.000</span>
                    <span class="price-sale prod-price" data-price="350000">₫350.000</span>
                </div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="1" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫350.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP006">🗑</button></div>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP007" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh50.jpg" alt="Cáp sạc" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">Cáp Sạc Nhanh 20W Bọc Dù Siêu Bền</a>
                        <div class="prod-variant">Phân loại hàng: 2m, Đen</div>
                    </div>
                </div>
                <div class="price-col"><span class="price-sale prod-price" data-price="80000">₫80.000</span></div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="1" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫80.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP007">🗑</button></div>
            </div>
        </div>

        <div class="shop-block">
            <div class="shop-header">
                <input type="checkbox" class="shop-checkbox shop-parent" checked>
                <span class="shop-name">🏪 K-Beauty Official</span>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP008" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh53.jpg" alt="Sữa rửa mặt" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">Sữa Rửa Mặt Tạo Bọt Chiết Xuất Trà Xanh K-Beauty</a>
                        <div class="prod-variant">Phân loại hàng: 150ml</div>
                    </div>
                </div>
                <div class="price-col"><span class="price-sale prod-price" data-price="220000">₫220.000</span></div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="2" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫440.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP008">🗑</button></div>
            </div>
            <div class="product-row">
                <div class="prod-check"><input type="checkbox" name="selectedItems" value="SP009" class="prod-checkbox" checked></div>
                <div class="prod-info">
                    <a href="product_detail.jsp" class="prod-thumb"><img src="${pageContext.request.contextPath}/assets/img/anh51.png" alt="Kem chống nắng" class="full-img"></a>
                    <div class="prod-meta">
                        <a href="product_detail.jsp" class="prod-name">Kem Chống Nắng Phổ Rộng SPF 50+ PA++++</a>
                        <div class="prod-variant">Phân loại hàng: 50ml</div>
                    </div>
                </div>
                <div class="price-col"><span class="price-sale prod-price" data-price="310000">₫310.000</span></div>
                <div class="qty-col">
                    <div class="qty-ctrl">
                        <button type="button" class="cart-qty-minus">−</button>
                        <input type="number" name="quantities" value="1" min="1" class="cart-qty-input">
                        <button type="button" class="cart-qty-plus">+</button>
                    </div>
                </div>
                <div class="subtotal-col prod-subtotal">₫310.000</div>
                <div class="action-col"><button type="button" class="btn-delete-trigger" data-id="SP009">🗑</button></div>
            </div>
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
                    <span class="amount" id="grand-total">₫0</span>
                </div>
                <button type="submit" class="btn-checkout">Mua hàng</button>
            </div>
        </div>
    </form>

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
 <script src="${pageContext.request.contextPath}/assets/js/cart.js?v=2"></script>
 </body>
</html>