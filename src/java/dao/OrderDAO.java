package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderItem;
import utils.DBContext;
import model.CartItemDTO; // Đã thêm import này

public class OrderDAO {

    private Connection getConnection() throws SQLException {
        try {
            return new DBContext().getConnection();
        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("Khong the tao ket noi CSDL", e);
        }
    }

    // ===================== ADMIN METHODS =====================

    public List<Order> getAllOrders() {
        return getOrdersWithFilter(-1, null);
    }

    public int countOrders(int sellerId) {
        String sql = "SELECT COUNT(DISTINCT o.order_id) FROM Orders o ";
        if (sellerId > 0) {
            sql += " JOIN Order_Items oi ON o.order_id = oi.order_id JOIN Products p ON oi.product_id = p.product_id WHERE p.seller_id = " + sellerId;
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public BigDecimal getTotalRevenue(int sellerId) {
        String sql = "SELECT SUM(oi.quantity * oi.price_at_purchase) FROM Order_Items oi JOIN Orders o ON oi.order_id = o.order_id WHERE o.status = 'completed' ";
        if (sellerId > 0) {
            sql = "SELECT SUM(oi.quantity * oi.price_at_purchase) FROM Order_Items oi JOIN Orders o ON oi.order_id = o.order_id JOIN Products p ON oi.product_id = p.product_id WHERE o.status = 'completed' AND p.seller_id = " + sellerId;
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                return sum != null ? sum : BigDecimal.ZERO;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    public List<Order> getOrdersBySeller(int sellerId) {
        return getOrdersWithFilter(sellerId, null);
    }

    public List<Order> getOrdersByStatus(int sellerId, String status) {
        return getOrdersWithFilter(sellerId, status);
    }

    private List<Order> getOrdersWithFilter(int sellerId, String status) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT o.*, u.full_name AS customer_name, v.code AS voucher_code, " +
            "CONCAT(a.receiver_name, ' - ', a.detail_address) AS address_details, " +
            "(SELECT p.seller_id FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id WHERE oi.order_id = o.order_id LIMIT 1) AS seller_id, " +
            "(SELECT s.shop_name FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id JOIN sellers s ON p.seller_id = s.seller_id WHERE oi.order_id = o.order_id LIMIT 1) AS shop_name " +
            "FROM Orders o " +
            "JOIN Users u ON o.user_id = u.user_id " +
            "JOIN Addresses a ON o.address_id = a.address_id " +
            "LEFT JOIN Vouchers v ON o.voucher_id = v.voucher_id "
        );

        if (sellerId > 0) {
            sql.append(" JOIN Order_Items oi ON o.order_id = oi.order_id ")
               .append(" JOIN Products p ON oi.product_id = p.product_id ")
               .append(" WHERE p.seller_id = ? ");
            if (status != null && !status.isEmpty()) {
                sql.append(" AND o.status = ? ");
            }
        } else {
            if (status != null && !status.isEmpty()) {
                sql.append(" WHERE o.status = ? ");
            }
        }

        sql.append(" ORDER BY o.created_at DESC");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int pIndex = 1;
            if (sellerId > 0) ps.setInt(pIndex++, sellerId);
            if (status != null && !status.isEmpty()) ps.setString(pIndex++, status);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildOrder(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.full_name AS customer_name, v.code AS voucher_code, " +
                     "CONCAT(a.receiver_name, ' - ', a.detail_address) AS address_details, " +
                     "(SELECT p.seller_id FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id WHERE oi.order_id = o.order_id LIMIT 1) AS seller_id, " +
                     "(SELECT s.shop_name FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id JOIN sellers s ON p.seller_id = s.seller_id WHERE oi.order_id = o.order_id LIMIT 1) AS shop_name " +
                     "FROM Orders o " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "JOIN Addresses a ON o.address_id = a.address_id " +
                     "LEFT JOIN Vouchers v ON o.voucher_id = v.voucher_id " +
                     "WHERE o.order_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildOrder(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name " +
                     "FROM Order_Items oi " +
                     "JOIN Products p ON oi.product_id = p.product_id " +
                     "WHERE oi.order_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPriceAtPurchase(rs.getBigDecimal("price_at_purchase"));
                item.setProductName(rs.getString("product_name"));
                list.add(item);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Order buildOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setAddressId(rs.getInt("address_id"));

        int voucherId = rs.getInt("voucher_id");
        if (!rs.wasNull()) o.setVoucherId(voucherId);

        o.setStatus(rs.getString("status"));
        o.setShippingFee(rs.getBigDecimal("shipping_fee"));
        o.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setCreatedAt(rs.getTimestamp("created_at"));

        o.setCustomerName(rs.getString("customer_name"));
        o.setShippingAddress(rs.getString("address_details"));
        o.setVoucherCode(rs.getString("voucher_code"));
        
        try {
            int sId = rs.getInt("seller_id");
            if (!rs.wasNull()) {
                o.setSellerId(sId);
                String shopName = rs.getString("shop_name");
                o.setShopName(shopName != null ? shopName : "Shop đã xóa");
            }
        } catch (Exception e) {
            // fallback if columns don't exist in some other queries (e.g. getOrdersByUser)
        }
        
        return o;
    }

    // ===================== CLIENT METHODS =====================

    /**
     * Lấy toàn bộ đơn hàng của một khách hàng (dùng cho trang Profile)
     */
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS customer_name, v.code AS voucher_code, " +
                     "CONCAT(a.receiver_name, ' - ', a.detail_address) AS address_details, " +
                     "(SELECT p.seller_id FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id WHERE oi.order_id = o.order_id LIMIT 1) AS seller_id, " +
                     "(SELECT s.shop_name FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id JOIN sellers s ON p.seller_id = s.seller_id WHERE oi.order_id = o.order_id LIMIT 1) AS shop_name " +
                     "FROM Orders o " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "JOIN Addresses a ON o.address_id = a.address_id " +
                     "LEFT JOIN Vouchers v ON o.voucher_id = v.voucher_id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildOrder(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Hàm xử lý quy trình chốt đơn khép kín (Transaction)
     */
    public boolean placeOrder(int userId, int addressId, Integer voucherId,
                              BigDecimal totalAmount, BigDecimal shippingFee, String paymentMethod, 
                              List<CartItemDTO> checkoutItems) { // Đã bổ sung danh sách sản phẩm mua

        Connection conn = null;

        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lưu thông tin chung vào bảng Orders
            String insertOrderSql = "INSERT INTO Orders (user_id, address_id, voucher_id, total_amount, shipping_fee, status) VALUES (?, ?, ?, ?, ?, 'pending')";
            PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, PreparedStatement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setInt(2, addressId);

            if (voucherId != null) {
                psOrder.setInt(3, voucherId);
            } else {
                psOrder.setNull(3, java.sql.Types.INTEGER);
            }

            psOrder.setBigDecimal(4, totalAmount);
            psOrder.setBigDecimal(5, shippingFee);
            psOrder.executeUpdate();

            ResultSet rsOrderKeys = psOrder.getGeneratedKeys();
            int orderId = -1;
            if (rsOrderKeys.next()) {
                orderId = rsOrderKeys.getInt(1);
            }

            // Chuẩn bị sẵn các câu lệnh SQL để dùng trong vòng lặp
            String checkStockSql = "SELECT stock_quantity FROM Products WHERE product_id = ? FOR UPDATE"; // FOR UPDATE giúp khóa row, chống lỗi đặt trùng
            PreparedStatement psCheckStock = conn.prepareStatement(checkStockSql);

            String insertOrderItemSql = "INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
            PreparedStatement psInsertItem = conn.prepareStatement(insertOrderItemSql);

            String updateStockSql = "UPDATE Products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
            PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSql);
            
            String deleteCartItemSql = "DELETE FROM Cart_Items WHERE cart_id = (SELECT cart_id FROM Carts WHERE user_id = ?) AND product_id = ?";
            PreparedStatement psDeleteCartItem = conn.prepareStatement(deleteCartItemSql);

            // 2. Lặp qua danh sách các món HÀNG ĐÃ CHỌN (checkoutItems)
            for (CartItemDTO item : checkoutItems) {
                int productId = item.getProductId();
                int quantity = item.getQuantity();
                BigDecimal basePrice = item.getBasePrice();
                
                // Kiểm tra lại tồn kho trực tiếp từ Database
                psCheckStock.setInt(1, productId);
                ResultSet rsStock = psCheckStock.executeQuery();
                if (rsStock.next()) {
                    int stockQuantity = rsStock.getInt("stock_quantity");
                    if (stockQuantity < quantity) {
                        throw new Exception("Sản phẩm ID " + productId + " không đủ số lượng trong kho!");
                    }
                } else {
                    throw new Exception("Không tìm thấy sản phẩm ID " + productId);
                }

                // Lưu vào Order_Items
                psInsertItem.setInt(1, orderId);
                psInsertItem.setInt(2, productId);
                psInsertItem.setInt(3, quantity);
                psInsertItem.setBigDecimal(4, basePrice);
                psInsertItem.executeUpdate();

                // Trừ tồn kho
                psUpdateStock.setInt(1, quantity);
                psUpdateStock.setInt(2, productId);
                psUpdateStock.executeUpdate();
                
                // Chỉ xóa món hàng này khỏi Giỏ Hàng
                psDeleteCartItem.setInt(1, userId);
                psDeleteCartItem.setInt(2, productId);
                psDeleteCartItem.executeUpdate();
            }

            // 3. Tạo bảng ghi thanh toán
            String insertPaymentSql = "INSERT INTO Payments (order_id, method, status) VALUES (?, ?, 'unpaid')";
            PreparedStatement psPayment = conn.prepareStatement(insertPaymentSql);
            psPayment.setInt(1, orderId);
            psPayment.setString(2, paymentMethod);
            psPayment.executeUpdate();

            // Hoàn tất mọi thứ -> Lưu vào cơ sở dữ liệu
            conn.commit();
            return true;

        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Có bất kỳ lỗi gì là hoàn tác hết
                    System.err.println("Giao dịch thất bại, ĐÃ ROLLBACK: " + e.getMessage());
                }
            } catch (Exception re) {
                re.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ce) {
                ce.printStackTrace();
            }
        }
    }
}