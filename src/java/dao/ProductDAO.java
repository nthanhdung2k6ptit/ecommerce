package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Products;
import utils.DBUtil;

public class ProductDAO {

    public List<Products> getAllProducts() {
        return getProductsBySeller(-1);
    }

    public int countProducts(int sellerId) {
        String sql = "SELECT COUNT(*) FROM Products ";
        if (sellerId > 0) sql += " WHERE seller_id = " + sellerId;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Products> getProductsBySeller(int sellerId) {
        List<Products> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name " +
                     "FROM Products p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Sellers s ON p.seller_id = s.seller_id ";
                     
        if (sellerId > 0) sql += " WHERE p.seller_id = ? ";
        sql += " ORDER BY p.product_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (sellerId > 0) ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Products p = buildProduct(rs);
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Products> searchProducts(String keyword, int sellerId) {
        List<Products> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name " +
                     "FROM Products p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Sellers s ON p.seller_id = s.seller_id " +
                     "WHERE (p.name LIKE ? OR c.name LIKE ?) ";
                     
        if (sellerId > 0) sql += " AND p.seller_id = ? ";
        sql += " ORDER BY p.product_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            if (sellerId > 0) ps.setInt(3, sellerId);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildProduct(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Products getProductById(int productId) {
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name FROM Products p JOIN Categories c ON p.category_id = c.category_id JOIN Sellers s ON p.seller_id = s.seller_id WHERE p.product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildProduct(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertProduct(Products p) {
        String sql = "INSERT INTO Products (seller_id, category_id, name, description, base_price, stock_quantity) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getSellerId());
            ps.setInt(2, p.getCategoryId());
            ps.setString(3, p.getName());
            ps.setString(4, p.getDescription());
            ps.setBigDecimal(5, p.getBasePrice());
            ps.setInt(6, p.getStockQuantity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateProduct(Products p) {
        String sql = "UPDATE Products SET category_id = ?, name = ?, description = ?, base_price = ?, stock_quantity = ? WHERE product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getBasePrice());
            ps.setInt(5, p.getStockQuantity());
            ps.setInt(6, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateStock(int productId, int quantity) {
        String sql = "UPDATE Products SET stock_quantity = ? WHERE product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Products WHERE product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Products buildProduct(ResultSet rs) throws SQLException {
        Products p = new Products();
        p.setProductId(rs.getInt("product_id"));
        p.setSellerId(rs.getInt("seller_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setBasePrice(rs.getBigDecimal("base_price"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        
        p.setCategoryName(rs.getString("cat_name"));
        p.setShopName(rs.getString("shop_name"));
        return p;
    }
}
