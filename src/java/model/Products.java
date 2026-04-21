package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model ánh xạ bảng Products
 * Schema thực tế: product_id, seller_id, category_id, name, description, base_price, stock_quantity, created_at
 * Không có: image_url, is_active
 */
public class Products {

    private int productId;
    private int sellerId;
    private int categoryId;
    private String name;           // Cột thực tế là "name"
    private String description;
    private BigDecimal basePrice;
    private int stockQuantity;
    private Timestamp createdAt;

    // Trường join để hiển thị trên UI
    private String categoryName;
    private String shopName;

    public Products() {}

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    // Alias để JSP hiện hành gọi getProductName() không bị lỗi (nếu sót)
    public String getProductName() { return name; }
    public void setProductName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }

    // Mock hàm này để dùng cho giao diện cũ (trong trường hợp chưa cập nhật hết JSP)
    public boolean isActive() { return true; }
    public void setActive(boolean a) {}
    public String getImageUrl() { return null; }
    public void setImageUrl(String s) {}
}
