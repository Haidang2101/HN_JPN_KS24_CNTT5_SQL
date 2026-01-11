-- =====================================================
-- FILE: social_network_view_index.sql
-- TOPIC: VIEW & INDEX (MySQL)
-- MÔ TẢ: Sử dụng VIEW để đơn giản hóa truy vấn,
--        che giấu dữ liệu nhạy cảm
--        và INDEX để tối ưu hiệu năng truy vấn
-- =====================================================

USE social_network;

-- =====================================================
-- PHẦN A – VIEW 
-- =====================================================


CREATE VIEW vw_public_user_profile AS
SELECT 
    username,
    email,
    created_at
FROM users;

-- Kiểm tra view
-- SELECT * FROM vw_public_user_profile;

CREATE VIEW vw_public_news_feed AS
SELECT
    u.username       AS author_name,
    p.content        AS post_content,
    p.created_at     AS post_date,
    COUNT(l.like_id) AS total_likes
FROM posts p
JOIN users u ON p.user_id = u.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
WHERE p.privacy = 'PUBLIC'
GROUP BY p.post_id, u.username, p.content, p.created_at;

-- Kiểm tra view
-- SELECT * FROM vw_public_news_feed ORDER BY post_date DESC;

CREATE VIEW vw_only_public_posts AS
SELECT
    post_id,
    user_id,
    content,
    privacy,
    created_at
FROM posts
WHERE privacy = 'PUBLIC'
WITH CHECK OPTION;

-- PHẦN B – INDEX (CHỈ MỤC)
-- =====================================================

EXPLAIN
SELECT *
FROM posts
WHERE privacy = 'PUBLIC'
ORDER BY created_at DESC;

CREATE INDEX idx_posts_privacy_created
ON posts (privacy, created_at);

-- Index phục vụ truy vấn lấy bài viết theo user
CREATE INDEX idx_posts_user
ON posts (user_id);

EXPLAIN
SELECT *
FROM posts
WHERE privacy = 'PUBLIC'
ORDER BY created_at DESC;


-- CÂU 6: PHÂN TÍCH HẠN CHẾ CỦA INDEX
-- (Trả lời bằng comment – đúng yêu cầu bài)
-- =====================================================

-- 1. Khi nào KHÔNG nên tạo index?
--    - Bảng có dữ liệu nhỏ
--    - Cột ít được dùng trong WHERE / JOIN / ORDER BY
--    - Bảng có tần suất INSERT / UPDATE cao

-- 2. Vì sao không nên index cột nội dung bài viết?
--    - Cột TEXT rất dài
--    - Tốn nhiều bộ nhớ
--    - Hiệu quả thấp với tìm kiếm thông thường

-- 3. Index ảnh hưởng thế nào đến INSERT / UPDATE?
--    - Làm chậm INSERT / UPDATE
--    - Vì MySQL phải cập nhật lại index mỗi lần dữ liệu thay đổi


-- =====================================================
-- END OF FILE
-- =====================================================
