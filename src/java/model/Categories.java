package model;

/**
 * Model ánh xạ bảng Categories
 * Schema thực tế: category_id, name, parent_id
 * Không có: category_name, image_url, description
 */
public class Categories {

    private int categoryId;
    private String name;           // cột thực tế là "name"
    private Integer parentId;      // cột thực tế là "parent_id"

    // Trường join (tên danh mục cha)
    private String parentName;

    public Categories() {}

    public Categories(int categoryId, String name, Integer parentId) {
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
    
    // Mocks for JSP/Controller compatibility
    public String getDescription() { return null; }
    public void setDescription(String s) {}
    public String getImageUrl() { return null; }
    public void setImageUrl(String s) {}
}
