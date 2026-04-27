package utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBContext {

    public Connection getConnection() throws Exception {
        Properties properties = new Properties();
        
        // 1. Dùng ClassLoader mạnh nhất của Tomcat
        InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("database.properties");
        
        // 2. Kế hoạch dự phòng: Tìm trong package utils (nếu ông vẫn để file ở chỗ cũ)
        if (inputStream == null) {
            inputStream = DBContext.class.getResourceAsStream("/utils/database.properties");
        }
        
        // 3. Kế hoạch dự phòng 2: Tìm trong package resources (nếu ông lỡ tạo package tên là resources)
        if (inputStream == null) {
            inputStream = DBContext.class.getResourceAsStream("/resources/database.properties");
        }

        if (inputStream == null) {
            throw new Exception("Lỗi tận mạng: Đã tìm ở thu muc goc, thu muc utils, thu muc resources ma van KHONG THAY file database.properties!");
        }
        
        properties.load(inputStream);

        String dbUrl = properties.getProperty("DB_URL");
        String user = properties.getProperty("DB_USER");
        String pass = properties.getProperty("DB_PASSWORD");

        String params = "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
        String finalUrl = dbUrl + params;
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(finalUrl, user, pass);
    }
}