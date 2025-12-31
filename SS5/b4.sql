
CREATE DATABASE IF NOT EXISTS B4;
USE B4;

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    sold_quantity INT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO products (product_id, product_name, price, stock, sold_quantity, status) VALUES
(1, 'Laptop A', 15000000, 10, 120, 'active'),
(2, 'Laptop B', 18000000, 5, 95, 'active'),
(3, 'Chuột Gaming', 500000, 50, 300, 'active'),
(4, 'Bàn phím cơ', 1200000, 30, 210, 'active'),
(5, 'Tai nghe', 800000, 40, 180, 'active'),
(6, 'Màn hình', 3500000, 15, 160, 'active'),
(7, 'USB 64GB', 250000, 100, 400, 'active'),
(8, 'Ổ cứng SSD', 2200000, 20, 140, 'active'),
(9, 'Webcam', 900000, 25, 110, 'active'),
(10, 'Loa Bluetooth', 1300000, 18, 170, 'active'),
(11, 'Router Wifi', 1700000, 12, 90, 'active'),
(12, 'Chuột văn phòng', 200000, 60, 260, 'active');

SELECT *FROM products
ORDER BY sold_quantity DESC
LIMIT 10;

SELECT *FROM products
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;

SELECT *FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;
