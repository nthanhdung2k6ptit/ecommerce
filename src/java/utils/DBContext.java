package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ResourceBundle;

public class DBContext {

    public Connection getConnection() throws Exception {
        try {
            // Vũ khí tối thượng: Tự động tìm file database.properties trong package utils
            // Lưu ý: Chỉ viết "utils.database" (không có đuôi .properties)
            ResourceBundle bundle = ResourceBundle.getBundle("utils.database");

            String dbUrl = bundle.getString("DB_URL");
            String user = bundle.getString("DB_USER");
            String pass = bundle.getString("DB_PASSWORD");

            String params = "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
            String finalUrl = dbUrl + params;
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(finalUrl, user, pass);
            
        } catch (Exception e) {
            System.err.println("=== LỖI KINH HOÀNG: KHÔNG ĐỌC ĐƯỢC FILE ===");
            e.printStackTrace();
            throw new Exception("Quá mệt mỏi! Lỗi thật sự là: " + e.getMessage());
        }
    }
}