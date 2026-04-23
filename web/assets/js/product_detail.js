
    // Script để đổi màu nút chọn phân loại hàng
    document.querySelectorAll('.variant-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.variant-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
        });
    });

    // Lấy phần tử ảnh chính
    const mainImage = document.getElementById('main-image');

    // Script để đổi hiệu ứng viền cho ảnh thumbnail VÀ đổi ảnh chính
    document.querySelectorAll('.thumb').forEach(thumb => {
        thumb.addEventListener('click', function() {
            // Đổi viền active
            document.querySelectorAll('.thumb').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            // Lấy link ảnh từ thẻ img nằm bên trong thẻ .thumb vừa click
            const newImgSrc = this.querySelector('img').getAttribute('src');
            
            // Cập nhật link ảnh cho ảnh chính
            mainImage.setAttribute('src', newImgSrc);
        });
    });
