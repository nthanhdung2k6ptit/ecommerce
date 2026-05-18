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
    var urlParams = new URLSearchParams(window.location.search);
    var currentSort = urlParams.get('sort') || 'popular'; 
    
    var activeBtn = document.querySelector('.sort-btn[data-sort="' + currentSort + '"]');
    if (activeBtn) {
        activeBtn.classList.add('active');
    }
    
    var priceSelect = document.getElementById('sortPriceSelect');
    if (priceSelect && (currentSort === 'price_asc' || currentSort === 'price_desc')) {
        priceSelect.value = currentSort;
    }

    var closeBtn = document.getElementById('close-filter-btn');
    if (closeBtn) {
        closeBtn.onclick = window.closeMobileFilter;
    }
});