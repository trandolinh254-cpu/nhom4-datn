# TRẠNG THÁI DỰ ÁN (PROJECT STATE)

Dự án hiện tại là ứng dụng **Java Spring / Servlet** phục vụ cho hệ thống tin tức/quản lý (ASM News).

---

## 1. Cấu trúc Dự án & Module
* **Tech Stack chính**: Java 21, Maven WAR (`pom.xml`), Jakarta Servlet/JSP/JSTL, JDBC MySQL, TestNG/Selenium, SQL dump (`asm_news_final.sql`).
* **Kiểu kiến trúc thực tế**: Servlet/JSP/JDBC truyền thống, chưa có Spring container. Servlet dùng `@WebServlet`; `web.xml` chủ yếu cấu hình static resource và welcome file.
* **Cơ sở dữ liệu**: File dump `asm_news_final.sql` (1.8MB) nằm tại thư mục gốc. Database trong code là `ASM_NEWS`, dump tạo `asm_news` nên cần chú ý khác biệt hoa/thường khi chạy trên môi trường phân biệt case.
* **Các package chính (`src/main/java/com/example/asmnews`)**:
  - `controller/`: Các servlet hoặc controller xử lý request/response.
  - `entity/`: Các model/entity mô phỏng cấu trúc database.
  - `repository/`: Tầng truy cập cơ sở dữ liệu.
  - `config/`: Cấu hình hệ thống.
  - `util/`: Tiện ích dùng chung.
* **Module chính**:
  - `auth`: đăng ký, đăng nhập/đăng xuất, Google/Facebook login, hồ sơ, đổi mật khẩu, quên/reset mật khẩu, quảng cáo của user.
  - `news`: trang danh sách/chi tiết tin, bình luận, reaction, follow tác giả, bookmark, lịch sử đọc.
  - `admin`: dashboard, quản lý tin/category/user/comment/newsletter/order/ads.
  - `reporter`: quản lý bài viết của phóng viên, auto-save bản nháp, bình luận, analytics.
  - `ads`: đăng ký quảng cáo online, chiến dịch, vị trí quảng cáo, hợp đồng, duyệt/từ chối/dừng quảng cáo.
  - `order`: đặt báo, premium checkout, newsletter subscribe/unsubscribe, transaction.
  - `ai`: tóm tắt/dịch nội dung qua Gemini API, có giới hạn lượt miễn phí theo user.
* **Luồng xử lý phổ biến**: Servlet nhận request → gọi DAO trong `repository` → map sang entity → forward JSP trong `WEB-INF/views` hoặc trả JSON thủ công.
* **Session/Auth**: User đăng nhập lưu ở session key `currentUser`. `BaseServlet` có helper `getCurrentUser`, `isLoggedIn`, `checkAdminAccess`, `checkReporterAccess`, `checkAccess`.
* **View**: JSP đặt trong `src/main/webapp/WEB-INF/views`, chia theo `admin`, `auth`, `news`, `reporter`, `order`, `ads`, `home`, `layouts`, `components`.
* **Các công cụ tiện ích phụ trợ (ở thư mục gốc và thư mục package)**:
  - `ExtractFK.java`, `FixDatabase.java` (gốc)
  - `FixPrice.java`, `FixTool.java`, `RefactorTool.java`, `ReplaceSidebarTool.java` (trong package com.example.asmnews)
* **Lưu ý hiện trạng**:
  - Có một số comment `// FIX` đã tồn tại trực tiếp trong source/schema từ trước.
  - Có credential/API key hard-code trong `DatabaseUtils`, `EmailUtils`, `AIServlet`; không tự ý đổi nếu task không yêu cầu.
  - DAO dùng JDBC trực tiếp, nhiều method trả `boolean` hoặc list/entity, lỗi thường được log bằng `printStackTrace`/`System.err`.

---

## 2. Trạng thái Cơ sở dữ liệu (Database State)
* **Bảng chính trong dump**: `Users`, `News`, `Categories`, `Comments`, `Reactions`, `Orders`, `Transactions`, `Newsletters`, `ad_campaigns`, `ad_contracts`, `ad_positions`.
* **Bảng bổ sung**: `SubCategories`, `Follows`, `Bookmarks`, `ReadingHistory`.
* **Cột/feature bổ sung đáng chú ý**:
  - `Users`: `PenName`, `Bio`, `FailedLoginAttempts`, `LockoutTime`, `IsPremium`, `FreeSummaryCount`.
  - `News`: `Summary`, `MetaTitle`, `MetaDescription`, `Slug`, `ScheduledDate`, `RejectReason`, `LastModified`, `IsDeleted`, `Status`.
  - `Comments`: `IsPinned`, `IsHidden`, `ReportCount`, `ParentId`.
  - `SubCategories`: `SubCategoryId`, `CategoryId`, `Name`, unique theo cặp `CategoryId` + `Name`.
