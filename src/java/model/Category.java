package model;

/**
 * Model ánh xạ bảng Category
 * Schema thực tế: category_id, name, parent_id
 * Không có: category_name, image_url, description
 */
public class Category {

    private int categoryId;
    private String name;           // cột thực tế là "name"
    private Integer parentId;      // cột thực tế là "parent_id"

    // Trường join (tên danh mục cha)
    private String parentName;

    public Category() {}

    public Category(int categoryId, String name, Integer parentId) {
        this.categoryId = categoryId;
        this.name = name;
        this.parentId = parentId;
    }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    // Dùng "name" theo schema thực tế
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    // Alias để tương thích với code cũ nếu cần
    public String getCategoryName() { return name; }
    public void setCategoryName(String name) { this.name = name; }

    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }

    // Alias
    public Integer getParentCategoryId() { return parentId; }
    public void setParentCategoryId(Integer parentId) { this.parentId = parentId; }

    public String getParentName() { return parentName; }
    public void setParentName(String parentName) { this.parentName = parentName; }

    // Alias
    public String getParentCategoryName() { return parentName; }
    public void setParentCategoryName(String parentName) { this.parentName = parentName; }
    
    private String description;
    private String imageUrl;

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}