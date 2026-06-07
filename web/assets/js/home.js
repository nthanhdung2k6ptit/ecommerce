document.addEventListener("DOMContentLoaded", function () {
    console.log("=== HỆ THỐNG JS TRANG CHỦ ĐÃ KHỞI CHẠY ===");

    /* ════════════════════════════════════════════════════════════ */
    /* 1. XỬ LÝ SỰ KIỆN BANNER SLIDER                               */
    /* ════════════════════════════════════════════════════════════ */
    const slides = document.querySelectorAll(".slide");
    const dots = document.querySelectorAll(".dot");
    const prevBtn = document.querySelector(".prev-btn");
    const nextBtn = document.querySelector(".next-btn");

    let currentSlide = 0;
    let slideTimer;

    function showSlide(index) {
        if (!slides || slides.length === 0) return;
        if (index >= slides.length) currentSlide = 0;
        if (index < 0) currentSlide = slides.length - 1;

        slides.forEach(s => s.classList.remove("active"));
        if (dots) dots.forEach(d => d.classList.remove("active"));

        slides[currentSlide].classList.add("active");
        if (dots && dots[currentSlide]) dots[currentSlide].classList.add("active");
    }

    function nextSlide() {
        currentSlide++;
        showSlide(currentSlide);
    }

    function resetSliderTimer() {
        clearInterval(slideTimer);
        slideTimer = setInterval(nextSlide, 4000);
    }

    if (nextBtn) {
        nextBtn.addEventListener("click", function (e) {
            e.preventDefault(); e.stopPropagation();
            currentSlide++; showSlide(currentSlide); resetSliderTimer(); 
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener("click", function (e) {
            e.preventDefault(); e.stopPropagation();
            currentSlide--; showSlide(currentSlide); resetSliderTimer();
        });
    }

    if (dots.length > 0) {
        dots.forEach((dot, index) => {
            dot.addEventListener("click", function () {
                currentSlide = index; showSlide(currentSlide); resetSliderTimer();
            });
        });
    }

    if (slides.length > 0) {
        showSlide(currentSlide);
        resetSliderTimer();
    }

    /* ════════════════════════════════════════════════════════════ */
    /* 2. BỘ ĐẾM NGƯỢC THỜI GIAN FLASH SALE                         */
    /* ════════════════════════════════════════════════════════════ */
    if (document.getElementById("fs-hours")) {
        let fsTimeRemaining = (2 * 3600) + (45 * 60) + 18;
        const timerInterval = setInterval(function() {
            let hours = Math.floor(fsTimeRemaining / 3600);
            let minutes = Math.floor((fsTimeRemaining % 3600) / 60);
            let seconds = Math.floor(fsTimeRemaining % 60);

            document.getElementById("fs-hours").innerText = hours < 10 ? "0" + hours : hours;
            document.getElementById("fs-minutes").innerText = minutes < 10 ? "0" + minutes : minutes;
            document.getElementById("fs-seconds").innerText = seconds < 10 ? "0" + seconds : seconds;

            if (fsTimeRemaining > 0) fsTimeRemaining--;
            else {
                clearInterval(timerInterval);
                const flashSaleBanner = document.querySelector('.flash-sale-banner');
                if (flashSaleBanner) flashSaleBanner.innerHTML = '<h3 style="color:var(--red); text-align:center; width:100%; font-size: 18px; font-weight: 800;">⚡ FLASH SALE ĐÃ KẾT THÚC!</h3>';
            }
        }, 1000);
    }

    /* ════════════════════════════════════════════════════════════ */
    /* 3. TỰ ĐỘNG TÍNH NHÃN GIẢM GIÁ (BADGE)                         */
    /* ════════════════════════════════════════════════════════════ */
    const flashSaleImages = document.querySelectorAll(".fs-product-grid .product-img");
    flashSaleImages.forEach(function (imgContainer) {
        if (imgContainer.querySelector(".badge")) return;
        const oldPrice = parseFloat(imgContainer.getAttribute("data-old-price"));
        const currentPrice = parseFloat(imgContainer.getAttribute("data-current-price"));

        if (oldPrice && currentPrice && oldPrice > currentPrice) {
            const discountPercent = Math.round(((oldPrice - currentPrice) / oldPrice) * 100);
            imgContainer.insertAdjacentHTML("afterbegin", `<div class="badge">-${discountPercent}%</div>`);
        }
    });

    /* ════════════════════════════════════════════════════════════ */
    /* 4. AJAX LOAD MORE SẢN PHẨM                                   */
    /* ════════════════════════════════════════════════════════════ */
    const loadMoreBtn = document.getElementById("load-more-btn");
    const productContainer = document.getElementById("product-container");

    if (loadMoreBtn && productContainer) {
        loadMoreBtn.addEventListener("click", function () {
            let offset = parseInt(loadMoreBtn.getAttribute("data-offset"));
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
            
            loadMoreBtn.innerText = "ĐANG TẢI...";
            loadMoreBtn.disabled = true;

            fetch(`${contextPath}/loadMoreProducts?offset=${offset}`)
                .then(response => {
                    if (!response.ok) throw new Error("Lỗi Backend");
                    return response.text();
                })
                .then(htmlData => {
                    if (htmlData.trim() === "") {
                        loadMoreBtn.innerText = "HẾT SẢN PHẨM";
                        loadMoreBtn.style.background = "#ccc";
                        loadMoreBtn.style.color = "#fff";
                    } else {
                        productContainer.insertAdjacentHTML('beforeend', htmlData);
                        loadMoreBtn.setAttribute("data-offset", offset + 5);
                        loadMoreBtn.innerText = "XEM THÊM";
                        loadMoreBtn.disabled = false;
                    }
                })
                .catch(error => {
                    loadMoreBtn.innerText = "THỬ LẠI";
                    loadMoreBtn.disabled = false;
                });
        });
    }

    /* ════════════════════════════════════════════════════════════ */
    /* 5. TÍNH NĂNG XỔ DANH MỤC TRÊN ĐIỆN THOẠI (MOBILE)            */
    /* ════════════════════════════════════════════════════════════ */
    const catGrid = document.getElementById('categoryGrid');
    const toggleBtn = document.getElementById('catToggleBtn');

    if (catGrid && toggleBtn) {
        toggleBtn.addEventListener('click', function () {
            // Thêm/Xóa class 'expanded' để hiển thị các danh mục bị ẩn và lật mũi tên
            catGrid.classList.toggle('expanded');
            this.classList.toggle('expanded');
        });
    }

});