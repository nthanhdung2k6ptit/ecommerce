<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, utils.DBContext"%>
<!DOCTYPE html>
<html>
<body>
    <h2>Kiểm tra kết nối CSDL và đọc dữ liệu</h2>
    <%
        try (Connection conn = new DBContext().getConnection();
             Statement stmt = conn.createStatement()) {
            out.println("<p style='color:green;'>✔️ Kết nối tới MySQL THÀNH CÔNG!</p>");
            
            // Thử Đếm số User
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Users");
            if(rs.next()) {
                out.println("<p><b>Số lượng Users trong DB của bạn:</b> " + rs.getInt(1) + "</p>");
            }
            rs.close();
            
            // Thử lệnh đếm Products (có thể sai tên cột)
            rs = stmt.executeQuery("SELECT * FROM Products LIMIT 1");
            out.println("<p style='color:green;'>✔️ Đọc bảng Products THÀNH CÔNG!</p>");
            rs.close();
            
            // Nếu chạy được tới đây thì dữ liệu thật sự bằng 0
        } catch (SQLException e) {
            out.println("<div style='color:red;'><h3>❌ Lỗi SQL:</h3><pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre></div>");
        } catch (Exception e) {
            out.println("<div style='color:red;'><h3>❌ Lỗi Khởi tạo:</h3><pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre></div>");
        }
    %>
</body>
</html>
