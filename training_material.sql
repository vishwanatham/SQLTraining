--declare @emp_name_c char(100), @emp_name_v varchar(100)

--set @emp_name_c = 'sai'
--set @emp_name_v = 'sai'

--select @emp_name_c, @emp_name_v


--create table tbl_employee
--    (
--	  id     int
--	, name   varchar(500)
--	, dob    date
--	, age    smallint
--	, salary decimal(15,2)
--	, gender char(1)
--	)

--alter table tbl_employee alter column id int not null

--alter table tbl_employee alter column name varchar(500) not null

alter table tbl_employee drop column age

sp_help 'tbl_employee'

insert into tbl_employee(id, name, dob, salary, gender)
values (1, 'Sai', '1990-01-01', 20000, 'M'), (2, 'vish', '1989-01-01', 15000, 'M')

select * --select clause
 from tbl_employee --from clause
 where id = 1 --where clause

--Authentication
---Windows
---SQL server
--Data Types
---number
----small int
----tiny int
----int
----bigint
----decimal(p,s)
---string
----char
----varchar
---date
----date
----datetime
----time
--Operators
----Like
----Logical
------ or, and, in, between, like
----
--DDL
---Create
---alter
----alter
----drop
--DML
---insert
--DQL
---select
--SET Operations
--Constraints
--Joins
--Functions
----Ranking Functions
----Aggregation functions
----
--Primary Key
--Foreign key




--views
--triggers
--stored procedures
--functions



--SET Operations
--union      -- Combine two sets, and removes duplicates
--union all  -- Combine two sets
--intersect  -- common values
--except     -- present in set a and not in set b


truncate table tbl_employee

select * from tbl_employee


insert into tbl_employee(id, name, dob, salary, gender)
select 1,'aaa', '1/1/1989',20000, 'M' union all
select 2,'bbb', '1/1/1990',20020, 'M' union all
select 3,'ccc', '1/1/1991',20040, 'M' union all
select 4,'ddd', '1/1/1992',20060, 'M' union all
select 5,'eee', '1/1/1993',20080, 'M' union all
select 6,'fff', '1/1/1994',20100, 'M' union all
select 7,'ggg', '1/1/1995',20120, 'M' union all
select 8,'hhh', '1/1/1996',20140, 'M' union all
select 9,'iii', '1/1/1997',20160, 'M' union all
select 10,'jjj', '1/1/1998',20180, 'M' union all
select 11,'kkk', '1/1/1999',20200, 'M' union all
select 12,'lll', '1/1/2000',20220, 'M' union all
select 13,'mmm', '1/1/2001',20240, 'F' union all
select 14,'nnn', '1/1/2002',20260, 'F' union all
select 15,'ooo', '1/1/2003',20280, 'F' union all
select 16,'ppp', '1/1/2004',20300, 'F' union all
select 17,'qqq', '1/1/2005',20320, 'F' union all
select 18,'rrr', '1/1/2006',20340, 'F' union all
select 19,'sss', '1/1/2007',20360, 'F' union all
select 20,'ttt', '1/1/2008',20380, 'F' 

--aggregation --> groups
--Count
--Sum
--Max
--Min
--AVg
--https://docs.microsoft.com/en-us/sql/t-sql/functions/aggregate-functions-transact-sql?view=sql-server-ver15

select gender, COUNT(*)
  from tbl_employee
 group by gender

--Find the max salary with in Male Employees
select MAX(salary)
  from tbl_employee
 where gender = 'M'

--Find the max salary for each gender group in Employees
select 'M'as gender, MAX(salary)
  from tbl_employee
 where gender = 'M'
union
select 'F', MAX(salary)
  from tbl_employee
 where gender = 'F'

 --clean approach
select gender, MAX(salary)
  from tbl_employee 
 group by gender


 
--Apply filters on aggregated values we will use 'having' caluse

--Get the gender group having minimum of 10 employees
select gender, COUNT(*)
  from tbl_employee
 group by gender
 having  COUNT(*) >= 10


--Ranking Functions
--RANK
--DENSE_RANK
--ROW_NUMBER
--https://docs.microsoft.com/en-us/sql/t-sql/functions/ranking-functions-transact-sql?view=sql-server-ver15

--provide the ranking based on salary
--Find the employee who is earning second highest salary
select *, ROW_NUMBER() over(order by salary desc) as 'SalaryRank'
  from tbl_employee

--sub queries
select *
 from (select *, ROW_NUMBER() over(order by salary desc) as 'SalaryRank'
         from tbl_employee)as t
where SalaryRank = 2

--update statement
--you can't directly use group by, having and order by clauses in update
update t
   set salary = 20380.00
  from tbl_employee t
 where id = 19

update t
   set salary = 20380.00
  from tbl_employee t
 where id = 18

select *, RANK() over(order by salary desc) as 'SalaryRank'
  from tbl_employee 

select *, DENSE_RANK() over(order by salary desc) as 'SalaryRank'
  from tbl_employee 

--order of execution for select
--from
--where
--group by
--having
--order by
--select

select count(distinct gender)
  from tbl_employee 


--constraints

--Check Constraint --> It validates the data is meeting the conditions that were specified in the constraint definition
--Unique Constraint --> it enforces uniqueness on the columns on which we are creating the constraint --> By default non clustered index will be created

alter table tbl_employee add constraint CK_tbl_employee_gender check(gender in ('M', 'F'))


insert into tbl_employee(id, name, dob, salary, gender)
select 21,'uuu', '1/1/2002',20400, 'K'

