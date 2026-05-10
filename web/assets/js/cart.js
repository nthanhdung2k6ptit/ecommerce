// ==========================================
// 1. TÍNH TOÁN TỔNG TIỀN VÀ CẬP NHẬT GIAO DIỆN
// ==========================================
function updateCart() {
    let grandTotal = 0;
    let totalItems = 0;
    let selectedCount = 0;

    // Lặp qua tất cả các khối shop
    document.querySelectorAll('.shop-block').forEach(shop => {
        let shopCheckedAll = true;
        let hasProduct = false;

        // Lặp qua từng sản phẩm trong shop
        shop.querySelectorAll('.product-row').forEach(row => {
            hasProduct = true;
            let checkbox = row.querySelector('.prod-checkbox');
            let price = parseInt(row.querySelector('.prod-price').getAttribute('data-price'));
            let qty = parseInt(row.querySelector('input[type="number"]').value);
            
            // Tính thành tiền của sản phẩm này
            let subtotal = price * qty;
            row.querySelector('.prod-subtotal').innerText = '₫' + subtotal.toLocaleString('vi-VN');

            // Nếu được tích chọn thì cộng vào tổng
            if (checkbox.checked) {
                grandTotal += subtotal;
                totalItems += qty;
                selectedCount++;
            } else {
                shopCheckedAll = false;
            }
        });

        // Xử lý tự động tích/bỏ tích checkbox của Shop
        let shopCheckbox = shop.querySelector('.shop-parent');
        if (shopCheckbox && hasProduct) {
            shopCheckbox.checked = shopCheckedAll;
        }
    });

    // Cập nhật giao diện tổng tiền
    document.getElementById('grand-total').innerText = '₫' + grandTotal.toLocaleString('vi-VN');
    document.getElementById('total-items').innerText = totalItems;
    document.getElementById('selected-count').innerText = selectedCount;

    // Cập nhật số lượng trên icon giỏ hàng ở Header
    let cartBadge = document.getElementById('cart-count-badge');
    if (cartBadge) {
        let allProductsCount = document.querySelectorAll('.product-row').length;
        cartBadge.innerText = allProductsCount;
    }
}

// ==========================================
// 2. XỬ LÝ CỘNG/TRỪ SỐ LƯỢNG SẢN PHẨM
// ==========================================
function changeQty(btn, delta) {
    let input = btn.parentElement.querySelector('input[type="number"]');
    let currentVal = parseInt(input.value);
    let newVal = currentVal + delta;
    
    // Không cho số lượng nhỏ hơn 1
    if (newVal < 1) newVal = 1;
    
    input.value = newVal;
    updateCart(); // Gọi lại hàm tính tiền
}

// ==========================================
// 3. XỬ LÝ CÁC CHECKBOX CHỌN SẢN PHẨM
// ==========================================
function setupCheckboxListeners() {
    let chkAllTop = document.getElementById('chk-all-top');
    let chkAllBottom = document.getElementById('chk-all-bottom');
    let shopCheckboxes = document.querySelectorAll('.shop-parent');
    let prodCheckboxes = document.querySelectorAll('.prod-checkbox');

    // Nút "Chọn tất cả" (Top & Bottom)
    function toggleAll(status) {
        chkAllTop.checked = status;
        chkAllBottom.checked = status;
        shopCheckboxes.forEach(chk => chk.checked = status);
        prodCheckboxes.forEach(chk => chk.checked = status);
        updateCart();
    }

    if(chkAllTop) chkAllTop.addEventListener('change', (e) => toggleAll(e.target.checked));
    if(chkAllBottom) chkAllBottom.addEventListener('change', (e) => toggleAll(e.target.checked));

    // Checkbox của từng Shop
    shopCheckboxes.forEach(shopChk => {
        shopChk.addEventListener('change', function() {
            let block = this.closest('.shop-block');
            let prodsInShop = block.querySelectorAll('.prod-checkbox');
            prodsInShop.forEach(p => p.checked = this.checked);
            updateGlobalCheckAll();
            updateCart();
        });
    });

    // Checkbox của từng Sản phẩm
    prodCheckboxes.forEach(prodChk => {
        prodChk.addEventListener('change', function() {
            updateGlobalCheckAll();
            updateCart();
        });
    });

    // Hàm tự động bỏ chọn "Chọn tất cả" nếu có 1 ô bị bỏ chọn
    function updateGlobalCheckAll() {
        let allProds = document.querySelectorAll('.prod-checkbox');
        let allChecked = Array.from(allProds).every(p => p.checked);
        if(chkAllTop) chkAllTop.checked = allChecked;
        if(chkAllBottom) chkAllBottom.checked = allChecked;
    }
}

