
use bai3;
drop table subject;
create table subject(
  subjectID int primary key,
  subject_name varchar(255) unique,
  sotinchi int check(sotinchi>0)
);
insert into subject (subjectID, subject_name,sotinchi)
values
(1,"Toan",1),
(2,"van",3),
(3,"Anh",1);
select * from subject;
update subject
set sotinchi=3
where subjectID=1;
update subject
set subject_name="Dia"
where subject_name="Anh";
select * from subject