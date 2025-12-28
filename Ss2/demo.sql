CREATE DATABASE session02_table;

USE session02_table;

CREATE TABLE Classes(
                class_id int primary key auto_increment, -- khóa chính tự tăng
        class_name varchar(20) not null unique,
        status bit default 1 -- 1 là đang học, 0 là đã tót nghiệp
);
                -- mối quan hệ 1 - 1 (khóa ngoại ở bảng nào cx đc nhưng phải duy nhất), 1 - n (khóa ngoại ở bảng nhiều) :
                -- Mối quan hệ n - n sinh ra bảng trung gian => 2 mqh 1 - n


CREATE TABLE students (
    -- Mã sinh viên : char(10)classesstudents
    student_id CHAR(10) PRIMARY KEY,

    -- Họ và tên : varchar(50)fk_students_classfk_students_class
    full_name VARCHAR(50) NOT NULL,

    -- Ngày sinh : date
    date_of_birth DATE NOT NULL,

    -- Điểm trung bình (gpa) : decimal(2,1)
    gpa DECIMAL(2,1) DEFAULT 0,

    -- Giới tính : enum('nam', 'nu')
    sex ENUM('nam', 'nu') NOT NULL,

    -- Số điện thoại : char(10)
    phone CHAR(10) UNIQUE,

    -- Email : varchar(50)
    email VARCHAR(50) UNIQUE,

    -- Sơ yếu lý lịch (học bạ, sổ hộ khẩu) : BLOB
    `profile` blob NOT NULL,
    class_id int not null,

   -- cú pháp : [constraint [tên ràng buộc] [loại ràng buộc]
        constraint chk_01 check(gpa >=0),
        CONSTRAINT fk_students_class
        FOREIGN KEY (class_id)
        REFERENCES Classes(class_id)

);
DESCRIBE students;


ALTER TABLE CCCD
    -- thêm cột
    ADD column address varchar(30) not null,

    -- định nghĩa kiểu dữ liệu
    modify column serial_number char(14) not null unique,

    -- xóa cột
    drop column address,

    -- thêm ràng buộc
    add foreign key(abc) references classes(abc),

    -- xóa ràng buộc
    drop constraint fk_01;