// ==========================================
// 4. XỬ LÝ XÓA SẢN PHẨM & MODAL
// ==========================================
let currentRowToDelete = null;

function showDeleteModal(btn) {
    currentRowToDelete = btn.closest('.product-row');
    document.getElementById('deleteModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('deleteModal').style.display = 'none';
    currentRowToDelete = null;
}

// Xóa 1 sản phẩm
let confirmBtn = document.getElementById('confirmDeleteBtn');
if (confirmBtn) {
    confirmBtn.addEventListener('click', function() {
        if (currentRowToDelete) {
            let shopBlock = currentRowToDelete.closest('.shop-block');
            currentRowToDelete.remove();
            
            // Xóa luôn khối Shop nếu không còn sản phẩm nào
            let remainingProds = shopBlock.querySelectorAll('.product-row');
            if(remainingProds.length === 0) {
                shopBlock.remove();
            }
        }
        closeModal();
        updateCart();
    });
}

// Xóa các sản phẩm đã chọn (nút Xóa ở thanh Bottom)
function removeSelected() {
    let checkedBoxes = document.querySelectorAll('.prod-checkbox:checked');
    if (checkedBoxes.length === 0) {
        alert("Bạn chưa chọn sản phẩm nào để xóa!");
        return;
    }

    if (confirm("Bạn có chắc chắn muốn xóa " + checkedBoxes.length + " sản phẩm đã chọn?")) {
        checkedBoxes.forEach(chk => {
            let row = chk.closest('.product-row');
            let shopBlock = row.closest('.shop-block');
            row.remove();
            
            if(shopBlock.querySelectorAll('.product-row').length === 0) {
                shopBlock.remove();
            }
        });
        updateCart();
    }
}

// ==========================================
// 5. CHUYỂN DỮ LIỆU SANG TRANG THANH TOÁN (CHECKOUT)
// ==========================================
// ==========================================
// 5. CHUYỂN DỮ LIỆU SANG TRANG THANH TOÁN (CHECKOUT)
// ==========================================
function goToCheckout(checkoutUrl) {
    let selectedItems = [];
    let checkedBoxes = document.querySelectorAll('.prod-checkbox:checked');
    
    // Nếu không tick sản phẩm nào thì chặn lại không cho sang trang
    if(checkedBoxes.length === 0) {
        alert("Vui lòng chọn ít nhất 1 sản phẩm để thanh toán nha Matcha!");
        return;
    }

    // Lặp qua các sản phẩm được chọn để lấy thông tin
    checkedBoxes.forEach(chk => {
        let row = chk.closest('.product-row');
        let shopName = row.closest('.shop-block').querySelector('.shop-name').innerText;
        
        let item = {
            shop: shopName,
            name: row.querySelector('.prod-name').innerText,
            variant: row.querySelector('.prod-variant') ? row.querySelector('.prod-variant').innerText : '',
            image: row.querySelector('.prod-thumb img').src,
            price: parseInt(row.querySelector('.prod-price').getAttribute('data-price')),
            priceText: row.querySelector('.prod-price').innerText,
            qty: parseInt(row.querySelector('input[type="number"]').value)
        };
        selectedItems.push(item);
    });

    // Lưu vào sessionStorage để trang checkout lấy ra dùng
    sessionStorage.setItem('checkoutItems', JSON.stringify(selectedItems));
    
    // Đẩy sang trang checkout theo đường dẫn Java Web
    window.location.href = checkoutUrl || 'checkout.jsp'; 
}

// ==========================================
// 6. KHỞI CHẠY KHI TẢI TRANG
// ==========================================
document.addEventListener("DOMContentLoaded", function() {
    setupCheckboxListeners();
    updateCart(); // Tính toán lần đầu khi vừa vào trang
});