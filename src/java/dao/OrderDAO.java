package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBContext;

public class OrderDAO {

    /**
     * Hàm xử lý quy trình chốt đơn khép kín (Transaction)
     * Nhận vào: ID người mua, ID địa chỉ giao, ID voucher (có thể null), 
     * Tổng tiền cuối cùng, Phí ship, và Phương thức thanh toán
     */
    public boolean placeOrder(int userId, int addressId, Integer voucherId, 
                              BigDecimal totalAmount, BigDecimal shippingFee, String paymentMethod) {
        
        Connection conn = null;
        
        try {
            conn = new DBContext().getConnection();
            // TẮT CHẾ ĐỘ AUTO COMMIT: Bắt đầu một Transaction (Giao dịch)
            conn.setAutoCommit(false);

            // =========================================================================
            // BƯỚC 1: LƯU VÀO BẢNG Orders
            // =========================================================================
            String insertOrderSql = "INSERT INTO Orders (user_id, address_id, voucher_id, total_amount, shipping_fee, status) VALUES (?, ?, ?, ?, ?, 'pending')";
            PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, PreparedStatement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setInt(2, addressId);
            
            // Xử lý voucherId có thể null
            if (voucherId != null) {
                psOrder.setInt(3, voucherId);
            } else {
                psOrder.setNull(3, java.sql.Types.INTEGER);
            }
            
            psOrder.setBigDecimal(4, totalAmount);
            psOrder.setBigDecimal(5, shippingFee);
            psOrder.executeUpdate();

            // Lấy ra order_id vừa được tạo
            ResultSet rsOrderKeys = psOrder.getGeneratedKeys();
            int orderId = -1;
            if (rsOrderKeys.next()) {
                orderId = rsOrderKeys.getInt(1);
            }

            // =========================================================================
            // BƯỚC 2: COPY TỪ GIỎ HÀNG SANG ORDER_ITEMS VÀ TRỪ TỒN KHO
            // =========================================================================
            // Lấy dữ liệu từ giỏ hàng hiện tại của user
            String getCartItemsSql = "SELECT ci.product_id, ci.quantity, p.base_price, p.stock_quantity "
                                   + "FROM Cart_Items ci "
                                   + "JOIN Carts c ON ci.cart_id = c.cart_id "
                                   + "JOIN Products p ON ci.product_id = p.product_id "
                                   + "WHERE c.user_id = ?";
            PreparedStatement psGetCart = conn.prepareStatement(getCartItemsSql);
            psGetCart.setInt(1, userId);
            ResultSet rsCart = psGetCart.executeQuery();

            String insertOrderItemSql = "INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
            PreparedStatement psInsertItem = conn.prepareStatement(insertOrderItemSql);

            String updateStockSql = "UPDATE Products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
            PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSql);

            while (rsCart.next()) {
                int productId = rsCart.getInt("product_id");
                int quantity = rsCart.getInt("quantity");
                BigDecimal basePrice = rsCart.getBigDecimal("base_price");
                int stockQuantity = rsCart.getInt("stock_quantity");

                // Kiểm tra xem kho còn đủ hàng không? Nếu không đủ -> Quăng lỗi để Rollback ngay
                if (stockQuantity < quantity) {
                    throw new Exception("Sản phẩm ID " + productId + " không đủ số lượng trong kho!");
                }

                // Lưu vào Order_Items (Bắt buộc phải lưu cứng price_at_purchase [cite: 57, 58])
                psInsertItem.setInt(1, orderId);
                psInsertItem.setInt(2, productId);
                psInsertItem.setInt(3, quantity);
                psInsertItem.setBigDecimal(4, basePrice);
                psInsertItem.executeUpdate();

                // Trừ tồn kho trong bảng Products
                psUpdateStock.setInt(1, quantity);
                psUpdateStock.setInt(2, productId);
                psUpdateStock.executeUpdate();
            }

            // =========================================================================
            // BƯỚC 3: DỌN SẠCH GIỎ HÀNG SAU KHI MUA XONG
            // =========================================================================
            String clearCartSql = "DELETE FROM Cart_Items WHERE cart_id = (SELECT cart_id FROM Carts WHERE user_id = ?)";
            PreparedStatement psClearCart = conn.prepareStatement(clearCartSql);
            psClearCart.setInt(1, userId);
            psClearCart.executeUpdate();

            // =========================================================================
            // BƯỚC 4: LƯU PHƯƠNG THỨC THANH TOÁN (Payments)
            // =========================================================================
            String insertPaymentSql = "INSERT INTO Payments (order_id, method, status) VALUES (?, ?, 'unpaid')";
            PreparedStatement psPayment = conn.prepareStatement(insertPaymentSql);
            psPayment.setInt(1, orderId);
            psPayment.setString(2, paymentMethod);
            psPayment.executeUpdate();

            // NẾU TẤT CẢ CÁC BƯỚC TRÊN CHẠY CHƠN TRU -> CHỐT SỔ (COMMIT)
            conn.commit();
            return true;

        } catch (Exception e) {
            // NẾU CÓ BẤT KỲ LỖI GÌ (ví dụ hết hàng) -> HOÀN TÁC TOÀN BỘ (ROLLBACK)
            try {
                if (conn != null) {
                    conn.rollback(); 
                    System.err.println("Giao dịch thất bại, ĐÃ ROLLBACK: " + e.getMessage());
                }
            } catch (Exception re) {
                re.printStackTrace();
            }
            return false;
        } finally {
            // Luôn luôn phải đóng kết nối
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Trả lại trạng thái mặc định
                    conn.close();
                }
            } catch (Exception ce) {
                ce.printStackTrace();
            }
        }
    }
}