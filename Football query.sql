DROP   DATABASE IF EXISTS db_university;
CREATE DATABASE           db_university;
USE                       db_university;

CREATE TABLE classroom(
    building           VARCHAR(15),
    room_number        VARCHAR(7),  
    capacity            FIXED(4,0), 
	PRIMARY KEY(building,room_number)   
);
    
INSERT   INTO classroom(building, room_number    , capacity            )  
VALUES 
		('Packard'   , 101 ,      500),
		('Painter'   , 514 ,      10),
		('Taylor'    , 3128,      70),
		('Watson'    , 100,       30),
		('Watson'    , 120,       50);

CREATE TABLE department(
	dept_name          VARCHAR(20),
    building           VARCHAR(15),
    budget             FIXED(12,2) CHECK (budget>0),
	PRIMARY KEY(dept_name)   
);

INSERT   INTO department(dept_name, building  , budget)  
VALUES 
		('Biology'      , 'Watson',        90e3),
		('Comp. Sci.'   , 'Taylor',       100e3),
		('Elec. Eng.'   , 'Taylor',        85e3),
		('Finance'      , 'Painter',       120e3),
		('History'      , 'Painter',       50e3),
		('Music'        , 'Packard',       80e3),
		('Physics'      , 'Watson' ,       70e3);

CREATE TABLE course(
	course_id          VARCHAR(8),
    title              VARCHAR(70),
    dept_name          VARCHAR(20),
    credits            NUMERIC(2,0),
	PRIMARY KEY(course_id)  ,
    FOREIGN KEY(dept_name) REFERENCES department(dept_name) ON delete set NULL
);

INSERT INTO course(course_id, title, dept_name , credits )  
VALUES 
		('BIO-101' ,   'Intro. to Biology'                 ,'Biology'     , 4),
		('BIO-301' ,   'Genetics'                          ,'Biology'     , 4),
		('BIO-399' ,   'Computational Biology'             ,'Biology'     , 3),
		('CS-101'  ,   'Intro to computer Sci.'            ,'Comp. Sci.'  , 4),
		('CS-190'  ,   'Game Design'                       ,'Comp. Sci.'  , 4),
		('CS-315'  ,   'Robotics'                          ,'Comp. Sci.'  , 3),
		('CS-319'  ,   'Image Processing'                  ,'Comp. Sci.'  , 3),
		('CS-347'  ,   'Data Base System Concepts'         ,'Comp. Sci.'  , 3),
		('EE-181'  ,   'Intr. to Digital Systems'          ,'Elec. Eng.'  , 4),
		('FIN-201' ,   'Investment Banking'                ,'Finance'     , 4),
		('HIS-351' ,   'World History'                     ,'History'     , 3),
		('MUS-199' ,   'Music Video Production'            ,'Music'       , 3),
		('PHY-101' ,   'Physical Principles'               ,'Physics'     , 4);

