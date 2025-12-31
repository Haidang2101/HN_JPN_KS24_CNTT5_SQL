
CREATE DATABASE IF NOT EXISTS B6;
USE B6;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    stock INT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);


INSERT INTO products (product_name, price, stock, status) VALUES
('Laptop Dell', 2500000, 10, 'active'),
('Laptop HP', 2800000, 5, 'active'),
('iPhone 13', 3000000, 8, 'active'),
('Samsung Galaxy S22', 2700000, 6, 'active'),
('Asus Gaming Laptop', 3500000, 3, 'active'),
('Mouse Logitech', 500000, 20, 'active'),
('Keyboard Mechanical', 1200000, 15, 'active'),
('Monitor LG', 2200000, 4, 'inactive'),
('Tablet Samsung', 1800000, 7, 'active'),
('Headphone Sony', 1500000, 12, 'active'),
('Printer Canon', 3200000, 2, 'inactive'),
('Webcam Logitech', 1100000, 9, 'active'),
('SSD 1TB', 2000000, 25, 'active'),
('Router Wifi', 1300000, 14, 'active'),
('Smart Watch', 1700000, 11, 'active');

SELECT *FROM products
WHERE status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 0;


SELECT *FROM products
WHERE status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;
