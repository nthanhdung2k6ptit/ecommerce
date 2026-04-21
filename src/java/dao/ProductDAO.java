package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import utils.DBContext;

public class ProductDAO {

    private Connection getConnection() throws SQLException {
        try {
            return new DBContext().getConnection();
        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("Khong the tao ket noi CSDL", e);
        }
    }

    public List<Product> getAllProduct() {
        return getProductBySeller(-1);
    }

    public int countProduct(int sellerId) {
        String sql = "SELECT COUNT(*) FROM Product ";
        if (sellerId > 0) sql += " WHERE seller_id = " + sellerId;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Product> getProductBySeller(int sellerId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name " +
                     "FROM Product p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Sellers s ON p.seller_id = s.seller_id ";
                     
        if (sellerId > 0) sql += " WHERE p.seller_id = ? ";
        sql += " ORDER BY p.product_id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (sellerId > 0) ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = buildProduct(rs);
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Product> searchProduct(String keyword, int sellerId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name " +
                     "FROM Product p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Sellers s ON p.seller_id = s.seller_id " +
                     "WHERE (p.name LIKE ? OR c.name LIKE ?) ";
                     
        if (sellerId > 0) sql += " AND p.seller_id = ? ";
        sql += " ORDER BY p.product_id DESC";

        try (Connection conn = getConnection();
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

    public Product getProductById(int productId) {
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name FROM Product p JOIN Categories c ON p.category_id = c.category_id JOIN Sellers s ON p.seller_id = s.seller_id WHERE p.product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildProduct(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO Product (seller_id, category_id, name, description, base_price, stock_quantity) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
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

    public boolean updateProduct(Product p) {
        String sql = "UPDATE Product SET category_id = ?, name = ?, description = ?, base_price = ?, stock_quantity = ? WHERE product_id = ?";
        try (Connection conn = getConnection();
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
        String sql = "UPDATE Product SET stock_quantity = ? WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Product WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Product buildProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
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
