package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.InputStream;
import java.util.Properties;

public class DBContext {

    public Connection getConnection() throws Exception {
        Properties properties = new Properties();
        // Tìm và đọc file database.properties
        InputStream inputStream = DBContext.class.getResourceAsStream("database.properties");
        
        if (inputStream == null) {
            throw new Exception("Loi: khong tim thay file database.properties! hay kiem tra lai vi tri file.");
        }
        properties.load(inputStream);

        // Lấy thông tin từ file properties theo đúng các key đã thiết lập
        String dbUrl = properties.getProperty("DB_URL");
        String user = properties.getProperty("DB_USER");
        String pass = properties.getProperty("DB_PASSWORD");

        // Nối thêm các tham số xử lý tiếng Việt và bypass bảo mật MySQL 8.0 vào đuôi URL
        String finalUrl = dbUrl + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
        
        // Load Driver và thực hiện kết nối
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(finalUrl, user, pass);
    }

    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            Connection conn = db.getConnection();
            if (conn != null) {
                System.out.println("SUCCESS! Ket noi voi ecommerce_db thanh cong.");
                conn.close();
            }
        } catch (Exception ex) {
            System.out.println("FAILED! Ket noi that bai.");
            System.out.println("Nguyen nhan that su la: " + ex.getMessage());
        }
    }
}