document.addEventListener("DOMContentLoaded", function () {
    
    // Logic cập nhật số lượng trên icon Giỏ hàng
    // Tạm thời lấy từ SessionStorage của phần Checkout lúc trước
    function updateCartBadge() {
        const badge = document.getElementById('header-cart-badge');
        if (!badge) return;

        let itemsJson = sessionStorage.getItem('checkoutItems');
        let count = 0;
        
        if(itemsJson) {
            try {
                let items = JSON.parse(itemsJson);
                // Cộng tổng số lượng sản phẩm (qty)
                items.forEach(item => {
                    count += item.qty;
                });
            } catch (e) {
                console.error("Lỗi đọc giỏ hàng:", e);
            }
        }
        
        // Nếu không có dùng JS tạm, bạn có thể gọi AJAX lên Server ở đoạn này để lấy tổng số.
        // Tạm thời gán số đếm
        badge.innerText = count > 99 ? "99+" : count;
    }

    // Chạy khi trang vừa tải
    updateCartBadge();

});