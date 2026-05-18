<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CDG - Thanh Toán</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css?v=perfect_2">
</head>
<body>

<header class="site-header">
  <div class="container">
    <div class="header-logo-wrap">
      <div class="logo">
        <a href="${pageContext.request.contextPath}/client/homepage.jsp" class="logo-link">CDG</a>
      </div>
      <div class="header-divider"></div>
      <div class="header-page-title">Thanh Toán</div>
    </div>
  </div>
</header>

<div class="container">
    <div class="page-wrap">

        <form action="${pageContext.request.contextPath}/placeOrder" method="POST" id="checkout-form">
            
            <input type="hidden" name="addressId" id="selectedAddressId" value="ADDR_01">
            <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="credit">

            <div class="card">
                <div class="address-section">
                    <div class="address-header-row">
                        <div class="address-label">📍 Địa Chỉ Nhận Hàng</div>
                        <div class="address-actions">
                            <span class="btn-change" id="btn-change-address">Thay Đổi</span>
                            <span class="btn-delete-addr" id="btn-delete-address">Xóa</span>
                        </div>
                    </div>
                    
                    <div class="address-row" id="current-address-data">
                        <span class="address-name" id="display-name">Matcha (+84) 901 234 567</span>
                        <span class="address-detail" id="display-addr">Ký túc xá PTIT, Hà Đông, Hà Nội</span>
                        <span class="tag-default">Mặc định</span>
                    </div>

                    <div class="address-empty-warning" id="address-empty-warning">
                        <p>⚠️ Bạn chưa có địa chỉ nhận hàng. Vui lòng thêm địa chỉ để tiếp tục đặt hàng!</p>
                        <button type="button" class="btn-add-addr" id="btn-add-new-address-warning">Thiết lập địa chỉ</button>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="table-header">
                    <span>Sản phẩm</span>
                    <span class="text-center">Đơn giá</span>
                    <span class="text-center">Số lượng</span>
                    <span class="text-right">Thành tiền</span>
                </div>

                <div class="checkout-item-list">
                    <div class="shop-group">
                        <div class="shop-name-header">🏪 VAMI Shop Phụ Kiện</div>
                        
                        <div class="checkout-prod-row">
                            <div class="prod-info-checkout">
                                <img src="${pageContext.request.contextPath}/assets/img/anh46.jpg" alt="SP" class="prod-img-mini">
                                <div>
                                    <div class="prod-name-checkout">VAMI Dây Chuyền Bạc Nữ Mặt Trái Tim Đính Đá</div>
                                    <div class="prod-variant-checkout">Phân loại hàng: Bạc Ý 925</div>
                                </div>
                            </div>
                            <div class="text-center mobile-label-price">₫99.000</div>
                            <div class="text-center mobile-label-qty">x1</div>
                            <div class="text-right prod-total-price">₫99.000</div>
                        </div>

                        <div class="checkout-prod-row">
                            <div class="prod-info-checkout">
                                <img src="${pageContext.request.contextPath}/assets/img/anh41.jpg" alt="SP" class="prod-img-mini">
                                <div>
                                    <div class="prod-name-checkout">VAMI Khuyên Tai Bạc Nữ Phong Cách Hàn Quốc</div>
                                    <div class="prod-variant-checkout">Phân loại hàng: Bạc Ý 925</div>
                                </div>
                            </div>
                            <div class="text-center mobile-label-price">₫45.000</div>
                            <div class="text-center mobile-label-qty">x2</div>
                            <div class="text-right prod-total-price">₫90.000</div>
                        </div>
                    </div>
                </div>

                <div class="note-shipping-row">
                    <div class="note-wrap">
                        <span class="note-label">Lời nhắn:</span>
                        
                        <div id="note-input-container" class="note-input-box">
                            <input class="note-input" type="text" id="orderNoteInput" placeholder="Lưu ý cho người bán...">
                        </div>

                        <div id="note-display-container" class="note-result-box">
                            <span id="note-text-display" class="note-text-saved"></span>
                            <div class="note-actions">
                                <span id="btn-edit-note" class="btn-note-edit">Sửa</span>
                                <span id="btn-delete-note" class="btn-note-delete">Xóa</span>
                            </div>
                        </div>

                        <input type="hidden" name="orderNote" id="hiddenOrderNote" value="">
                    </div>

                    <div class="shipping-info">
                        <div class="ship-row">
                            <span class="label">Đơn vị vận chuyển:</span>
                            <select name="shippingMethod" id="shippingMethodSelect" class="ship-select">
                                <option value="nhanh" data-fee="28500" data-date="Nhận hàng vào 25 Th4 - 27 Th4">Nhanh (₫28.500)</option>
                                <option value="cdge" data-fee="15000" data-date="Nhận hàng vào 24 Th4 - 25 Th4">CDGE Express (₫15.000)</option>
                            </select>
                        </div>
                        <div class="ship-date" id="ship-date-display">Nhận hàng vào 25 Th4 - 27 Th4</div>
                    </div>
                </div>

                <div class="subtotal-row">
                    <span>Tổng số tiền (3 sản phẩm):</span>
                    <span class="subtotal-amount">₫189.000</span>
                </div>
            </div>

            <div class="card">
                <div class="payment-section">
                    <div class="payment-title">Phương thức thanh toán</div>
                    <div class="payment-options">
                        <button type="button" class="pay-btn" data-method="cod">Thanh toán khi nhận hàng</button>
                        <button type="button" class="pay-btn active" data-method="credit">Thẻ Tín dụng/Ghi nợ</button>
                    </div>

                    <div id="credit-card-info" class="credit-card-display">
                        <div class="card-info-header">
                            <span id="display-card" class="card-text-highlight">Đang chọn thẻ: 💳 Visa **** 1234</span>
                            <span class="btn-change btn-change-card" id="btn-change-card">Thay đổi thẻ</span>
                        </div>
                    </div>
                </div>

                <div class="checkout-summary-box">
                    <div class="summary-line"><span>Tổng tiền hàng</span><span class="s-value" id="summary-items-total">₫189.000</span></div>
                    <div class="summary-line"><span>Phí vận chuyển</span><span class="s-value" id="summary-shipping-fee">₫28.500</span></div>
                    <div class="total-line">
                        <span class="total-lbl">Tổng thanh toán</span>
                        <span class="total-amount" id="summary-grand-total">₫217.500</span>
                    </div>
                </div>

                <div class="order-action">
                    <p class="policy-note">Nhấn "Đặt hàng" đồng nghĩa với việc bạn đồng ý tuân theo điều khoản CDG</p>
                    <button type="submit" class="btn-order">Đặt hàng</button>
                </div>
            </div>
        </form>

    </div> 
