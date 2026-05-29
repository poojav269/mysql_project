create database college_erp;
use college_erp;

create table department 
(
dept_id int primary key auto_increment,
dept_name varchar(100) unique not null
);

create table student 
(
student_id int primary key auto_increment,
name varchar( 100),
email varchar(100),
phone varchar(15),
gender enum ('male','female'),
dob date ,
dept_id int,
admission_date datetime default current_timestamp(),
foreign key (dept_id) references department(dept_id)
);

select * from student;
create table faculty
(
faculty_id int primary key auto_increment,
name varchar(100),
email varchar(100),
salary decimal(10,2),
dept_id int,
foreign key (dept_id) references department(dept_id)
);

select * from faculty;


create table course
(
course_id int primary key auto_increment,
course_name varchar(100),
credits int,
dept_id int,
faculty_id int,
foreign key (dept_id) references department(dept_id),
foreign key (faculty_id)references faculty(faculty_id)
);


select *from course;

create table enrollment
(
enroll_id int primary key auto_increment,
student_id int ,
course_id int,
enroll_date datetime default current_timestamp(),
unique (student_id,course_id),
foreign key (student_id) references student(student_id),
foreign key (course_id) references course(course_id)
);

select * from enrollment;



create table attendence 
(
attendence_id int primary key auto_increment,
student_id int,
course_id int ,
date date,
status enum ('present','absent'),
foreign key (student_id) references student (student_id),
foreign key (course_id) references course(course_id)
);

SELECT *FROM ATTENDENCE;

create table marks 
(
marks_id int primary key auto_increment,
student_id int,
course_id int,
marks int check (marks between 0 and 100),
foreign key (student_id) references student (student_id),
foreign key (course_id) references course(course_id)
);


select * from marks;

create table fees
(

fee_id int primary key auto_increment,
student_id int ,
total_fee decimal(10,2),
paid_amount decimal(10,2),
foreign key (student_id) references student(student_id)
); 

select * from fees;




insert into department(dept_name)
values 
('computer science'),
('mechanical'),
('civil');

insert into student(name,email,phone,gender,dob,dept_id)
values
('rahul sharma','rahul@gmail.com','9876543210','male','2002-05-10',1),
('anita verma','anita@gmail,com','9876543211','female','2003-03-12',2);

insert into faculty(name,email,salary,dept_id)
values
('dr singh','sinvgh@gmail.com',80000,1),
('prof kumar','kumar@gmail.com',75000,2);

insert into course(course_name,credits,dept_id,faculty_id)
values
('databse system',4,1,1),
('thermodynamics',3,2,2);

select 
s.name,
c.course_name ,
m.marks,
case
when m.marks>=90 then 'A+'
WHEN M.MARKS>75 THEN 'A'
WHEN M.MARKS>=60 THEN 'B'
WHEN M.MARKS >=50 THEN 'C'
ELSE 'F'
END AS GRADE 
FROM MARKS M 
JOIN STUDENT S ON M.STUDENT_ID = S.STUDENT_ID
JOIN COURSE C ON M.COURSE_ID = C.COURSE_ID;


-- fee status

select
s.name,
f.total_fee,
f.paid_amount,
(f.total_fee- f.paid_amount)  as due_amount,
case
when (f.total_fee - f.paid_amount)=0 then 'PAID'ELSE 'PENDING'
END AS STATUS 
FROM FEES f 
join student s on f.student_id= s.student_id;  



-- attendence percentage 

select 
s.name,
c.course_name,
ROUND(SUM(a.status='Present')*100/COUNT(*),2) AS ATTENDENCE_PERCENTAGE
FROM ATTENDENCE A
JOIN STUDENT S ON A.STUDENT_ID=S.STUDENT_ID
JOIN COURSE C ON A.COURSE_ID=C.COURSE_ID
GROUP BY S.NAME,C.COURSE_NAME;


-- TOPPER PER COURSE
SELECT
C.COURSE_NAME,
S.NAME,
M.MARKS
FROM MARKS M
JOIN STUDENT S ON M.STUDENT_ID=S.STUDENT_ID
JOIN COURSE C ON M.COURSE_ID =C.COURSE_ID
WHERE (C.COURSE_ID,M.MARKS) IN (
SELECT COURSE_ID,MAX(MARKS)
FROM MARKS 
GROUP BY COURSE_ID 
);



