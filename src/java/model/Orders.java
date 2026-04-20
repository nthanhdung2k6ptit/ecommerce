package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model ánh xạ bảng Orders
 * Schema: order_id, user_id, address_id, voucher_id, status, shipping_fee, total_amount, created_at
 * Chú ý: total_amount là Tổng tiền cuối (Snapshot) => Thay thế cho final_amount trước đó.
 * Bảng Orders KHÔNG có cột seller_id, tuy nhiên với ứng dụng multi-vendor một đơn hàng có thể chứa
 * sản phẩm của 1 seller, hoặc nếu DB chuẩn hóa thì việc lọc đơn hàng theo seller phải join qua Order_Items!
 */
public class Orders {

    private int orderId;
    private int userId;
    private int addressId;
    private Integer voucherId;
    private String status;
    private BigDecimal shippingFee;
    private BigDecimal totalAmount;
    private Timestamp createdAt;

    // Các trường join (tiện cho frontend UI)
    private String customerName;
    private String customerPhone;
    private String shippingAddressDetails; 
    private String voucherCode;
    
    // Giữ thuộc tính này để dùng vào code nếu cần (nhưng không map trực tiếp với 1 cột trong bảng Orders)
    private int sellerId;
    private String shopName;

    public Orders() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public Integer getVoucherId() { return voucherId; }
    public void setVoucherId(Integer voucherId) { this.voucherId = voucherId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getShippingFee() { return shippingFee; }
    public void setShippingFee(BigDecimal shippingFee) { this.shippingFee = shippingFee; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // Joins & ALIASES for compatibility with JSP
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getVoucherCode() { return voucherCode; }
    public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }
    
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    
    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
    
    // Aliases 
    public BigDecimal getFinalAmount() { return totalAmount; }
    public void setFinalAmount(BigDecimal d) { this.totalAmount = d; }
    
    public BigDecimal getDiscountAmount() { return BigDecimal.ZERO; }
    public void setDiscountAmount(BigDecimal d) {}
    
    public String getShippingAddress() { return shippingAddressDetails; }
    public void setShippingAddress(String s) { this.shippingAddressDetails = s; }
}
