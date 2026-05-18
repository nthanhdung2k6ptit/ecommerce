document.addEventListener("DOMContentLoaded", function() {
    
    const menuItems = document.querySelectorAll('.menu-item');
    const contentSections = document.querySelectorAll('.content-section');
    const breadcrumbText = document.getElementById('breadcrumb-text');

    if (menuItems.length > 0 && contentSections.length > 0 && breadcrumbText) {
        
        // =========================================
        // HÀM DÙNG CHUNG: CHUYỂN TAB VÀ ĐỔI GIAO DIỆN
        // =========================================
        function switchTab(targetId) {
            const targetMenu = document.querySelector(`.menu-item[data-target="${targetId}"]`);
            const activeSection = document.getElementById(targetId);

            if (targetMenu && activeSection) {
                // Xóa trạng thái active cũ
                menuItems.forEach(m => m.classList.remove('active'));
                contentSections.forEach(sec => sec.classList.remove('active'));

                // Bật trạng thái active mới
                targetMenu.classList.add('active');
                activeSection.classList.add('active');
                
                // Đồng bộ chữ Breadcrumb
                breadcrumbText.innerText = targetMenu.innerText;
            }
        }

        // =========================================
        // 1. KHI NGƯỜI DÙNG CLICK TRỰC TIẾP VÀO MENU
        // =========================================
        menuItems.forEach(item => {
            item.addEventListener('click', function(e) {
                e.preventDefault(); // Chặn hành vi nhảy trang mặc định
                const targetId = this.getAttribute('data-target');
                
                switchTab(targetId); // Gọi hàm chuyển tab
                
                // Đổi đuôi URL trên thanh địa chỉ cho khớp
                window.history.replaceState(null, null, "#" + targetId);
            });
        });

        // =========================================
        // 2. KHI TẢI TRANG (Khách bấm từ Footer trang khác bay tới)
        // =========================================
        let currentHash = window.location.hash.replace('#', '');
        if (currentHash) {
            switchTab(currentHash);
        }

        // =========================================
        // 3. KHI ĐANG Ở TRONG TRANG NÀY MÀ KHÁCH BẤM FOOTER
        // =========================================
        window.addEventListener('hashchange', function() {
            let newHash = window.location.hash.replace('#', '');
            if (newHash) {
                switchTab(newHash);
            }
        });
    }
});