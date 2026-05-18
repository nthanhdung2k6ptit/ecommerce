document.addEventListener("DOMContentLoaded", function () {
    
    console.log("=== HỆ THỐNG JAVASCRIPT CDG MARKETPLACE ĐÃ KHỞI CHẠY ===");

    /* ════════════════════════════════════════════════════════════ */
    /* 1. XỬ LÝ SỰ KIỆN BANNER SLIDER TỰ ĐỘNG CHUYỂN ĐỘNG + NÚT BẤM  */
    /* ════════════════════════════════════════════════════════════ */
    const slides = document.querySelectorAll(".slide");
    const dots = document.querySelectorAll(".dot");
    const prevBtn = document.querySelector(".prev-btn");
    const nextBtn = document.querySelector(".next-btn");
    
    console.log("Số lượng ảnh slide tìm thấy:", slides.length);
    console.log("Số lượng dấu chấm tìm thấy:", dots.length);

    let currentSlide = 0;
    let slideTimer;

    function showSlide(index) {
        if (!slides || slides.length === 0) return;

        if (index >= slides.length) currentSlide = 0;
        if (index < 0) currentSlide = slides.length - 1;

        slides.forEach(s => s.classList.remove("active"));
        if (dots) {
            dots.forEach(d => d.classList.remove("active"));
        }

        if (slides[currentSlide]) {
            slides[currentSlide].classList.add("active");
        }
        if (dots && dots[currentSlide]) {
            dots[currentSlide].classList.add("active");
        }
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
            e.preventDefault();
            e.stopPropagation();
            console.log("-> Bạn vừa click nút TIẾN (Next)");
            currentSlide++;
            showSlide(currentSlide);
            resetSliderTimer(); 
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();
            console.log("-> Bạn vừa click nút LÙI (Prev)");
            currentSlide--;
            showSlide(currentSlide);
            resetSliderTimer();
        });
    }

    if (dots && dots.length > 0) {
        dots.forEach((dot, index) => {
            dot.addEventListener("click", function () {
                console.log(`-> Bạn vừa click vào dấu chấm thứ: ${index + 1}`);
                currentSlide = index;
                showSlide(currentSlide);
                resetSliderTimer();
            });
        });
    }

    if (slides && slides.length > 0) {
        showSlide(currentSlide);
        resetSliderTimer();
    }

    /* ════════════════════════════════════════════════════════════ */
    /* 2. BỘ ĐẾM NGƯỢC THỜI GIAN FLASH SALE                        */
    /* ════════════════════════════════════════════════════════════ */
    if (document.getElementById("fs-hours")) {
        // Đã đổi tên biến độc bản chống trùng lặp hoàn toàn
        let fsTimeRemaining = (2 * 3600) + (45 * 60) + 18;

        const timerInterval = setInterval(function() {
            let hours = Math.floor(fsTimeRemaining / 3600);
            let minutes = Math.floor((fsTimeRemaining % 3600) / 60);
            let seconds = Math.floor(fsTimeRemaining % 60);

            hours = hours < 10 ? "0" + hours : hours;
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            document.getElementById("fs-hours").innerText = hours;
            document.getElementById("fs-minutes").innerText = minutes;
            document.getElementById("fs-seconds").innerText = seconds;

            if (fsTimeRemaining > 0) {
                fsTimeRemaining--;
            } else {
                clearInterval(timerInterval);
                const flashSaleBanner = document.querySelector('.flash-sale-banner');
                if (flashSaleBanner) {
                    flashSaleBanner.innerHTML = '<h3 style="color:var(--red); text-align:center; width:100%; font-size: 18px; font-weight: 800;">⚡ FLASH SALE ĐÃ KẾT THÚC!</h3>';
                }
            }
        }, 1000);
    }

    /* ════════════════════════════════════════════════════════════ */
    /* 3. TỰ ĐỘNG TÍNH TOÁN VÀ HIỂN THỊ NHÃN GIẢM GIÁ (BADGE)        */
    /* ════════════════════════════════════════════════════════════ */
    const flashSaleImages = document.querySelectorAll(".fs-product-grid .product-img");
    if (flashSaleImages.length > 0) {
        flashSaleImages.forEach(function (imgContainer) {
            if (imgContainer.querySelector(".badge")) return;
            const oldPrice = parseFloat(imgContainer.getAttribute("data-old-price"));
            const currentPrice = parseFloat(imgContainer.getAttribute("data-current-price"));

            if (oldPrice && currentPrice && oldPrice > currentPrice) {
                const discountPercent = Math.round(((oldPrice - currentPrice) / oldPrice) * 100);
                const badgeHtml = `<div class="badge">-${discountPercent}%</div>`;
                imgContainer.insertAdjacentHTML("afterbegin", badgeHtml);
            }
        });
    }

    /* ════════════════════════════════════════════════════════════ */
    /* 4. XỬ LÝ SỰ KIỆN BẤM "XEM THÊM" SẢN PHẨM (AJAX FETCH)         */
    /* ════════════════════════════════════════════════════════════ */
    const loadMoreBtn = document.getElementById("load-more-btn");
    const productContainer = document.getElementById("product-container");

    if (loadMoreBtn && productContainer) {
        loadMoreBtn.addEventListener("click", function () {
            let offset = parseInt(loadMoreBtn.getAttribute("data-offset"));
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
            const url = `${contextPath}/loadMoreProducts?offset=${offset}`;

            loadMoreBtn.innerText = "ĐANG TẢI SẢN PHẨM...";
            loadMoreBtn.disabled = true;

            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error("Không thể kết nối Backend.");
                    return response.text();
                })
                .then(htmlData => {
                    if (htmlData.trim() === "") {
                        loadMoreBtn.innerText = "HẾT SẢN PHẨM";
                        loadMoreBtn.style.backgroundColor = "#ccc";
                        loadMoreBtn.style.color = "#fff";
                        loadMoreBtn.style.cursor = "not-allowed";
                        loadMoreBtn.disabled = true;
                    } else {
                        productContainer.insertAdjacentHTML('beforeend', htmlData);
                        offset += 5;
                        loadMoreBtn.setAttribute("data-offset", offset);
                        loadMoreBtn.innerText = "XEM THÊM";
                        loadMoreBtn.disabled = false;
                    }
                })
                .catch(error => {
                    console.error("Lỗi AJAX:", error);
                    loadMoreBtn.innerText = "THỬ LẠI";
                    loadMoreBtn.disabled = false;
                });
        });
    }
});