USE social_network_pro;

DELIMITER $$

CREATE PROCEDURE CalculateUserActivityScore(
    IN  p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
    DECLARE total_posts INT DEFAULT 0;
    DECLARE total_comments INT DEFAULT 0;
    DECLARE total_likes_received INT DEFAULT 0;

    -- 1) Đếm số bài viết của user
    SELECT COUNT(*)
    INTO total_posts
    FROM posts
    WHERE user_id = p_user_id;

    -- 2) Đếm số comment do user tạo
    SELECT COUNT(*)
    INTO total_comments
    FROM comments
    WHERE user_id = p_user_id;

    -- 3) Đếm số like NHẬN ĐƯỢC trên tất cả bài viết của user
    SELECT COUNT(*)
    INTO total_likes_received
    FROM likes l
    JOIN posts p ON p.post_id = l.post_id
    WHERE p.user_id = p_user_id;

    -- 4) Tính điểm
    SET activity_score =
        total_posts * 10
        + total_comments * 5
        + total_likes_received * 3;

    -- 5) Xếp loại mức hoạt động
    SET activity_level = CASE
        WHEN activity_score > 500 THEN 'Rất tích cực'
        WHEN activity_score BETWEEN 200 AND 500 THEN 'Tích cực'
        ELSE 'Bình thường'
    END;
END$$

DELIMITER ;

CALL CalculateUserActivityScore(3, @score, @level);
SELECT @score AS activity_score, @level AS activity_level;

DROP PROCEDURE IF EXISTS CalculateUserActivityScore;
