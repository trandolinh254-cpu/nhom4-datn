USE asm_news;

-- Bổ sung các dây khóa ngoại (Foreign Keys) bị thiếu
ALTER TABLE ad_campaigns ADD CONSTRAINT FK_ad_campaigns_contracts FOREIGN KEY (contract_id) REFERENCES ad_contracts(ContractId);
ALTER TABLE ad_campaigns ADD CONSTRAINT FK_ad_campaigns_positions FOREIGN KEY (position_id) REFERENCES ad_positions(PositionId);
ALTER TABLE ad_contracts ADD CONSTRAINT FK_ad_contracts_users FOREIGN KEY (user_id) REFERENCES users(UserId);
ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES users(UserId);
ALTER TABLE Transactions ADD CONSTRAINT FK_Transactions_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId);
ALTER TABLE Transactions ADD CONSTRAINT FK_Transactions_Users FOREIGN KEY (UserId) REFERENCES users(UserId);
ALTER TABLE Comments ADD CONSTRAINT FK_Comments_Users FOREIGN KEY (UserId) REFERENCES users(UserId);
ALTER TABLE Comments ADD CONSTRAINT FK_Comments_News FOREIGN KEY (NewsId) REFERENCES News(NewsId);
ALTER TABLE News ADD CONSTRAINT FK_News_Users FOREIGN KEY (Author) REFERENCES users(UserId);
ALTER TABLE News ADD CONSTRAINT FK_News_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId);

-- Bảng Reactions (Lượt thích/thả tim tin tức)
ALTER TABLE reactions ADD CONSTRAINT FK_reactions_users FOREIGN KEY (UserId) REFERENCES users(UserId);
ALTER TABLE reactions ADD CONSTRAINT FK_reactions_news FOREIGN KEY (NewsId) REFERENCES News(NewsId);

-- Bổ sung các cột phục vụ Mô tả ngắn, SEO, Lên lịch, Xóa mềm và Lý do từ chối vào bảng News
ALTER TABLE News ADD COLUMN Summary VARCHAR(500) NULL AFTER Title; -- Mô tả ngắn
ALTER TABLE News ADD COLUMN MetaTitle VARCHAR(65) NULL; -- SEO Title
ALTER TABLE News ADD COLUMN MetaDescription VARCHAR(160) NULL; -- SEO Desc
ALTER TABLE News ADD COLUMN Slug VARCHAR(255) NULL; -- URL Slug
ALTER TABLE News ADD COLUMN ScheduledDate DATETIME NULL; -- Ngày giờ lên lịch xuất bản
ALTER TABLE News ADD COLUMN RejectReason VARCHAR(500) NULL; -- Lý do từ chối từ Admin
ALTER TABLE News ADD COLUMN LastModified DATETIME NULL; -- Thời gian chỉnh sửa cuối
ALTER TABLE News ADD COLUMN IsDeleted TINYINT(1) DEFAULT 0; -- Cơ chế xóa mềm (Soft Delete)

-- Bổ sung cột Bút danh, Tiểu sử và Số lần đăng nhập sai vào bảng Users
ALTER TABLE Users ADD COLUMN PenName VARCHAR(100) NULL; -- Bút danh hiển thị công khai
ALTER TABLE Users ADD COLUMN Bio TEXT NULL; -- Tiểu sử ngắn của tác giả
ALTER TABLE Users ADD COLUMN FailedLoginAttempts INT DEFAULT 0; -- Đếm số lần đăng nhập sai
ALTER TABLE Users ADD COLUMN LockoutTime DATETIME NULL; -- Thời điểm khóa tài khoản

-- Bổ sung cột Premium và Số lượt tóm tắt miễn phí (RQ: AI Premium)
ALTER TABLE Users ADD COLUMN IsPremium TINYINT(1) DEFAULT 0;
ALTER TABLE Users ADD COLUMN FreeSummaryCount INT DEFAULT 4;

-- Bổ sung cột Ghim và Ẩn bình luận vào bảng Comments (Đáp ứng RQ46)
ALTER TABLE Comments ADD COLUMN IsPinned TINYINT(1) DEFAULT 0; -- Ghim bình luận lên đầu
ALTER TABLE Comments ADD COLUMN IsHidden TINYINT(1) DEFAULT 0; -- Ẩn bình luận khỏi độc giả
ALTER TABLE Comments ADD COLUMN ReportCount INT DEFAULT 0; -- -- FIX: Đếm số lượt bị báo cáo (RQ18)

-- Bảng Follows (Theo dõi tác giả - RQ22) -- FIX
CREATE TABLE IF NOT EXISTS Follows ( -- FIX
    FollowerId VARCHAR(100), -- FIX
    AuthorId VARCHAR(100), -- FIX
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- FIX
    PRIMARY KEY (FollowerId, AuthorId), -- FIX
    FOREIGN KEY (FollowerId) REFERENCES Users(UserId) ON DELETE CASCADE, -- FIX
    FOREIGN KEY (AuthorId) REFERENCES Users(UserId) ON DELETE CASCADE -- FIX
); -- FIX

-- Bảng Bookmarks (Lưu bài viết - RQ27) -- FIX
CREATE TABLE IF NOT EXISTS Bookmarks ( -- FIX
    UserId VARCHAR(100), -- FIX
    NewsId VARCHAR(100), -- FIX
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- FIX
    PRIMARY KEY (UserId, NewsId), -- FIX
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE, -- FIX
    FOREIGN KEY (NewsId) REFERENCES News(NewsId) ON DELETE CASCADE -- FIX
); -- FIX

-- Bảng ReadingHistory (Lịch sử đọc tin - RQ25) -- FIX
CREATE TABLE IF NOT EXISTS ReadingHistory ( -- FIX
    UserId VARCHAR(100), -- FIX
    NewsId VARCHAR(100), -- FIX
    ReadDate DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- FIX
    PRIMARY KEY (UserId, NewsId), -- FIX
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE, -- FIX
    FOREIGN KEY (NewsId) REFERENCES News(NewsId) ON DELETE CASCADE -- FIX
); -- FIX