-- LOW ATTENDENCE

SELECT * FROM ( 
SELECT
S.NAME ,
ROUND( SUM(A.STATUS ='PRESENT')*100/COUNT(*),2) AS PERCENTAGE 
FROM ATTENDENCE A 
JOIN STUDENT S ON A.STUDENT_ID = S.STUDENT_ID 
group by S.NAME 
)AS TEMP
WHERE PERCENTAGE < 75;

-- FEE DEFAULTERS
SELECT
S.NAME,
(F.TOTAL_FEE -F.PAID_AMOUNT)AS DUE_AMOUNT
FROM FEES f
JOIN STUDENT S ON F.STUDENT_ID = S.STUDENT_ID 
WHERE (F.TOTAL_FEE - F.PAID_AMOUNT) > 0;



CREATE VIEW REPORT_CARD AS 
SELECT 
S.NAME,
C.COURSE_NAME,
M.MARKS,
CASE 
WHEN M.MARKS>=90 THEN 'A+'
WHEN M.MARKS>=75 THEN 'A'
WHEN M.MARKS >=60 THEN 'B'
WHEN M.MARKS >=50 THEN 'C'
ELSE'F'
END AS GRADE
FROM MARKS M 
JOIN STUDENT S ON M.STUDENT_ID = S.STUDENT_ID
JOIN COURSE C ON M.COURSE_ID = C.COURSE_ID;



-- STORAGE PROCEDURE 

DELIMITER //
CREATE PROCEDURE GETSTUDENTREP0RT(IN SID INT)
BEGIN 
SELECT* FROM REPORT_CARD
WHERE NAME  = (SELECT NAME FROM STUDENT WHERE STUDENT_ID= SID);
END   //
DELIMITER ;


SELECT * FROM STUDENT;



INSERT INTO DEPARTMENT(DEPT_NAME)
VALUES
('ELECTRICAL'),
('BCA'),
('IT');

INSERT INTO STUDENT (NAME,EMAIL,PHONE,GENDER,DEPT_ID,DOB)
VALUES
('POOJA RAWAT','POOJA@GMAIL.COM ', '9867452312', 'FEMALE',3, '2002-05-23'),
('LOVEY SINGH','LOVEY@GMAIL.COM','9997154345','MALE',4,'2003-04-30'),
('POONAM SINGH','POONAM@GMAIL.COM','9889766745','FEMALE',5,'2005-04-08');




INSERT INTO FACULTY(NAME,EMAIL,SALARY,DEPT_ID)
VALUES 
('PROF.RAJEEV','RAJEEV@GMAIL.COM',90000,3),
('DR.PRADEEP','PRADEEP@GMAIL.COM',95000,4),
('PROF.ANKIT','ANKIT@HMAIL.COM',75000,5);


INSERT INTO COURSE(COURSE_NAME,CREDITS,DEPT_ID,FACULTY_ID)
VALUES
('ACCOUNTING',5,3,3),
('DATA SCIENCE',4,4,4),
('ARTIFICIAL INTELLIGENCE',6,5,5);


SELECT * FROM STUDENT;



insert into enrollment(enroll_id,student_id,course_id)
values
(101,1,1),
(102,2,2),
(103,9,3),
(104,10,4),
(105,11,5);


insert into attendence(attendence_id,student_id,course_id,date,status)
values

(101,1,1,'2026-05-12','present'),
(102,2,2,'2026-06-23','absent'),
(103,9,3,'2026-05-09','present'),
(104,10,4,'2026-03-16','absent'),
(105,11,5,'2026-07-11','present');

select * from attendence;


insert into marks (marks_id,student_id,course_id,marks)
values
(111,1,1,75),
(112,2,2,89),
(113,9,3,90),
(114,10,4,45),
(115,11,5,67);

select * from marks ;


insert into fees(fee_id,student_id,total_fee,paid_amount)
values
(1001,1,150000,85000),
(1002,2,180000,50000),
(1003,9,132000,50000),
(1004,10,100000,65000),
(1005,11,95000,45000);


select * from college_erp.report_card;





