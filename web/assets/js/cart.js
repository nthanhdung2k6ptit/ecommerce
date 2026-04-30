let currentItemToDelete = null;

    function updateTotals() {
        let grandTotal = 0;
        let totalQty = 0;
        let hasItems = false;

        document.querySelectorAll('.product-row').forEach(row => {
            hasItems = true;
            const isChecked = row.querySelector('.prod-checkbox').checked;
            const price = parseInt(row.querySelector('.prod-price').dataset.price);
            const qty = parseInt(row.querySelector('.qty-ctrl input').value);
            const subtotal = price * qty;
            
            row.querySelector('.prod-subtotal').innerText = '₫' + subtotal.toLocaleString('vi-VN');
            
            if (isChecked) {
                grandTotal += subtotal;
                totalQty += qty;
            }
        });

        document.getElementById('grand-total').innerText = '₫' + grandTotal.toLocaleString('vi-VN');
        document.getElementById('cart-count-badge').innerText = totalQty;
        document.getElementById('selected-count').innerText = totalQty;
        document.getElementById('total-items').innerText = totalQty;

        if(!hasItems) {
            document.getElementById('cart-container').innerHTML = "<div style='text-align:center; padding:100px; background:#fff; margin-top:20px; font-size:16px; color:#888;'>Giỏ hàng của bạn đang trống.</div>";
        }
    }

    function changeQty(btn, delta) {
        const input = btn.parentElement.querySelector('input');
        input.value = Math.max(1, parseInt(input.value) + delta);
        updateTotals();
    }

    function showDeleteModal(btn) {
        currentItemToDelete = btn.closest('.product-row');
        document.getElementById('deleteModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('deleteModal').style.display = 'none';
        currentItemToDelete = null;
    }

    document.getElementById('confirmDeleteBtn').onclick = function() {
        if (currentItemToDelete) {
            const shopBlock = currentItemToDelete.closest('.shop-block');
            currentItemToDelete.remove();
            if (shopBlock.querySelectorAll('.product-row').length === 0) shopBlock.remove();
            closeModal();
            updateTotals();
        }
    };

    function removeSelected() {
        const selected = document.querySelectorAll('.prod-checkbox:checked');
        if (selected.length === 0) return alert("Vui lòng chọn sản phẩm cần xoá!");
        
        if (confirm("Bạn có chắc chắn muốn xoá các sản phẩm đã chọn?")) {
            selected.forEach(cb => {
                const row = cb.closest('.product-row');
                const shop = row.closest('.shop-block');
                row.remove();
                if (shop.querySelectorAll('.product-row').length === 0) shop.remove();
            });
            updateTotals();
        }
    }

    document.querySelectorAll('.shop-checkbox').forEach(box => {
        box.addEventListener('change', (e) => {
            const isAllCheck = e.target.id === 'chk-all-top' || e.target.id === 'chk-all-bottom';
            if (isAllCheck) {
                document.querySelectorAll('.shop-checkbox, .prod-checkbox').forEach(c => c.checked = e.target.checked);
            } else if (e.target.classList.contains('shop-parent')) {
                e.target.closest('.shop-block').querySelectorAll('.prod-checkbox').forEach(c => c.checked = e.target.checked);
            }
            updateTotals();
        });
    });

    document.addEventListener('change', (e) => {
        if(e.target.classList.contains('prod-checkbox')) updateTotals();
    });

    window.onload = updateTotals;