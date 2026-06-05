package com.example.asmnews.util;






import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.example.asmnews.repository.news.NewsDAO;
import com.example.asmnews.entity.news.News;

public class NewsAutoFetcher {

    private NewsDAO newsDAO = new NewsDAO();

    // Lớp cấu hình nguồn báo
    private static class FeedConfig {
        String url;
        String categoryId;
        String subCategory;

        FeedConfig(String url, String categoryId, String subCategory) {
            this.url = url;
            this.categoryId = categoryId;
            this.subCategory = subCategory;
        }
    }

    public void fetchAndSaveNews() {
        System.out.println("[AUTO-FETCHER] Bắt đầu cào dữ liệu tối đa theo từng thư mục con...");

        // : Bổ sung hàng loạt link RSS chi tiết để phân bổ đều cho các Sub-Category
        List<FeedConfig> feeds = Arrays.asList(
                // Công nghệ
                new FeedConfig("https://vnexpress.net/rss/so-hoa.rss", "TECH", "Chuyển đổi số"),
                new FeedConfig("https://vnexpress.net/rss/khoa-hoc.rss", "TECH", "AI - Trí tuệ nhân tạo"),

                // Thể thao
                new FeedConfig("https://vnexpress.net/rss/the-thao.rss", "SPORT", "Bóng đá"),
                new FeedConfig("https://vnexpress.net/rss/the-thao/tennis.rss", "SPORT", "Tennis"),

                // Kinh doanh
                new FeedConfig("https://vnexpress.net/rss/kinh-doanh.rss", "BUSINESS", "Thị trường"),
                new FeedConfig("https://vnexpress.net/rss/kinh-doanh/chung-khoan.rss", "BUSINESS", "Chứng khoán"),
                new FeedConfig("https://vnexpress.net/rss/kinh-doanh/bat-dong-san.rss", "BUSINESS", "Bất động sản"),

                // Giải trí
                new FeedConfig("https://vnexpress.net/rss/giai-tri.rss", "ENTERTAINMENT", "Showbiz"),
                new FeedConfig("https://vnexpress.net/rss/giai-tri/am-nhac.rss", "ENTERTAINMENT", "Âm nhạc"),
                new FeedConfig("https://vnexpress.net/rss/giai-tri/phim.rss", "ENTERTAINMENT", "Phim ảnh"),

                // Sức khỏe
                new FeedConfig("https://vnexpress.net/rss/suc-khoe.rss", "HEALTH", "Y tế"),
                new FeedConfig("https://vnexpress.net/rss/gia-dinh.rss", "HEALTH", "Dinh dưỡng"));

        int totalSaved = 0;
        for (FeedConfig feed : feeds) {
            totalSaved += fetchFromUrl(feed);
        }

        System.out.println("[AUTO-FETCHER] Hoàn tất! Đã lưu thành công tổng cộng " + totalSaved + " bài báo mới.");
    }

    private int fetchFromUrl(FeedConfig feed) {
        int count = 0;
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(feed.url);

            NodeList itemList = doc.getElementsByTagName("item");

            // : Xóa điều kiện giới hạn (&& count < 10), cho phép lấy TẤT CẢ các bài đang
            // có trong RSS
            for (int i = 0; i < itemList.getLength(); i++) {
                Element item = (Element) itemList.item(i);

                String title = getTagValue("title", item);
                String descriptionRaw = getTagValue("description", item);
                String imageLink = extractImageUrl(descriptionRaw);
                String content = descriptionRaw.replaceAll("<[^>]*>", "").trim();

                News news = new News();
                // : Tạo ID ngẫu nhiên phức tạp hơn chút để không bị trùng lặp khi chạy số
                // lượng lớn
                news.setId("AUTO_" + feed.categoryId + "_" + System.nanoTime() + "_" + i);
                news.setTitle(title);
                news.setContent(content + " (Nguồn: VNExpress)");
                news.setImage(imageLink != null ? imageLink
                        : "https://s1.vnecdn.net/vnexpress/restruct/i/v914/v2_2019/pc/graphics/logo.svg");
                news.setPostedDate(new Date());
                news.setAuthor("admin");
                news.setViewCount((int) (Math.random() * 500) + 10);
                news.setCategoryId(feed.categoryId);
                news.setSubCategory(feed.subCategory);
                news.setHome(Math.random() > 0.85);
                news.setStatus(0);

                if (newsDAO.insert(news)) {
                    count++;
                }
            }
        } catch (Exception e) {
            System.err.println("[AUTO-FETCHER] Lỗi cào feed " + feed.subCategory + ": " + e.getMessage());
        }
        return count;
    }

    private String getTagValue(String tag, Element element) {
        NodeList nodeList = element.getElementsByTagName(tag);
        if (nodeList != null && nodeList.getLength() > 0) {
            return nodeList.item(0).getTextContent();
        }
        return "";
    }

    private String extractImageUrl(String html) {
        Pattern p = Pattern.compile("<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
        Matcher m = p.matcher(html);
        if (m.find())
            return m.group(1);
        return null;
    }
}
