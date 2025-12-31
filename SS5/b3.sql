CREATE DATABASE IF NOT EXISTS B3;
USE B3;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL
);

INSERT INTO orders (order_id, customer_id, total_amount, order_date, status) VALUES
(1, 101, 3200000, '2024-01-10', 'completed'),
(2, 102, 7500000, '2024-01-15', 'pending'),
(3, 103, 12000000, '2024-02-01', 'completed'),
(4, 104, 4500000, '2024-02-05', 'cancelled'),
(5, 105, 9800000, '2024-02-10', 'completed'),
(6, 106, 1500000, '2024-02-12', 'completed');

SELECT *FROM orders
WHERE status = 'completed';

SELECT *FROM orders
WHERE total_amount > 5000000;

SELECT *FROM orders
ORDER BY order_date DESC
LIMIT 5;

SELECT *FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;
