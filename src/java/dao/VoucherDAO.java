package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Vouchers;
import utils.DBUtil;

public class VoucherDAO {

    public List<Vouchers> getAllVouchers() {
        return getVouchersBySeller(-1);
    }

    public int countVouchers(int sellerId) {
        String sql = "SELECT COUNT(*) FROM Vouchers ";
        if (sellerId > 0) sql += " WHERE seller_id = " + sellerId;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Vouchers> getVouchersBySeller(int sellerId) {
        List<Vouchers> list = new ArrayList<>();
        String sql = "SELECT v.*, s.shop_name FROM Vouchers v LEFT JOIN Sellers s ON v.seller_id = s.seller_id ";
        if (sellerId > 0) {
            sql += " WHERE v.seller_id = ? ";
        }
        sql += " ORDER BY v.voucher_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (sellerId > 0) {
                ps.setInt(1, sellerId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildVoucher(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Vouchers getVoucherById(int voucherId) {
        String sql = "SELECT v.*, s.shop_name FROM Vouchers v LEFT JOIN Sellers s ON v.seller_id = s.seller_id WHERE v.voucher_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildVoucher(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Vouchers getVoucherByCode(String code) {
        String sql = "SELECT v.*, s.shop_name FROM Vouchers v LEFT JOIN Sellers s ON v.seller_id = s.seller_id WHERE v.code = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildVoucher(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertVoucher(Vouchers v) {
        String sql = "INSERT INTO Vouchers (seller_id, code, discount_type, discount_value, max_discount_value, min_order_value, start_date, end_date, usage_limit, used_count) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (v.getSellerId() != null) ps.setInt(1, v.getSellerId());
            else ps.setNull(1, java.sql.Types.INTEGER);
            
            ps.setString(2, v.getCode());
            ps.setString(3, v.getDiscountType());
            ps.setBigDecimal(4, v.getDiscountValue());
            
            if (v.getMaxDiscountValue() != null) ps.setBigDecimal(5, v.getMaxDiscountValue());
            else ps.setNull(5, java.sql.Types.DECIMAL);
            
            ps.setBigDecimal(6, v.getMinOrderValue());
            ps.setTimestamp(7, v.getStartDate());
            ps.setTimestamp(8, v.getEndDate());
            ps.setInt(9, v.getUsageLimit());
            ps.setInt(10, v.getUsedCount());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateVoucher(Vouchers v) {
        String sql = "UPDATE Vouchers SET discount_type = ?, discount_value = ?, max_discount_value = ?, min_order_value = ?, start_date = ?, end_date = ?, usage_limit = ? WHERE voucher_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getDiscountType());
            ps.setBigDecimal(2, v.getDiscountValue());
            
            if (v.getMaxDiscountValue() != null) ps.setBigDecimal(3, v.getMaxDiscountValue());
            else ps.setNull(3, java.sql.Types.DECIMAL);
            
            ps.setBigDecimal(4, v.getMinOrderValue());
            ps.setTimestamp(5, v.getStartDate());
            ps.setTimestamp(6, v.getEndDate());
            ps.setInt(7, v.getUsageLimit());
            ps.setInt(8, v.getVoucherId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteVoucher(int voucherId) {
        String sql = "DELETE FROM Vouchers WHERE voucher_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Vouchers buildVoucher(ResultSet rs) throws SQLException {
        Vouchers v = new Vouchers();
        v.setVoucherId(rs.getInt("voucher_id"));
        
        int sellerId = rs.getInt("seller_id");
        if (!rs.wasNull()) v.setSellerId(sellerId);
        
        v.setCode(rs.getString("code"));
        v.setDiscountType(rs.getString("discount_type"));
        v.setDiscountValue(rs.getBigDecimal("discount_value"));
        v.setMaxDiscountValue(rs.getBigDecimal("max_discount_value"));
        v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
        v.setStartDate(rs.getTimestamp("start_date"));
        v.setEndDate(rs.getTimestamp("end_date"));
        v.setUsageLimit(rs.getInt("usage_limit"));
        v.setUsedCount(rs.getInt("used_count"));
        
        v.setShopName(rs.getString("shop_name"));
        return v;
    }
}