CREATE TABLE instructor(
	ID                 VARCHAR(8)          ,
    name               VARCHAR(50) not null,
    dept_name          VARCHAR(20)         ,
    salary             FIXED(8,2)      check(salary  >29000)    ,
	PRIMARY KEY(ID)                        ,
    FOREIGN KEY(dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);


INSERT   INTO instructor(ID, name,dept_name, salary)
VALUES 
	('10101', 'Srinivasan'   , 'Comp. Sci.'      , 65e3),
    ('12121', 'Wu'           , 'Finance'         , 90e3),
	('15151', 'Mozart'       , 'Music'           , 40e3),
    ('22222', 'Einstein'     , 'Physics'         , 95e3),
	('32343', 'El Said'      , 'History'         , 60e3),
	('33456', 'Gold'         , 'Physics'         , 87e3),
    ('45565', 'Katz'         , 'Comp. Sci.'      , 75e3),
	('58583', 'Califeri'     , 'History'         , 62e3),
	('76543', 'Singh'        , 'Finance'         , 80e3),
	('76766', 'Crick'        , 'Biology'         , 72e3),
	('83821', 'Brandt'       , 'Comp. Sci.'      , 92e3),
    ('98345', 'Kim'          , 'Elec. Eng.'      , 80e3);

CREATE TABLE section(
	course_id          VARCHAR(8)  ,
    sec_id             VARCHAR(8)  ,
    semester           VARCHAR(8) check(semester in ('Fall','Winter','Spring','Summer')) ,
    year               FIXED(4)    check(year >1700 and year <2100),
    building           VARCHAR(15) ,
    room_number        VARCHAR(7)  ,
    time_slot_id       VARCHAR(4)  ,
	PRIMARY KEY(course_id,sec_id, semester,year),
    FOREIGN KEY(course_id) REFERENCES course(course_id) on delete cascade, 
    FOREIGN KEY(building, room_number) REFERENCES classroom(building, room_number) on delete set null
);

INSERT   INTO section(course_id, sec_id ,semester , year, building,room_number, time_slot_id) 
VALUES 
		('BIO-101', '1', 'Summer',2009, 'Painter' ,514  ,'B'),
		('BIO-301', '1', 'Summer',2010, 'Painter' ,514  ,'A'),
        ('CS-101' , '1', 'Fall'  ,2009, 'Packard' ,101  ,'H'),
        ('CS-101' , '1', 'Spring',2010, 'Packard' ,101  ,'F'),
        ('CS-190' , '1', 'Spring',2009, 'Taylor'  ,3128 ,'E'),
        ('CS-190' , '2', 'Spring',2009, 'Taylor'  ,3128 ,'A'),
        ('CS-315' , '1', 'Spring',2010, 'Watson'  ,120  ,'D'),
        ('CS-319' , '1', 'Spring',2010, 'Watson'  ,100  ,'B'),
		('CS-319' , '2', 'Spring',2010, 'Taylor'  ,3128 ,'C'),
        ('CS-347' , '1', 'Fall'  ,2009, 'Taylor'  ,3128 ,'A'),
        ('EE-181' , '1', 'Spring',2009, 'Taylor'  ,3128 ,'C'),
		('FIN-201', '1', 'Spring',2010, 'Packard' ,101  ,'B'),
		('HIS-351', '1', 'Spring',2010, 'Painter' ,514  ,'C'),
		('MUS-199', '1', 'Spring',2010, 'Packard' ,101  ,'D'),
		('PHY-101', '1', 'Fall'  ,2009, 'Watson'  ,100  ,'A');

CREATE TABLE teaches(
	ID                 VARCHAR(5),
    course_id          VARCHAR(8),
    sec_id             VARCHAR(8),
    semester           VARCHAR(6),
    year               FIXED(4)  ,
	PRIMARY KEY(ID,course_id,sec_id,semester,year),
    FOREIGN KEY(course_id,sec_id,semester,year) REFERENCES section(course_id,sec_id,semester,year) on delete cascade,
    FOREIGN KEY(ID)        REFERENCES instructor(ID) on delete cascade
);

INSERT   INTO teaches(ID,course_id, sec_id ,semester , year) 
VALUES 
		('10101','CS-101'   ,'1'  ,'Fall'  , 2009),
		('10101','CS-315'   ,'1'  ,'Spring', 2010),
        ('10101','CS-347'   ,'1'  ,'Fall'  , 2009),
        ('12121','FIN-201'  ,'1'  ,'Spring', 2010),
        ('15151','MUS-199'  ,'1'  ,'Spring', 2010),
        ('22222','PHY-101'  ,'1'  ,'Fall'  , 2009),
        ('32343','HIS-351'  ,'1'  ,'Spring', 2010),
        ('45565','CS-101'   ,'1'  ,'Spring', 2010),
        ('45565','CS-319'   ,'1'  ,'Spring', 2010),
        ('76766','BIO-101'  ,'1'  ,'Summer', 2009),
        ('83821','CS-190'   ,'1'  ,'Spring', 2009),
        ('83821','CS-190'   ,'2'  ,'Spring', 2009),
        ('83821','CS-319'   ,'2'  ,'Spring', 2010),
        ('98345','EE-181'   ,'1'  ,'Spring', 2009)
        ;

CREATE TABLE student(
	ID                 VARCHAR(5),
    name               VARCHAR(20) not null,
    dept_name          VARCHAR(20),
    tot_cred           numeric(3,0) check(tot_cred>=0),
    PRIMARY KEY(ID) ,
    FOREIGN KEY(dept_name) references department(dept_name) on delete set null
);

-- drop table student;
INSERT   INTO student(ID,name, dept_name,tot_cred) 
VALUES 
		('00128','Zhang'    ,'Comp. Sci.'  , 102),
		('12345','Shankar'  ,'Comp. Sci.'  , 32 ),
		('19991','Brandt'   ,'History'     , 80 ),
		('23121','Chavez'   ,'Finance'     , 110),
        ('44553','Peltier'  ,'Physics'     , 56 ),
        ('45678','Levy'     ,'Physics'     , 46 ),
        ('54321','William'  ,'Comp. Sci.'  , 54 ),
        ('55739','Sanchez'  ,'Music'       , 38),
        ('70557','Snow'     ,'Physics'     , 0 ),
        ('76543','Brown'    ,'Comp. Sci.'  , 58 ),
        ('76653','Aoi'      ,'Elec. Eng.'  , 60 ),
        ('98765','Bourikas' ,'Elec. Eng.'  , 98),
        ('98988','Tanaka'   ,'Biology'     , 120);

CREATE TABLE takes(
	ID                 VARCHAR(5),
    course_id          VARCHAR(8),
    sec_id             VARCHAR(8),
    semester_id        VARCHAR(8)  ,
    year               FIXED(4)    ,
	grade              VARCHAR(2)  ,
    PRIMARY KEY(ID,course_id,sec_id,semester_id,year),
    FOREIGN KEY(course_id,sec_id,semester_id,year) references section(course_id,sec_id,semester,year) on delete cascade,
    FOREIGN KEY(ID)        references student(ID) on delete cascade
);

INSERT   INTO takes(ID,course_id, sec_id ,semester_id        , year,grade) 
VALUES 
		('00128','CS-101'   ,1  ,'Fall'   , 2009,'A' ),
        ('00128','CS-347'   ,1  ,'Fall'   , 2009,'A-'),
        ('12345','CS-101'   ,1  ,'Fall'   , 2009,'C' ),
        ('12345','CS-190'   ,2  ,'Spring' , 2009,'A' ),
        ('12345','CS-315'   ,1  ,'Spring' , 2010,'A' ),
        ('12345','CS-347'   ,1  ,'Fall'   , 2009,'A' ),
        ('19991','HIS-351'  ,1  ,'Spring' , 2010,'B' ),
        ('23121','FIN-201'  ,1  ,'Spring' , 2010,'C+'),
        ('44553','PHY-101'  ,1  ,'Fall'   , 2009,'B-'),
		('45678','CS-101'   ,1  ,'Fall'   , 2009,'F' ),
		('45678','CS-101'   ,1  ,'Spring' , 2010,'B+'),
		('45678','CS-319'   ,1  ,'Spring' , 2010,'B' ),
        ('54321','CS-101'   ,1  ,'Fall'   , 2009,'A-'),
        ('54321','CS-319'   ,2  ,'Spring' , 2010,'B+'),
        ('55739','MUS-199'  ,1  ,'Spring' , 2010,'A-'),
        ('76543','CS-101'   ,1  ,'Fall'   , 2009,'A' ),
        ('76543','CS-319'   ,2  ,'Spring' , 2010,'A' ),
        ('76653','EE-181'   ,1  ,'Spring' , 2009,'C' ),
        ('98765','CS-101'   ,1  ,'Fall'   , 2009,'C-'),
        ('98765','CS-315'   ,1  ,'Spring' , 2010,'B-'),
        ('98988','BIO-101'  ,1  ,'Summer' , 2009,'A' ),
        ('98988','BIO-301'  ,1  ,'Summer' , 2010,NULL)
        ;

CREATE TABLE advisor(
	s_id               VARCHAR(5),
    i_id               VARCHAR(5),
    PRIMARY KEY(s_id),
    FOREIGN KEY(i_id) references instructor(ID) on delete set null,
    FOREIGN KEY(s_id) references student(ID) on delete cascade);
    
    
INSERT   INTO advisor(s_id               ,i_id) 
VALUES 
	('00128','45565'),
    ('12345','10101'),
    ('23121','76543'),
    ('44553','22222'),
    ('45678','22222'),
    ('76543','45565'),    
    ('76653','98345'),    
    ('98765','98345'),    
    ('98988','76766');
    
CREATE TABLE prereq(
	course_id          VARCHAR(8),
    prereq_id          VARCHAR(8),
    PRIMARY KEY(course_id,prereq_id          ),
    FOREIGN KEY(course_id) references course(course_id) on delete cascade,
    FOREIGN KEY(prereq_id) references course(course_id));
    
INSERT   INTO prereq(course_id                         ,prereq_id          )
VALUES 
	('BIO-301','BIO-101'),
	('BIO-399','BIO-101'),
	('CS-190','CS-101'),
	('CS-315','CS-101'),
	('CS-319','CS-101'),
	('CS-347','CS-101'),
	('EE-181','PHY-101');
    
 
    
CREATE TABLE timeslot(
	time_slot_id       VARCHAR(4),
    day                VARCHAR(1) check (day in ('M','T','W','R','F','S','U')),
    start_time         time, 
    end_time           time, 
    PRIMARY KEY(time_slot_id       ,day,start_time         )
    );

INSERT INTO timeslot(	time_slot_id,    day                ,    start_time         ,     end_time           )
VALUES
	('A','M','8:00','8:50'),
    ('A','W','8:00','8:50'),
    ('A','F','8:00','8:50'),
    ('B','M','9:00','9:50'),
    ('B','W','9:00','9:50'),
    ('B','F','9:00','9:50'),
    ('C','M','11:00','11:50'),
    ('C','W','11:00','11:50'),
    ('C','F','11:00','1:50'),
    ('D','M','13:00','13:50'),
    ('D','W','13:00','13:50'),
    ('D','F','13:00','13:50'),
	('E','T','10:30','11:45'),
    ('E','R','10:30','11:45'),
    ('F','T','14:30','15:45'),
    ('F','R','14:30','15:45'),
    ('G','M','16:00','16:50'),
    ('G','W','16:00','16:50'),
    ('G','F','16:00','16:50'),
    ('H','W','10:00','12:30');

show tables;
alter table instructor rename column name to ins_name;
alter table student rename column name to stu_name;
#List all the 3-credit courses that belong to the Comp. Sci. department.
select * from course;
select * from course where credits=3 and dept_name like 'Comp%' ;  

#List all the students who have been instructed by Einstein; make sure there are no duplicates.
# option 1
select * from instructor;
select * from student;
select distinct stu_name, ins_name
from student stu right join instructor ins 
on stu.dept_name = ins.dept_name
where ins_name like 'Einstein';

# option 2
alter table instructor rename column id1 to ID;
select distinct ID,stu_name
from student stu 
right join advisor adv
on stu.ID = adv.s_id
where i_id like (select ID from instructor where ins_name like 'Einstein') ;

#List the names of all the instructors with the highest salary, along with the instructors’ department name and department building.
#option1
select ins_name,max(salary)as highest_salary,dept_name,building 
from instructor 
right join department 
using (dept_name) 
group by ins_name,dept_name,building ; 
#option2
select ins_name, salary, building,instructor.dept_name 
from instructor 
left join department 
on department.dept_name = instructor.dept_name 
where salary like (select max(salary) from instructor);

#List the names of all the instructors along with the titles of the courses that they teach.
select * from instructor;
select * from course;
select ins.ins_name,title
from instructor ins
right join course
on ins.dept_name = course.dept_name;

#List the names of all the instructors whose salary amounts between $90K and $100K.
select ins_name,salary from instructor where salary between 90000 and 100000;

#List all the courses taught in the fall of 2009.
select * from course;
select * from section;
select sec.course_id,title,semester,year
from course
right join section sec
on course.course_id=sec.course_id
where semester like 'fall' and year like '2009';

#List all the courses taught in the spring of 2010.
select * from course;
select * from section;
select sec.course_id,title,semester,year
from course
right join section sec
on course.course_id=sec.course_id
where semester like 'spring' and year like '2010';

#List all the courses taught in the fall of 2009 or the spring of 2010. 
select * from course;
select * from section;
select sec.course_id,title,semester,year
from course
right join section sec
on course.course_id=sec.course_id
where semester like 'spring' and year like '2010' or semester like 'fall' and year like '2009';

-- List all the courses taught in the fall of 2009 and the spring of 2010.
select distinct course_id
from section
where semester like 'fall' and year= 2009 and
 course_id in (select course_id
 from section
 where semester like 'spring' and year = 2010);


-- List all the instructors who have taught a course in 2009, along with their salary and department name.
select * from instructor;
select * from course;
select * from teaches;
select instructor.ins_name, instructor.salary, instructor.dept_name, teaches.year 
from instructor 
right join teaches using(ID)
where teaches.year = 2009;

#Find the average salary of the faculty in the Comp. Sci. department.
select * from department;
select * from instructor;
select avg(salary) 
from instructor 
where dept_name 
like 'Comp. Sci.';

#Find the maximum possible enrollment of each department in the fall of 2009 in terms of classroom capacity for courses from the department.
create temporary table course_schedule as select * from section right join course using(course_id);
select * from course_schedule;
create temporary table K as select semester, dept_name, room_number, capacity 
from course_schedule
left join classroom using(room_number) 
where semester='Fall' and year=2009;
select dept_name, max(capacity) from K group by dept_name;

#Display a list of all the students with their ID, name, department name, total credits, and the course(s) they have taken.
select * from student;
select * from course;
select ID,stu_name, stu.dept_name, tot_cred, course_id, title
from student stu
right join course
on stu.dept_name = course.dept_name;

#Display a list of all the students in the Comp. Sci. department along with the course section(s) in which they were enrolled in the spring of 2009; 
#also make sure every course taught in the spring of 2009 are displayed in the list even if the course was not taken by any of the students.
select * from takes;
select * from student;
select * from course;
select * from teaches;
select stu_name, course_id 
from student 
right join takes 
on student.ID = takes.ID
where dept_name = 'Comp. Sci.' and semester_id = 'Spring' and year = 2009;

				 