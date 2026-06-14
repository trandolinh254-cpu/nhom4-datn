package com.example.asmnews.entity.news;

import java.util.ArrayList;
import java.util.List;






/**
 * Entity class cho bảng Categories
 * Đại diện cho loại tin tức
 */
public class Category {
    private String id;
    private String name;
    private List<SubCategory> subCategories;

    // Constructor mặc định
    public Category() {
        this.subCategories = new ArrayList<>();
    }

    // Constructor có tham số
    public Category(String id, String name) {
        this.id = id;
        this.name = name;
        this.subCategories = new ArrayList<>();
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

    public List<SubCategory> getSubCategories() {
        return subCategories;
    }

    public void setSubCategories(List<SubCategory> subCategories) {
        this.subCategories = subCategories;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
