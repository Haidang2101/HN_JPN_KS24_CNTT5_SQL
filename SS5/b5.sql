CREATE DATABASE IF NOT EXISTS B5;
USE B5;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL
);

INSERT INTO orders (order_id, customer_id, total_amount, order_date, status) VALUES
(1, 101, 2000000, '2024-01-01', 'completed'),
(2, 102, 3000000, '2024-01-02', 'pending'),
(3, 103, 1500000, '2024-01-03', 'completed'),
(4, 104, 5000000, '2024-01-04', 'cancelled'),
(5, 105, 2500000, '2024-01-05', 'pending'),
(6, 106, 4200000, '2024-01-06', 'completed'),
(7, 107, 1800000, '2024-01-07', 'pending'),
(8, 108, 3600000, '2024-01-08', 'completed'),
(9, 109, 2900000, '2024-01-09', 'pending'),
(10,110, 4700000, '2024-01-10', 'completed'),
(11,111, 5100000, '2024-01-11', 'pending'),
(12,112, 3300000, '2024-01-12', 'completed'),
(13,113, 4100000, '2024-01-13', 'pending'),
(14,114, 3900000, '2024-01-14', 'completed'),
(15,115, 2800000, '2024-01-15', 'pending');

SELECT *FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

SELECT *FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT *FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;
