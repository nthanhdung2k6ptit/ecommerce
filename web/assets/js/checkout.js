// ==========================================
// 1. RENDER SẢN PHẨM TỪ GIỎ HÀNG SANG
// ==========================================
document.addEventListener("DOMContentLoaded", function() {
    loadCheckoutItems();
    fetchCities(); // Kích hoạt gọi API Tỉnh/Thành ngay khi vào trang
    setupValidationClear(); // Cài đặt tự động xóa viền đỏ khi gõ
});

function loadCheckoutItems() {
    let container = document.getElementById('checkout-item-list');
    if (!container) return; 

    let itemsJson = sessionStorage.getItem('checkoutItems');
    if(!itemsJson) {
        return;
    }

    let items = JSON.parse(itemsJson);
    let html = '';
    let totalAmount = 0;
    let totalQty = 0;
    let currentShop = '';

    // Lặp qua dữ liệu và render HTML
    items.forEach(item => {
        // Nhóm theo tên Shop
        if(item.shop !== currentShop) {
            html += `<div class="shop-row">${item.shop}</div>`;
            currentShop = item.shop;
        }

        let itemTotal = item.price * item.qty;
        totalAmount += itemTotal;
        totalQty += item.qty;

        html += `
        <div class="product-row">
            <div class="product-cell">
                <div class="product-thumb">
                    <img src="${item.image}" alt="Thumb" style="width: 100%; height: 100%; object-fit: cover;">
                </div>
                <div>
                    <div class="product-name">${item.name}</div>
                    <div class="product-variant">${item.variant}</div>
                </div>
            </div>
            <div class="cell-price text-center">${item.priceText}</div>
            <div class="cell-qty">${item.qty}</div>
            <div class="cell-total">₫${itemTotal.toLocaleString('vi-VN')}</div>
        </div>`;
    });

    // In ra màn hình
    container.innerHTML = html;

    // --- Cập nhật lại các con số tổng tiền ---
    let shippingFee = 28500; // Phí ship mặc định
    let grandTotal = totalAmount + shippingFee;

    // Cập nhật số lượng hiển thị ở dòng Subtotal
    let subtotalRow = document.querySelector('.subtotal-row span:first-child');
    if(subtotalRow) subtotalRow.innerText = `Tổng số tiền (${totalQty} sản phẩm):`;
    
    let subtotalAmount = document.querySelector('.subtotal-amount');
    if(subtotalAmount) subtotalAmount.innerText = `₫${totalAmount.toLocaleString('vi-VN')}`;
    
    // Cập nhật phần tóm tắt đơn hàng ở dưới cùng
    let summaryValues = document.querySelectorAll('.s-value');
    if(summaryValues.length >= 2) {
        summaryValues[0].innerText = `₫${totalAmount.toLocaleString('vi-VN')}`; // Tổng tiền hàng
    }
    
    let totalAmountEl = document.querySelector('.total-amount');
    if(totalAmountEl) totalAmountEl.innerText = `₫${grandTotal.toLocaleString('vi-VN')}`; // Tổng thanh toán
}


// ==========================================
// 2. XỬ LÝ GIAO DIỆN CƠ BẢN & MODAL
// ==========================================

// Xử lý chọn Phương thức thanh toán (Ẩn/Hiện thông tin thẻ)
function selectPayMethod(btn, type) {
    document.querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('credit-card-info').style.display = (type === 'credit') ? 'block' : 'none';
}

// Modal Controls
function openModal(id) { document.getElementById(id).style.display = 'flex'; }
function closeModal(id) { document.getElementById(id).style.display = 'none'; }
function switchModal(closeId, openId) {
    closeModal(closeId);
    openModal(openId);
}

// Đóng modal khi bấm ra ngoài vùng xám
window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
}


// ==========================================
// 3. LÔ-GIC ĐỊA CHỈ & VALIDATION LỖI
// ==========================================

function confirmAddress() {
    const selected = document.querySelector('input[name="addrRadio"]:checked').value;
    const [namePart, detailPart] = selected.split('|');
    document.getElementById('display-name').innerText = namePart;
    document.getElementById('display-addr').innerText = detailPart;
    closeModal('addressListModal');
}

