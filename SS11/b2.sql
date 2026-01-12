USE social_network_pro;
-- Tính tổng likes của một bài post
DELIMITER $$

CREATE PROCEDURE CalculatePostLikes(
    IN p_post_id INT,
    OUT total_likes INT
)
BEGIN
    SELECT COUNT(*) 
    INTO total_likes
    FROM likes
    WHERE post_id = p_post_id;
END$$

DELIMITER ;

-- Gọi và truy vấn
CALL CalculatePostLikes(101, @kq);
SELECT @kq AS total_likes;
-- Xóa 
DROP PROCEDURE IF EXISTS CalculatePostLikes;
