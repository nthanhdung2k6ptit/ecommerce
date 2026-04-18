package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
public class DBContext {

    public Connection getConnection() throws Exception {
        Properties properties = new Properties();
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream("database.properties");
        
        if (inputStream == null) {
            throw new Exception("Lỗi: Không tìm thấy file database.properties! Hãy kiểm tra lại vị trí file.");
        }
        properties.load(inputStream);

        String serverName = properties.getProperty("db.server");
        String portNumber = properties.getProperty("db.port");
        String dbName = properties.getProperty("db.name");
        String userID = properties.getProperty("db.user");
        String password = properties.getProperty("db.password");

        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName 
                   + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, userID, password);
    }
/*
public class DBContext {
    private final String serverName = "localhost";
    private final String dbName = "ecommerce_db";
    private final String portNumber = "3306";
    private final String userID = "root";
    private final String password = "123456";

    public Connection getConnection() throws Exception {
        // Đã sửa lỗi dư dấu ngoặc kép ở cuối chuỗi URL
        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName 
                   + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        return DriverManager.getConnection(url, userID, password);
    }

    /**
     * Hàm test nhanh kết nối
     */
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            Connection conn = db.getConnection();
            if (conn != null) {
                System.out.println("Kết nối CSDL thành công! Sẵn sàng xử lý dữ liệu.");
                conn.close(); // Test xong thì nhớ đóng lại
            }
        } catch (Exception ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Lỗi kết nối CSDL: Vui lòng kiểm tra lại thông tin cấu hình hoặc MySQL đã bật chưa.");
        }
    }
}