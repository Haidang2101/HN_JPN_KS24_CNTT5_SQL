
use bai2;
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
(3, "Le Van C", "2003-05-20", "levanc@gmail.com"),
(5, "Le Van C", "2003-05-20", "levan4@gmail.com");
select * from student;
update student
set email="levane@gmail.com"
where studentID=3;
SELECT * FROM student;
update student
set date_of_birth="2002-08-15"
where studentID=2;
SELECT * FROM student;
delete from student
where studentID=5;
SELECT * FROM student;