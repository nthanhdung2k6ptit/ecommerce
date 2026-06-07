// Hàm kiểm tra form Đăng Ký trước khi gửi xuống Backend
function validateRegister() {
    // Lấy giá trị từ các ô nhập liệu (theo đúng ID trong file login_register.jsp)
    var password = document.getElementById('reg-password').value;
    var confirmPassword = document.getElementById('reg-confirm-password').value;

    // Kiểm tra xem mật khẩu nhập lại có khớp không
    if (password !== confirmPassword) {
        alert("Lỗi: Mật khẩu xác nhận không khớp! Vui lòng nhập lại.");
        return false; // Chặn chặn chặn! Không cho form gửi đi
    }

    // Nếu mọi thứ ok, trả về true để form lao thẳng xuống Controller
    return true; 
}