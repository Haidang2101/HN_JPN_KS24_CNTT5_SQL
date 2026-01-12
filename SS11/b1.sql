USE social_network_pro;
-- Tạo stored procedure có tham số IN nhận vào p_user_id:
DELIMITER $$

CREATE PROCEDURE LayBaiViet(IN p_user_id INT)
BEGIN
	SELECT 
		 post_id   AS PostID,
        content   AS `Nội dung`,
        created_at AS `Thời gian tạo`
    FROM posts
    WHERE user_id = p_user_id
    ORDER BY created_at DESC;
END$$

DELIMITER ;

-- Gọi lại thủ tục vừa tạo với user cụ thể 
CALL LayBaiViet(1);

-- Xóa thủ tự vừa tạo
DROP PROCEDURE IF EXISTS LayBaiViet;



