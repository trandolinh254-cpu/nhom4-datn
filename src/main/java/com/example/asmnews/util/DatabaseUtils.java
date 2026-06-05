package com.example.asmnews.util;






import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class để quản lý kết nối database
 */
public class DatabaseUtils {
    // Thông tin kết nối database
    private static final String SERVER = "localhost";
    private static final String PORT = "3306";
    private static final String DATABASE = "ASM_NEWS";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "MatKhauMoi_123!"; // FIX

    // URL kết nối MySQL
    private static final String URL = "jdbc:mysql://" + SERVER + ":" + PORT + "/" + DATABASE + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh";

    // Load driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Không thể load MySQL JDBC Driver: " + e.getMessage());
        }
    }

    /**
     * Tạo kết nối đến database
     * 
     * @return Connection object
     * @throws SQLException nếu không thể kết nối
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("Kết nối database thành công!");
            return conn;
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Đóng kết nối database
     * 
     * @param conn Connection cần đóng
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Đã đóng kết nối database");
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
            }
        }
    }

    /**
     * Test kết nối database
     * 
     * @return true nếu kết nối thành công
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Test kết nối thất bại: " + e.getMessage());
            return false;
        }
    }
}
