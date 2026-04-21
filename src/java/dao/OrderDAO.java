package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderItem;
import utils.DBUtil;
import utils.DBContext;

public class OrderDAO {

    // ===================== ADMIN METHODS =====================

    public List<Order> getAllOrders() {
        return getOrdersWithFilter(-1, null);
    }

    public int countOrders(int sellerId) {
        String sql = "SELECT COUNT(DISTINCT o.order_id) FROM Orders o ";
        if (sellerId > 0) {
            sql += " JOIN Order_Items oi ON o.order_id = oi.order_id JOIN Products p ON oi.product_id = p.product_id WHERE p.seller_id = " + sellerId;
        }
        try (Connection conn = DBUtil.getConnection();
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
        try (Connection conn = DBUtil.getConnection();
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
            "CONCAT(a.receiver_name, ' - ', a.phone, ' - ', a.detail_address) AS address_details " +
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

        try (Connection conn = DBUtil.getConnection();
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
                     "CONCAT(a.receiver_name, ' - ', a.detail_address) AS address_details " +
                     "FROM Orders o " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "JOIN Addresses a ON o.address_id = a.address_id " +
                     "LEFT JOIN Vouchers v ON o.voucher_id = v.voucher_id " +
                     "WHERE o.order_id = ?";
        try (Connection conn = DBUtil.getConnection();
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
        try (Connection conn = DBUtil.getConnection();
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
        try (Connection conn = DBUtil.getConnection();
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
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setCreatedAt(rs.getTimestamp("created_at"));

        o.setCustomerName(rs.getString("customer_name"));
        o.setShippingAddress(rs.getString("address_details"));
        o.setVoucherCode(rs.getString("voucher_code"));
        return o;
    }

    // ===================== CLIENT METHODS =====================

    /**
     * Hàm xử lý quy trình chốt đơn khép kín (Transaction)
     */
    public boolean placeOrder(int userId, int addressId, Integer voucherId,
                              BigDecimal totalAmount, BigDecimal shippingFee, String paymentMethod) {

        Connection conn = null;

        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

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

                if (stockQuantity < quantity) {
                    throw new Exception("Sản phẩm ID " + productId + " không đủ số lượng trong kho!");
                }

                psInsertItem.setInt(1, orderId);
                psInsertItem.setInt(2, productId);
                psInsertItem.setInt(3, quantity);
                psInsertItem.setBigDecimal(4, basePrice);
                psInsertItem.executeUpdate();

                psUpdateStock.setInt(1, quantity);
                psUpdateStock.setInt(2, productId);
                psUpdateStock.executeUpdate();
            }

            String clearCartSql = "DELETE FROM Cart_Items WHERE cart_id = (SELECT cart_id FROM Carts WHERE user_id = ?)";
            PreparedStatement psClearCart = conn.prepareStatement(clearCartSql);
            psClearCart.setInt(1, userId);
            psClearCart.executeUpdate();

            String insertPaymentSql = "INSERT INTO Payments (order_id, method, status) VALUES (?, ?, 'unpaid')";
            PreparedStatement psPayment = conn.prepareStatement(insertPaymentSql);
            psPayment.setInt(1, orderId);
            psPayment.setString(2, paymentMethod);
            psPayment.executeUpdate();

            conn.commit();
            return true;

        } catch (Exception e) {
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