insert into tbl_employee(id, name, dob, salary, gender)
select 21,'uuu', '1/1/2002',20400, 'M'


alter table tbl_employee drop constraint UC_tbl_employee_name

alter table tbl_employee add constraint UC_tbl_employee_name unique(name, gender)

insert into tbl_employee(id, name, dob, salary, gender)
select 22,'vvv', '1/1/2002',20400, 'F'

insert into tbl_employee(id, name, dob, salary, gender)
select 22,'vvv', '1/1/2002',20400, 'M'

sp_help 'tbl_employee'

select * from tbl_employee


--Primary Key - Doesn't allow NULL Values --> clustered index will be created

--no clustered index --> Heap
--Clustered Index    --> b+tree --> Root, Intermediate, Leaf --> data will be stored in leaf nodes --> pk column info will be available in non-leaf nodes

--data will be stored in pages

--Thumb rule, it's better to choose number (int, bigint) columns as primary keys

--you can create primary keys on more than one column -- composite primary key

--Delete
--you can't directly use group by, having and order by clauses in delete
delete from tbl_employee where id =22

alter table tbl_employee add constraint PK_tbl_employee_id primary key(id)


--Relationships are enforced using foreign keys
--Foreign Key Constraint
create table dbo.tbl_department
     (
	   dep_id int not null
	 , name   varchar(50) not null
	 )

insert into dbo.tbl_department(dep_id, name)
select 1, 'Accounts' union all
select 2, 'Technology'  union all
select 3, 'HR'  union all
select 5, 'Management'


alter table tbl_employee add depid int null

--alter table tbl_employee drop column depid

--alter table tbl_employee drop constraint DF__tbl_emplo__depid__48CFD27E 

 update tbl_employee set depid = 1 where id = 1
 update tbl_employee set depid = 1 where id = 2
 update tbl_employee set depid = 2 where id = 3
 update tbl_employee set depid = 2 where id = 4
 update tbl_employee set depid = 2 where id = 5
 update tbl_employee set depid = 2 where id = 6
 update tbl_employee set depid = 2 where id = 7
 update tbl_employee set depid = 2 where id = 8
 update tbl_employee set depid = 2 where id = 9
 update tbl_employee set depid = 2 where id = 10
 update tbl_employee set depid = 2 where id = 11
 update tbl_employee set depid = 2 where id = 12
 update tbl_employee set depid = 2 where id = 13
 update tbl_employee set depid = 2 where id = 14
 update tbl_employee set depid = 2 where id = 15
 update tbl_employee set depid = 2 where id = 16
 update tbl_employee set depid = 3 where id = 17
 update tbl_employee set depid = 3 where id = 18
 update tbl_employee set depid = 3 where id = 19
 update tbl_employee set depid = 4 where id = 20
 update tbl_employee set depid = 4 where id = 21

select * from tbl_employee
select * from tbl_department

delete from tbl_department where dep_id = 4


 update tbl_employee set depid = null where id = 20
 update tbl_employee set depid = null where id = 21


 update tbl_employee set depid = 4 where id = 20
 update tbl_employee set depid = 4 where id = 21


alter table tbl_department add constraint PK_tbl_department primary key(dep_id)

sp_help 'tbl_department'

ALTER TABLE tbl_employee
   drop CONSTRAINT FK_tbl_employee_tbl_department

ALTER TABLE tbl_employee
   ADD CONSTRAINT FK_tbl_employee_tbl_department FOREIGN KEY (depid)
      REFERENCES tbl_department (dep_id)
	  ON DELETE CASCADE
	  ON UPDATE CASCADE

sp_help 'tbl_employee'


--when I delete data from parent table the data in child table should get deleted

update tbl_department set dep_id = 4 where dep_id = 5


--join
--Logical Joins
	--inner join
	--left outer join -- will always return all the data from the left table, and if the data isn't there in right table it will give null values
	--right outer join
	--full outer join
	--cross join
--Physical Joins


select e.id, e.name, d.name
  from tbl_employee e
  join tbl_department d
     on e.depid = d.dep_id

--Find records for which the department info is missing in department table
select *
  from tbl_employee e
  left join tbl_department d
     on e.depid = d.dep_id
  where d.dep_id is null


select *
  from tbl_employee e
  full outer join tbl_department d
     on e.depid = d.dep_id


select e.id, e.name, d.name
  from tbl_employee e
  cross join tbl_department d 
  order by 1

--select *
--  from tbl_employee e
--  join tbl_department d
--     on e.depid <> d.dep_id
--order by e.id

--select *
--  from tbl_employee e
--  left join tbl_department d
--     on e.depid <> d.dep_id
--order by e.id


--Regular expression
--wildcard characters
--% any character, any number of times
-- _ any aingle character
--Like
update tbl_employee set name = 'sai_matcha' where  id = 1
update tbl_employee set name = 'saibaba' where  id = 2

select *
  from tbl_employee
 where name like '%a%' --anywhere in the string

select *
  from tbl_employee
 where name like 'a%' --starting with a

select *
  from tbl_employee
 where name like '%a' --Ending with a

select *
  from tbl_employee
 where name like '%ai' --Ending with ai

 select *
  from tbl_employee
 where name like 's%i' --starts with s and ends with i

 select *
  from tbl_employee
 where name like 's_i' --starts with s and ends with i and has only one letter in between

 select *
  from tbl_employee
 where name like 'sai[_]%' --escaepe wildcard characters
