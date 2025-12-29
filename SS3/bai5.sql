
use bai5;
drop table score;
drop table student;
drop table subject;
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
create table score(
  MaSV int,
  MaMH int,
  primary key(MaSV,MaMH),
  foreign key(MaSV) references student(studentID),
  foreign key(MaMH) references subject(subjectID),
  mid_score float check (mid_score between 0 and 10),
  final_score float check (final_score between 0 and 10)
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
insert into score(MaSV,MaMH,mid_score,final_score)
values
(1,1,7.5,8.9),
(2,2,9.5,3);
select * from score;
select * from score
where final_score>8