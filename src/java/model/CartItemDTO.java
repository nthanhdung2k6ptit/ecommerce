package model;

import java.math.BigDecimal;

public class CartItemDTO {
    private int productId;
    private String productName;
    private BigDecimal basePrice;
    private int quantity;
    
    // Tổng tiền của món này (basePrice * quantity)
    private BigDecimal itemTotal; 

    public CartItemDTO() {
    }

    // --- GETTER & SETTER ---
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getItemTotal() { return itemTotal; }
    public void setItemTotal(BigDecimal itemTotal) { this.itemTotal = itemTotal; }
}