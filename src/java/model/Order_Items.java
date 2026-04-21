package model;

import java.math.BigDecimal;

/**
 * Model ánh xạ bảng Order_Items
 * Schema: order_id, product_id, quantity, price_at_purchase
 * Khóa hợp thể: order_id + product_id
 */
public class Order_Items {

    private int orderId;
    private int productId;
    private int quantity;
    private BigDecimal priceAtPurchase;

    // Trường join
    private String productName;

    public Order_Items() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPriceAtPurchase() { return priceAtPurchase; }
    public void setPriceAtPurchase(BigDecimal priceAtPurchase) { this.priceAtPurchase = priceAtPurchase; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    // Alias tương thích JSP
    public BigDecimal getUnitPrice() { return priceAtPurchase; }
    public BigDecimal getSubtotal() {
        if (priceAtPurchase != null) {
            return priceAtPurchase.multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }
    public String getImageUrl() { return null; }
}
