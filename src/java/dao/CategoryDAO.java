package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Categories;
import utils.DBUtil;

public class CategoryDAO {

    public List<Categories> getAllCategories() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT c.*, p.name AS parent_name FROM Categories c LEFT JOIN Categories p ON c.parent_id = p.category_id ORDER BY c.category_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categories c = new Categories();
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

    public List<Categories> getRootCategories() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT * FROM Categories WHERE parent_id IS NULL";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categories c = new Categories();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Categories getCategoryById(int id) {
        String sql = "SELECT * FROM Categories WHERE category_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Categories c = new Categories();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                int parentId = rs.getInt("parent_id");
                if (!rs.wasNull()) c.setParentId(parentId);
                return c;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertCategory(Categories c) {
        String sql = "INSERT INTO Categories (name, parent_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateCategory(Categories c) {
        String sql = "UPDATE Categories SET name = ?, parent_id = ? WHERE category_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            if (c.getParentId() != null) ps.setInt(2, c.getParentId());
            else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setInt(3, c.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM Categories WHERE category_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
