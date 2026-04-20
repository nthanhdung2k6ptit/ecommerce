package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Orders;
import model.Order_Items;
import utils.DBUtil;

public class OrderDAO {

    public List<Orders> getAllOrders() {
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

    public java.math.BigDecimal getTotalRevenue(int sellerId) {
        String sql = "SELECT SUM(oi.quantity * oi.price_at_purchase) FROM Order_Items oi JOIN Orders o ON oi.order_id = o.order_id WHERE o.status = 'completed' ";
        if (sellerId > 0) {
            sql = "SELECT SUM(oi.quantity * oi.price_at_purchase) FROM Order_Items oi JOIN Orders o ON oi.order_id = o.order_id JOIN Products p ON oi.product_id = p.product_id WHERE o.status = 'completed' AND p.seller_id = " + sellerId;
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                java.math.BigDecimal sum = rs.getBigDecimal(1);
                return sum != null ? sum : java.math.BigDecimal.ZERO;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return java.math.BigDecimal.ZERO;
    }

    public List<Orders> getOrdersBySeller(int sellerId) {
        return getOrdersWithFilter(sellerId, null);
    }
    
    public List<Orders> getOrdersByStatus(int sellerId, String status) {
        return getOrdersWithFilter(sellerId, status);
    }

    // Lọc theo điều kiện và JOIN để lấy đúng thông tin đơn từ chuẩn 3NF
    private List<Orders> getOrdersWithFilter(int sellerId, String status) {
        List<Orders> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT o.*, u.full_name AS customer_name, v.code AS voucher_code, " +
            "CONCAT(a.receiver_name, ' - ', a.phone, ' - ', a.detail_address) AS address_details " +
            "FROM Orders o " +
            "JOIN Users u ON o.user_id = u.user_id " +
            "JOIN Addresses a ON o.address_id = a.address_id " +
            "LEFT JOIN Vouchers v ON o.voucher_id = v.voucher_id "
        );

        if (sellerId > 0) {
            // Join Order_Items và Products để lấy seller
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

    public Orders getOrderById(int orderId) {
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

    public List<Order_Items> getOrderItems(int orderId) {
        List<Order_Items> list = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name " +
                     "FROM Order_Items oi " +
                     "JOIN Products p ON oi.product_id = p.product_id " +
                     "WHERE oi.order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order_Items item = new Order_Items();
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

    private Orders buildOrder(ResultSet rs) throws SQLException {
        Orders o = new Orders();
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
}
