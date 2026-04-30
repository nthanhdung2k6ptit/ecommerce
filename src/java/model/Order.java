package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Unified Order Model:
 * - Mapping chuẩn DB (Orders table)
 * - Hỗ trợ JOIN (User, Address, Voucher, Seller...)
 * - Có alias để tương thích JSP cũ
 */
public class Order {

    // ===== CORE FIELDS (Mapping DB) =====
    private int orderId;
    private int userId;
    private int addressId;
    private Integer voucherId; // nullable
    private String status;
    private BigDecimal shippingFee;
    private BigDecimal totalAmount; // snapshot tổng tiền
    private Timestamp createdAt;

    // ===== JOIN FIELDS (UI / VIEW) =====
    private String customerName;
    private String customerPhone;
    private String shippingAddressDetails;
    private String voucherCode;

    // Multi-vendor support (NOT from Orders table)
    private Integer sellerId;
    private String shopName;

    // ===== CONSTRUCTOR =====
    public Order() {}

    public Order(int orderId, int userId, int addressId, Integer voucherId,
                 String status, BigDecimal shippingFee,
                 BigDecimal totalAmount, Timestamp createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.addressId = addressId;
        this.voucherId = voucherId;
        this.status = status;
        this.shippingFee = shippingFee;
        this.totalAmount = totalAmount;
        this.createdAt = createdAt;
    }

    // ===== GETTER & SETTER (CORE) =====
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

    // ===== GETTER & SETTER (JOIN) =====
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public String getShippingAddressDetails() { return shippingAddressDetails; }
    public void setShippingAddressDetails(String shippingAddressDetails) {
        this.shippingAddressDetails = shippingAddressDetails;
    }

    public String getVoucherCode() { return voucherCode; }
    public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }

    public Integer getSellerId() { return sellerId; }
    public void setSellerId(Integer sellerId) { this.sellerId = sellerId; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }

    // ===== ALIAS (Backward Compatibility) =====

    // totalAmount alias
    public BigDecimal getFinalAmount() { return totalAmount; }
    public void setFinalAmount(BigDecimal amount) { this.totalAmount = amount; }

    // giả lập discount (nếu chưa lưu DB)
    public BigDecimal getDiscountAmount() { return BigDecimal.ZERO; }
    public void setDiscountAmount(BigDecimal d) {}

    // address alias
    public String getShippingAddress() { return shippingAddressDetails; }
    public void setShippingAddress(String s) { this.shippingAddressDetails = s; }
}