package model;

import java.sql.Timestamp;

/**
 * Model ánh xạ bảng Seller
 * Schema thực tế: seller_id, user_id, shop_name, description
 * Không có: shop_logo_url, is_approved
 */
public class Seller {

    private int sellerId;
    private int userId;
    private String shopName;
    private String description;    // cột thực tế là "description" (không phải shop_description)
    private Timestamp createdAt;   // nếu DB có cột này

    // Trường join từ Users
    private String ownerEmail;
    private String ownerFullName;

    public Seller() {}

    public Seller(int sellerId, int userId, String shopName, String description) {
        this.sellerId = sellerId;
        this.userId = userId;
        this.shopName = shopName;
        this.description = description;
    }

    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    // Giữ alias để JSP cũ vẫn dùng được
    public String getShopDescription() { return description; }
    public void setShopDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getOwnerEmail() { return ownerEmail; }
    public void setOwnerEmail(String ownerEmail) { this.ownerEmail = ownerEmail; }

    public String getOwnerFullName() { return ownerFullName; }
    public void setOwnerFullName(String ownerFullName) { this.ownerFullName = ownerFullName; }

    private boolean isApproved;

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean isApproved) { this.isApproved = isApproved; }
}