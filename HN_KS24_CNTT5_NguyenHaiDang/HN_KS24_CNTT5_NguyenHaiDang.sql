CREATE DATABASE Test ;
USE Test;

CREATE TABLE Reader (
    reader_id INT PRIMARY KEY AUTO_INCREMENT, 
    reader_name VARCHAR(100) NOT NULL,        
    phone VARCHAR(15) UNIQUE,                 
    register_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Book (
    book_id INT PRIMARY KEY,                  
    book_title VARCHAR(150) NOT NULL,         
    author VARCHAR(150),                      
    publish_year INT CHECK (publish_year >= 1900) 
);

CREATE TABLE Borrow (
    reader_id INT,                            
    book_id INT,                              
    borrow_date DATE DEFAULT (CURRENT_DATE),  
    return_date DATE,                        
    
    FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
ALTER TABLE Reader 
ADD email VARCHAR(100) UNIQUE;

ALTER TABLE Book 
MODIFY COLUMN author VARCHAR(150);

ALTER TABLE Borrow 
ADD CONSTRAINT chk_date_logic CHECK (return_date >= borrow_date);

INSERT INTO Reader (reader_id, reader_name, phone, email, register_date)
VALUES 
(1, 'Nguyễn Văn An', '0901234567', 'an.nguyen@gmail.com', '2024-09-01'),
(2, 'Trần Thị Bình', '0912345678', 'binh.tran@gmail.com', '2024-09-05'),
(3, 'Lê Minh Châu', '0923456789', 'chau.le@gmail.com', '2024-09-10');

INSERT INTO Book (book_id, book_title, author , publish_year)
VALUES 
(101, 'lập trình C căn bản','Nguyễn Văn A','2018'),

;