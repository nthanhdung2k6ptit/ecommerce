package dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;
import model.Seller;
import utils.DBContext;

public class UserDAO {

    private Connection getConnection() throws SQLException {
        try {
            return new DBContext().getConnection();
        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("Khong the tao ket noi CSDL", e);
        }
    }

    // ===================== CLIENT METHODS =====================

    public User checkLogin(String email, String password) {
        System.out.println(">>> Đang login: [" + email + "] / [" + password + "]");
        
        // Chỉ cho phép đăng nhập nếu tài khoản chưa bị khóa (is_active = 1)
        String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ? AND is_active = 1";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println(">>> Tìm thấy user hợp lệ, đang map...");
                    return mapUser(rs);
                } else {
                    System.out.println(">>> Không tìm thấy hoặc tài khoản bị khóa!");
                }
            }
        } catch (Exception e) {
            System.out.println(">>> LỖI checkLogin: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public User findUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO Users (full_name, email, phone, password_hash, role) VALUES (?, ?, ?, ?, 'customer')";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPasswordHash());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println(">>> LỖI registerUser: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    // ===================== ADMIN METHODS =====================

    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'customer'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countSeller() {
        String sql = "SELECT COUNT(*) FROM sellers s JOIN users u ON s.user_id = u.user_id WHERE s.is_approved = 1 AND u.is_active = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY user_id ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapUser(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ĐÃ FIX: Lấy thêm created_at để hiển thị
    public List<Seller> getAllSeller() {
        List<Seller> list = new ArrayList<>();
        String sql = "SELECT s.*, u.email, u.full_name FROM sellers s JOIN users u ON s.user_id = u.user_id ORDER BY s.seller_id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Seller s = new Seller();
                s.setSellerId(rs.getInt("seller_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setShopName(rs.getString("shop_name"));
                s.setDescription(rs.getString("description"));
                s.setApproved(rs.getBoolean("is_approved"));
                s.setOwnerEmail(rs.getString("email"));
                s.setOwnerFullName(rs.getString("full_name"));
                
                // Cố gắng lấy created_at nếu có trong DB
                try {
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                } catch (Exception ignored) {}
                
                list.add(s);
            }
        } catch (SQLException e) { 
            System.err.println("Lỗi getAllSeller: " + e.getMessage());
            e.printStackTrace(); 
        }
        return list;
    }

    // ĐÃ FIX: Logic tự động tạo Shop chờ duyệt khi cấp quyền
    public boolean updateUserRole(int userId, String role) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // 1. Cập nhật quyền trong bảng users
            String sqlUpdateRole = "UPDATE users SET role = ? WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateRole)) {
                ps.setString(1, role);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }
            
            // 2. NẾU LÀ SELLER, TỰ ĐỘNG TẠO 1 SHOP CHỜ DUYỆT (is_approved = 0) NẾU CHƯA CÓ
            if ("seller".equals(role)) {
                String checkShop = "SELECT seller_id FROM sellers WHERE user_id = ?";
                boolean hasShop = false;
                try (PreparedStatement psCheck = conn.prepareStatement(checkShop)) {
                    psCheck.setInt(1, userId);
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) hasShop = true;
                    }
                }
                
                // Nếu chưa có shop, insert mặc định vào
                if (!hasShop) {
                    String insertShop = "INSERT INTO sellers (user_id, shop_name, description, is_approved) VALUES (?, 'Gian Hàng Mới', 'Đang chờ Admin duyệt quyền bán hàng...', 0)";
                    try (PreparedStatement psInsert = conn.prepareStatement(insertShop)) {
                        psInsert.setInt(1, userId);
                        psInsert.executeUpdate();
                    }
                }
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) { 
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace(); 
            return false; 
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }

    public boolean deleteSeller(int sellerId) {
        String sqlGetUserId = "SELECT user_id FROM sellers WHERE seller_id = ?";
        String sqlDelShop = "DELETE FROM sellers WHERE seller_id = ?";
        String sqlUpdateRole = "UPDATE users SET role = 'customer' WHERE user_id = ?";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            int userId = -1;
            try (PreparedStatement ps = conn.prepareStatement(sqlGetUserId)) {
                ps.setInt(1, sellerId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) userId = rs.getInt("user_id");
            }
            if (userId == -1) return false;

            try (PreparedStatement ps = conn.prepareStatement(sqlDelShop)) {
                ps.setInt(1, sellerId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateRole)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }

    public Seller getSellerByUserId(int userId) {
        String sql = "SELECT * FROM sellers WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Seller s = new Seller();
                s.setSellerId(rs.getInt("seller_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setShopName(rs.getString("shop_name"));
                s.setDescription(rs.getString("description"));
                s.setApproved(rs.getBoolean("is_approved"));
                return s;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean deleteUser(int userId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            try (Statement s = conn.createStatement()) { s.execute("SET FOREIGN_KEY_CHECKS = 0"); }
            
            String sql1 = "DELETE FROM cart_items WHERE cart_id IN (SELECT cart_id FROM carts WHERE user_id = ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql1)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql2 = "DELETE FROM carts WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql2)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql3 = "DELETE FROM order_items WHERE order_id IN (SELECT order_id FROM orders WHERE user_id = ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql3)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql4 = "DELETE FROM orders WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql4)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql5 = "DELETE FROM reviews WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql5)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql6 = "DELETE FROM order_items WHERE product_id IN (SELECT product_id FROM products WHERE seller_id IN (SELECT seller_id FROM sellers WHERE user_id = ?))";
            try (PreparedStatement ps = conn.prepareStatement(sql6)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql7 = "DELETE FROM products WHERE seller_id IN (SELECT seller_id FROM sellers WHERE user_id = ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql7)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql8 = "DELETE FROM sellers WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql8)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql9 = "DELETE FROM addresses WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql9)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            String sql10 = "DELETE FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql10)) { ps.setInt(1, userId); ps.executeUpdate(); }
            
            try (Statement s = conn.createStatement()) { s.execute("SET FOREIGN_KEY_CHECKS = 1"); }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    try (Statement s = conn.createStatement()) { s.execute("SET FOREIGN_KEY_CHECKS = 1"); }
                    conn.rollback();
                } catch (SQLException ex) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }

    public boolean updateUserActive(int userId, boolean active) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    public boolean updateSellerApproval(int sellerId, boolean isApproved) {
        String sql = "UPDATE sellers SET is_approved = ? WHERE seller_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, isApproved ? 1 : 0);
            ps.setInt(2, sellerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}