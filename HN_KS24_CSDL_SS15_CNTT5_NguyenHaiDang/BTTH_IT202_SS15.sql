drop database if exists mini_social_network;
create database mini_social_network character set utf8mb4 collate utf8mb4_unicode_ci;
use mini_social_network;
-- 1) users
create table users (
  user_id    int primary key auto_increment,
  username   varchar(50) not null unique,
  password   varchar(255) not null,
  email      varchar(100) not null unique,
  created_at datetime default current_timestamp
) engine=innodb;

-- 2) posts (thêm like_count theo Bài 3)
create table posts (
  post_id    int primary key auto_increment,
  user_id    int not null,
  content    text not null,
  like_count int default 0,
  created_at datetime default current_timestamp,
  constraint fk_posts_users foreign key (user_id)
    references users(user_id) on delete cascade
) engine=innodb;

-- 3) comments
create table comments (
  comment_id int primary key auto_increment,
  post_id    int not null,
  user_id    int not null,
  content    text not null,
  created_at datetime default current_timestamp,
  constraint fk_comments_posts foreign key (post_id)
    references posts(post_id) on delete cascade,
  constraint fk_comments_users foreign key (user_id)
    references users(user_id) on delete cascade
) engine=innodb;

-- 4) likes
create table likes (
  user_id    int not null,
  post_id    int not null,
  created_at datetime default current_timestamp,
  primary key (user_id, post_id),
  constraint fk_likes_users foreign key (user_id)
    references users(user_id) on delete cascade,
  constraint fk_likes_posts foreign key (post_id)
    references posts(post_id) on delete cascade
) engine=innodb;

-- 5) friends 
create table friends (
  user_id    int not null,
  friend_id  int not null,
  status     varchar(20) default 'pending',
  created_at datetime default current_timestamp,
  primary key (user_id, friend_id),
  constraint fk_friends_user foreign key (user_id)
    references users(user_id) on delete cascade,
  constraint fk_friends_friend foreign key (friend_id)
    references users(user_id) on delete cascade,
  constraint chk_friends_status check (status in ('pending','accepted'))
) engine=innodb;

-- user_log: log đăng ký / xóa user
create table user_log (
  log_id   int primary key auto_increment,
  user_id  int,
  action   varchar(50) not null,
  log_time datetime default current_timestamp,
  note     varchar(255),
  index (user_id)
) engine=innodb;

-- post_log: log đăng bài / xóa bài
create table post_log (
  log_id   int primary key auto_increment,
  post_id  int,
  user_id  int,
  action   varchar(50) not null,
  log_time datetime default current_timestamp,
  note     varchar(255),
  index (post_id),
  index (user_id)
) engine=innodb;

-- like_log: log like / unlike
create table like_log (
  log_id   int primary key auto_increment,
  user_id  int,
  post_id  int,
  action   varchar(50) not null,
  log_time datetime default current_timestamp,
  index (user_id),
  index (post_id)
) engine=innodb;

-- friend_log: log gửi lời mời / chấp nhận / hủy
create table friend_log (
  log_id     int primary key auto_increment,
  user_id    int,
  friend_id  int,
  action     varchar(50) not null,
  log_time   datetime default current_timestamp,
  note       varchar(255),
  index (user_id),
  index (friend_id)
) engine=innodb;


delimiter $$

-- Bài 1: 
drop trigger if exists trg_users_after_insert_log $$
create trigger trg_users_after_insert_log
after insert on users
for each row
begin
  insert into user_log(user_id, action, note)
  values (new.user_id, 'register', concat('username=', new.username));
end $$

-- Bài 2: 
drop trigger if exists trg_posts_after_insert_log $$
create trigger trg_posts_after_insert_log
after insert on posts
for each row
begin
  insert into post_log(post_id, user_id, action, note)
  values (new.post_id, new.user_id, 'create_post', 'post created');
end $$

-- Bài 3: 
-- tăng like
drop trigger if exists trg_likes_after_insert_count $$
create trigger trg_likes_after_insert_count
after insert on likes
for each row
begin
  update posts
  set like_count = like_count + 1
  where post_id = new.post_id;

  insert into like_log(user_id, post_id, action)
  values (new.user_id, new.post_id, 'like');
end $$

-- giảm like
drop trigger if exists trg_likes_after_delete_count $$
create trigger trg_likes_after_delete_count
after delete on likes
for each row
begin
  update posts
  set like_count = case when like_count > 0 then like_count - 1 else 0 end
  where post_id = old.post_id;

  insert into like_log(user_id, post_id, action)
  values (old.user_id, old.post_id, 'unlike');
end $$

