package com.example.asmnews;
import java.sql.*;
import com.example.asmnews.util.DatabaseUtils;

public class FixPrice {
    public static void main(String[] args) {
        try (Connection conn = DatabaseUtils.getConnection()) {
            Statement stmt = conn.createStatement();
            int rows = stmt.executeUpdate("UPDATE ad_contracts SET total_price = ABS(CHECKSUM(NEWID()) % 10000000) + 1000000 WHERE total_price = 0 OR total_price IS NULL");
            System.out.println("Updated " + rows + " contracts with mock prices!");
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
