CREATE DATABASE SocialNetworkDB;
USE SocialNetworkDB;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50),
    total_posts INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE post_audits (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- task 1
DELIMITER //
CREATE TRIGGER tg_CheckPostContent
BEFORE INSERT ON posts
FOR EACH ROW
BEGIN
    IF NEW.content IS NULL OR TRIM(NEW.content) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nội dung bài viết không được để trống!';
    END IF;
END //
DELIMITER ;

-- task 2

DELIMITER //
CREATE TRIGGER tg_UpdatePostCountAfterInsert
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    UPDATE users 
    SET total_posts = total_posts + 1 
    WHERE user_id = NEW.user_id;
END //
DELIMITER ;

-- task 3 
DELIMITER //
CREATE TRIGGER tg_LogPostChanges
AFTER UPDATE ON posts
FOR EACH ROW
BEGIN
    -- Chỉ ghi log nếu nội dung thực sự thay đổi
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_audits (post_id, old_content, new_content)
        VALUES (OLD.post_id, OLD.content, NEW.content);
    END IF;
END //
DELIMITER ;

-- task 4

DELIMITER //
CREATE TRIGGER tg_UpdatePostCountAfterDelete
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    UPDATE users 
    SET total_posts = total_posts - 1 
    WHERE user_id = OLD.user_id;
END //
DELIMITER ;

--

-- 1. Tạo người dùng
INSERT INTO users (username) VALUES ('NguyenVanA');

-- 2. Thử chèn bài viết trống (Sẽ báo lỗi từ Task 1)
INSERT INTO posts (user_id, content) VALUES (1, '   ');

-- 3. Chèn bài viết hợp lệ (Task 2: total_posts sẽ tăng lên 1)
INSERT INTO posts (user_id, content) VALUES (1, 'Chào mừng đến với SQL!');
SELECT * FROM users; -- Kiểm tra total_posts

-- 4. Chỉnh sửa bài viết (Task 3: Sinh ra log trong post_audits)
UPDATE posts SET content = 'Nội dung đã cập nhật!' WHERE post_id = 1;
SELECT * FROM post_audits;

-- 5. Xóa bài viết (Task 4: total_posts giảm về 0)
DELETE FROM posts WHERE post_id = 1;
SELECT * FROM users;

DROP TRIGGER IF EXISTS tg_CheckPostContent;
DROP TRIGGER IF EXISTS tg_UpdatePostCountAfterInsert;
DROP TRIGGER IF EXISTS tg_LogPostChanges;
DROP TRIGGER IF EXISTS tg_UpdatePostCountAfterDelete;