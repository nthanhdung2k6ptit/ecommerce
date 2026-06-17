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
        // ĐÃ FIX: Thêm ORDER BY DESC để hiện cái mới nhất, tăng LIMIT lên 8 (hoặc xóa LIMIT tùy ý)
        String sql = "SELECT * FROM categories WHERE icon_url IS NOT NULL AND icon_url != '' ORDER BY category_id DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setIconUrl(rs.getString("icon_url")); 
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
                
                // ĐÃ FIX: Lấy cột icon_url từ DB nhét vào biến imageUrl của Model
                c.setImageUrl(rs.getString("icon_url")); 
                // Bỏ cột description vì DB không có
                
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
                c.setImageUrl(rs.getString("icon_url")); // ĐÃ FIX
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
                c.setImageUrl(rs.getString("icon_url")); // ĐÃ FIX
                return c;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertCategory(Category c) {
        // ĐÃ FIX: Sửa câu lệnh INSERT cho khớp tên cột trong MySQL
        String sql = "INSERT INTO categories (name, parent_id, icon_url) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setString(3, c.getImageUrl()); // Lấy URL do admin nhập
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateCategory(Category c) {
        // ĐÃ FIX: Sửa câu lệnh UPDATE
        String sql = "UPDATE categories SET name = ?, parent_id = ?, icon_url = ? WHERE category_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setString(3, c.getImageUrl());
            ps.setInt(4, c.getCategoryId());
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