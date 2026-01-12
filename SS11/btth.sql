DROP DATABASE IF EXISTS SocialLab;
CREATE DATABASE SocialLab;
USE SocialLab;

CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    content TEXT,
    author VARCHAR(100),
    likes_count INT DEFAULT 0
);

INSERT INTO posts (content, author, likes_count) VALUES 
('Nội dung bài viết 1!', 'A', 10),
('Nội dung bài viết 1!', 'B', 5),
('Nội dung bài viết 1!', 'C', 25),
('Nội dung bài viết 1!', 'C', 12),
('Nội dung bài viết 1!', 'D', 3);

DELIMITER //

-- Task 1: Tạo bài viết mới và trả về ID
CREATE PROCEDURE sp_CreatePost(
    IN p_content TEXT,
    IN p_author VARCHAR(100),
    OUT p_post_id INT
)
BEGIN
    INSERT INTO posts (content, author) VALUES (p_content, p_author);
    SET p_post_id = LAST_INSERT_ID();
END //

-- Task 2: Tìm kiếm bài viết theo từ khóa nội dung
CREATE PROCEDURE sp_SearchPost(IN p_keyword VARCHAR(255))
BEGIN
    SELECT * FROM posts 
    WHERE content LIKE CONCAT('%', p_keyword, '%');
END //

-- Task 3: Tăng Like (Sử dụng INOUT)
CREATE PROCEDURE sp_IncreaseLike(
    IN p_post_id INT,
    INOUT p_current_likes INT
)
BEGIN
    SET p_current_likes = p_current_likes + 1;
    UPDATE posts SET likes_count = p_current_likes WHERE post_id = p_post_id;
END //

-- Task 4: Xóa bài viết theo ID
CREATE PROCEDURE sp_DeletePost(IN p_post_id INT)
BEGIN
    DELETE FROM posts WHERE post_id = p_post_id;
END //

DELIMITER ;

-- KIỂM TRA TASK 1: Thêm bài viết mới
CALL sp_CreatePost('Học Stored Procedure rất thú vị!', 'Gemini_AI', @new_id);
SELECT @new_id AS 'ID_Bai_Viet_Moi';

-- KIỂM TRA TASK 2: Tìm kiếm từ khóa "hello"
CALL sp_SearchPost('hello');

-- KIỂM TRA TASK 3: Tăng Like cho bài viết vừa tạo
SELECT likes_count INTO @current_likes FROM posts WHERE post_id = @new_id;
CALL sp_IncreaseLike(@new_id, @current_likes);
SELECT @current_likes AS 'So_Like_Sau_Khi_Tang';

-- KIỂM TRA TASK 4: Xóa một bài viết (ví dụ bài số 2)
CALL sp_DeletePost(2);

-- XEM LẠI TOÀN BỘ DỮ LIỆU CUỐI CÙNG
SELECT * FROM posts;

-- Xóa các thủ tục sau khi hoàn thành
DROP PROCEDURE IF EXISTS sp_CreatePost;
DROP PROCEDURE IF EXISTS sp_SearchPost;
DROP PROCEDURE IF EXISTS sp_IncreaseLike;
DROP PROCEDURE IF EXISTS sp_DeletePost;