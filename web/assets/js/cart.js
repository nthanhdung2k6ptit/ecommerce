document.addEventListener("DOMContentLoaded", function () {

    // ==========================================
    // 1. TÍNH TOÁN TỔNG TIỀN VÀ CẬP NHẬT GIAO DIỆN
    // ==========================================
    function updateCart() {
        let grandTotal = 0;
        let totalItems = 0;
        let selectedCount = 0;

        document.querySelectorAll('.shop-block').forEach(shop => {
            let shopCheckedAll = true;
            let hasProduct = false;

            shop.querySelectorAll('.product-row').forEach(row => {
                hasProduct = true;
                let checkbox = row.querySelector('.prod-checkbox');
                let priceElem = row.querySelector('.prod-price');
                let qtyInput = row.querySelector('.cart-qty-input');
                
                if (priceElem && qtyInput) {
                    let price = parseInt(priceElem.getAttribute('data-price')) || 0;
                    let qty = parseInt(qtyInput.value) || 1;
                    
                    // Cập nhật thành tiền từng dòng
                    let subtotal = price * qty;
                    row.querySelector('.prod-subtotal').innerText = '₫' + subtotal.toLocaleString('vi-VN');

                    // Cộng dồn nếu được tick chọn
                    if (checkbox && checkbox.checked) {
                        grandTotal += subtotal;
                        totalItems += qty;
                        selectedCount++;
                    } else {
                        shopCheckedAll = false;
                    }
                }
            });

            // Tự động tick/bỏ tick ô của Shop
            let shopCheckbox = shop.querySelector('.shop-parent');
            if (shopCheckbox && hasProduct) {
                shopCheckbox.checked = shopCheckedAll;
            }
        });

        // Cập nhật text tổng tiền hiển thị
        const grandTotalElem = document.getElementById('grand-total');
        const totalItemsElem = document.getElementById('total-items');
        const selectedCountElem = document.getElementById('selected-count');
        const cartBadge = document.getElementById('cart-count-badge');

        if(grandTotalElem) grandTotalElem.innerText = '₫' + grandTotal.toLocaleString('vi-VN');
        if(totalItemsElem) totalItemsElem.innerText = totalItems;
        if(selectedCountElem) selectedCountElem.innerText = selectedCount;

        if (cartBadge) {
            let allProductsCount = document.querySelectorAll('.product-row').length;
            cartBadge.innerText = allProductsCount;
        }

        checkEmptyCart(); // Kiểm tra xem giỏ hàng có trống không
    }

    // ==========================================
    // 2. KIỂM TRA GIỎ HÀNG TRỐNG
    // ==========================================
    function checkEmptyCart() {
        const cartItems = document.querySelectorAll('.product-row');
        const cartForm = document.getElementById('cart-form');
        const emptyCart = document.querySelector('.empty-cart');
        
        if (cartItems.length === 0 && cartForm && emptyCart) {
            cartForm.style.display = 'none';
            emptyCart.style.display = 'flex';
        }
    }

    // ==========================================
    // 3. ĐIỀU KHIỂN SỐ LƯỢNG (CỘNG / TRỪ)
    // ==========================================
    document.querySelectorAll('.cart-qty-minus').forEach(btn => {
        btn.addEventListener('click', function () {
            let input = this.nextElementSibling;
            let currentVal = parseInt(input.value) || 1;
            input.value = Math.max(1, currentVal - 1);
            updateCart();
        });
    });

    document.querySelectorAll('.cart-qty-plus').forEach(btn => {
        btn.addEventListener('click', function () {
            let input = this.previousElementSibling;
            let currentVal = parseInt(input.value) || 1;
            input.value = currentVal + 1;
            updateCart();
        });
    });

    document.querySelectorAll('.cart-qty-input').forEach(input => {
        input.addEventListener('input', function () {
            this.value = this.value.replace(/[^0-9]/g, '');
            if (this.value === "" || parseInt(this.value) < 1) this.value = 1;
            updateCart();
        });
    });

    // ==========================================
    // 4. XỬ LÝ LẮNG NGHE CHECKBOX
    // ==========================================
    const chkAllTop = document.getElementById('chk-all-top');
    const chkAllBottom = document.getElementById('chk-all-bottom');
    const shopCheckboxes = document.querySelectorAll('.shop-parent');
    const prodCheckboxes = document.querySelectorAll('.prod-checkbox');

    function toggleAll(status) {
        if(chkAllTop) chkAllTop.checked = status;
        if(chkAllBottom) chkAllBottom.checked = status;
        document.querySelectorAll('.shop-parent').forEach(chk => chk.checked = status);
        document.querySelectorAll('.prod-checkbox').forEach(chk => chk.checked = status);
        updateCart();
    }

    if(chkAllTop) chkAllTop.addEventListener('change', (e) => toggleAll(e.target.checked));
    if(chkAllBottom) chkAllBottom.addEventListener('change', (e) => toggleAll(e.target.checked));

    shopCheckboxes.forEach(shopChk => {
        shopChk.addEventListener('change', function() {
            let block = this.closest('.shop-block');
            block.querySelectorAll('.prod-checkbox').forEach(p => p.checked = this.checked);
            updateGlobalCheckAll();
            updateCart();
        });
    });

    prodCheckboxes.forEach(prodChk => {
        prodChk.addEventListener('change', function() {
            updateGlobalCheckAll();
            updateCart();
        });
    });

    function updateGlobalCheckAll() {
        let allProds = document.querySelectorAll('.prod-checkbox');
        let allChecked = allProds.length > 0 && Array.from(allProds).every(p => p.checked);
        if(chkAllTop) chkAllTop.checked = allChecked;
        if(chkAllBottom) chkAllBottom.checked = allChecked;
    }

    // ==========================================
    // 5. MODAL XÓA SẢN PHẨM & XÓA NHIỀU MỤC
    // ==========================================
    const deleteModal = document.getElementById("deleteModal");
    const hiddenInputId = document.getElementById("delete-item-id");
    const modalCancelBtn = document.querySelector(".btn-modal-cancel");
    const modalConfirmBtn = document.getElementById("confirmDeleteBtn");

    // Mở Modal khi bấm nút Thùng rác
    document.querySelectorAll(".btn-delete-trigger").forEach(btn => {
        btn.addEventListener("click", function () {
            hiddenInputId.value = this.getAttribute("data-id");
            if(deleteModal) deleteModal.classList.add("show");
        });
    });

    // Đóng Modal
    if(modalCancelBtn) {
        modalCancelBtn.addEventListener("click", () => {
            deleteModal.classList.remove("show");
            hiddenInputId.value = "";
        });
    }

    // Xác nhận xóa (Demo Frontend - Backend sẽ xử lý qua Form/Ajax sau)
    if(modalConfirmBtn) {
        modalConfirmBtn.addEventListener("click", function () {
            const idToDelete = hiddenInputId.value;
            if (idToDelete) {
                const btn = document.querySelector(`.btn-delete-trigger[data-id="${idToDelete}"]`);
                if (btn) {
                    let row = btn.closest('.product-row');
                    let shopBlock = row.closest('.shop-block');
                    row.remove();
                    if(shopBlock.querySelectorAll('.product-row').length === 0) {
                        shopBlock.remove();
                    }
                }
            }
            deleteModal.classList.remove("show");
            updateCart();
        });
    }

    // Xóa các mục đã chọn ở thanh Bottom
    const btnDeleteSelected = document.querySelector(".btn-delete-selected");
    if (btnDeleteSelected) {
        btnDeleteSelected.addEventListener("click", function() {
            let checkedBoxes = document.querySelectorAll('.prod-checkbox:checked');
            if (checkedBoxes.length === 0) {
                alert("Bạn chưa chọn sản phẩm nào để xóa!");
                return;
            }
            if (confirm(`Bạn có chắc chắn muốn xóa ${checkedBoxes.length} sản phẩm đã chọn?`)) {
                checkedBoxes.forEach(chk => {
                    let row = chk.closest('.product-row');
                    let shopBlock = row.closest('.shop-block');
                    row.remove();
                    if(shopBlock.querySelectorAll('.product-row').length === 0) {
                        shopBlock.remove();
                    }
                });
                updateGlobalCheckAll();
                updateCart();
            }
        });
    }

    // ==========================================
    // 6. KIỂM TRA TRƯỚC KHI SUBMIT FORM THANH TOÁN
    // ==========================================
    const cartForm = document.getElementById("cart-form");
    if (cartForm) {
        cartForm.addEventListener("submit", function(event) {
            let checkedBoxes = document.querySelectorAll('.prod-checkbox:checked');
            if(checkedBoxes.length === 0) {
                event.preventDefault(); // Chặn Form submit
                alert("Vui lòng chọn ít nhất 1 sản phẩm để thanh toán nha Matcha!");
            }
            // Nếu có chọn, Form sẽ tự động ném dữ liệu sang file checkout qua phương thức POST
        });
    }

    // Khởi chạy tính toán lần đầu
    updateCart();
});