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
