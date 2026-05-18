// Hàm chuyển đổi giữa form Đăng Nhập và Đăng Ký
function toggleForms() {
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    
    if (loginForm.style.display === 'none') {
        loginForm.style.display = 'block';
        registerForm.style.display = 'none';
    } else {
        loginForm.style.display = 'none';
        registerForm.style.display = 'block';
    }
}

// Logic kiểm tra URL khi vừa tải trang xong (Dùng JS thuần thay vì EL của Java)
document.addEventListener("DOMContentLoaded", function() {
    // Đọc tham số trên thanh địa chỉ URL
    const urlParams = new URLSearchParams(window.location.search);
    const action = urlParams.get('action');
    
    // Nếu URL có đuôi ?action=register thì tự động bật form Đăng ký lên
    if (action === 'register') {
        document.getElementById('login-form').style.display = 'none';
        document.getElementById('register-form').style.display = 'block';
    }
});