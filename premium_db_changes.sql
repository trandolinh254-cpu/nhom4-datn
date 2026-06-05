-- ==============================================================
-- CẬP NHẬT DATABASE: CHUYỂN ĐỔI "ORDERS" THÀNH "PREMIUM SUBSCRIPTIONS"
-- ==============================================================

-- 1. Bổ sung cờ Premium và AI Summary cho bảng Users
-- ALTER TABLE Users 
-- ADD COLUMN IsPremium TINYINT(1) DEFAULT 0,
-- ADD COLUMN FreeSummaryCount INT DEFAULT 4;

-- 2. Dọn dẹp bảng Orders (Xóa các cột giao hàng vật lý không còn dùng)
-- Vì chúng ta chỉ bán gói Premium Online, không cần lưu địa chỉ ship báo giấy nữa.
ALTER TABLE Orders
DROP COLUMN City,
DROP COLUMN District,
DROP COLUMN Ward,
DROP COLUMN AddressDetail;

-- Ghi chú: Các cột còn lại (OrderId, UserId, NewspaperType, PackageDuration, 
-- StartDate, EndDate, TotalAmount, Status) giữ nguyên để tái sử dụng cho Premium.

-- 3. Đảm bảo Transactions vẫn giữ khóa ngoại tới Orders (để đồng bộ logic cũ)
-- (Không cần DROP hay ALTER bảng Transactions nữa vì cấu trúc cũ đã hoàn hảo cho Premium)

-- ==============================================================
-- HOÀN TẤT!
-- Bằng cách này, toàn bộ logic Admin cũ (Danh sách Premium, Lịch sử GD) 
-- sẽ tự động chạy đúng mà không cần phải viết lại code Backend phức tạp!
-- ==============================================================