-- Bài 4: 
drop trigger if exists trg_friends_after_insert_log $$
create trigger trg_friends_after_insert_log
after insert on friends
for each row
begin
  insert into friend_log(user_id, friend_id, action, note)
  values (new.user_id, new.friend_id, 'send_request', concat('status=', new.status));
end $$

-- Bài 5: 
drop trigger if exists trg_friends_after_update_symmetry $$
create trigger trg_friends_after_update_symmetry
after update on friends
for each row
begin
  if old.status <> 'accepted' and new.status = 'accepted' then
    insert ignore into friends(user_id, friend_id, status, created_at)
    values (new.friend_id, new.user_id, 'accepted', current_timestamp);

    insert into friend_log(user_id, friend_id, action, note)
    values (new.user_id, new.friend_id, 'accept_request', 'accepted + ensure symmetric');
  end if;
end $$

delimiter ;

delimiter $$

drop procedure if exists sp_register_user $$
create procedure sp_register_user(
  in p_username varchar(50),
  in p_password varchar(255),
  in p_email    varchar(100)
)
begin
  declare v_cnt int default 0;

  if p_username is null or length(trim(p_username)) = 0 then
    signal sqlstate '45000' set message_text = 'username khong duoc rong';
  end if;

  if p_email is null or length(trim(p_email)) = 0 then
    signal sqlstate '45000' set message_text = 'email khong duoc rong';
  end if;

  select count(*) into v_cnt from users where username = p_username;
  if v_cnt > 0 then
    signal sqlstate '45000' set message_text = 'trung username';
  end if;

  select count(*) into v_cnt from users where email = p_email;
  if v_cnt > 0 then
    signal sqlstate '45000' set message_text = 'trung email';
  end if;

  insert into users(username, password, email)
  values (p_username, p_password, p_email);
end $$

create procedure sp_create_post(
  in p_user_id int,
  in p_content text
)
begin
  declare v_cnt int default 0;

  select count(*) into v_cnt from users where user_id = p_user_id;
  if v_cnt = 0 then
    signal sqlstate '45000' set message_text = 'user khong ton tai';
  end if;

  if p_content is null or length(trim(p_content)) = 0 then
    signal sqlstate '45000' set message_text = 'content khong duoc rong';
  end if;

  insert into posts(user_id, content) values (p_user_id, p_content);
end $$


drop procedure if exists sp_toggle_like $$
create procedure sp_toggle_like(
  in p_user_id int,
  in p_post_id int
)
begin
  declare v_cnt int default 0;

  select count(*) into v_cnt from posts where post_id = p_post_id;
  if v_cnt = 0 then
    signal sqlstate '45000' set message_text = 'post khong ton tai';
  end if;

  select count(*) into v_cnt from users where user_id = p_user_id;
  if v_cnt = 0 then
    signal sqlstate '45000' set message_text = 'user khong ton tai';
  end if;

  select count(*) into v_cnt from likes where user_id = p_user_id and post_id = p_post_id;

  if v_cnt = 0 then
    insert into likes(user_id, post_id) values (p_user_id, p_post_id);
  else
    delete from likes where user_id = p_user_id and post_id = p_post_id;
  end if;
end $$

drop procedure if exists sp_send_friend_request $$
create procedure sp_send_friend_request(
  in p_sender_id   int,
  in p_receiver_id int
)
begin
  declare v_cnt int default 0;

  if p_sender_id = p_receiver_id then
    signal sqlstate '45000' set message_text = 'khong the tu gui ket ban cho chinh minh';
  end if;

  select count(*) into v_cnt from users where user_id = p_sender_id;
  if v_cnt = 0 then
    signal sqlstate '45000' set message_text = 'sender khong ton tai';
  end if;

  select count(*) into v_cnt from users where user_id = p_receiver_id;
  if v_cnt = 0 then
    signal sqlstate '45000' set message_text = 'receiver khong ton tai';
  end if;

  -- không cho trùng (cả 2 chiều)
  select count(*) into v_cnt
  from friends
  where (user_id = p_sender_id and friend_id = p_receiver_id)
     or (user_id = p_receiver_id and friend_id = p_sender_id);

  if v_cnt > 0 then
    signal sqlstate '45000' set message_text = 'da ton tai loi moi/quan he ket ban';
  end if;

  insert into friends(user_id, friend_id, status)
  values (p_sender_id, p_receiver_id, 'pending');
end $$


drop procedure if exists sp_accept_friend_request $$
create procedure sp_accept_friend_request(
  in p_sender_id   int,
  in p_receiver_id int
)
begin
  declare v_cnt int default 0;

  select count(*) into v_cnt
  from friends
  where user_id = p_sender_id
    and friend_id = p_receiver_id
    and status = 'pending';

  if v_cnt = 0 then
    signal sqlstate '45000' set message_text = 'khong tim thay loi moi pending de chap nhan';
  end if;

  update friends
  set status = 'accepted'
  where user_id = p_sender_id and friend_id = p_receiver_id;
  -- trigger AFTER UPDATE sẽ tự tạo bản ghi đối xứng + log
