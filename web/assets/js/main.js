
    // Cài đặt thời gian đếm ngược ban đầu (2 giờ, 45 phút, 18 giây)
    let timeRemaining = (2 * 3600) + (45 * 60) + 18;

    function startFlashSaleTimer() {
        const timerInterval = setInterval(function() {
            // Tính toán giờ, phút, giây
            let hours = Math.floor(timeRemaining / 3600);
            let minutes = Math.floor((timeRemaining % 3600) / 60);
            let seconds = Math.floor(timeRemaining % 60);

            // Thêm số 0 ở trước nếu số nhỏ hơn 10 (VD: 9 -> 09)
            hours = hours < 10 ? "0" + hours : hours;
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            // Hiển thị ra màn hình
            document.getElementById("fs-hours").innerText = hours;
            document.getElementById("fs-minutes").innerText = minutes;
            document.getElementById("fs-seconds").innerText = seconds;

            // Giảm 1 giây
            if (timeRemaining > 0) {
                timeRemaining--;
            } else {
                clearInterval(timerInterval);
                // Xử lý khi hết giờ (nếu cần)
                // document.querySelector('.flash-sale-banner').innerHTML = '<h3 style="color:var(--red); text-align:center; width:100%;">FLASH SALE ĐÃ KẾT THÚC!</h3>';
            }
        }, 1000); // Lặp lại mỗi 1000ms (1 giây)
    }

    // Khởi chạy hàm khi tải xong trang
    startFlashSaleTimer();
