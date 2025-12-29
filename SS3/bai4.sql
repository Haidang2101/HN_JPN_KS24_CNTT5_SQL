
use bai4;
drop table enrollment;
DROP TABLE Subject;
DROP TABLE Student;
create table Student(
  studentID int unique primary key,
  full_name varchar(255) not null ,
  date_of_birth date,
  email varchar(255) unique
);
create table subject(
  subjectID int primary key,
  subject_name varchar(255) unique,
  sotinchi int check(sotinchi>0)
);
create table Enrollment(
  MaSV int,
  MaMH int,
  Enroll_date date,
  PRIMARY KEY (MaSV, MaMH),
  foreign key(MaSV) references student(studentID),
  foreign key(MaMH) references subject(subjectID)
);
insert into student (studentID,full_name,date_of_birth,email) 
VALUES
(1, "Nguyen Van A", "2002-12-01", "nguyenvana@gmail.com"),
(2, "Tran Thi B", "2001-08-15", "tranthib@gmail.com"),
(3, "Le Van C", "2003-05-20", "levanc@gmail.com"),
(5, "Le Van C", "2003-05-20", "levan4@gmail.com");
select * from student;
insert into subject (subjectID, subject_name,sotinchi)
values
(1,"Toan",1),
(2,"van",3),
(3,"Anh",1);
select * from subject;
insert into enrollment(MaSV,MaMH,Enroll_date)
values
(1,1,"2025-12-29");
select * from Enrollment;
