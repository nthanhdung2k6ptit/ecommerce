package utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * Tiện ích kết nối CSDL MySQL.
 * Đọc cấu hình từ utils/database.properties
 */
public class DBUtil {

    private static String url;
    private static String user;
    private static String password;

    static {
        try {
            url = "jdbc:mysql://localhost:3306/ecommerce?useUnicode=true&characterEncoding=utf-8";
            user = "root";
            password = "123456";
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws java.sql.SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}
