 
document.addEventListener("DOMContentLoaded", function () {
    
    // ======================================================= //
    // 1. XỬ LÝ THÔNG BÁO "ĐẶT HÀNG THÀNH CÔNG"                //
    // ======================================================= //
    const successBanner = document.getElementById("success-banner");
    const closeBannerBtn = document.getElementById("close-banner-btn");
    let bannerTimeout; // Biến lưu trữ bộ đếm thời gian tự động đóng

    if (successBanner) {
        
        // Hàm đóng banner dùng chung để tối ưu code, tránh lặp đi lặp lại
        function closeBanner() {
            // Nếu khách hàng bấm [x] chủ động đóng sớm, hủy ngay bộ đếm chạy ngầm 5 giây
            if (bannerTimeout) {
                clearTimeout(bannerTimeout);
            }
            
            successBanner.style.animation = "slideUp 0.4s ease forwards";
            setTimeout(() => { 
                successBanner.style.display = "none"; 
            }, 400); // Chờ animation slideUp chạy xong hoàn toàn mới ẩn thẻ HTML
        }

        // Tự động kích hoạt đóng và mờ biến mất sau 5 giây (UX mượt mà)
        bannerTimeout = setTimeout(closeBanner, 5000);

        // Lắng nghe sự kiện khách hàng bấm nút [x] để đóng sớm
        if (closeBannerBtn) {
            closeBannerBtn.addEventListener("click", closeBanner);
        }
    }

    // ======================================================= //
    // 2. ALERT CẢNH BÁO KHI BẤM NÚT ĐĂNG XUẤT                  //
    // ======================================================= //
    const logoutBtn = document.getElementById("btn-logout");
    if (logoutBtn) {
        logoutBtn.addEventListener("click", function(e) {
            // Hiện hộp thoại xác nhận native chuẩn hệ thống
            if (!confirm("Bạn có chắc chắn muốn đăng xuất khỏi hệ thống CDG không?")) {
                e.preventDefault(); // Chặn đứng hành động chuyển hướng URL sang logout.jsp nếu bấm Hủy
            }
        });
    }

});