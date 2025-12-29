
use bai1;
drop table student;
create table Student(
  studentID int unique primary key,
  full_name varchar(255) not null ,
  date_of_birth date,
  email varchar(255) unique
);
insert into student (studentID,full_name,date_of_birth,email) 
VALUES
(1, "Nguyen Van A", "2002-12-01", "nguyenvana@gmail.com"),
(2, "Tran Thi B", "2001-08-15", "tranthib@gmail.com"),
(3, "Le Van C", "2003-05-20", "levanc@gmail.com");
select * from student;
select studentID,full_name from student;