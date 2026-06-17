document.addEventListener("DOMContentLoaded", function () {

    // 1. API TỈNH THÀNH
    bindApiToSelects('city', 'district', 'ward'); 
    bindApiToSelects('editCity', 'editDistrict', 'editWard'); 

    document.querySelectorAll('.modal input, .modal select').forEach(el => {
        el.addEventListener('input', function() { this.classList.remove('has-error'); });
        el.addEventListener('change', function() { this.classList.remove('has-error'); });
    });

    // 2. MODAL CHUNG
    function openModal(id) {
        const modal = document.getElementById(id);
        if(modal) modal.classList.add('show');
    }

    function closeModal(id) {
        const modal = document.getElementById(id);
        if(modal) modal.classList.remove('show');
    }

    document.querySelectorAll('.trigger-close-modal').forEach(btn => {
        btn.addEventListener('click', function() { closeModal(this.getAttribute('data-target')); });
    });

    document.querySelectorAll('.trigger-switch-modal').forEach(btn => {
        btn.addEventListener('click', function() {
            closeModal(this.getAttribute('data-from'));
            openModal(this.getAttribute('data-to'));
        });
    });

    window.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal')) e.target.classList.remove('show');
    });

    // 3. ĐỊA CHỈ NHẬN HÀNG
    const hiddenAddressId = document.getElementById("selectedAddressId");
    const currentAddressData = document.getElementById("current-address-data");
    const addressEmptyWarning = document.getElementById("address-empty-warning");
    const mainDefaultTag = document.querySelector('#current-address-data .tag-default');

    document.getElementById("btn-change-address")?.addEventListener("click", () => openModal("addressListModal"));
    document.getElementById("btn-add-new-address-warning")?.addEventListener("click", () => openModal("addressListModal"));

    document.getElementById("btn-delete-address")?.addEventListener("click", () => {
        if(confirm("Bạn có chắc chắn muốn xóa địa chỉ nhận hàng này?")) {
            hiddenAddressId.value = "";
            currentAddressData.style.display = "none";
            addressEmptyWarning.style.display = "block";
        }
    });

    document.getElementById("confirmAddressBtn")?.addEventListener("click", () => {
        const selectedRadio = document.querySelector('input[name="addrRadio"]:checked');
        if (selectedRadio) {
            hiddenAddressId.value = selectedRadio.value;
            const name = selectedRadio.getAttribute('data-name');
            const phone = selectedRadio.getAttribute('data-phone');
            const detail = selectedRadio.getAttribute('data-detail');
            
            document.getElementById("display-name").innerText = `${name} ${phone}`;
            document.getElementById("display-addr").innerText = detail;

            const hasDefault = selectedRadio.closest('.item-row').querySelector('.tag-default') !== null;
            if (mainDefaultTag) mainDefaultTag.style.display = hasDefault ? 'inline-block' : 'none'; 

            addressEmptyWarning.style.display = "none";
            currentAddressData.style.display = "flex";
        }
        closeModal("addressListModal");
    });

    document.getElementById("saveNewAddressBtn")?.addEventListener("click", () => {
        const nameEl = document.getElementById('newAddrName'), phoneEl = document.getElementById('newAddrPhone');
        const cityEl = document.getElementById('city'), districtEl = document.getElementById('district'), wardEl = document.getElementById('ward');
        const streetEl = document.getElementById('newAddrStreet'), errorMsg = document.getElementById('addrErrorMsg');
        
        if (!validateAddressForm(nameEl, phoneEl, cityEl, districtEl, wardEl, streetEl, errorMsg)) return;

        const name = nameEl.value.trim();
        let phoneRaw = phoneEl.value.trim();
        if(phoneRaw.startsWith('0')) phoneRaw = phoneRaw.substring(1);
        const phoneFormatted = `(+84) ${phoneRaw}`; 
        const fullAddress = `${streetEl.value.trim()}, ${wardEl.value}, ${districtEl.value}, ${cityEl.value}`;
        
        const isDefault = document.getElementById('newAddrDefault').checked ? 1 : 0;

        // BẮN AJAX XUỐNG API ĐỂ LƯU THẬT VÀO DATABASE
        fetch('api/address/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `name=${encodeURIComponent(name)}&phone=${encodeURIComponent(phoneFormatted)}&province=${encodeURIComponent(cityEl.value)}&district=${encodeURIComponent(districtEl.value)}&ward=${encodeURIComponent(wardEl.value)}&street=${encodeURIComponent(streetEl.value)}&isDefault=${isDefault}`
        })
        .then(r => r.json())
        .then(data => {
            if (data.status === 'success') {
                const newId = data.newId; // ĐÂY MỚI LÀ ID THẬT NÈ!

                const addressListContainer = document.querySelector('#addressListModal .item-list');
                if (addressListContainer) {
                    if (isDefault) addressListContainer.querySelectorAll('.tag-default').forEach(tag => tag.remove());
                    addressListContainer.querySelectorAll('input[type="radio"]').forEach(r => r.checked = false);

                    let defaultTagHtml = isDefault ? `<span class="tag-default tag-mt">Mặc định</span>` : '';
                    const newRowHtml = `
                        <label class="item-row item-start">
                            <input type="radio" name="addrRadio" checked value="${newId}" data-name="${name}" data-phone="${phoneFormatted}" data-detail="${fullAddress}">
                            <div class="item-flex">
                                <strong class="a-name">${name}</strong> <span class="a-phone">${phoneFormatted}</span><br>
                                <span class="a-detail addr-sub-text">${fullAddress}</span>
                                ${defaultTagHtml}
                            </div>
                            <span class="btn-edit-addr trigger-edit-addr" data-id="${newId}">Cập nhật</span>
                        </label>
                    `;
                    addressListContainer.insertAdjacentHTML('afterbegin', newRowHtml);
                }

                document.getElementById('display-name').innerText = `${name} ${phoneFormatted}`;
                document.getElementById('display-addr').innerText = fullAddress;
                
                // Gắn ID thật vào form Checkout
                hiddenAddressId.value = newId;

                if (mainDefaultTag) mainDefaultTag.style.display = isDefault ? 'inline-block' : 'none';

                addressEmptyWarning.style.display = "none";
                currentAddressData.style.display = "flex";
                closeModal('newAddressModal');
                
                nameEl.value = ''; phoneEl.value = ''; streetEl.value = '';
                document.getElementById('newAddrDefault').checked = false;
                cityEl.selectedIndex = 0;
                districtEl.innerHTML = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
                wardEl.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>';
            } else {
                alert("Lỗi lưu địa chỉ: " + data.message);
            }
        })
        .catch(err => console.error("Lỗi:", err));
    });

    let currentEditRow = null; 

    document.getElementById('addressListModal')?.addEventListener('click', function(e) {
        if (e.target.classList.contains('trigger-edit-addr')) {
            e.preventDefault(); e.stopPropagation();
            currentEditRow = e.target.closest('.item-row');
            
            let name = currentEditRow.querySelector('.a-name').innerText;
            let phone = currentEditRow.querySelector('.a-phone').innerText.replace('(+84)', '0').replace(/\s/g, '').trim();
            let detail = currentEditRow.querySelector('.a-detail').innerText;
            let hasDefaultTag = currentEditRow.querySelector('.tag-default') !== null;

            let parts = detail.split(',');
            let streetOnly = detail;
            if (parts.length >= 4) streetOnly = parts.slice(0, parts.length - 3).join(',').trim();
            else if (parts.length > 1) streetOnly = parts[0].trim();

            document.getElementById('editAddrName').value = name;
            document.getElementById('editAddrPhone').value = phone;
            document.getElementById('editAddrStreet').value = streetOnly; 
            document.getElementById('editAddrDefault').checked = hasDefaultTag;

            document.getElementById('editCity').selectedIndex = 0;
            document.getElementById('editDistrict').innerHTML = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
            document.getElementById('editWard').innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>';

            closeModal('addressListModal');
            openModal('editAddressModal');
        }
    });

    document.getElementById("saveEditAddressBtn")?.addEventListener("click", () => {
        const nameEl = document.getElementById('editAddrName'), phoneEl = document.getElementById('editAddrPhone');
        const cityEl = document.getElementById('editCity'), districtEl = document.getElementById('editDistrict'), wardEl = document.getElementById('editWard');
        const streetEl = document.getElementById('editAddrStreet'), errorMsg = document.getElementById('editAddrErrorMsg');
        
        if (!validateAddressForm(nameEl, phoneEl, cityEl, districtEl, wardEl, streetEl, errorMsg)) return;

        const name = nameEl.value.trim();
        let phoneRaw = phoneEl.value.trim();
        if(phoneRaw.startsWith('0')) phoneRaw = phoneRaw.substring(1);
        const phoneFormatted = `(+84) ${phoneRaw}`; 
        const fullAddress = `${streetEl.value.trim()}, ${wardEl.value}, ${districtEl.value}, ${cityEl.value}`;
        const isDefault = document.getElementById('editAddrDefault').checked;

        if(currentEditRow) {
            currentEditRow.querySelector('.a-name').innerText = name;
            currentEditRow.querySelector('.a-phone').innerText = phoneFormatted;
            currentEditRow.querySelector('.a-detail').innerText = fullAddress;
            
            let radioInput = currentEditRow.querySelector('input[type="radio"]');
            radioInput.setAttribute('data-name', name);
            radioInput.setAttribute('data-phone', phoneFormatted);
            radioInput.setAttribute('data-detail', fullAddress);

            if(isDefault) {
                document.querySelectorAll('#addressListModal .tag-default').forEach(tag => tag.remove());
                if(!currentEditRow.querySelector('.tag-default')) {
                    currentEditRow.querySelector('.item-flex').insertAdjacentHTML('beforeend', '<span class="tag-default tag-mt">Mặc định</span>');
                }
            } else {
                let tag = currentEditRow.querySelector('.tag-default');
                if(tag) tag.remove();
            }

            if(radioInput.checked) {
                document.getElementById('display-name').innerText = `${name} ${phoneFormatted}`;
                document.getElementById('display-addr').innerText = fullAddress;
                if (mainDefaultTag) mainDefaultTag.style.display = isDefault ? 'inline-block' : 'none';
            }
        }
        closeModal('editAddressModal');
        openModal('addressListModal'); 
    });


    // 🌟 4. LỜI NHẮN
    const noteInput = document.getElementById('orderNoteInput');
    const hiddenOrderNote = document.getElementById('hiddenOrderNote');
    const noteInputBox = document.getElementById('note-input-container');
    const noteResultBox = document.getElementById('note-display-container');
    const noteTextDisplay = document.getElementById('note-text-display');
    const btnEditNote = document.getElementById('btn-edit-note');
    const btnDeleteNote = document.getElementById('btn-delete-note');

    if (noteInput) {
        noteInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault(); 
                let text = this.value.trim();
                if (text !== "") {
                    hiddenOrderNote.value = text;
                    noteTextDisplay.innerText = `"${text}"`;
                    noteInputBox.style.display = 'none';
                    noteResultBox.style.display = 'flex';
                } else {
                    this.blur();
                }
            }
        });
    }

    if (btnEditNote) {
        btnEditNote.addEventListener('click', function() {
            noteInput.value = hiddenOrderNote.value; 
            noteResultBox.style.display = 'none';
            noteInputBox.style.display = 'block';
            noteInput.focus();
        });
    }

    if (btnDeleteNote) {
        btnDeleteNote.addEventListener('click', function() {
            hiddenOrderNote.value = ""; 
            noteInput.value = ""; 
            noteResultBox.style.display = 'none';
            noteInputBox.style.display = 'block';
        });
    }

    // 5. VẬN CHUYỂN TÍNH TIỀN TỰ ĐỘNG
    const shippingSelect = document.getElementById('shippingMethodSelect');
    const shipDateDisplay = document.getElementById('ship-date-display');
    const summaryShippingFee = document.getElementById('summary-shipping-fee');
    const summaryGrandTotal = document.getElementById('summary-grand-total');

    shippingSelect?.addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        const fee = parseInt(selectedOption.getAttribute('data-fee'));
        const dateText = selectedOption.getAttribute('data-date');
        
        let currentSubTotal = parseInt(document.getElementById('subtotal-display').getAttribute('data-subtotal'));
        let discount = parseInt(document.getElementById('hiddenDiscountAmount')?.value || 0);

        if(shipDateDisplay) shipDateDisplay.innerText = dateText;
        if(summaryShippingFee) summaryShippingFee.innerText = '₫' + fee.toLocaleString('vi-VN');
        
        let newTotal = currentSubTotal + fee - discount;
        if(summaryGrandTotal) summaryGrandTotal.innerText = '₫' + (newTotal > 0 ? newTotal : 0).toLocaleString('vi-VN');
    });

    // 6. THANH TOÁN (PAYMENT) & CHỐT ĐƠN
    const hiddenPaymentMethod = document.getElementById("selectedPaymentMethod");
    
    document.querySelectorAll('.pay-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            const method = this.getAttribute('data-method');
            hiddenPaymentMethod.value = method; 
            document.getElementById('credit-card-info').style.display = (method === 'credit') ? 'block' : 'none';
        });
    });

    document.getElementById("btn-change-card")?.addEventListener("click", () => openModal("cardListModal"));

    document.getElementById("confirmCardBtn")?.addEventListener("click", () => {
        let checkedRadio = document.querySelector('input[name="cardRadio"]:checked');
        if(!checkedRadio) return;
        document.getElementById('display-card').innerText = "Đang chọn thẻ: " + checkedRadio.getAttribute('data-text');
        closeModal('cardListModal');
    });

    document.getElementById('newCardNum')?.addEventListener('input', function (e) {
        let value = e.target.value.replace(/\D/g, ''); 
        value = value.replace(/(.{4})/g, '$1 ').trim();
        e.target.value = value;
    });

    document.getElementById('newCardExp')?.addEventListener('input', function (e) {
        let value = e.target.value.replace(/\D/g, ''); 
        if (value.length > 2) value = value.substring(0, 2) + '/' + value.substring(2, 4); 
        e.target.value = value;
    });

    document.getElementById('newCardName')?.addEventListener('input', function (e) {
        this.value = this.value.toUpperCase().replace(/[^A-Z\s]/g, '');
    });

    document.getElementById('newCardCvv')?.addEventListener('input', function (e) {
        this.value = this.value.replace(/\D/g, '');
    });

    document.getElementById("saveNewCardBtn")?.addEventListener("click", () => {
        const numEl = document.getElementById('newCardNum'), nameEl = document.getElementById('newCardName');
        const expEl = document.getElementById('newCardExp'), cvvEl = document.getElementById('newCardCvv');
        const numErr = document.getElementById('errCardNum'), nameErr = document.getElementById('errCardName');
        const expErr = document.getElementById('errCardExp'), cvvErr = document.getElementById('errCardCvv');

        let isValid = true;
        [numEl, nameEl, expEl, cvvEl].forEach(el => el.classList.remove('has-error'));
        [numErr, nameErr, expErr, cvvErr].forEach(el => el.style.display = 'none');

        let num = numEl.value.replace(/\s/g, '');
        if(!/^(4[0-9]{15}|5[1-5][0-9]{14})$/.test(num)) { numEl.classList.add('has-error'); numErr.style.display = 'block'; isValid = false; }
        if(nameEl.value.trim().length < 2) { nameEl.classList.add('has-error'); nameErr.style.display = 'block'; isValid = false; }
        if(!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expEl.value.trim())) { expEl.classList.add('has-error'); expErr.style.display = 'block'; isValid = false; }
        if(!/^\d{3}$/.test(cvvEl.value.trim())) { cvvEl.classList.add('has-error'); cvvErr.style.display = 'block'; isValid = false; }

        if(!isValid) return;

        let cardType = num.startsWith('4') ? 'Visa' : 'MasterCard';
        let displayStr = `💳 ${cardType} **** ${num.slice(-4)}`;
        
        document.getElementById('display-card').innerText = "Đang chọn thẻ: " + displayStr;
        closeModal('newCardModal');
        numEl.value = ''; nameEl.value = ''; expEl.value = ''; cvvEl.value = '';
    });

    const checkoutForm = document.getElementById("checkout-form");
    if (checkoutForm) {
        checkoutForm.insertAdjacentHTML('beforeend', '<input type="hidden" name="voucherId" id="hiddenVoucherId" value="">');
        checkoutForm.insertAdjacentHTML('beforeend', '<input type="hidden" name="discountAmount" id="hiddenDiscountAmount" value="0">');

        checkoutForm.addEventListener("submit", function(event) {
            event.preventDefault(); 
            if (!hiddenAddressId.value || hiddenAddressId.value.trim() === "") {
                alert("Bạn chưa thiết lập Địa chỉ nhận hàng! Vui lòng cập nhật để tiếp tục.");
                return;
            }
            document.getElementById('successOrderModal').classList.add('show');
            sessionStorage.removeItem('checkoutItems'); 
            setTimeout(function() { checkoutForm.submit(); }, 2000);
        });
    }

    // ==========================================
    // 7. XỬ LÝ VOUCHER BẰNG AJAX
    // ==========================================
    const btnApplyVoucher = document.getElementById('btnApplyVoucher');
    const voucherInput = document.getElementById('voucherCodeInput');
    const voucherMsg = document.getElementById('voucherMsg');
    const subtotalDisplay = document.getElementById('subtotal-display');

    if (btnApplyVoucher) {
        btnApplyVoucher.addEventListener('click', function() {
            let code = voucherInput.value.trim();
            let subTotal = subtotalDisplay.getAttribute('data-subtotal');

            if (code === "") {
                voucherMsg.innerText = "Vui lòng nhập mã giảm giá!";
                voucherMsg.style.color = "#e74c3c";
                return;
            }

            // Gọi API kiểm tra Voucher ngầm
            // Bắn AJAX kiểm tra Voucher
            fetch('api/voucher/check', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `code=${code}&subTotal=${subTotal}`
            })
            .then(response => response.json())
            .then(data => {
                let currentFee = parseInt(shippingSelect.options[shippingSelect.selectedIndex].getAttribute('data-fee'));
                
                // MỚI: Bắt các thẻ hiển thị dòng Giảm giá
                const discountRow = document.getElementById('summary-discount-row');
                const discountValue = document.getElementById('summary-discount-value');

                if (data.status === 'success') {
                    voucherMsg.innerText = data.message + ` (Giảm ₫${data.discountAmount.toLocaleString('vi-VN')})`;
                    voucherMsg.style.color = "#2ecc71";
                    
                    document.getElementById('hiddenVoucherId').value = data.voucherId;
                    document.getElementById('hiddenDiscountAmount').value = data.discountAmount;

                    // HIỆN DÒNG GIẢM GIÁ 
                    if (discountRow) discountRow.style.display = 'flex';
                    if (discountValue) discountValue.innerText = '-₫' + data.discountAmount.toLocaleString('vi-VN');

                    // Tính lại tổng tiền
                    let newTotal = parseInt(subTotal) + currentFee - data.discountAmount;
                    summaryGrandTotal.innerText = '₫' + (newTotal > 0 ? newTotal : 0).toLocaleString('vi-VN');
                } else {
                    voucherMsg.innerText = data.message; 
                    voucherMsg.style.color = "#e74c3c";
                    document.getElementById('hiddenVoucherId').value = "";
                    document.getElementById('hiddenDiscountAmount').value = "0";
                    
                    // ẨN DÒNG GIẢM GIÁ NẾU MÃ SAI
                    if (discountRow) discountRow.style.display = 'none';
                    if (discountValue) discountValue.innerText = '-₫0';
                    
                    // Trả lại giá cũ
                    summaryGrandTotal.innerText = '₫' + (parseInt(subTotal) + currentFee).toLocaleString('vi-VN');
                }
            })
            .catch(err => console.error("Lỗi áp mã:", err));
        });
    }
});