</div> 

<div class="modal" id="addressListModal">
    <div class="modal-content modal-lg">
        <div class="modal-header">Địa Chỉ Của Tôi</div>
        <div class="modal-body">
            <div class="item-list">
                <label class="item-row item-start">
                    <input type="radio" name="addrRadio" checked value="ADDR_01" data-name="Matcha" data-phone="(+84) 901 234 567" data-detail="Ký túc xá PTIT, Hà Đông, Hà Nội">
                    <div class="item-flex">
                        <strong class="a-name">Matcha</strong> <span class="a-phone">(+84) 901 234 567</span><br>
                        <span class="a-detail addr-sub-text">Ký túc xá PTIT, Hà Đông, Hà Nội</span>
                        <span class="tag-default tag-mt">Mặc định</span>
                    </div>
                    <span class="btn-edit-addr trigger-edit-addr" data-id="ADDR_01">Cập nhật</span>
                </label>

                <label class="item-row item-start">
                    <input type="radio" name="addrRadio" value="ADDR_02" data-name="Giang Hoàng" data-phone="(+84) 988 777 666" data-detail="Số 12 Nguyễn Trãi, Thanh Xuân, Hà Nội">
                    <div class="item-flex">
                        <strong class="a-name">Giang Hoàng</strong> <span class="a-phone">(+84) 988 777 666</span><br>
                        <span class="a-detail addr-sub-text">Số 12 Nguyễn Trãi, Thanh Xuân, Hà Nội</span>
                    </div>
                    <span class="btn-edit-addr trigger-edit-addr" data-id="ADDR_02">Cập nhật</span>
                </label>
            </div>
            <button type="button" class="btn-add-new trigger-switch-modal" data-from="addressListModal" data-to="newAddressModal"><span>+</span> Thêm Địa Chỉ Mới</button>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-outline trigger-close-modal" data-target="addressListModal">Huỷ</button>
            <button type="button" class="btn-red" id="confirmAddressBtn">Xác nhận</button>
        </div>
    </div>
</div>

<div class="modal" id="newAddressModal">
    <div class="modal-content modal-md">
        <div class="modal-header">Địa chỉ mới</div>
        <div class="modal-body">
            <div class="form-grid">
                <div class="form-group"><input type="text" id="newAddrName" placeholder="Họ và tên"></div>
                <div class="form-group"><input type="text" id="newAddrPhone" placeholder="Số điện thoại"></div>
            </div>
            <div class="form-grid-3">
                <div class="form-group"><select id="city" class="form-select"><option value="" selected disabled>Chọn Tỉnh/Thành phố</option></select></div>
                <div class="form-group"><select id="district" class="form-select"><option value="" selected disabled>Chọn Quận/Huyện</option></select></div>
                <div class="form-group"><select id="ward" class="form-select"><option value="" selected disabled>Chọn Phường/Xã</option></select></div>
            </div>
            <div class="form-group mt-15">
                <input type="text" id="newAddrStreet" placeholder="Địa chỉ cụ thể (Số nhà, tên đường...)">
                <div id="addrErrorMsg" class="error-message">Bạn chưa điền hết thông tin cần thiết.</div>
            </div>
            <div class="form-group mt-15">
                <label class="checkbox-label">
                    <input type="checkbox" id="newAddrDefault" class="custom-checkbox"> 
                    Đặt làm địa chỉ mặc định
                </label>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-outline trigger-switch-modal" data-from="newAddressModal" data-to="addressListModal">Trở lại</button>
            <button type="button" class="btn-red" id="saveNewAddressBtn">Hoàn thành</button>
        </div>
    </div>
