
window.adjustQuantity = function(amount) {
    const qtyInput = document.getElementById("qty");
    if (qtyInput) {
        let currentVal = parseInt(qtyInput.value) || 1;
        qtyInput.value = Math.max(1, currentVal + amount);
    }
};

document.addEventListener("DOMContentLoaded", function () {

    // ======================================================= //
    // 1. XỬ LÝ ĐỔI ẢNH CHÍNH KHI CLICK VÀO ẢNH NHỎ (THUMBNAIL)  //
    // ======================================================= //
    const mainImage = document.getElementById('main-image');
    const thumbs = document.querySelectorAll('.thumb');

    if (mainImage && thumbs.length > 0) {
        thumbs.forEach(thumb => {
            thumb.addEventListener('click', function() {
                // Xóa class active ở tất cả các thumbnail
                thumbs.forEach(t => t.classList.remove('active'));
                
                // Thêm viền active cho ảnh vừa click
                this.classList.add('active');
                
                // Lấy link ảnh từ thẻ img nằm bên trong thẻ .thumb vừa click
                const imgInside = this.querySelector('img');
                if (imgInside) {
                    const newImgSrc = imgInside.getAttribute('src');
                    // Cập nhật link ảnh cho ảnh chính
                    mainImage.setAttribute('src', newImgSrc);
                }
            });
        });
    }

    // ======================================================= //
    // 2. XỬ LÝ TĂNG GIẢM SỐ LƯỢNG SẢN PHẨM                      //
    // ======================================================= //
    const qtyInput = document.getElementById("qty");
    const btnMinus = document.querySelector(".qty-minus");
    const btnPlus = document.querySelector(".qty-plus");

    if (qtyInput) {
        
        // Kiểm tra nếu nút Minus không có onclick inline thì mới gán sự kiện để tránh chạy 2 lần
        if (btnMinus && !btnMinus.hasAttribute('onclick')) {
            btnMinus.addEventListener("click", function() {
                let currentVal = parseInt(qtyInput.value) || 1;
                qtyInput.value = Math.max(1, currentVal - 1);
            });
        }

        // Kiểm tra tương tự cho nút Plus
        if (btnPlus && !btnPlus.hasAttribute('onclick')) {
            btnPlus.addEventListener("click", function() {
                let currentVal = parseInt(qtyInput.value) || 1;
                qtyInput.value = currentVal + 1;
            });
        }

        // 🔥 Giữ nguyên Logic xử lý Input cực xịn của Matcha
        qtyInput.addEventListener("input", function() {
            // Chặn người dùng nhập chữ vào ô số lượng
            this.value = this.value.replace(/[^0-9]/g, '');
            
            // Nếu người dùng xóa sạch hoặc cố tình nhập 0 thì tự đưa về 1
            if (this.value === "" || parseInt(this.value) < 1) {
                this.value = 1;
            }
        });
    }
});