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
        <a href="${pageContext.request.contextPath}/client/homepage.jsp" style="text-decoration: none; color: var(--red);">CDG</a>
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

        <div id="checkout-item-list"></div>

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
          <span>Tổng số tiền (0 sản phẩm):</span>
          <span class="subtotal-amount">₫0</span>
        </div>
      </div>

      <div class="card">
        <div class="payment-section">
          <div class="payment-title">Phương thức thanh toán</div>
          <div class="payment-options">
            <button class="pay-btn" onclick="selectPayMethod(this, 'cod')">Thanh toán khi nhận hàng</button>
            <button class="pay-btn active" id="btn-credit" onclick="selectPayMethod(this, 'credit')">Thẻ Tín dụng/Ghi nợ</button>
          </div>

          <div id="credit-card-info" style="display:block;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
                <span id="display-card" style="font-size: 14px; font-weight: 500; color: #333;">Đang chọn thẻ: 💳 Visa **** 1234</span>
                <span class="btn-change" onclick="openModal('cardListModal')" style="font-size: 12px;">Thay đổi thẻ</span>
            </div>
          </div>
        </div>

        <div style="background: #fffefb; padding: 20px 0; border-top: 1px solid #eee;">
            <div class="summary-line"><span>Tổng tiền hàng</span><span class="s-value">₫0</span></div>
            <div class="summary-line"><span>Phí vận chuyển</span><span class="s-value">₫28.500</span></div>
            <div class="total-line">
              <span style="font-size: 16px; color: #222;">Tổng thanh toán</span>
              <span class="total-amount">₫0</span>
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
    <div class="modal-content" style="width: 600px;">
        <div class="modal-header">Địa Chỉ Của Tôi</div>
        <div class="modal-body">
            <div class="item-list">
                <label class="item-row" style="align-items: flex-start;">
                    <input type="radio" name="addrRadio" checked value="Matcha (+84) 901 234 567|Ký túc xá PTIT, Hà Đông, Hà Nội">
                    <div style="flex: 1;">
                        <strong class="a-name">Matcha</strong> <span class="a-phone">(+84) 901 234 567</span><br>
                        <span class="a-detail" style="color:#666;font-size:13px;margin-top:4px;display:block;">Ký túc xá PTIT, Hà Đông, Hà Nội</span>
                        <span class="tag-default" style="margin-top:6px;display:inline-block;">Mặc định</span>
                    </div>
                    <span class="btn-edit-addr" onclick="openEditAddress(this, event)">Cập nhật</span>
                </label>

                <label class="item-row" style="align-items: flex-start;">
                    <input type="radio" name="addrRadio" value="Giang Hoàng (+84) 988 777 666|Số 12 Nguyễn Trãi, Thanh Xuân, Hà Nội">
                    <div style="flex: 1;">
                        <strong class="a-name">Giang Hoàng</strong> <span class="a-phone">(+84) 988 777 666</span><br>
                        <span class="a-detail" style="color:#666;font-size:13px;margin-top:4px;display:block;">Số 12 Nguyễn Trãi, Thanh Xuân, Hà Nội</span>
                    </div>
                    <span class="btn-edit-addr" onclick="openEditAddress(this, event)">Cập nhật</span>
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
    <div class="modal-content" style="width: 550px;">
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
                <div id="addrErrorMsg" class="error-message">Bạn chưa điền hết các thông tin cần thiết, vui lòng điền đầy đủ để tiếp tục.</div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="switchModal('newAddressModal', 'addressListModal')">Trở lại</button>
            <button class="btn-red" onclick="saveNewAddress()">Hoàn thành</button>
        </div>
    </div>
</div>

<div class="modal" id="editAddressModal">
    <div class="modal-content" style="width: 550px;">
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
                <div id="editAddrErrorMsg" class="error-message">Bạn chưa điền hết các thông tin cần thiết, vui lòng điền đầy đủ để tiếp tục.</div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="switchModal('editAddressModal', 'addressListModal')">Trở lại</button>
            <button class="btn-red" onclick="saveEditAddress()">Lưu thay đổi</button>
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

<div class="modal" id="editAddressModal">
    <div class="modal-content" style="width: 550px;">
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
                <div id="editAddrErrorMsg" class="error-message">Bạn chưa điền hết các thông tin cần thiết, vui lòng điền đầy đủ để tiếp tục.</div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="switchModal('editAddressModal', 'addressListModal')">Trở lại</button>
            <button class="btn-red" onclick="saveEditAddress()">Lưu thay đổi</button>
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
            <div class="form-group">
                <input type="text" id="newCardNum" placeholder="Số thẻ (VD: 4123 4567 8901 2345)" maxlength="19">
                <div id="errCardNum" class="error-message">Số thẻ không hợp lệ (Phải là 16 số, thẻ Visa hoặc MasterCard).</div>
            </div>
            <div class="form-group">
                <input type="text" id="newCardName" placeholder="Tên in trên thẻ (Không dấu)">
                <div id="errCardName" class="error-message">Tên in trên thẻ không được để trống.</div>
            </div>
            <div class="form-grid">
                <div class="form-group">
                    <input type="text" id="newCardExp" placeholder="Ngày hết hạn (MM/YY)" maxlength="5">
                    <div id="errCardExp" class="error-message">Ngày hết hạn không hợp lệ hoặc đã quá hạn.</div>
                </div>
                <div class="form-group">
                    <input type="text" id="newCardCvv" placeholder="Mã CVV" maxlength="3">
                    <div id="errCardCvv" class="error-message">Mã CVV phải gồm 3 chữ số.</div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-outline" onclick="switchModal('newCardModal', 'cardListModal')">Trở lại</button>
            <button class="btn-red" onclick="saveNewCard()">Hoàn thành</button>
        </div>
    </div>
</div>
<div class="modal" id="successOrderModal" style="z-index: 9999;">
    <div class="modal-content" style="width: 450px; text-align: center; padding: 40px 30px; border-radius: 8px;">
        <img src="https://media.tenor.com/qoIGqkJ345gAAAAM/tick.gif" alt="Success Tick" style="width: 120px; height: 120px; margin: 0 auto 20px; object-fit: contain;">
        
        <h2 style="color: #4CAF50; font-size: 26px; font-weight: 800; margin-bottom: 10px;">ĐẶT HÀNG THÀNH CÔNG!</h2>
        <p style="color: #555; margin-bottom: 30px; font-size: 14px; line-height: 1.6;">
            Cảm ơn bạn đã tin tưởng và mua sắm tại hệ thống CDG.<br>Đơn hàng của bạn đang được đóng gói và chuẩn bị giao!
        </p>
        
        <button class="btn-red" style="width: 100%; padding: 14px; font-size: 16px; border-radius: 4px;" onclick="window.location.href='homepage.jsp'">VỀ TRANG CHỦ</button>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>

</body>
</html>