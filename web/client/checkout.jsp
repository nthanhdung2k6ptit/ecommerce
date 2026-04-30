<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - Thanh Toán</title>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">

</head>
<body>

<header class="site-header">
  <div class="container">
    <div class="header-logo-wrap">
      <div class="logo">
    <a href="${pageContext.request.contextPath}/homepage.jsp">CDG</a>
</div>
      <div class="header-divider"></div>
      <div class="header-page-title">Thanh Toán</div>
    </div>
  </div>
</header>

<div class="container">
    <div class="page-wrap">

      <div class="card">
        <div class="address-section">
          <div class="address-label">📍 Địa Chỉ Nhận Hàng</div>
          <div class="address-row">
            <span class="address-name" id="display-name">Matcha (+84) 901 234 567</span>
            <span class="address-detail" id="display-addr">Ký túc xá PTIT, Hà Đông, Hà Nội</span>
            <span class="tag-default">Mặc định</span>
            <span class="btn-change" onclick="openModal('addressListModal')">Thay Đổi</span>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="table-header">
          <span>Sản phẩm</span>
          <span style="text-align:center">Đơn giá</span>
          <span style="text-align:center">Số lượng</span>
          <span style="text-align:right">Thành tiền</span>
        </div>

        <div class="shop-row">🏪 VAMI Shop Phụ Kiện</div>
        <div class="product-row">
          <div class="product-cell">
            <div class="product-thumb">
              <img src="${pageContext.request.contextPath}/assets/img/anh41.jpg" alt="dây" style="width: 100%; height: 100%; object-fit: cover;">/>
            </div>
            <div>
              <div class="product-name">Dây Chuyền Bạc Nữ Mặt Trái Tim Đính Đá Cao Cấp</div>
              <div class="product-variant">Phân loại: Bạc Ý 925</div>
            </div>
          </div>
          <div class="cell-price text-center">₫99.000</div>
          <div class="cell-qty">1</div>
          <div class="cell-total">₫99.000</div>
        </div>

        <div class="product-row">
          <div class="product-cell">
            <div class="product-thumb">
              <img src="https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=160&q=80" alt="Khuyên Tai" style="width: 100%; height: 100%; object-fit: cover;">
            </div>
            <div>
              <div class="product-name">Khuyên Tai Bạc Nữ Phong Cách Hàn Quốc</div>
              <div class="product-variant">Phân loại: Bạc Ý 925</div>
            </div>
          </div>
          <div class="cell-price text-center">₫45.000</div>
          <div class="cell-qty">2</div>
          <div class="cell-total">₫90.000</div>
        </div>

        <div class="note-shipping-row">
          <div class="note-wrap">
            <span>Lời nhắn:</span>
            <input class="note-input" type="text" placeholder="Lưu ý cho người bán...">
          </div>
          <div class="shipping-info">
            <div class="ship-row">
              <span class="label">Đơn vị vận chuyển: Nhanh</span>
              <span class="fee">₫28.500</span>
            </div>
            <div style="font-size: 12px; color: #888;">Nhận hàng vào 25 Th4 - 27 Th4</div>
          </div>
        </div>

        <div class="subtotal-row">
          <span>Tổng số tiền (3 sản phẩm):</span>
          <span class="subtotal-amount">₫217.500</span>
        </div>
      </div>

      <div class="card">
        <div class="payment-section">
          <div class="payment-title">Phương thức thanh toán</div>
          <div class="payment-options">
            <button class="pay-btn" onclick="selectPayMethod(this, 'cod')">Thanh toán khi nhận hàng</button>
            <button class="pay-btn active" id="btn-credit" onclick="selectPayMethod(this, 'credit')">Thẻ Tín dụng/Ghi nợ</button>
            <button class="pay-btn" onclick="selectPayMethod(this, 'wallet')">Ví CDG Pay</button>
          </div>

          <div id="credit-card-info" style="display:block;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
                <span id="display-card" style="font-size: 14px; font-weight: 500; color: #333;">Đang chọn thẻ: 💳 Visa **** 1234</span>
                <span class="btn-change" onclick="openModal('cardListModal')" style="font-size: 12px;">Thay đổi thẻ</span>
            </div>
          </div>
        </div>

        <div style="background: #fffefb; padding: 20px 0; border-top: 1px solid #eee;">
            <div class="summary-line"><span>Tổng tiền hàng</span><span class="s-value">₫189.000</span></div>
            <div class="summary-line"><span>Phí vận chuyển</span><span class="s-value">₫28.500</span></div>
            <div class="total-line">
              <span style="font-size: 16px; color: #222;">Tổng thanh toán</span>
              <span class="total-amount">₫217.500</span>
            </div>
        </div>

        <div class="order-action">
          <p style="color: #888; font-size: 12px;">Nhấn "Đặt hàng" đồng nghĩa với việc bạn đồng ý tuân theo điều khoản CDG</p>
          <button class="btn-order">Đặt hàng</button>
        </div>
      </div>

    </div>
