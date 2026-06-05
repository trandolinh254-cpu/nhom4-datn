package com.example.asmnews.entity.news;






/**
 * Entity class cho bảng Categories
 * Đại diện cho loại tin tức
 */
public class Category {
    private String id;
    private String name;

    // Constructor mặc định
    public Category() {
    }

    // Constructor có tham số
    public Category(String id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getter và Setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
