CREATE DATABASE b3;
USE b3;

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2)
);

INSERT INTO orders VALUES
(101, 1, '2025-01-05', 5000000),
(102, 2, '2025-01-06', 12000000),
(103, 3, '2025-01-07', 8000000),
(104, 1, '2025-01-08', 20000000),
(105, 4, '2025-01-09', 3000000),
(106, 5, '2025-01-10', 15000000);

SELECT *FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);
