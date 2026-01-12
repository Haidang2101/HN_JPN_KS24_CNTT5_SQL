USE social_network_pro;

DELIMITER $$

CREATE PROCEDURE CalculateBonusPoints(
	IN p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
	DECLARE total_posts  INT;
    
    SELECT COUNT(*)
    INTO total_posts
    FROM posts
    WHERE user_id = p_user_id;
    
    IF total_posts >= 20 THEN 
		SET p_bonus_points = p_bonus_points + 100;
    ELSEIF total_posts >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    ELSE
        SET p_bonus_points = p_bonus_points;
    END IF;
END $$

DELIMITER ;

SET @points = 100;
CALL CalculateBonusPoints(3, @points);

SELECT @points AS bonus_points_sau_cap_nhat;

DROP PROCEDURE IF EXISTS CalculateBonusPoints;
