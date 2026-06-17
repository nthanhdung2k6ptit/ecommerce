package dao;

import java.math.BigDecimal;
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
        String sql = "SELECT COUNT(*) FROM products ";
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
                     "FROM products p " +
                     "JOIN categories c ON p.category_id = c.category_id " +
                     "JOIN sellers s ON p.seller_id = s.seller_id ";
                     
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
        } catch (SQLException e) { throw new RuntimeException("SQL Error in getProductBySeller: " + e.getMessage(), e); }
        return list;
    }

    public List<Product> searchProduct(String keyword, int sellerId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name " +
                     "FROM products p " +
                     "JOIN categories c ON p.category_id = c.category_id " +
                     "JOIN sellers s ON p.seller_id = s.seller_id " +
                     "WHERE (p.name LIKE ? OR c.name LIKE ?) ";
                     
        if (sellerId > 0) sql += " AND p.seller_id = ? ";
        sql += " ORDER BY p.product_id DESC";

        // Diagnostic: print SQL and parameters
        System.out.println("[ProductDAO.searchProduct] sql=" + sql + " | keyword=" + keyword + " | sellerId=" + sellerId);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            if (sellerId > 0) ps.setInt(3, sellerId);

            System.out.println("[ProductDAO.searchProduct] Executing prepared statement: " + ps);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildProduct(rs));
            }
        } catch (SQLException e) { 
            System.out.println("[ProductDAO.searchProduct] SQL exception: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int productId) {
        // Đã sửa c.name AS category_name thành c.name AS cat_name
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name \n" +
        "FROM Products p \n" +
        "LEFT JOIN Categories c ON p.category_id = c.category_id \n" +
        "LEFT JOIN Sellers s ON p.seller_id = s.seller_id \n" +
        "WHERE p.product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildProduct(rs);
        } catch (SQLException e) { 
            // In ra lỗi cụ thể nếu có để dễ debug
            System.err.println("Lỗi tại getProductById: " + e.getMessage()); 
        }
        return null;
    }

    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO products (seller_id, category_id, name, description, base_price, stock_quantity, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getSellerId());
            ps.setInt(2, p.getCategoryId());
            ps.setString(3, p.getName());
            ps.setString(4, p.getDescription());
            ps.setBigDecimal(5, p.getBasePrice());
            ps.setInt(6, p.getStockQuantity());
            ps.setString(7, p.getImageUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE products SET category_id = ?, name = ?, description = ?, base_price = ?, stock_quantity = ?, image_url = ? WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getBasePrice());
            ps.setInt(5, p.getStockQuantity());
            ps.setString(6, p.getImageUrl());
            ps.setInt(7, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock_quantity = ? WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false;
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
        p.setImageUrl(rs.getString("image_url"));
        p.setActive(rs.getBoolean("is_active"));
        
        p.setCategoryName(rs.getString("cat_name"));
        p.setShopName(rs.getString("shop_name"));
        return p;
    }
    
    public List<Product> getProductsForHome(int offset) {
        List<Product> list = new ArrayList<>();
        // Lấy 5 sản phẩm, bắt đầu từ vị trí offset
        String sql = "SELECT p.*, c.name AS cat_name, s.shop_name " +
                     "FROM products p " +
                     "JOIN categories c ON p.category_id = c.category_id " +
                     "JOIN sellers s ON p.seller_id = s.seller_id " +
                     "WHERE p.is_active = 1 " +
                     "ORDER BY p.product_id DESC LIMIT 5 OFFSET ?";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Hàm tìm kiếm sản phẩm theo từ khóa (Tìm trong tên sản phẩm)
     */
    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        // Dùng LIKE %keyword% để tìm kiếm chuỗi chứa từ khóa
        String sql = "SELECT * FROM Products WHERE name LIKE ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            // Bọc từ khóa trong % % để tìm kiếm linh hoạt (chứa từ khóa là ra)
            ps.setString(1, "%" + keyword + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setBasePrice(rs.getBigDecimal("base_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    // Thêm các thuộc tính khác của Product nếu ông cần
                    
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại hàm searchProducts: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * 1. Hàm Lọc, Tìm kiếm, Sắp xếp, Phân trang + LỌC THEO DANH MỤC
     */
    public List<Product> getFilteredProducts(String keyword, String minPrice, String maxPrice, String categoryId, String sort, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE 1=1 ");

        // Lọc theo Danh mục (Từ trang chủ ném sang)
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append(" AND category_id = ? ");
            params.add(Integer.parseInt(categoryId));
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (minPrice != null && !minPrice.trim().isEmpty()) {
            sql.append(" AND base_price >= ? ");
            params.add(new BigDecimal(minPrice));
        }
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            sql.append(" AND base_price <= ? ");
            params.add(new BigDecimal(maxPrice));
        }

        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY base_price ASC ");
        } else if ("price_desc".equals(sort)) {
            sql.append(" ORDER BY base_price DESC ");
        } else if ("newest".equals(sort)) {
            sql.append(" ORDER BY product_id DESC "); 
        } else {
            sql.append(" ORDER BY product_id DESC "); 
        }

        int offset = (page - 1) * pageSize;
        sql.append(" LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = new utils.DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setBasePrice(rs.getBigDecimal("base_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại getFilteredProducts: " + e.getMessage());
        }
        return list;
    }

    /**
     * 2. Hàm đếm tổng sản phẩm (Cập nhật thêm categoryId)
     */
    public int countFilteredProducts(String keyword, String minPrice, String maxPrice, String categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Products WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append(" AND category_id = ? ");
            params.add(Integer.parseInt(categoryId));
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (minPrice != null && !minPrice.trim().isEmpty()) {
            sql.append(" AND base_price >= ? ");
            params.add(new BigDecimal(minPrice));
        }
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            sql.append(" AND base_price <= ? ");
            params.add(new BigDecimal(maxPrice));
        }

        try (Connection conn = new utils.DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại countFilteredProducts: " + e.getMessage());
        }
        return 0;
    }
}
