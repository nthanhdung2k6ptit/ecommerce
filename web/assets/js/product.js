/**
 * Product Page Scripts
 * CDG Marketplace - Backend Demo Supported
 */

window.openMobileFilter = function() {
    var sidebar = document.getElementById('product-sidebar');
    if (sidebar) {
        sidebar.classList.add('active');
    }
};

window.closeMobileFilter = function() {
    var sidebar = document.getElementById('product-sidebar');
    if (sidebar) {
        sidebar.classList.remove('active');
    }
};

window.changeSort = function(sortValue) {
    if (!sortValue) return;
    var urlParams = new URLSearchParams(window.location.search);
    urlParams.set('sort', sortValue); 
    window.location.search = urlParams.toString(); 
};

document.addEventListener("DOMContentLoaded", function() {
    let loadMoreBtn = document.getElementById("load-more-btn");
    
    if (loadMoreBtn) {
        loadMoreBtn.addEventListener("click", function() {
            // Lấy offset hiện tại (mặc định đang để data-offset="5")
            let currentOffset = parseInt(this.getAttribute("data-offset"));
            
            // Gọi AJAX xuống Servlet LoadMore
            fetch("load-more?offset=" + currentOffset)
                .then(response => response.text())
                .then(html => {
                    if(html.trim() === "") {
                        // Nếu hết sản phẩm thì ẩn cái nút đi
                        loadMoreBtn.style.display = "none";
                    } else {
                        // Đắp thêm HTML vào cuối danh sách
                        document.getElementById("product-container").insertAdjacentHTML("beforeend", html);
                        
                        // Cộng thêm 5 cho lần bấm tiếp theo
                        loadMoreBtn.setAttribute("data-offset", currentOffset + 5);
                    }
                })
                .catch(error => console.log("Lỗi tải thêm sản phẩm: ", error));
        });
    }
});
