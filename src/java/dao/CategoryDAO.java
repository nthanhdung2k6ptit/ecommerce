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

    public List<Category> getAllCategory() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, p.name AS parent_name FROM Category c LEFT JOIN Category p ON c.parent_id = p.category_id ORDER BY c.category_id DESC";
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
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Category> getRootCategory() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category WHERE parent_id IS NULL";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM Category WHERE category_id = ?";
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
                return c;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertCategory(Category c) {
        String sql = "INSERT INTO Category (name, parent_id) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateCategory(Category c) {
        String sql = "UPDATE Category SET name = ?, parent_id = ? WHERE category_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setInt(3, c.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM Category WHERE category_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
