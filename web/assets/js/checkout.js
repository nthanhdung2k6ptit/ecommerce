// ==========================================
// 1. RENDER SẢN PHẨM TỪ GIỎ HÀNG SANG
// ==========================================
document.addEventListener("DOMContentLoaded", function() {
    loadCheckoutItems();
    
    // Kích hoạt API Tỉnh/Thành cho 2 form (Thêm mới và Sửa)
    bindApiToSelects('city', 'district', 'ward'); 
    bindApiToSelects('editCity', 'editDistrict', 'editWard'); 

    setupValidationClear(); // Cài đặt tự động xóa viền đỏ khi gõ
});

function loadCheckoutItems() {
    let container = document.getElementById('checkout-item-list');
    if (!container) return; 

    let itemsJson = sessionStorage.getItem('checkoutItems');
    if(!itemsJson) return;

    let items = JSON.parse(itemsJson);
    let html = '';
    let totalAmount = 0;
    let totalQty = 0;
    let currentShop = '';

    items.forEach(item => {
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

    container.innerHTML = html;

    let shippingFee = 28500; 
    let grandTotal = totalAmount + shippingFee;

    let subtotalRow = document.querySelector('.subtotal-row span:first-child');
    if(subtotalRow) subtotalRow.innerText = `Tổng số tiền (${totalQty} sản phẩm):`;
    
    let subtotalAmount = document.querySelector('.subtotal-amount');
    if(subtotalAmount) subtotalAmount.innerText = `₫${totalAmount.toLocaleString('vi-VN')}`;
    
    let summaryValues = document.querySelectorAll('.s-value');
    if(summaryValues.length >= 2) {
        summaryValues[0].innerText = `₫${totalAmount.toLocaleString('vi-VN')}`; 
    }
    
    let totalAmountEl = document.querySelector('.total-amount');
    if(totalAmountEl) totalAmountEl.innerText = `₫${grandTotal.toLocaleString('vi-VN')}`; 
}

// ==========================================
// 2. XỬ LÝ GIAO DIỆN CƠ BẢN & MODAL
// ==========================================
function selectPayMethod(btn, type) {
    document.querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('credit-card-info').style.display = (type === 'credit') ? 'block' : 'none';
}

function openModal(id) { document.getElementById(id).style.display = 'flex'; }
function closeModal(id) { document.getElementById(id).style.display = 'none'; }
function switchModal(closeId, openId) {
    closeModal(closeId);
    openModal(openId);
}

window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
}

// ==========================================
// 3. LÔ-GIC ĐỊA CHỈ (THÊM, SỬA, BẮT LỖI)
// ==========================================

// Bấm nút Xác nhận ở Modal Danh Sách
function confirmAddress() {
    let checkedRadio = document.querySelector('input[name="addrRadio"]:checked');
    if(!checkedRadio) {
        alert("Vui lòng chọn 1 địa chỉ!");
        return;
    }
    const [namePart, detailPart] = checkedRadio.value.split('|');
    document.getElementById('display-name').innerText = namePart;
    document.getElementById('display-addr').innerText = detailPart;
    closeModal('addressListModal');
}

// --- THÊM ĐỊA CHỈ MỚI ---
function saveNewAddress() {
    const nameEl = document.getElementById('newAddrName'), phoneEl = document.getElementById('newAddrPhone');
    const cityEl = document.getElementById('city'), districtEl = document.getElementById('district'), wardEl = document.getElementById('ward');
    const streetEl = document.getElementById('newAddrStreet'), errorMsg = document.getElementById('addrErrorMsg');
    
    let isValid = validateAddressForm(nameEl, phoneEl, cityEl, districtEl, wardEl, streetEl, errorMsg);
    if (!isValid) return;

    const name = nameEl.value.trim();
    let phoneRaw = phoneEl.value.trim();
    if(phoneRaw.startsWith('0')) phoneRaw = phoneRaw.substring(1);
    const phoneFormatted = `(+84) ${phoneRaw}`; 
    
    const fullAddress = `${streetEl.value.trim()}, ${wardEl.value}, ${districtEl.value}, ${cityEl.value}`;

    // Cập nhật ra ngoài màn hình chính
    document.getElementById('display-name').innerText = name + ' ' + phoneFormatted;
    document.getElementById('display-addr').innerText = fullAddress;

    // Chèn thêm vào Danh sách trong Modal
    const addressListContainer = document.querySelector('#addressListModal .item-list');
    if (addressListContainer) {
        // Bỏ check cũ
        addressListContainer.querySelectorAll('input[type="radio"]').forEach(radio => radio.checked = false);

        const newRowHtml = `
            <label class="item-row" style="align-items: flex-start;">
                <input type="radio" name="addrRadio" checked value="${name} ${phoneFormatted}|${fullAddress}">
                <div style="flex: 1;">
                    <strong class="a-name">${name}</strong> <span class="a-phone">${phoneFormatted}</span><br>
                    <span class="a-detail" style="color:#666;font-size:13px;margin-top:4px;display:block;">${fullAddress}</span>
                </div>
                <span class="btn-edit-addr" onclick="openEditAddress(this, event)">Cập nhật</span>
            </label>
        `;
        addressListContainer.insertAdjacentHTML('beforeend', newRowHtml);
    }

    closeModal('newAddressModal');
    
    // Reset Form
    nameEl.value = ''; phoneEl.value = ''; streetEl.value = '';
    cityEl.selectedIndex = 0;
    districtEl.innerHTML = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
    wardEl.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>';
}

// --- CẬP NHẬT ĐỊA CHỈ CŨ ---
let currentEditRow = null; // Biến lưu tạm dòng đang sửa

function openEditAddress(btn, event) {
    event.preventDefault(); 
    event.stopPropagation(); 

    currentEditRow = btn.closest('.item-row');

    // Đẩy data cũ lên Form
    let name = currentEditRow.querySelector('.a-name').innerText;
    let phone = currentEditRow.querySelector('.a-phone').innerText.replace('(+84)', '0').replace(/\s/g, '').trim();
    let detail = currentEditRow.querySelector('.a-detail').innerText;

    document.getElementById('editAddrName').value = name;
    document.getElementById('editAddrPhone').value = phone;
    document.getElementById('editAddrStreet').value = detail; 

    // Xoá viền đỏ (nếu có)
    document.querySelectorAll('#editAddressModal input, #editAddressModal select').forEach(el => el.classList.remove('has-error'));
    document.getElementById('editAddrErrorMsg').style.display = 'none';

    switchModal('addressListModal', 'editAddressModal');
}

function saveEditAddress() {
    const nameEl = document.getElementById('editAddrName'), phoneEl = document.getElementById('editAddrPhone');
    const cityEl = document.getElementById('editCity'), districtEl = document.getElementById('editDistrict'), wardEl = document.getElementById('editWard');
    const streetEl = document.getElementById('editAddrStreet'), errorMsg = document.getElementById('editAddrErrorMsg');

    let isValid = validateAddressForm(nameEl, phoneEl, cityEl, districtEl, wardEl, streetEl, errorMsg);
    if (!isValid) return;

    let phoneRaw = phoneEl.value.trim();
    if(phoneRaw.startsWith('0')) phoneRaw = phoneRaw.substring(1);
    const phoneFormatted = `(+84) ${phoneRaw}`; 

    const fullAddress = `${streetEl.value.trim()}, ${wardEl.value}, ${districtEl.value}, ${cityEl.value}`;
    const name = nameEl.value.trim();

    // Cập nhật lại HTML của dòng đang sửa
    if(currentEditRow) {
        currentEditRow.querySelector('.a-name').innerText = name;
        currentEditRow.querySelector('.a-phone').innerText = phoneFormatted;
        currentEditRow.querySelector('.a-detail').innerText = fullAddress;
        
        // Cập nhật Value cho thẻ radio
        let radioInput = currentEditRow.querySelector('input[type="radio"]');
        radioInput.value = `${name} ${phoneFormatted}|${fullAddress}`;
        
        // Nếu dòng này đang được tích chọn, thì cập nhật luôn màn hình chính
        if(radioInput.checked) {
            document.getElementById('display-name').innerText = name + ' ' + phoneFormatted;
            document.getElementById('display-addr').innerText = fullAddress;
        }
    }

    switchModal('editAddressModal', 'addressListModal'); 
}

// --- HÀM VALIDATE DÙNG CHUNG ---
function validateAddressForm(nameEl, phoneEl, cityEl, districtEl, wardEl, streetEl, errorMsg) {
    let isValid = true;
    [nameEl, phoneEl, cityEl, districtEl, wardEl, streetEl].forEach(el => { if(el) el.classList.remove('has-error'); });
    if(errorMsg) errorMsg.style.display = 'none';

    if (!nameEl.value.trim()) { nameEl.classList.add('has-error'); isValid = false; }
    if (!phoneEl.value.trim()) { phoneEl.classList.add('has-error'); isValid = false; }
    if (!cityEl.value) { cityEl.classList.add('has-error'); isValid = false; }
    if (!districtEl.value) { districtEl.classList.add('has-error'); isValid = false; }
    if (!wardEl.value) { wardEl.classList.add('has-error'); isValid = false; }
    if (!streetEl.value.trim()) { streetEl.classList.add('has-error'); isValid = false; }

    if (!isValid && errorMsg) {
        errorMsg.style.display = 'block';
    }
    return isValid;
}

function setupValidationClear() {
    document.querySelectorAll('.modal input, .modal select').forEach(el => {
        el.addEventListener('input', function() { this.classList.remove('has-error'); });
        el.addEventListener('change', function() { this.classList.remove('has-error'); });
    });
}

// ==========================================
// 4. API LẤY DANH SÁCH TỈNH THÀNH VIỆT NAM (API MỚI)
// ==========================================

// Hàm gắn API vào 3 ô dropdown (Dùng được cho cả form Thêm và form Sửa)
function bindApiToSelects(cityId, distId, wardId) {
    let citySelect = document.getElementById(cityId);
    let distSelect = document.getElementById(distId);
    let wardSelect = document.getElementById(wardId);

    if(!citySelect) return;

    // Load Tỉnh/Thành Phố
    fetch("https://esgoo.net/api-tinhthanh/1/0.htm")
    .then(r => r.json())
    .then(response => {
        if(response.error === 0) {
            let html = '<option value="" selected disabled>Chọn Tỉnh/Thành phố</option>';
            response.data.forEach(c => html += `<option value="${c.full_name}" data-code="${c.id}">${c.full_name}</option>`);
            citySelect.innerHTML = html;
        }
    }).catch(err => console.error("Lỗi tải API tỉnh thành:", err));

    // Chọn Tỉnh -> Load Quận/Huyện
    citySelect.addEventListener('change', function() {
        let code = this.options[this.selectedIndex].getAttribute('data-code');
        fetch("https://esgoo.net/api-tinhthanh/2/" + code + ".htm")
        .then(r => r.json())
        .then(response => {
            if(response.error === 0) {
                let html = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
                response.data.forEach(d => html += `<option value="${d.full_name}" data-code="${d.id}">${d.full_name}</option>`);
                distSelect.innerHTML = html;
                wardSelect.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>'; 
            }
        });
    });

    // Chọn Quận/Huyện -> Load Phường/Xã
    distSelect.addEventListener('change', function() {
        let code = this.options[this.selectedIndex].getAttribute('data-code');
        fetch("https://esgoo.net/api-tinhthanh/3/" + code + ".htm")
        .then(r => r.json())
        .then(response => {
            if(response.error === 0) {
                let html = '<option value="" selected disabled>Chọn Phường/Xã</option>';
                response.data.forEach(w => html += `<option value="${w.full_name}" data-code="${w.id}">${w.full_name}</option>`);
                wardSelect.innerHTML = html;
            }
        });
    });
}
// ==========================================
// 5. LÔ-GIC THẺ (VALIDATE THỰC TẾ) & ĐẶT HÀNG
// ==========================================

// --- Tự động định dạng (Auto-format) khi người dùng gõ phím ---
document.getElementById('newCardNum')?.addEventListener('input', function (e) {
    let value = e.target.value.replace(/\D/g, ''); // Xóa mọi ký tự không phải số
    // Tự động chèn dấu cách mỗi 4 số cho đẹp
    value = value.replace(/(.{4})/g, '$1 ').trim();
    e.target.value = value;
    this.classList.remove('has-error');
});

document.getElementById('newCardExp')?.addEventListener('input', function (e) {
    let value = e.target.value.replace(/\D/g, ''); // Chỉ lấy số
    if (value.length > 2) {
        value = value.substring(0, 2) + '/' + value.substring(2, 4); // Tự chèn dấu /
    }
    e.target.value = value;
    this.classList.remove('has-error');
});

document.getElementById('newCardName')?.addEventListener('input', function (e) {
    // Tự động viết hoa và xóa số/ký tự đặc biệt
    this.value = this.value.toUpperCase().replace(/[^A-Z\s]/g, '');
    this.classList.remove('has-error');
});

document.getElementById('newCardCvv')?.addEventListener('input', function (e) {
    this.value = this.value.replace(/\D/g, '');
    this.classList.remove('has-error');
});

// --- Lưu và Bắt Lỗi Thẻ ---
function confirmCard() {
    let checkedRadio = document.querySelector('input[name="cardRadio"]:checked');
    if(!checkedRadio) return;
    document.getElementById('display-card').innerText = "Đang chọn thẻ: " + checkedRadio.value;
    closeModal('cardListModal');
}

function saveNewCard() {
    const numEl = document.getElementById('newCardNum');
    const nameEl = document.getElementById('newCardName');
    const expEl = document.getElementById('newCardExp');
    const cvvEl = document.getElementById('newCardCvv');

    const numErr = document.getElementById('errCardNum');
    const nameErr = document.getElementById('errCardName');
    const expErr = document.getElementById('errCardExp');
    const cvvErr = document.getElementById('errCardCvv');

    let isValid = true;
    
    // Reset viền đỏ
    [numEl, nameEl, expEl, cvvEl].forEach(el => el.classList.remove('has-error'));
    [numErr, nameErr, expErr, cvvErr].forEach(el => el.style.display = 'none');

    // Lấy chuỗi số thẻ (bỏ đi khoảng trắng)
    let num = numEl.value.replace(/\s/g, '');
    
    // Validate Regex Visa (đầu 4) hoặc MasterCard (đầu 51-55) & đúng 16 số
    if(!/^(4[0-9]{15}|5[1-5][0-9]{14})$/.test(num)) {
        numEl.classList.add('has-error');
        numErr.style.display = 'block';
        isValid = false;
    }

    // Tên ít nhất 2 ký tự
    if(nameEl.value.trim().length < 2) {
        nameEl.classList.add('has-error');
        nameErr.style.display = 'block';
        isValid = false;
    }

    // Validate Ngày hết hạn (MM/YY) & không được là ngày quá khứ
    let exp = expEl.value.trim();
    if(!/^(0[1-9]|1[0-2])\/\d{2}$/.test(exp)) {
        expEl.classList.add('has-error');
        expErr.style.display = 'block';
        isValid = false;
    } else {
        let parts = exp.split('/');
        let month = parseInt(parts[0], 10);
        let year = parseInt("20" + parts[1], 10); // Đổi '26' thành 2026
        
        let now = new Date();
        let currentMonth = now.getMonth() + 1;
        let currentYear = now.getFullYear();
        
        if (year < currentYear || (year === currentYear && month < currentMonth)) {
            expEl.classList.add('has-error');
            expErr.innerText = "Thẻ đã hết hạn.";
            expErr.style.display = 'block';
            isValid = false;
        }
    }

    // CVV tròn 3 số
    let cvv = cvvEl.value.trim();
    if(!/^\d{3}$/.test(cvv)) {
        cvvEl.classList.add('has-error');
        cvvErr.style.display = 'block';
        isValid = false;
    }

    if(!isValid) return;

    // Phân loại thẻ dựa vào đầu số
    let cardType = num.startsWith('4') ? 'Visa' : 'MasterCard';
    let last4 = num.slice(-4);
    let displayStr = `💳 ${cardType} **** ${last4}`;
    
    // Thêm thẻ vào Danh sách bên trong Modal
    const cardListContainer = document.querySelector('#cardListModal .item-list');
    if (cardListContainer) {
        cardListContainer.querySelectorAll('input[type="radio"]').forEach(radio => radio.checked = false);
        const newRowHtml = `
            <label class="item-row">
                <input type="radio" name="cardRadio" checked value="${displayStr}">
                <div style="font-size: 14px;"><strong>${cardType}</strong> **** ${last4}</div>
            </label>
        `;
        cardListContainer.insertAdjacentHTML('beforeend', newRowHtml);
    }

    // Hiển thị ra màn hình chính
    document.getElementById('display-card').innerText = "Đang chọn thẻ: " + displayStr;
    closeModal('newCardModal');

    // Xóa form
    numEl.value = ''; nameEl.value = ''; expEl.value = ''; cvvEl.value = '';
}

// Click Đặt hàng
// Đặt hàng
let btnOrder = document.querySelector('.btn-order');
if(btnOrder) {
    btnOrder.addEventListener('click', function() {
        // Bật popup Đặt Hàng Thành Công có GIF tích xanh lên
        document.getElementById('successOrderModal').style.display = 'flex';
        
        // Xóa giỏ hàng tạm thời
        sessionStorage.removeItem('checkoutItems'); 
        
        // (Tùy chọn) Mi set thêm tính năng: Nếu user lười không bấm nút, 
        // thì 5 giây sau web tự động chuyển về Trang Chủ luôn cho xịn.
        setTimeout(function() {
            window.location.href = 'homepage.jsp'; 
        }, 5000);
    });
}