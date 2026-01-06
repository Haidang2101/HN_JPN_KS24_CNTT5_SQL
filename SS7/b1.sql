CREATE DATABASE b1;
USE b1;

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
(5, 'Hoang Van Em', 'em@gmail.com'),
(6, 'Vo Thi Giang', 'giang@gmail.com'),
(7, 'Do Van Hung', 'hung@gmail.com');

INSERT INTO orders VALUES
(101, 1, '2025-01-01', 5000000),
(102, 2, '2025-01-02', 12000000),
(103, 1, '2025-01-03', 3000000),
(104, 3, '2025-01-04', 8000000),
(105, 4, '2025-01-05', 15000000),
(106, 2, '2025-01-06', 4000000),
(107, 5, '2025-01-07', 2000000);

SELECT *
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
);
