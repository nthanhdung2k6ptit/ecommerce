document.addEventListener('DOMContentLoaded', function() {
    console.log("=== HỆ THỐNG GIỎ HÀNG ĐÃ KHỞI CHẠY BẢN MỚI NHẤT ===");

    const cartForm = document.getElementById('cart-form');
    const ctx = cartForm ? cartForm.getAttribute('action').replace('/checkout', '') : '';

    function formatCurrency(num) {
        return '₫' + num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }

    function calculateTotal() {
        let grandTotal = 0;
        let selectedCount = 0;
        let totalItemsQty = 0;

        document.querySelectorAll('.product-row').forEach(row => {
            const checkbox = row.querySelector('.prod-checkbox');
            if (checkbox && checkbox.checked) {
                const priceElem = row.querySelector('.prod-price');
                const qtyInput = row.querySelector('.cart-qty-input');
                
                if (priceElem && qtyInput) {
                    const price = parseInt(priceElem.getAttribute('data-price')) || 0;
                    const qty = parseInt(qtyInput.value) || 1;
                    
                    grandTotal += (price * qty);
                    selectedCount += 1; 
                    totalItemsQty += qty; 
                }
            }
        });

        const selectedCountElem = document.getElementById('selected-count');
        const totalItemsElem = document.getElementById('total-items');
        const grandTotalElem = document.getElementById('grand-total');

        if (selectedCountElem) selectedCountElem.innerText = selectedCount;
        if (totalItemsElem) totalItemsElem.innerText = totalItemsQty;
        if (grandTotalElem) grandTotalElem.innerText = formatCurrency(grandTotal);
    }

    // XỬ LÝ CHECKBOX (CHỌN TẤT CẢ)
    const chkTop = document.getElementById('chk-all-top');
    const chkBottom = document.getElementById('chk-all-bottom');
    const chkShop = document.querySelector('.shop-parent');
    const prodCheckboxes = document.querySelectorAll('.prod-checkbox');

    function syncCheckboxes(state) {
        if (chkTop) chkTop.checked = state;
        if (chkBottom) chkBottom.checked = state;
        if (chkShop) chkShop.checked = state;
        prodCheckboxes.forEach(cb => cb.checked = state);
        calculateTotal();
    }

    [chkTop, chkBottom, chkShop].forEach(chk => {
        if (chk) {
            chk.addEventListener('change', function() {
                syncCheckboxes(this.checked);
            });
        }
    });

    prodCheckboxes.forEach(cb => {
        cb.addEventListener('change', function() {
            let allChecked = document.querySelectorAll('.prod-checkbox:checked').length === prodCheckboxes.length;
            if (chkTop) chkTop.checked = allChecked;
            if (chkBottom) chkBottom.checked = allChecked;
            if (chkShop) chkShop.checked = allChecked;
            calculateTotal();
        });
    });

    // XỬ LÝ NÚT CỘNG TRỪ (ĐÃ FIX SỰ KIỆN CLICK)
    document.querySelectorAll('.cart-qty-minus, .cart-qty-plus').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const row = this.closest('.product-row');
            const input = row.querySelector('.cart-qty-input');
            const productId = row.querySelector('.btn-delete-trigger').getAttribute('data-id');
            let qty = parseInt(input.value) || 1;

            if (this.classList.contains('cart-qty-minus')) {
                if (qty > 1) qty--;
            } else {
                qty++;
            }
            updateCartItem(row, input, productId, qty);
        });
    });

    document.querySelectorAll('.cart-qty-input').forEach(input => {
        input.addEventListener('change', function() {
            const row = this.closest('.product-row');
            const productId = row.querySelector('.btn-delete-trigger').getAttribute('data-id');
            let qty = parseInt(this.value) || 1;
            if (qty < 1) qty = 1;
            updateCartItem(row, this, productId, qty);
        });
    });

    function updateCartItem(row, input, productId, qty) {
        input.value = qty;
        const price = parseInt(row.querySelector('.prod-price').getAttribute('data-price')) || 0;
        row.querySelector('.prod-subtotal').innerText = formatCurrency(price * qty);
        calculateTotal();

        // Đồng bộ ngầm với Java Database
        fetch(`${ctx}/cart/update?productId=${productId}&quantity=${qty}`)
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success' && data.adjusted) {
                    alert(`❌ Kho chỉ còn tối đa ${data.maxStock} sản phẩm!`);
                    input.value = data.maxStock;
                    row.querySelector('.prod-subtotal').innerText = formatCurrency(price * data.maxStock);
                    calculateTotal();
                }
            })
            .catch(err => console.log('Lỗi cập nhật giỏ hàng:', err));
    }

    // XỬ LÝ NÚT XÓA SẢN PHẨM (POPUP)
    const deleteModal = document.getElementById('deleteModal');
    const deleteInput = document.getElementById('delete-item-id');
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    const cancelDeleteBtn = document.querySelector('.btn-cancel');

    document.querySelectorAll('.btn-delete-trigger').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            if (deleteInput) deleteInput.value = id;
            if (deleteModal) deleteModal.classList.add('show');
        });
    });

    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener('click', function() {
            if (deleteModal) deleteModal.classList.remove('show');
        });
    }

    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener('click', function() {
            const id = deleteInput.value;
            window.location.href = `${ctx}/cart/remove?productId=${id}`;
        });
    }

    if (cartForm) {
        cartForm.addEventListener('submit', function(e) {
            const checkedBoxes = document.querySelectorAll('.prod-checkbox:checked');
            if (checkedBoxes.length === 0) {
                e.preventDefault();
                alert("🛒 Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
            }
        });
    }

    calculateTotal();
});