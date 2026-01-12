create database SocialLab;
USE SocialLab;

CREATE TABLE posts(
	post_id INT primary key auto_increment,
	content TEXT,
	author VARCHAR(50),
	likes_count INT Default 0
);

INSERT INTO posts( content, author, likes_count) 
values
('hello', 'a', 6),
('lololo', 'b', 9),
('ok', 'vg', 10);

DROP PROCEDURE IF EXISTS sp_SearchPost;
DELIMITER //

CREATE PROCEDURE sp_SearchPost(
    IN p_keyword VARCHAR(255)
)
BEGIN
    SELECT
        post_id,
        content,
        author,
        likes_count
    FROM posts
    WHERE content LIKE CONCAT('%', p_keyword, '%');
END$$

DELIMITER ;
CALL sp_SearchPost('lololo');


DROP PROCEDURE IF EXISTS sp_IncreaseLike;
DELIMITER $$

CREATE PROCEDURE sp_IncreaseLike(
    IN    p_post_id INT,
    INOUT p_like_current INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM posts WHERE post_id = p_post_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Post not found';
    END IF;

    SET p_like_current = IFNULL(p_like_current, 0) + 1;
END$$

DELIMITER ;
SET @likes = 10;
CALL sp_IncreaseLike(5, @likes);
SELECT @likes AS like_after;



DROP PROCEDURE IF EXISTS sp_DeletePost;
DELIMITER $$

CREATE PROCEDURE sp_DeletePost(
    IN p_post_id INT
)
BEGIN
    DELETE FROM posts
    WHERE post_id = p_post_id;
END$$

DELIMITER ;
CALL sp_DeletePost(5);
