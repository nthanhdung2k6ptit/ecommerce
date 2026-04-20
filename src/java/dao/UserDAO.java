package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Users;
import model.Sellers;
import utils.DBUtil;

public class UserDAO {

    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = 'customer'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countSellers() {
        String sql = "SELECT COUNT(*) FROM Sellers";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Users u = new Users();
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

    public List<Sellers> getAllSellers() {
        List<Sellers> list = new ArrayList<>();
        String sql = "SELECT s.*, u.email, u.full_name FROM Sellers s JOIN Users u ON s.user_id = u.user_id ORDER BY s.seller_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Sellers s = new Sellers();
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
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteSeller(int sellerId) {
        String sqlGetUserId = "SELECT user_id FROM Sellers WHERE seller_id = ?";
        String sqlDelShop = "DELETE FROM Sellers WHERE seller_id = ?";
        String sqlUpdateRole = "UPDATE Users SET role = 'customer' WHERE user_id = ?";

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
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
    
    public Sellers getSellerByUserId(int userId) {
        String sql = "SELECT * FROM Sellers WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Sellers s = new Sellers();
                s.setSellerId(rs.getInt("seller_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setShopName(rs.getString("shop_name"));
                s.setDescription(rs.getString("description"));
                return s;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Bỏ qua update_active và approve_seller vì schema không hỗ trợ trường này.
    public void updateUserActive(int userId, boolean isActive) {}
    public void updateSellerApproval(int sellerId, boolean isApproved) {}
}
