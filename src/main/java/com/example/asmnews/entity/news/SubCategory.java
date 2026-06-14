package com.example.asmnews.entity.news;

/**
 * Entity class cho bảng SubCategories.
 * Đại diện cho danh mục con thuộc một chuyên mục chính.
 */
public class SubCategory {
    private int id;
    private String categoryId;
    private String name;

    public SubCategory() {
    }

    public SubCategory(int id, String categoryId, String name) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
