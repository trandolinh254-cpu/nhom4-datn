import java.nio.file.*;
import java.util.*;
import java.util.regex.*;

public class ExtractFK {
    public static void main(String[] args) throws Exception {
        String content = new String(Files.readAllBytes(Paths.get("database_utf8.sql")), "UTF-16LE"); // or UTF-8
        // Actually, try both encodings if needed.
        if (!content.contains("FOREIGN KEY")) {
            content = new String(Files.readAllBytes(Paths.get("database_utf8.sql")), "UTF-8");
        }
        
        Pattern p = Pattern.compile("ALTER TABLE \\[dbo\\]\\.\\[(.*?)\\]\\s+WITH CHECK ADD\\s+CONSTRAINT \\[(.*?)\\] FOREIGN KEY\\(\\[(.*?)\\]\\)\\s*REFERENCES \\[dbo\\]\\.\\[(.*?)\\] \\(\\[(.*?)\\]\\)", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(content);
        
        while (m.find()) {
            String table = m.group(1);
            String constraint = m.group(2);
            String column = m.group(3);
            String refTable = m.group(4);
            String refColumn = m.group(5);
            
            System.out.println("ALTER TABLE " + table + " ADD CONSTRAINT " + constraint + " FOREIGN KEY (" + column + ") REFERENCES " + refTable + "(" + refColumn + ");");
        }
    }
}
