import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.regex.*;

public class FixDatabase {
    public static void main(String[] args) throws Exception {
        System.out.println("Dang xu ly database_mysql.sql...");
        
        Path mysqlPath = Paths.get("database_mysql.sql");
        String mysqlContent = new String(Files.readAllBytes(mysqlPath), StandardCharsets.UTF_8);
        
        // 1. Đổi VARCHAR -> NVARCHAR
        mysqlContent = mysqlContent.replaceAll("(?i)\\bVARCHAR\\b", "NVARCHAR");
        
        // 2. Tìm khóa ngoại từ database_utf8.sql
        String utf8Content = "";
        try {
            utf8Content = new String(Files.readAllBytes(Paths.get("database_utf8.sql")), "UTF-16LE");
            if (!utf8Content.contains("FOREIGN KEY")) {
                utf8Content = new String(Files.readAllBytes(Paths.get("database_utf8.sql")), StandardCharsets.UTF_8);
            }
        } catch (Exception e) {}
        
        StringBuilder fkBuilder = new StringBuilder();
        fkBuilder.append("\n\n-- ==========================================\n");
        fkBuilder.append("-- NOi LAI KHOA NGOAI (FOREIGN KEYS)\n");
        fkBuilder.append("-- ==========================================\n");
        
        Pattern p = Pattern.compile("ALTER TABLE \\[dbo\\]\\.\\[(.*?)\\]\\s+WITH CHECK ADD\\s+CONSTRAINT \\[(.*?)\\] FOREIGN KEY\\(\\[(.*?)\\]\\)\\s*REFERENCES \\[dbo\\]\\.\\[(.*?)\\] \\(\\[(.*?)\\]\\)", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(utf8Content);
        
        int fkCount = 0;
        while (m.find()) {
            String table = m.group(1);
            String constraint = m.group(2);
            String column = m.group(3);
            String refTable = m.group(4);
            String refColumn = m.group(5);
            
            // Check if this constraint is already in mysqlContent to avoid duplicate
            if (!mysqlContent.contains(constraint)) {
                fkBuilder.append(String.format("ALTER TABLE %s ADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s (%s);\n", table, constraint, column, refTable, refColumn));
                fkCount++;
            }
        }
        
        if (fkCount > 0) {
            mysqlContent += fkBuilder.toString();
            System.out.println("Da noi lai " + fkCount + " day khoa ngoai!");
        } else {
            System.out.println("Khong tim thay khoa ngoai moi nao can them (co the ban da them hoac file goc k co).");
            // Dự phòng cứng nếu RegEx xịt
            String backupFKs = "\n-- DU PHONG KHOA NGOAI --\n" +
            "ALTER TABLE ad_campaigns ADD CONSTRAINT FK_ad_campaigns_contracts FOREIGN KEY (contract_id) REFERENCES ad_contracts(ContractId);\n" +
            "ALTER TABLE ad_campaigns ADD CONSTRAINT FK_ad_campaigns_positions FOREIGN KEY (position_id) REFERENCES ad_positions(PositionId);\n" +
            "ALTER TABLE ad_contracts ADD CONSTRAINT FK_ad_contracts_users FOREIGN KEY (user_id) REFERENCES users(UserId);\n" +
            "ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES users(UserId);\n" +
            "ALTER TABLE Transactions ADD CONSTRAINT FK_Transactions_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId);\n" +
            "ALTER TABLE Transactions ADD CONSTRAINT FK_Transactions_Users FOREIGN KEY (UserId) REFERENCES users(UserId);\n" +
            "ALTER TABLE Comments ADD CONSTRAINT FK_Comments_Users FOREIGN KEY (UserId) REFERENCES users(UserId);\n" +
            "ALTER TABLE Comments ADD CONSTRAINT FK_Comments_News FOREIGN KEY (NewsId) REFERENCES News(NewsId);\n" +
            "ALTER TABLE News ADD CONSTRAINT FK_News_Users FOREIGN KEY (Author) REFERENCES users(UserId);\n" +
            "ALTER TABLE News ADD CONSTRAINT FK_News_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId);\n";
            if (!mysqlContent.contains("FK_ad_campaigns_contracts")) {
                mysqlContent += backupFKs;
                System.out.println("Da dung Khoa Ngoai du phong tu ERD!");
            }
        }
        
        // Ghi lại file
        Files.write(mysqlPath, mysqlContent.getBytes(StandardCharsets.UTF_8));
        System.out.println("Da doi toan bo VARCHAR -> NVARCHAR.");
        System.out.println("HOAN TAT! Ban hay mo file database_mysql.sql va chay lai trong MySQL Workbench!");
    }
}
