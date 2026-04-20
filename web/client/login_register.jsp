<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login Test</title>
    </head>
    <body>
        <h2>Form Đăng nhập (Dành cho Dev Test)</h2>
        <form action="${pageContext.request.contextPath}/login" method="POST">
            <label>Email:</label><br>
            <input type="text" name="email" value="test@gmail.com"><br><br>
            
            <label>Mật khẩu:</label><br>
            <input type="password" name="password" value="123456"><br><br>
            
            <button type="submit">Bấm Đăng Nhập để lấy Session</button>
        </form>
        
        <p style="color:red;">${errorMessage}</p>
    </body>
</html>