package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private int addressId;
    private Integer voucherId; // Dùng Integer (Object) thay vì int để có thể lưu giá trị null
    private String status;
    private BigDecimal shippingFee;
    private BigDecimal totalAmount; // Snapshot tổng tiền, cực kỳ quan trọng
    private Timestamp createdAt;

    // Constructor rỗng (Bắt buộc phải có cho Java Beans)
    public Order() {
    }

    // Constructor đầy đủ tham số
    public Order(int orderId, int userId, int addressId, Integer voucherId, String status, BigDecimal shippingFee, BigDecimal totalAmount, Timestamp createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.addressId = addressId;
        this.voucherId = voucherId;
        this.status = status;
        this.shippingFee = shippingFee;
        this.totalAmount = totalAmount;
        this.createdAt = createdAt;
    }

    // --- GETTER & SETTER ---
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
}