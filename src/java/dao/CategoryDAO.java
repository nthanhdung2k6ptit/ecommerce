package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import utils.DBContext;

public class CategoryDAO {

    private Connection getConnection() throws SQLException {
        try {
            return new DBContext().getConnection();
        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("Khong the tao ket noi CSDL", e);
        }
    }

    // === LẤY DANH MỤC CHO TRANG CHỦ ===
    public List<Category> getCategoriesForHome() {
        List<Category> list = new ArrayList<>();
        // ĐÃ FIX: Lấy tất cả danh mục (có thể giới hạn số lượng bằng LIMIT 8 hoặc 12 tùy ông)
        String sql = "SELECT * FROM categories ORDER BY category_id DESC LIMIT 12";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                
                String catName = rs.getString("name");
                c.setName(catName);
                
                // TRICK BÙ ẢNH TRỐNG: Nếu ảnh trong DB bị NULL, tự động cấp ảnh Placeholder
                String img = rs.getString("image_url");
                if (img == null || img.trim().isEmpty()) {
                    // Tạo ảnh ảo có chứa chữ tên danh mục cho khỏi bị vỡ layout
                    c.setImageUrl("https://placehold.co/150x150/f0f0f0/666666?text=" + catName.replace(" ", "+"));
                } else {
                    c.setImageUrl(img);
                }
                
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        } catch (SQLException e) { 
            System.err.println("Lỗi lấy danh mục trang chủ: " + e.getMessage());
        }
        return list;
    }

    // === LẤY TẤT CẢ CHO TRANG QUẢN TRỊ ===
    public List<Category> getAllCategory() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, p.name AS parent_name FROM categories c LEFT JOIN categories p ON c.parent_id = p.category_id ORDER BY c.category_id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                
                int parentId = rs.getInt("parent_id");
                if (!rs.wasNull()) {
                    c.setParentId(parentId);
                }
                c.setParentName(rs.getString("parent_name"));
                c.setImageUrl(rs.getString("image_url")); 
                c.setDescription(rs.getString("description"));
                
                list.add(c);
            }
        } catch (SQLException e) { 
            System.err.println("Lỗi getAllCategory: " + e.getMessage()); 
        }
        return list;
    }

    public List<Category> getRootCategory() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE parent_id IS NULL";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setImageUrl(rs.getString("image_url")); 
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                int parentId = rs.getInt("parent_id");
                if (!rs.wasNull()) c.setParentId(parentId);
                c.setImageUrl(rs.getString("image_url"));
                c.setDescription(rs.getString("description"));
                return c;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertCategory(Category c) {
        String sql = "INSERT INTO categories (name, parent_id, image_url, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setString(3, c.getImageUrl());
            ps.setString(4, c.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateCategory(Category c) {
        String sql = "UPDATE categories SET name = ?, parent_id = ?, image_url = ?, description = ? WHERE category_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setString(3, c.getImageUrl());
            ps.setString(4, c.getDescription());
            ps.setInt(5, c.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}