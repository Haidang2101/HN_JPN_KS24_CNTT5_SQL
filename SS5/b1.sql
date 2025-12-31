
CREATE DATABASE IF NOT EXISTS B1;
USE B1;

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO products (product_id, product_name, price, stock, status) VALUES
(1, 'Laptop', 15000000, 10, 'active'),
(2, 'Chuột', 300000, 50, 'active'),
(3, 'Bàn phím', 800000, 30, 'inactive'),
(4, 'Màn hình', 3500000, 15, 'active');

SELECT * FROM products;
SELECT *FROM products
WHERE status = 'active';
SELECT *FROM products
WHERE price > 1000000;
SELECT *FROM products
WHERE status = 'active'
ORDER BY price ASC;
