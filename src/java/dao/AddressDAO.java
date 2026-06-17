package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Address;
import utils.DBContext;

public class AddressDAO {
    
    // Hàm móc toàn bộ địa chỉ của 1 User, ưu tiên địa chỉ mặc định lên đầu
    public List<Address> getAddressesByUserId(int userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, address_id DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Address a = new Address();
                    a.setAddressId(rs.getInt("address_id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setReceiverName(rs.getString("receiver_name"));
                    a.setReceiverPhone(rs.getString("receiver_phone"));
                    a.setProvince(rs.getString("province"));
                    a.setDistrict(rs.getString("district"));
                    a.setWard(rs.getString("ward"));
                    a.setDetailAddress(rs.getString("detail_address"));
                    a.setIsDefault(rs.getInt("is_default"));
                    list.add(a);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại getAddressesByUserId: " + e.getMessage());
        }
        return list;
    }
    // Thêm vào AddressDAO.java
    public int insertAddress(Address a) {
        // Lưu địa chỉ và lấy lại ID vừa tạo
        String sql = "INSERT INTO addresses (user_id, receiver_name, receiver_phone, province, district, ward, detail_address, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) { // Quan trọng: RETURN_GENERATED_KEYS
            
            ps.setInt(1, a.getUserId());
            ps.setString(2, a.getReceiverName());
            ps.setString(3, a.getReceiverPhone());
            ps.setString(4, a.getProvince());
            ps.setString(5, a.getDistrict());
            ps.setString(6, a.getWard());
            ps.setString(7, a.getDetailAddress());
            ps.setInt(8, a.getIsDefault());
            
            // Nếu set làm mặc định, phải gỡ mặc định của các địa chỉ cũ
            if (a.getIsDefault() == 1) {
                resetDefaultAddress(a.getUserId());
            }

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về ID thật từ DB
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi insertAddress: " + e.getMessage());
        }
        return -1;
    }

    public void resetDefaultAddress(int userId) {
        String sql = "UPDATE addresses SET is_default = 0 WHERE user_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {}
    }   
}