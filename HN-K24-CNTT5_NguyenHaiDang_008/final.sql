-- PHẦN 1: THIẾT KẾ CSDL & CHÈN DỮ LIỆU
-- tạo cơ sở dữ liệu
create database library_management;
use library_management;

-- bảng 1: độc giả
create table readers (
    reader_id int primary key auto_increment,
    full_name varchar(100) not null,
    email varchar(100) unique not null,
    phone_number varchar(15),
    created_at datetime default current_timestamp
);

-- bảng 2: chi tiết thẻ thành viên
create table membership_details (
    card_number varchar(20) primary key,
    reader_id int unique,
    rank_type varchar(20) default 'standard',
    expiry_date date,
    citizen_id varchar(20) unique not null,
    foreign key (reader_id) references readers(reader_id)
);

-- bảng 3: danh mục sách
create table categories (
    category_id int primary key auto_increment,
    category_name varchar(50) not null,
    description text
);

-- bảng 4: sách
create table books (
    book_id int primary key auto_increment,
    title varchar(150) not null,
    author varchar(100),
    category_id int,
    price decimal(10,2) check (price > 0),
    stock_quantity int default 0 check (stock_quantity >= 0),
    foreign key (category_id) references categories(category_id)
);

-- bảng 5: hồ sơ mượn trả
create table loan_records (
    loan_id int primary key auto_increment,
    reader_id int,
    book_id int,
    borrow_date date not null,
    due_date date not null,
    return_date date null,
    constraint chk_dates check (due_date > borrow_date),
    foreign key (reader_id) references readers(reader_id),
    foreign key (book_id) references books(book_id)
);

-- chèn bảng readers
insert into readers (reader_id, full_name, email, phone_number, created_at) values
(1, 'Nguyen Van a', 'anv@gmail.com', '901234567', '2022-01-15'),
(2, 'Tran Thi b', 'btt@gmail.com', '912345678', '2022-05-20'),
(3, 'Le Van c', 'cle@yahoo.com', '922334455', '2023-02-10'),
(4, 'Pham Minh d', 'dpham@hotmail.com', '933445566', '2023-11-05'),
(5, 'Hoang Anh e', 'ehoang@gmail.com', '944556677', '2024-01-12');

-- chèn bảng membership_details
insert into membership_details (card_number, reader_id, rank_type, expiry_date, citizen_id) values
('card-001', 1, 'standard', '2025-01-15', '123456789'),
('card-002', 2, 'vip', '2025-05-20', '234567890'),
('card-003', 3, 'standard', '2024-02-10', '345678901'),
('card-004', 4, 'vip', '2025-11-05', '456789012'),
('card-005', 5, 'standard', '2026-01-12', '567890123');

-- chèn bảng categories
insert into categories (category_id, category_name, description) values
(1, 'it', 'sách về công nghệ thông tin và lập trình'),
(2, 'Kinh tế', 'sách kinh doanh, tài chính, khởi nghiệp'),
(3, 'Văn học', 'tiểu thuyết, truyện ngắn, thơ'),
(4, 'Ngoại ngữ', 'sách học tiếng anh, nhật, hàn'),
(5, 'Lịch sử', 'sách nghiên cứu lịch sử, văn hóa');

-- chèn bảng books 
insert into books (book_id, title, author, category_id, price, stock_quantity) values
(1, 'Clean Code', 'robert c. martin', 1, 450000, 10),
(2, 'Đắc Nhân Tâm', 'dale carnegie', 2, 150000, 50),
(3, 'Harry Potter 1', 'j.k. rowling', 3, 250000, 5),
(4, 'Ielts Reading', 'cambridge', 4, 180000, 0),
(5, 'Đại Việt Sử Ký', 'le van huu', 5, 300000, 20);

-- chèn bảng loan_records 
insert into loan_records (loan_id, reader_id, book_id, borrow_date, due_date, return_date) values
(101, 1, 1, '2023-11-15', '2023-11-22', '2023-11-20'),
(102, 2, 2, '2023-12-01', '2023-12-08', '2023-12-05'),
(103, 1, 3, '2024-01-10', '2024-01-17', null),
(104, 3, 4, '2023-05-20', '2023-05-27', null),
(105, 4, 1, '2024-01-18', '2024-01-25', null);

-- PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN 

-- Câu 1:
select b.book_id, b.title, b.price
from books b
join categories c on b.category_id = c.category_id
where c.category_name = 'it' 
and b.price > 200000;

-- Câu 2: 
select reader_id, full_name, email
from readers
where year(created_at) = 2022 
and email like '%@gmail.com';

-- - Câu 3 (5đ): Hiển thị danh sách 5 cuốn sách có giá trị cao nhất, sắp xếp theo thứ tự giảm dần. Yêu cầu sử dụng LIMIT và OFFSET để bỏ qua 2 cuốn sách đắt nhất đầu tiên (lấy từ cuốn thứ 3 đến thứ 7).
select book_id, title, price
from books
order by price desc
limit 5 offset 2;

-- PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO
-- Câu 1: 
select l.loan_id, r.full_name, b.title, l.borrow_date, l.return_date
from loan_records l
join readers r on l.reader_id = r.reader_id
join books b on l.book_id = b.book_id
where l.return_date is null;

-- Câu 2:	
select c.category_name, sum(b.stock_quantity) as total_stock
from categories c
join books b on c.category_id = b.category_id
group by c.category_name
having total_stock > 10;

-- Câu 3:
select distinct r.full_name
from readers r
join membership_details m on r.reader_id = m.reader_id
where m.rank_type = 'vip'
and r.reader_id not in (
    select l.reader_id 
    from loan_records l
    join books b on l.book_id = b.book_id
    where b.price > 300000
);

-- PHẦN 4: INDEX VÀ VIEW
-- Câu 1:
create index idx_loan_dates 
on loan_records (borrow_date, return_date);

-- Câu 2: 
create view vw_overdue_loans as
select l.loan_id, r.full_name, b.title, l.borrow_date, l.due_date
from loan_records l
join readers r on l.reader_id = r.reader_id
join books b on l.book_id = b.book_id
where l.return_date is null 
and curdate() > l.due_date;


-- PHẦN 5: TRIGGER
-- Câu 1:
delimiter //

create trigger trg_after_loan_insert
after insert on loan_records
for each row
begin
    update books 
    set stock_quantity = stock_quantity - 1
    where book_id = new.book_id;
end //

delimiter ;

-- Câu 2:
delimiter //

create trigger trg_prevent_delete_active_reader
before delete on readers
for each row
begin
    if exists (select 1 from loan_records 
               where reader_id = old.reader_id 
               and return_date is null) then
               
        signal sqlstate '45000'
        set message_text = 'không thể xóa độc giả này vì họ vẫn đang mượn sách chưa trả!';
        
    end if;
end //

delimiter ;

-- PHẦN 6: STORED PROCEDURE
-- câu 1:
delimiter //

create procedure sp_check_availability(
    in p_book_id int,
    out p_message varchar(50)
)
begin
end //

delimiter ;

