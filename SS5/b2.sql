
CREATE DATABASE IF NOT EXISTS B2;
USE B2;

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO customers (customer_id, full_name, email, city, status) VALUES
(1, 'Nguyen Van A', 'a@gmail.com', 'TPHCM', 'active'),
(2, 'Tran Thi B', 'b@gmail.com', 'Ha Noi', 'active'),
(3, 'Le Van C', 'c@gmail.com', 'TPHCM', 'inactive'),
(4, 'Pham Thi D', 'd@gmail.com', 'Ha Noi', 'active'),
(5, 'Hoang Van E', 'e@gmail.com', 'Da Nang', 'active');

SELECT *FROM customers;

SELECT *FROM customers
WHERE city = 'TPHCM';

SELECT *FROM customers
WHERE status = 'active'
AND city = 'Ha Noi';

SELECT *FROM customers
ORDER BY full_name ASC;
