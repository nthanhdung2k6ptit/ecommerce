package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ResourceBundle;

public class DBContext {

    public Connection getConnection() throws Exception {
        // Chỉ gọi "utils.database" - ResourceBundle tự động hiểu là đi tìm file database.properties trong package utils
        ResourceBundle bundle = ResourceBundle.getBundle("utils.database");

        String dbUrl = bundle.getString("DB_URL");
        String user = bundle.getString("DB_USER");
        String pass = bundle.getString("DB_PASSWORD");

        String params = "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
        String finalUrl = dbUrl + params;
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(finalUrl, user, pass);
    }

    // Hàm main để test thử luôn không cần bật web
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            Connection conn = db.getConnection();
            if (conn != null) {
                System.out.println(">>> ĐÃ THÔNG NÒNG DATABASE! MỌI THỨ CHẠY NGON!");
                conn.close();
            }
        } catch (Exception ex) {
            System.err.println(">>> VẪN TẠCH!");
            ex.printStackTrace();
        }
    }
}