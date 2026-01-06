CREATE DATABASE b6;
USE b6;

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2)
);

INSERT INTO orders VALUES
(101, 1, '2025-01-05', 5000000),
(102, 1, '2025-01-06', 8000000),
(103, 2, '2025-01-07', 12000000),
(104, 3, '2025-01-08', 3000000),
(105, 3, '2025-01-09', 7000000),
(106, 4, '2025-01-10', 15000000),
(107, 5, '2025-01-11', 4000000),
(108, 5, '2025-01-12', 6000000);

SELECT
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(total_per_customer)
    FROM (
        SELECT SUM(total_amount) AS total_per_customer
        FROM orders
        GROUP BY customer_id
    ) AS temp
);