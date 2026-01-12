USE social_network_pro;

DELIMITER $$

CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE v_post_id INT;
    DECLARE v_full_name VARCHAR(255);
    DECLARE v_friend_id INT;
    DECLARE done INT DEFAULT 0;
    DECLARE v_sent INT DEFAULT 0;

    DECLARE cur_friends CURSOR FOR
        SELECT DISTINCT
            CASE
                WHEN f.user_id = p_user_id THEN f.friend_id
                ELSE f.user_id
            END AS friend_id
        FROM friends f
        WHERE (f.user_id = p_user_id OR f.friend_id = p_user_id)
          AND f.status = 'accepted';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT u.full_name
    INTO v_full_name
    FROM users u
    WHERE u.user_id = p_user_id;

    IF v_full_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User not found';
    END IF;

    INSERT INTO posts(user_id, content, created_at)
    VALUES (p_user_id, p_content, NOW());

    SET v_post_id = LAST_INSERT_ID();

    OPEN cur_friends;

    read_loop: LOOP
        FETCH cur_friends INTO v_friend_id;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF v_friend_id <> p_user_id THEN
            INSERT INTO notifications(user_id, type, content, post_id, created_at)
            VALUES (
                v_friend_id,
                'new_post',
                CONCAT(v_full_name, ' đã đăng một bài viết mới'),
                v_post_id,
                NOW()
            );
            SET v_sent = v_sent + 1;
        END IF;
    END LOOP;

    CLOSE cur_friends;

    SELECT v_post_id AS new_post_id, v_sent AS notifications_sent;
END$$

DELIMITER ;

CALL NotifyFriendsOnNewPost(3, 'Hôm nay mình đăng bài mới nha!');

SELECT *
FROM notifications
WHERE post_id = @pid
  AND type = 'new_post'
ORDER BY created_at DESC;

DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
