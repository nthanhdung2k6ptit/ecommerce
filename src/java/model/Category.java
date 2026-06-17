package model;

/**
 * Model ánh xạ bảng Category
 */
public class Category {

    private int categoryId;
    private String name;           
    private Integer parentId;      
    private String parentName;
    private String iconUrl;

    private String description;
    private String imageUrl;

    public Category() {}

    public Category(int categoryId, String name, Integer parentId) {
        this.categoryId = categoryId;
        this.name = name;
        this.parentId = parentId;
    }

    // === GETTER & SETTER CHO BIẾN MỚI ===
    public String getIconUrl() { return iconUrl; }
    public void setIconUrl(String iconUrl) { this.iconUrl = iconUrl; }

    // ====================================================
    // CÁC HÀM GETTER/SETTER CŨ GIỮ NGUYÊN BÊN DƯỚI
    // ====================================================
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategoryName() { return name; }
    public void setCategoryName(String name) { this.name = name; }

    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }

    public Integer getParentCategoryId() { return parentId; }
    public void setParentCategoryId(Integer parentId) { this.parentId = parentId; }

    public String getParentName() { return parentName; }
    public void setParentName(String parentName) { this.parentName = parentName; }

    public String getParentCategoryName() { return parentName; }
    public void setParentCategoryName(String parentName) { this.parentName = parentName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}