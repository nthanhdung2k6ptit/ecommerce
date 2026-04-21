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

    /**
     * 1. Kiểm tra đăng nhập
     * Trả về User object nếu đúng, null nếu sai
     */
    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 2. Đăng ký tài khoản mới
     * Trả về true nếu đăng ký thành công
     */
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
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 3. Kiểm tra Email đã tồn tại chưa (Dùng khi Đăng ký)
     */
    public boolean isEmailExists(String email) {
        String sql = "SELECT user_id FROM Users WHERE email = ?";
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

    /**
     * 4. Lấy thông tin User theo ID (Dùng cho trang Profile)
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    // ===================== ADMIN METHODS =====================

    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = 'customer'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countSeller() {
        String sql = "SELECT COUNT(*) FROM Seller";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Seller> getAllSeller() {
        List<Seller> list = new ArrayList<>();
        String sql = "SELECT s.*, u.email, u.full_name FROM Seller s JOIN Users u ON s.user_id = u.user_id ORDER BY s.seller_id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Seller s = new Seller();
                s.setSellerId(rs.getInt("seller_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setShopName(rs.getString("shop_name"));
                s.setDescription(rs.getString("description"));
                s.setOwnerEmail(rs.getString("email"));
                s.setOwnerFullName(rs.getString("full_name"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateUserRole(int userId, String role) {
        String sql = "UPDATE Users SET role = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteSeller(int sellerId) {
        String sqlGetUserId = "SELECT user_id FROM Seller WHERE seller_id = ?";
        String sqlDelShop = "DELETE FROM Seller WHERE seller_id = ?";
        String sqlUpdateRole = "UPDATE Users SET role = 'customer' WHERE user_id = ?";

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
        String sql = "SELECT * FROM Seller WHERE user_id = ?";
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
                return s;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void updateUserActive(int userId, boolean isActive) {}
    public void updateSellerApproval(int sellerId, boolean isApproved) {}
}
