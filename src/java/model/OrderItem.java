package model;

import java.math.BigDecimal;

/**
 * Unified OrderItem Model:
 * - Mapping chuẩn DB (Order_Items)
 * - Hỗ trợ JOIN (Product)
 * - Có alias cho JSP/UI
 * 
 * PK: (order_id, product_id)
 */
public class OrderItem {

    // ===== CORE FIELDS (DB) =====
    private int orderId;
    private int productId;
    private int quantity;
    private BigDecimal priceAtPurchase; // snapshot giá tại thời điểm mua

    // ===== JOIN FIELDS (UI) =====
    private String productName;
    private String imageUrl; // optional (nếu join từ Products)

    // ===== CONSTRUCTOR =====
    public OrderItem() {}

    public OrderItem(int orderId, int productId, int quantity, BigDecimal priceAtPurchase) {
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.priceAtPurchase = priceAtPurchase;
    }

    // ===== GETTER & SETTER (CORE) =====
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPriceAtPurchase() { return priceAtPurchase; }
    public void setPriceAtPurchase(BigDecimal priceAtPurchase) {
        this.priceAtPurchase = priceAtPurchase;
    }

    // ===== GETTER & SETTER (JOIN) =====
    public String getProductName() { return productName; }
    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // ===== BUSINESS LOGIC (UI SUPPORT) =====

    // alias cho JSP
    public BigDecimal getUnitPrice() {
        return priceAtPurchase;
    }

    // subtotal = price * quantity
    public BigDecimal getSubtotal() {
        if (priceAtPurchase != null) {
            return priceAtPurchase.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }
}