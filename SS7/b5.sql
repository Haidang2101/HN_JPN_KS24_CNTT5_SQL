CREATE DATABASE b5;
USE b5;

CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2)
);

INSERT INTO customers VALUES
(1, 'Nguyen Van An', 'an@gmail.com'),
(2, 'Tran Thi Binh', 'binh@gmail.com'),
(3, 'Le Van Cuong', 'cuong@gmail.com'),
(4, 'Pham Thi Dao', 'dao@gmail.com'),
(5, 'Hoang Van Em', 'em@gmail.com');

INSERT INTO orders VALUES
(101, 1, '2025-01-05', 5000000),
(102, 1, '2025-01-06', 8000000),
(103, 2, '2025-01-07', 12000000),
(104, 3, '2025-01-08', 3000000),
(105, 3, '2025-01-09', 7000000),
(106, 3, '2025-01-10', 4000000),
(107, 4, '2025-01-11', 2000000),
(108, 5, '2025-01-12', 15000000);

SELECT *
FROM customers
WHERE id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(total_spent)
        FROM (
            SELECT SUM(total_amount) AS total_spent
            FROM orders
            GROUP BY customer_id
        ) AS temp
    )
);