end $$


drop procedure if exists sp_remove_friend $$
create procedure sp_remove_friend(
  in p_user_id   int,
  in p_friend_id int
)
begin
  declare exit handler for sqlexception
  begin
    rollback;
    signal sqlstate '45000' set message_text = 'remove friend that bai -> da rollback';
  end;

  start transaction;

  delete from friends where user_id = p_user_id and friend_id = p_friend_id;
  delete from friends where user_id = p_friend_id and friend_id = p_user_id;

  insert into friend_log(user_id, friend_id, action, note)
  values (p_user_id, p_friend_id, 'remove_relationship', 'delete both directions');

  commit;
end $$

drop procedure if exists sp_delete_post $$
create procedure sp_delete_post(
  in p_post_id int,
  in p_user_id int
)
begin
  declare v_owner int;

  declare exit handler for sqlexception
  begin
    rollback;
    signal sqlstate '45000' set message_text = 'xoa bai viet that bai -> da rollback';
  end;

  select user_id into v_owner
  from posts
  where post_id = p_post_id;

  if v_owner is null then
    signal sqlstate '45000' set message_text = 'post khong ton tai';
  end if;

  if v_owner <> p_user_id then
    signal sqlstate '45000' set message_text = 'khong co quyen xoa (khong phai chu post)';
  end if;

  start transaction;

  delete from likes where post_id = p_post_id;
  delete from comments where post_id = p_post_id;
  delete from posts where post_id = p_post_id;

  insert into post_log(post_id, user_id, action, note)
  values (p_post_id, p_user_id, 'delete_post', 'delete likes+comments+post');

  commit;
end $$


drop procedure if exists sp_delete_user $$
create procedure sp_delete_user(
  in p_user_id int
)
begin
  declare v_cnt int default 0;

  declare exit handler for sqlexception
  begin
    rollback;
    signal sqlstate '45000' set message_text = 'xoa user that bai -> da rollback';
  end;

  select count(*) into v_cnt from users where user_id = p_user_id;
  if v_cnt = 0 then
    signal sqlstate '45000' set message_text = 'user khong ton tai';
  end if;

  start transaction;

  delete from friends where user_id = p_user_id or friend_id = p_user_id;

  delete from likes where user_id = p_user_id;

  delete from comments where user_id = p_user_id;

  delete from posts where user_id = p_user_id;

  delete from users where user_id = p_user_id;

  insert into user_log(user_id, action, note)
  values (p_user_id, 'delete_user', 'delete user + all related data');

  commit;
end $$

delimiter ;


-- Bài 1: 
call sp_register_user('alice', 'hash_pw_1', 'alice@gmail.com');
call sp_register_user('bob',   'hash_pw_2', 'bob@gmail.com');
call sp_register_user('cindy', 'hash_pw_3', 'cindy@gmail.com');


select * from users;
select * from user_log order by log_id;

-- Bài 2: 
call sp_create_post(1, 'xin chao, day la bai viet 1');
call sp_create_post(1, 'bai viet 2 cua alice');
call sp_create_post(2, 'bai viet 1 cua bob');


select * from posts;
select * from post_log order by log_id;

-- Bài 3: 
call sp_toggle_like(2, 1);
call sp_toggle_like(3, 1); 
call sp_toggle_like(2, 1);

select post_id, like_count from posts;
select * from likes;
select * from like_log order by log_id;

-- Bài 4:
call sp_send_friend_request(1, 2);

select * from friends;
select * from friend_log order by log_id;

-- Bài 5: 
call sp_accept_friend_request(1, 2); 
select * from friends order by user_id, friend_id;
select * from friend_log order by log_id;

-- Bài 6: 
call sp_remove_friend(1, 2);
select * from friends;
select * from friend_log order by log_id;

-- Bài 7: 
insert into comments(post_id, user_id, content) values (2, 2, 'comment cua bob');
call sp_toggle_like(2, 2); 

call sp_delete_post(2, 1); 
select * from posts;
select * from comments;
select * from likes;
select * from post_log order by log_id;

-- Bài 8: 
call sp_create_post(3, 'post cua cindy');
call sp_toggle_like(1, 4); 
call sp_send_friend_request(2, 3);
call sp_accept_friend_request(2, 3);

call sp_delete_user(3); 

select * from users;
select * from posts;
select * from comments;
select * from likes;
select * from friends;
select * from user_log order by log_id;
