<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Hứng thông báo lỗi hoặc thành công từ Controller (LoginController / RegisterController)
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập / Đăng ký</title>
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/base.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

<div class="auth-container">
    <% if (error != null) { %>
        <div class="alert error"><%= error %></div>
    <% } %>
    <% if (message != null) { %>
        <div class="alert success"><%= message %></div>
    <% } %>

    <div id="login-form">
        <div class="auth-header">
            <h2>Đăng Nhập</h2>
            <p>Thỏa mãn nhu cầu mua sắm của bạn trên nền tảng CDG</p>
        </div>
        <form action="<%= request.getContextPath() %>/login" method="POST">
            <div class="form-group">
                <label for="login-email">Email</label>
                <input type="email" id="login-email" name="email" required placeholder="Nhập email của bạn">
            </div>
            
            <div class="form-group">
                <label for="login-password">Mật khẩu</label>
                <input type="password" id="login-password" name="password" required placeholder="Nhập mật khẩu">
            </div>
            <button type="submit" class="btn-submit">Đăng Nhập</button>
        </form>
        <div class="toggle-text">
            Chưa có tài khoản? <a href="javascript:void(0)" onclick="toggleForms()">Đăng ký ngay</a>
        </div>
    </div>

    <div id="register-form" style="display: none;">
        <div class="auth-header">
            <h2>Tạo Tài Khoản</h2>
            <p>Tham gia mua sắm ngay hôm nay</p>
        </div>
        <form action="<%= request.getContextPath() %>/register" method="POST" onsubmit="return validateRegister()">
            <div class="form-group">
                <label for="reg-fullname">Họ và Tên</label>
                <input type="text" id="reg-fullname" name="fullName" required placeholder="Ví dụ: Nguyễn Văn A">
            </div>
            <div class="form-group">
                <label for="reg-email">Email</label>
                <input type="email" id="reg-email" name="email" required placeholder="Nhập địa chỉ email">
            </div>
            <div class="form-group">
                <label for="reg-phone">Số điện thoại</label>
                <input type="text" id="reg-phone" name="phone" required placeholder="Nhập số điện thoại">
            </div>
            <div class="form-group">
                <label for="reg-password">Mật khẩu</label>
                <input type="password" id="reg-password" name="password" required placeholder="Tạo mật khẩu">
            </div>
            <div class="form-group">
                <label for="reg-confirm-password">Xác nhận mật khẩu</label>
                <input type="password" id="reg-confirm-password" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
            </div>
            <button type="submit" class="btn-submit btn-register">Đăng Ký</button>
        </form>
        <div class="toggle-text">
            Đã có tài khoản? <a href="javascript:void(0)" onclick="toggleForms()">Đăng nhập</a>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/assets/js/validate.js"></script>

<script>
    // Logic lật form (Nếu nhóm ông định gom hàm này vào main.js thì cứ cắt bếch sang bên kia)
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

   // Giữ lại form đăng ký nếu bị lỗi
    window.onload = function() {
        // Dùng EL của Java để check xem có phải đang ở luồng Register không
        var isRegisterAction = '${param.action}' === 'register';
        
        if (isRegisterAction) {
            document.getElementById('login-form').style.display = 'none';
            document.getElementById('register-form').style.display = 'block';
        }
    };
</script>

</body>
</html>