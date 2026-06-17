document.addEventListener("DOMContentLoaded", function () {
    // Đã vô hiệu hóa JS đếm giỏ hàng ảo cũ.
});

window.addEventListener("pageshow", function (event) {
    // event.persisted = true nghĩa là trang được load từ Cache (khi bấm nút Back)
    var historyTraversal = event.persisted || 
                           (typeof window.performance != "undefined" && 
                            window.performance.navigation.type === 2);
    if (historyTraversal) {
        window.location.reload();
    }
});