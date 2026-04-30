// Xử lý chọn Phương thức thanh toán (Ẩn/Hiện thông tin thẻ)
    function selectPayMethod(btn, type) {
        document.querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById('credit-card-info').style.display = (type === 'credit') ? 'block' : 'none';
    }

    // Modal Controls cơ bản
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

    // ---- LÔ-GIC ĐỊA CHỈ ----
    function confirmAddress() {
        const selected = document.querySelector('input[name="addrRadio"]:checked').value;
        const [namePart, detailPart] = selected.split('|');
        document.getElementById('display-name').innerText = namePart;
        document.getElementById('display-addr').innerText = detailPart;
        closeModal('addressListModal');
    }

    function saveNewAddress() {
        const name = document.getElementById('newAddrName').value || 'Người Dùng Mới';
        const phone = document.getElementById('newAddrPhone').value || '0123456789';
        const street = document.getElementById('newAddrStreet').value || 'Địa chỉ chưa cập nhật';
        
        // Cập nhật thẳng ra ngoài giao diện (Như Shopee)
        document.getElementById('display-name').innerText = name + ' (+84) ' + phone;
        document.getElementById('display-addr').innerText = street;
        
        closeModal('newAddressModal');
        // Reset form
        document.getElementById('newAddrName').value = '';
        document.getElementById('newAddrPhone').value = '';
        document.getElementById('newAddrStreet').value = '';
    }

    // ---- LÔ-GIC THẺ ----
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