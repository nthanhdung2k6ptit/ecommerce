package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model ánh xạ bảng Vouchers
 * schema: voucher_id, seller_id, code, discount_type, discount_value, max_discount_value, 
 *         min_order_value, start_date (TIMESTAMP), end_date (TIMESTAMP), usage_limit, used_count
 */
public class Vouchers {

    private int voucherId;
    private Integer sellerId;
    private String code;
    private String discountType;
    private BigDecimal discountValue;
    private BigDecimal maxDiscountValue;
    private BigDecimal minOrderValue;
    private int usageLimit;
    private int usedCount;
    private Timestamp startDate; // Theo schema là TIMESTAMP
    private Timestamp endDate;   // Theo schema là TIMESTAMP

    // Trường join
    private String shopName;

    public Vouchers() {}

    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }

    public Integer getSellerId() { return sellerId; }
    public void setSellerId(Integer sellerId) { this.sellerId = sellerId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }

    public BigDecimal getMaxDiscountValue() { return maxDiscountValue; }
    public void setMaxDiscountValue(BigDecimal maxDiscountValue) { this.maxDiscountValue = maxDiscountValue; }

    public BigDecimal getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(BigDecimal minOrderValue) { this.minOrderValue = minOrderValue; }

    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
    
    // Mock hàm
    public boolean isActive() { return true; }
    public void setActive(boolean a) {}
}