</div>

<div class="modal" id="addressListModal">
    <div class="modal-content">
        <div class="modal-header">Địa Chỉ Của Tôi</div>
        <div class="modal-body">
            <div class="item-list">
                <label class="item-row">
                    <input type="radio" name="addrRadio" checked value="Matcha (+84) 901 234 567|Ký túc xá PTIT, Hà Đông, Hà Nội">
                    <div><strong>Matcha</strong> (+84) 901 234 567<br><span style="color:#666;font-size:13px;margin-top:4px;display:block;">Ký túc xá PTIT, Hà Đông, Hà Nội</span><span class="tag-default" style="margin-top:6px;display:inline-block;">Mặc định</span></div>
                </label>
                <label class="item-row">
                    <input type="radio" name="addrRadio" value="Giang Hoàng (+84) 988 777 666|Số 12 Nguyễn Trãi, Thanh Xuân, Hà Nội">
                    <div><strong>Giang Hoàng</strong> (+84) 988 777 666<br><span style="color:#666;font-size:13px;margin-top:4px;display:block;">Số 12 Nguyễn Trãi, Thanh Xuân, Hà Nội</span></div>
                </label>
            </div>
            <button class="btn-add-new" onclick="switchModal('addressListModal', 'newAddressModal')"><span>+</span> Thêm Địa Chỉ Mới</button>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="closeModal('addressListModal')">Huỷ</button>
            <button class="btn-red" onclick="confirmAddress()">Xác nhận</button>
        </div>
    </div>
</div>

<div class="modal" id="newAddressModal">
    <div class="modal-content">
        <div class="modal-header">Địa chỉ mới</div>
        <div class="modal-body">
            <div class="form-grid">
                <div class="form-group"><input type="text" id="newAddrName" placeholder="Họ và tên"></div>
                <div class="form-group"><input type="text" id="newAddrPhone" placeholder="Số điện thoại"></div>
            </div>
            <div class="form-group">
                <input type="text" id="newAddrStreet" placeholder="Địa chỉ cụ thể (Số nhà, tên đường...)">
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="switchModal('newAddressModal', 'addressListModal')">Trở lại</button>
            <button class="btn-red" onclick="saveNewAddress()">Hoàn thành</button>
        </div>
    </div>
</div>

<div class="modal" id="cardListModal">
    <div class="modal-content">
        <div class="modal-header">Chọn Thẻ</div>
        <div class="modal-body">
            <div class="item-list">
                <label class="item-row">
                    <input type="radio" name="cardRadio" checked value="💳 Visa **** 1234">
                    <div style="font-size: 14px;"><strong>Visa</strong> **** 1234</div>
                </label>
                <label class="item-row">
                    <input type="radio" name="cardRadio" value="💳 MasterCard **** 5678">
                    <div style="font-size: 14px;"><strong>MasterCard</strong> **** 5678</div>
                </label>
            </div>
            <button class="btn-add-new" onclick="switchModal('cardListModal', 'newCardModal')"><span>+</span> Thêm Thẻ Mới</button>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="closeModal('cardListModal')">Huỷ</button>
            <button class="btn-red" onclick="confirmCard()">Xác nhận</button>
        </div>
    </div>
</div>

<div class="modal" id="newCardModal">
    <div class="modal-content">
        <div class="modal-header">Thêm Thẻ Mới</div>
        <div class="modal-body">
            <div class="form-group"><input type="text" id="newCardNum" placeholder="Số thẻ (VD: 4123 4567 8901 2345)"></div>
            <div class="form-group"><input type="text" id="newCardName" placeholder="Tên in trên thẻ (Không dấu)"></div>
            <div class="form-grid">
                <div class="form-group"><input type="text" id="newCardExp" placeholder="Ngày hết hạn (MM/YY)"></div>
                <div class="form-group"><input type="text" id="newCardCvv" placeholder="Mã CVV"></div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="switchModal('newCardModal', 'cardListModal')">Trở lại</button>
            <button class="btn-red" onclick="saveNewCard()">Hoàn thành</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>

</body>
</html>