</div>

<div class="modal" id="editAddressModal">
    <div class="modal-content modal-md">
        <div class="modal-header">Cập nhật địa chỉ</div>
        <div class="modal-body">
            <div class="form-grid">
                <div class="form-group"><input type="text" id="editAddrName" placeholder="Họ và tên"></div>
                <div class="form-group"><input type="text" id="editAddrPhone" placeholder="Số điện thoại"></div>
            </div>
            <div class="form-grid-3">
                <div class="form-group"><select id="editCity" class="form-select"><option value="" selected disabled>Chọn Tỉnh/Thành phố</option></select></div>
                <div class="form-group"><select id="editDistrict" class="form-select"><option value="" selected disabled>Chọn Quận/Huyện</option></select></div>
                <div class="form-group"><select id="editWard" class="form-select"><option value="" selected disabled>Chọn Phường/Xã</option></select></div>
            </div>
            <div class="form-group mt-15">
                <input type="text" id="editAddrStreet" placeholder="Địa chỉ cụ thể (Số nhà, tên đường...)">
                <div id="editAddrErrorMsg" class="error-message">Bạn chưa điền hết thông tin cần thiết.</div>
            </div>
            <div class="form-group mt-15">
                <label class="checkbox-label">
                    <input type="checkbox" id="editAddrDefault" class="custom-checkbox"> 
                    Đặt làm địa chỉ mặc định
                </label>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-outline trigger-switch-modal" data-from="editAddressModal" data-to="addressListModal">Trở lại</button>
            <button type="button" class="btn-red" id="saveEditAddressBtn">Lưu thay đổi</button>
        </div>
    </div>
</div>

<div class="modal" id="cardListModal">
    <div class="modal-content">
        <div class="modal-header">Chọn Thẻ</div>
        <div class="modal-body">
            <div class="item-list">
                <label class="item-row">
                    <input type="radio" name="cardRadio" checked value="CARD_01" data-text="💳 Visa **** 1234">
                    <div class="card-item-text"><strong>Visa</strong> **** 1234</div>
                </label>
                <label class="item-row">
                    <input type="radio" name="cardRadio" value="CARD_02" data-text="💳 MasterCard **** 5678">
                    <div class="card-item-text"><strong>MasterCard</strong> **** 5678</div>
                </label>
            </div>
            <button type="button" class="btn-add-new trigger-switch-modal" data-from="cardListModal" data-to="newCardModal"><span>+</span> Thêm Thẻ Mới</button>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-outline trigger-close-modal" data-target="cardListModal">Huỷ</button>
            <button type="button" class="btn-red" id="confirmCardBtn">Xác nhận</button>
        </div>
    </div>
</div>

<div class="modal" id="newCardModal">
    <div class="modal-content">
        <div class="modal-header">Thêm Thẻ Mới</div>
        <div class="modal-body">
            <div class="form-group">
                <input type="text" id="newCardNum" placeholder="Số thẻ (VD: 4123 4567 8901 2345)" maxlength="19">
                <div id="errCardNum" class="error-message">Số thẻ không hợp lệ.</div>
            </div>
            <div class="form-group">
                <input type="text" id="newCardName" placeholder="Tên in trên thẻ (Không dấu)">
                <div id="errCardName" class="error-message">Tên in trên thẻ không được để trống.</div>
            </div>
            <div class="form-grid">
                <div class="form-group">
                    <input type="text" id="newCardExp" placeholder="Ngày hết hạn (MM/YY)" maxlength="5">
                    <div id="errCardExp" class="error-message">Ngày hết hạn không hợp lệ.</div>
                </div>
                <div class="form-group">
                    <input type="text" id="newCardCvv" placeholder="Mã CVV" maxlength="3">
                    <div id="errCardCvv" class="error-message">Mã CVV phải gồm 3 chữ số.</div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-outline trigger-switch-modal" data-from="newCardModal" data-to="cardListModal">Trở lại</button>
            <button type="button" class="btn-red" id="saveNewCardBtn">Hoàn thành</button>
        </div>
    </div>
</div>

<div class="modal modal-success" id="successOrderModal">
    <div class="modal-content success-content">
        <img src="${pageContext.request.contextPath}/assets/img/tick.gif" alt="Success Tick" class="success-icon">
        <h2 class="success-title">ĐẶT HÀNG THÀNH CÔNG!</h2>
        <p class="success-desc">Cảm ơn bạn đã tin tưởng và mua sắm tại hệ thống CDG.<br>Đơn hàng của bạn đang được đóng gói và chuẩn bị giao!</p>
        <a href="${pageContext.request.contextPath}/client/homepage.jsp" class="btn-red btn-go-home">VỀ TRANG CHỦ</a>
    </div>
</div>

<div style="clear: both;"></div>

 
<script src="${pageContext.request.contextPath}/assets/js/checkout.js?v=perfect_1"></script>
</body>
</html>