function saveNewAddress() {
    // Lấy các element để dễ thao tác viền đỏ
    const nameEl = document.getElementById('newAddrName');
    const phoneEl = document.getElementById('newAddrPhone');
    const cityEl = document.getElementById('city');
    const districtEl = document.getElementById('district');
    const wardEl = document.getElementById('ward');
    const streetEl = document.getElementById('newAddrStreet');
    const errorMsg = document.getElementById('addrErrorMsg');
    
    // Lấy giá trị
    const name = nameEl.value.trim();
    const phone = phoneEl.value.trim();
    const city = cityEl.value;
    const district = districtEl.value;
    const ward = wardEl.value;
    const street = streetEl.value.trim();
    
    let isValid = true;

    // 1. Xóa hết viền đỏ cũ trước khi kiểm tra lại
    [nameEl, phoneEl, cityEl, districtEl, wardEl, streetEl].forEach(el => {
        if(el) el.classList.remove('has-error');
    });
    if(errorMsg) errorMsg.style.display = 'none';

    // 2. Kiểm tra từng ô, ô nào rỗng thì bôi đỏ ô đó
    if (!name) { nameEl.classList.add('has-error'); isValid = false; }
    if (!phone) { phoneEl.classList.add('has-error'); isValid = false; }
    if (!city) { cityEl.classList.add('has-error'); isValid = false; }
    if (!district) { districtEl.classList.add('has-error'); isValid = false; }
    if (!ward) { wardEl.classList.add('has-error'); isValid = false; }
    if (!street) { streetEl.classList.add('has-error'); isValid = false; }

    // 3. Nếu có lỗi thì hiện dòng chữ báo lỗi và dừng lại
    if (!isValid) {
        if(errorMsg) errorMsg.style.display = 'block';
        return; 
    }

    // Nếu qua được vòng kiểm tra thì Nối chuỗi và Lưu
    const fullAddress = `${street}, ${ward}, ${district}, ${city}`;

    document.getElementById('display-name').innerText = name + ' (+84) ' + phone;
    document.getElementById('display-addr').innerText = fullAddress;
    
    closeModal('newAddressModal');
    
    // Reset form sạch sẽ
    nameEl.value = '';
    phoneEl.value = '';
    streetEl.value = '';
    cityEl.selectedIndex = 0;
    districtEl.innerHTML = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
    wardEl.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>';
}

// Xóa viền đỏ ngay khi người dùng bắt đầu nhập hoặc chọn
function setupValidationClear() {
    const inputs = document.querySelectorAll('#newAddressModal input, #newAddressModal select');
    inputs.forEach(el => {
        el.addEventListener('input', function() {
            this.classList.remove('has-error');
        });
        el.addEventListener('change', function() {
            this.classList.remove('has-error');
        });
    });
}


// ==========================================
// 4. API LẤY DANH SÁCH TỈNH THÀNH VIỆT NAM
// ==========================================
const apiHost = "https://provinces.open-api.vn/api/";

// Lấy danh sách Tỉnh/Thành phố khi vừa mở trang
function fetchCities() {
    let citySelect = document.getElementById('city');
    if(!citySelect) return;

    fetch(apiHost + "?depth=1")
    .then(response => response.json())
    .then(data => {
        let html = '<option value="" selected disabled>Chọn Tỉnh/Thành phố</option>';
        data.forEach(city => {
            html += `<option value="${city.name}" data-code="${city.code}">${city.name}</option>`;
        });
        citySelect.innerHTML = html;
    })
    .catch(err => console.error("Lỗi tải API tỉnh thành:", err));
}

// Khi người dùng chọn Tỉnh -> Đổ dữ liệu Quận/Huyện
let citySelect = document.getElementById('city');
if(citySelect) {
    citySelect.addEventListener('change', function() {
        let cityCode = this.options[this.selectedIndex].getAttribute('data-code');
        fetch(apiHost + "p/" + cityCode + "?depth=2")
        .then(response => response.json())
        .then(data => {
            let html = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
            data.districts.forEach(district => {
                html += `<option value="${district.name}" data-code="${district.code}">${district.name}</option>`;
            });
            document.getElementById('district').innerHTML = html;
            // Xóa trắng Phường/Xã cũ
            document.getElementById('ward').innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>'; 
        });
    });
}

// Khi người dùng chọn Quận/Huyện -> Đổ dữ liệu Phường/Xã
let districtSelect = document.getElementById('district');
if(districtSelect) {
    districtSelect.addEventListener('change', function() {
        let districtCode = this.options[this.selectedIndex].getAttribute('data-code');
        fetch(apiHost + "d/" + districtCode + "?depth=2")
        .then(response => response.json())
        .then(data => {
            let html = '<option value="" selected disabled>Chọn Phường/Xã</option>';
            data.wards.forEach(ward => {
                html += `<option value="${ward.name}" data-code="${ward.code}">${ward.name}</option>`;
            });
            document.getElementById('ward').innerHTML = html;
        });
    });
}


// ==========================================
// 5. LÔ-GIC THẺ & ĐẶT HÀNG
// ==========================================
function confirmCard() {
    const selected = document.querySelector('input[name="cardRadio"]:checked').value;
    document.getElementById('display-card').innerText = "Đang chọn thẻ: " + selected;
    closeModal('cardListModal');
}

function saveNewCard() {
    const cardNum = document.getElementById('newCardNum').value || '1234';
    // Lấy 4 số cuối của thẻ để hiển thị
    const last4 = cardNum.slice(-4);
    
    document.getElementById('display-card').innerText = "Đang chọn thẻ: 💳 Visa **** " + last4;
    closeModal('newCardModal');
    
    // Reset form
    document.getElementById('newCardNum').value = '';
    document.getElementById('newCardName').value = '';
    document.getElementById('newCardExp').value = '';
    document.getElementById('newCardCvv').value = '';
}

// Đặt hàng
let btnOrder = document.querySelector('.btn-order');
if(btnOrder) {
    btnOrder.addEventListener('click', function() {
        alert("Đặt hàng thành công! CDG cảm ơn Matcha nhé ^^");
        sessionStorage.removeItem('checkoutItems'); // Xóa giỏ hàng tạm
        window.location.href = 'homepage.jsp'; // Đẩy về trang chủ (Nhớ sửa lại URL cho khớp với Tomcat nếu cần)
    });
}