// CÁC HÀM VALIDATE CHUNG
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

    if (!isValid && errorMsg) errorMsg.style.display = 'block';
    return isValid;
}

function bindApiToSelects(cityId, distId, wardId) {
    let citySelect = document.getElementById(cityId);
    let distSelect = document.getElementById(distId);
    let wardSelect = document.getElementById(wardId);
    if(!citySelect) return;

    fetch("https://esgoo.net/api-tinhthanh/1/0.htm").then(r => r.json()).then(response => {
        if(response.error === 0) {
            let html = '<option value="" selected disabled>Chọn Tỉnh/Thành phố</option>';
            response.data.forEach(c => html += `<option value="${c.full_name}" data-code="${c.id}">${c.full_name}</option>`);
            citySelect.innerHTML = html;
        }
    }).catch(err => console.error("Lỗi tải API tỉnh thành:", err));

    citySelect.addEventListener('change', function() {
        let code = this.options[this.selectedIndex].getAttribute('data-code');
        fetch("https://esgoo.net/api-tinhthanh/2/" + code + ".htm").then(r => r.json()).then(response => {
            if(response.error === 0) {
                let html = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
                response.data.forEach(d => html += `<option value="${d.full_name}" data-code="${d.id}">${d.full_name}</option>`);
                distSelect.innerHTML = html;
                wardSelect.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>'; 
            }
        });
    });

    distSelect.addEventListener('change', function() {
        let code = this.options[this.selectedIndex].getAttribute('data-code');
        fetch("https://esgoo.net/api-tinhthanh/3/" + code + ".htm").then(r => r.json()).then(response => {
            if(response.error === 0) {
                let html = '<option value="" selected disabled>Chọn Phường/Xã</option>';
                response.data.forEach(w => html += `<option value="${w.full_name}" data-code="${w.id}">${w.full_name}</option>`);
                wardSelect.innerHTML = html;
            }
        });
    });
}