* *Chưa có thay đổi database mới trong session này.*

---

## 3. Nhật ký Thay đổi gần nhất (Change Log)
*(Mỗi khi sửa code xong, AI sẽ cập nhật chi tiết các file đã sửa và logic thay đổi vào đây)*

- **2026-06-14**:
  - **Sửa khoảng trắng ở khối Tin mới trang chủ**: Bỏ `h-full` và `flex-1` ở card `Tin mới / Bạn quan tâm` trong `home/index.jsp` để card không bị kéo cao theo ảnh tin chính, giúp banner `Medium Rectangle` nằm ngay dưới card thay vì rớt xuống xa.
  - **Đồng bộ Medium Rectangle trên trang chủ**: `HomeServlet` truyền `mediumRectangle1Ad` từ vị trí quảng cáo ID 3; `home/index.jsp` hiển thị banner này dưới khối `Tin mới / Bạn quan tâm` và tránh render trùng ở block medium phía dưới; mock demo quảng cáo đổi nhãn `Tin nổi bật` thành `Tin mới` để khớp giao diện trang chủ thật.
  - **Bổ sung demo vị trí quảng cáo**: Thêm wireframe cho `Medium Rectangle 1` trong trang khách hàng đặt quảng cáo online, đặt tại cột phụ bên phải dưới khối tin nổi bật và map nút `Xem demo` để không còn báo chưa có mô phỏng.
  - **Sửa luồng đặt quảng cáo online**: Chuẩn hóa ID vị trí quảng cáo theo DB (`1=Super Masthead`, `2=Top Banner`, `3=Medium Rectangle`, `4=Sidebar Left`, `5=Sidebar Right`); trang khách hàng vẫn hiển thị giá vị trí độc quyền nhưng khóa nút mua nếu vị trí đang `RUNNING/PENDING/APPROVED`; sửa resize ảnh upload theo đúng kích thước vị trí; cập nhật seed `ad_positions` trong `asm_news_final.sql` để Super Masthead active và Sidebar Left/Right có giá `30.000.000` thay vì `30.000`.
  - **Sửa quản lý Newsletter**: Thêm route POST `/admin/newsletters/toggle` trong `AdminServlet` để nút vô hiệu hóa/kích hoạt không bị 404; cập nhật thống kê tổng số và đang hoạt động cho trang quản lý newsletter.
  - **Thêm quản lý danh mục con**: Tạo `SubCategory` entity và `SubCategoryDAO`, tự tạo bảng `SubCategories` nếu DB cũ chưa có, seed danh mục con mặc định cho các chuyên mục có sẵn.
  - **Cập nhật UI danh mục con**: Trang quản lý chuyên mục có form thêm/xóa danh mục con; form thêm tin admin/reporter load danh mục con từ DB theo chuyên mục chính; header public render dropdown theo `category.subCategories` thay vì hard-code.
  - **Cập nhật database dump**: Thêm bảng `SubCategories` và dữ liệu mặc định vào `asm_news_final.sql`.
  - **Sửa quản lý chuyên mục**: Fix lỗi thêm chuyên mục bị hiểu nhầm thành sửa do form luôn gửi `id`; thêm `mode=create/edit`, validate mã/tên, chặn trùng mã khi thêm mới.
  - **Cập nhật navbar chuyên mục**: `CategoryDAO.findAll()` giữ thứ tự menu mặc định `TECH`, `ENT`, `BUSINESS`, `HEALTH`, `SPORT`; chuyên mục mới hiển thị sau nhóm mặc định và trước ô tìm kiếm. `ProfileServlet` cũng truyền `categories` để header trang hồ sơ không bị thiếu menu.
  - **Cập nhật trạng thái dự án**: Bổ sung tổng quan kiến trúc Servlet/JSP/JDBC, module chính, luồng xử lý, session auth, view structure và database state vào `PROJECT_STATE.md`.
  - **Cập nhật quy tắc**: Thay nội dung [GEMINI.md](file:///c:/Users/Acer%20Nitro%205/.gemini/GEMINI.md) bằng bản rules tối ưu hơn: linh hoạt constructor/getter/setter, không ép `// FIX` vào source code, ưu tiên kiến trúc hiện có trước khi tạo folder mới.
  - **Tạo file**: [PROJECT_STATE.md](file:///c:/Users/Acer%20Nitro%205/Downloads/Asm-new-main/PROJECT_STATE.md) mẫu lưu trạng thái dự án.
  - **Cập nhật quy tắc**: Thêm rule tự động đọc/ghi `PROJECT_STATE.md` vào [GEMINI.md](file:///c:/Users/Acer%20Nitro%205/.gemini/GEMINI.md).
