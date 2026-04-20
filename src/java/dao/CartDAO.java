package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;
import utils.DBContext;
import model.CartItemDTO;

public class CartDAO {
    
    /**
     * Hàm lấy cart_id của user, nếu chưa có thì tạo mới
     */
    public int getOrCreateCartId(int userId) {
        String checkSql = "SELECT cart_id FROM Carts WHERE user_id = ?";
        String insertSql = "INSERT INTO Carts (user_id) VALUES (?)";
        
        try (Connection conn = new DBContext().getConnection()) {
            // 1. Kiểm tra xem đã có giỏ hàng chưa
            PreparedStatement psCheck = conn.prepareStatement(checkSql);
            psCheck.setInt(1, userId);
            ResultSet rs = psCheck.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("cart_id"); // Đã có giỏ, trả về ID luôn
            }
            
            // 2. Nếu chưa có, tạo giỏ mới
            PreparedStatement psInsert = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            psInsert.setInt(1, userId);
            psInsert.executeUpdate();
            
            ResultSet rsKeys = psInsert.getGeneratedKeys();
            if (rsKeys.next()) {
                return rsKeys.getInt(1); // Trả về cart_id vừa được tạo tự động
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại getOrCreateCartId: " + e.getMessage());
        }
        return -1; // Lỗi
    }

    /**
     * Hàm xử lý nút "Thêm vào giỏ hàng"
     */
    public boolean addToCart(int userId, int productId, int quantity) {
        // Lấy mã giỏ hàng của user này
        int cartId = getOrCreateCartId(userId);
        if (cartId == -1) return false;

        String checkItemSql = "SELECT quantity FROM Cart_Items WHERE cart_id = ? AND product_id = ?";
        String updateItemSql = "UPDATE Cart_Items SET quantity = quantity + ? WHERE cart_id = ? AND product_id = ?";
        String insertItemSql = "INSERT INTO Cart_Items (cart_id, product_id, quantity) VALUES (?, ?, ?)";

        try (Connection conn = new DBContext().getConnection()) {
            // Kiểm tra sản phẩm đã có trong giỏ chưa
            PreparedStatement psCheck = conn.prepareStatement(checkItemSql);
            psCheck.setInt(1, cartId);
            psCheck.setInt(2, productId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Sản phẩm đã tồn tại -> Cộng dồn số lượng
                PreparedStatement psUpdate = conn.prepareStatement(updateItemSql);
                psUpdate.setInt(1, quantity);
                psUpdate.setInt(2, cartId);
                psUpdate.setInt(3, productId);
                psUpdate.executeUpdate();
            } else {
                // Sản phẩm mới -> Thêm mới vào giỏ
                PreparedStatement psInsert = conn.prepareStatement(insertItemSql);
                psInsert.setInt(1, cartId);
                psInsert.setInt(2, productId);
                psInsert.setInt(3, quantity);
                psInsert.executeUpdate();
            }
            return true;
            
        } catch (Exception e) {
            System.err.println("Lỗi tại addToCart: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Hàm lấy danh sách sản phẩm trong giỏ hàng của một User
     */
    public List<CartItemDTO> getCartItems(int userId) {
        List<CartItemDTO> list = new ArrayList<>();
        
        // Câu lệnh INNER JOIN 3 bảng: Carts, Cart_Items và Products
        String sql = "SELECT p.product_id, p.name, p.base_price, ci.quantity "
                   + "FROM Carts c "
                   + "INNER JOIN Cart_Items ci ON c.cart_id = ci.cart_id "
                   + "INNER JOIN Products p ON ci.product_id = p.product_id "
                   + "WHERE c.user_id = ?";
                   
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItemDTO item = new CartItemDTO();
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("name"));
                    
                    BigDecimal price = rs.getBigDecimal("base_price");
                    int quantity = rs.getInt("quantity");
                    
                    item.setBasePrice(price);
                    item.setQuantity(quantity);
                    
                    // Tự động tính tổng tiền của món đó (Giá x Số lượng)
                    item.setItemTotal(price.multiply(new BigDecimal(quantity)));
                    
                    list.add(item);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại getCartItems: " + e.getMessage());
        }
        return list; // Trả về danh sách đã được nhồi đầy dữ liệu
    }
}