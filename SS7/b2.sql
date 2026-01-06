CREATE DATABASE b2;
USE b2;

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(12,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO products VALUES
(1, 'Laptop Dell', 20000000),
(2, 'iPhone 15', 25000000),
(3, 'Tai nghe Bluetooth', 1500000),
(4, 'Chuột không dây', 500000),
(5, 'Bàn phím cơ', 2000000),
(6, 'Màn hình 24 inch', 4000000),
(7, 'USB 64GB', 300000);

INSERT INTO order_items VALUES
(101, 1, 1),
(101, 3, 2),
(102, 2, 1),
(103, 5, 1),
(104, 3, 1),
(105, 4, 3),
(106, 1, 1);

SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);
