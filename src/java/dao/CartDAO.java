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
     * HÃ m láº¥y cart_id cá»§a user, náº¿u chÆ°a cÃ³ thÃ¬ táº¡o má»›i
     */
    public int getOrCreateCartId(int userId) {
        String checkSql = "SELECT cart_id FROM Carts WHERE user_id = ?";
        String insertSql = "INSERT INTO Carts (user_id) VALUES (?)";
        
        try (Connection conn = new DBContext().getConnection()) {
            // 1. Kiá»ƒm tra xem Ä‘Ã£ cÃ³ giá» hÃ ng chÆ°a
            PreparedStatement psCheck = conn.prepareStatement(checkSql);
            psCheck.setInt(1, userId);
            ResultSet rs = psCheck.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("cart_id"); // ÄÃ£ cÃ³ giá», tráº£ vá» ID luÃ´n
            }
            
            // 2. Náº¿u chÆ°a cÃ³, táº¡o giá» má»›i
            PreparedStatement psInsert = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            psInsert.setInt(1, userId);
            psInsert.executeUpdate();
            
            ResultSet rsKeys = psInsert.getGeneratedKeys();
            if (rsKeys.next()) {
                return rsKeys.getInt(1); // Tráº£ vá» cart_id vá»«a Ä‘Æ°á»£c táº¡o tá»± Ä‘á»™ng
            }
        } catch (Exception e) {
            System.err.println("Lá»—i táº¡i getOrCreateCartId: " + e.getMessage());
        }
        return -1; // Lá»—i
    }

    /**
     * HÃ m xá»­ lÃ½ nÃºt "ThÃªm vÃ o giá» hÃ ng"
     */
    public boolean addToCart(int userId, int productId, int quantity) {
        // Láº¥y mÃ£ giá» hÃ ng cá»§a user nÃ y
        int cartId = getOrCreateCartId(userId);
        if (cartId == -1) return false;

        String checkItemSql = "SELECT quantity FROM Cart_Items WHERE cart_id = ? AND product_id = ?";
        String updateItemSql = "UPDATE Cart_Items SET quantity = quantity + ? WHERE cart_id = ? AND product_id = ?";
        String insertItemSql = "INSERT INTO Cart_Items (cart_id, product_id, quantity) VALUES (?, ?, ?)";

        try (Connection conn = new DBContext().getConnection()) {
            // Kiá»ƒm tra sáº£n pháº©m Ä‘Ã£ cÃ³ trong giá» chÆ°a
            PreparedStatement psCheck = conn.prepareStatement(checkItemSql);
            psCheck.setInt(1, cartId);
            psCheck.setInt(2, productId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Sáº£n pháº©m Ä‘Ã£ tá»“n táº¡i -> Cá»™ng dá»“n sá»‘ lÆ°á»£ng
                PreparedStatement psUpdate = conn.prepareStatement(updateItemSql);
                psUpdate.setInt(1, quantity);
                psUpdate.setInt(2, cartId);
                psUpdate.setInt(3, productId);
                psUpdate.executeUpdate();
            } else {
                // Sáº£n pháº©m má»›i -> ThÃªm má»›i vÃ o giá»
                PreparedStatement psInsert = conn.prepareStatement(insertItemSql);
                psInsert.setInt(1, cartId);
                psInsert.setInt(2, productId);
                psInsert.setInt(3, quantity);
                psInsert.executeUpdate();
            }
            return true;
            
        } catch (Exception e) {
            System.err.println("Lá»—i táº¡i addToCart: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * HÃ m láº¥y danh sÃ¡ch sáº£n pháº©m trong giá» hÃ ng cá»§a má»™t User
     */
    public List<CartItemDTO> getCartItems(int userId) {
        List<CartItemDTO> list = new ArrayList<>();
        
        // CÃ¢u lá»‡nh INNER JOIN 3 báº£ng: Carts, Cart_Items vÃ  Products
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
                    
                    // Tá»± Ä‘á»™ng tÃ­nh tá»•ng tiá»n cá»§a mÃ³n Ä‘Ã³ (GiÃ¡ x Sá»‘ lÆ°á»£ng)
                    item.setItemTotal(price.multiply(new BigDecimal(quantity)));
                    
                    list.add(item);
                }
            }
        } catch (Exception e) {
            System.err.println("Lá»—i táº¡i getCartItems: " + e.getMessage());
        }
        return list; // Tráº£ vá» danh sÃ¡ch Ä‘Ã£ Ä‘Æ°á»£c nhá»“i Ä‘áº§y dá»¯ liá»‡u
    }
}
