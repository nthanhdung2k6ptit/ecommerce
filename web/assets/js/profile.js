document.addEventListener("DOMContentLoaded", function () {

    // ======================================================= //
    // 1. XỬ LÝ THÔNG BÁO "ĐẶT HÀNG THÀNH CÔNG"               //
    // ======================================================= //
    const successBanner = document.getElementById("success-banner");
    const closeBannerBtn = document.getElementById("close-banner-btn");
    let bannerTimeout;

    if (successBanner) {
        function closeBanner() {
            if (bannerTimeout) clearTimeout(bannerTimeout);
            successBanner.style.animation = "slideUp 0.4s ease forwards";
            setTimeout(() => { successBanner.style.display = "none"; }, 400);
        }
        bannerTimeout = setTimeout(closeBanner, 5000);
        if (closeBannerBtn) {
            closeBannerBtn.addEventListener("click", closeBanner);
        }
    }

    // ======================================================= //
    // 2. ALERT XÁC NHẬN KHI BẤM ĐĂNG XUẤT                    //
    // ======================================================= //
    const logoutBtn = document.getElementById("btn-logout");
    if (logoutBtn) {
        logoutBtn.addEventListener("click", function (e) {
            if (!confirm("Bạn có chắc chắn muốn đăng xuất khỏi hệ thống CDG không?")) {
                e.preventDefault();
            }
        });
    }

    // ======================================================= //
    // 3. CONFIRM KHI BẤM VÀO DASHBOARD (tuỳ chọn)            //
    // ======================================================= //
    const dashboardBtn = document.querySelector(".btn-dashboard");
    if (dashboardBtn) {
        dashboardBtn.addEventListener("click", function (e) {
            // Có thể bỏ confirm nếu không cần
            // if (!confirm("Chuyển sang trang Quản Trị?")) e.preventDefault();
        });
    }

});
