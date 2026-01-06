
CREATE DATABASE b4;
USE b4;

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
(107, 5, '2025-01-11', 9000000);

SELECT
    c.name AS customer_name,
    (
        SELECT COUNT(*)
        FROM orders o
        WHERE o.customer_id = c.id
    ) AS total_orders
FROM customers c;
