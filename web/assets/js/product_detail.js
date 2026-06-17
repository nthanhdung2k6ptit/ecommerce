window.adjustQuantity = function(amount) {
    const qtyInput = document.getElementById("qty");
    if (qtyInput) {
        let currentVal = parseInt(qtyInput.value) || 1;
        let maxVal = parseInt(qtyInput.getAttribute("data-max")) || 9999;
        
        let newVal = currentVal + amount;
        
        // Chặn không cho giảm dưới 1
        if (newVal < 1) newVal = 1;
        // Chặn không cho bấm dấu + vượt quá tồn kho
        if (newVal > maxVal) {
            newVal = maxVal;
            alert("Sản phẩm chỉ còn tối đa " + maxVal + " chiếc trong kho!");
        }
        
        qtyInput.value = newVal;
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
                thumbs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                const imgInside = this.querySelector('img');
                if (imgInside) {
                    mainImage.setAttribute('src', imgInside.getAttribute('src'));
                }
            });
        });
    }

    // ======================================================= //
    // 2. XỬ LÝ NHẬP SỐ LƯỢNG TỪ BÀN PHÍM VÀ KIỂM TRA TỒN KHO      //
    // ======================================================= //
    const qtyInput = document.getElementById("qty");

    if (qtyInput) {
        // CHỈ cho phép nhập số (lọc chữ cái ngay khi gõ)
        qtyInput.addEventListener("input", function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });

        // Khi click chuột ra ngoài ô nhập (blur) -> Tiến hành chốt số
        qtyInput.addEventListener("blur", function() {
            let val = parseInt(this.value);
            let maxVal = parseInt(this.getAttribute("data-max")) || 9999;

            if (isNaN(val) || val < 1) {
                // Trống hoặc số 0 -> Đưa về 1
                this.value = 1;
            } else if (val > maxVal) {
                // Nhập quá tồn kho -> Ép thẳng về số tối đa
                this.value = maxVal;
                alert("Sản phẩm chỉ còn tối đa " + maxVal + " chiếc trong kho!");
            } else {
                this.value = val;
            }
        });
    }
});