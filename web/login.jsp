<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Xử lý login nhanh bằng scriptlet (Mock Login)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String role = request.getParameter("role");
        User mockUser = new User();
        mockUser.setUserId(1);
        mockUser.setFullName("Quản trị viên Demo");
        mockUser.setEmail("admin@example.com");
        mockUser.setRole(role != null ? role : "admin");
        
        // Lưu session giả lập
        session.setAttribute("loggedUser", mockUser);
        
        // Nếu là seller, giả lập session sellerId
        if ("seller".equals(role)) {
            session.setAttribute("sellerId", 1);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Kênh Quản trị</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .login-box { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; }
        .login-box h2 { margin-top: 0; color: #333; }
        .btn { display: block; width: 100%; padding: 12px; margin: 10px 0; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; color: #fff; font-weight: bold;}
        .btn-admin { background: #4e73df; }
        .btn-seller { background: #1cc88a; }
        .btn-admin:hover { background: #2e59d9; }
        .btn-seller:hover { background: #17a673; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Đăng nhập Hệ thống</h2>
        <p>Vui lòng chọn quyền truy cập (Dùng tạm cho mục đích hiển thị Giao diện Admin)</p>
        
        <form method="POST">
            <button type="submit" name="role" value="admin" class="btn btn-admin">Đăng nhập tài khoản Chủ Sàn (Admin)</button>
        </form>
        
        <form method="POST">
            <button type="submit" name="role" value="seller" class="btn btn-seller">Đăng nhập tài khoản Chủ Shop (Seller)</button>
        </form>
    </div>
</body>
</html>
