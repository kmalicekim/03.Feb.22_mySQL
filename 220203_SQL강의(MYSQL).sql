-- 20220203 SQL 강의(MYSQL)

mysql -u root -p
show databases;
use mysql;
show tables;


-- 데이터베이스 생성 
create database multi;
use multi;
show tables;


-- Table 생성 
-- AUTO_INCLEMENT 숫자 자동
DROP TABLE IF EXISTS students;
create table students(
 id int,
 name varchar(100),
 phone char(13),
 address varchar(1000)
);

desc students;


insert into students 
values(1, 'hong-gd', '010-1111-1111', 'seoul');


Select *
From students;

Alter table students 
Add job varchar(100);

Desc students;

Insert into students(id, name, address, job)
Values(2, 'Kim-sd', 'suwon', 'engineer');

Select id, name, phone, address, job
From students;

Alter table students
Modify job varchar(1000);

Desc students;



Drop table students;
-- Desc students;

drop database multi;

show databases;

exit;


-- mySQL 에서 EMPLOYEE DB 다운 후 실행
cd test_db-master
-- ls로 확인

mysql -u root -p
source employees.sql

show databases;
USE employees;
show tables;

DESC employees;

-- 데이터가 너무 크면 count(*)로 사용할 것
SELECT * FROM employees;

SELECT COUNT(*) FROM employees;

SELECT emp_no, first_name, last_name FROM employees LIMIT 10;

SELECT * FROM employees LIMIT 1000;


-- 조건 걸기 (실행 순서 1,2,3)
SELECT *   -- 출력해라 (3)
FROM employees   -- (1)
WHERE hire_date >= '2000-01-01';  -- (2)

SELECT COUNT(*) FROM salaries;
SELECT * FROM salaries LIMIT 100;

-- salary가 150000 이상인 사람만 뽑아 보기
SELECT *
FROM salaries
WHERE salary >= 150000;

-- 실습 | 월급이 100000 보다 크고 150000 보다 작거나 같은 모든 데이터 출력
SELECT *
FROM salaries
WHERE salary > 100000 and salary <= 150000;


-- 실습 | 1960년대에 태어난 사원의 이름(first_name)과 생일 출력
SELECT first_name, birth_date
FROM employees
WHERE birth_date >= '1960-01-01' and birth_date <= '1969-12-31' 
ORDER BY birth_date DESC;


-- 정렬 (오름차순)
SELECT *
FROM salaries
ORDER BY salary 
LIMIT 1000;

SELECT *
FROM salaries
ORDER BY salary ASC
LIMIT 100;

-- (내림차순)
SELECT *
FROM salaries
ORDER BY salary DESC
LIMIT 100;


-- 늦게 취업한 사람 순서대로, 나이 순으로 출력
SELECT *
FROM employees
ORDER BY hire_date DESC, birth_date 
LIMIT 100;

-- 나이 순서대로, 늦게 취업한 사람 순서대로 출력
SELECT *
FROM employees
ORDER BY birth_date, hire_date DESC
LIMIT 100;


SELECT title
FROM titles
LIMIT 100;

-- GROUB BY 
SELECT title
FROM titles
GROUP BY title;

-- count 사용하여 group 의 개수 확인
SELECT title, COUNT(*)
FROM titles
GROUP BY title;

-- ERROR (GROUP BY 하지 않은 데이터는 출력 불가)
SELECT title, emp_no
FROM titles
GROUP BY title;

-- 집계함수에 조건 사용시, where 대신 having 사용
SELECT COUNT(*)
FROM employees
WHERE gender = 'M';

SELECT dept_no, COUNT(dept_no)
FROM dept_emp
GROUP BY dept_no;

-- 실습 | 부서별 사원수가 50000 명 이상인 부서만 출력
SELECT dept_no, COUNT(dept_no)
FROM dept_emp
GROUP BY dept_no
HAVING COUNT(dept_no) >= 50000;    -- (WHERE 쓰면 안됨)



-- DB : 여러 사용자들이 정보에 접근할 수 있게 만들어놓은 데이터들의 집합체
-- RDBMS 
-- SQL (DDL, DML, DCL) 

-- DDL 
--     CREATE, ALTER, DROP
-- DML
--     SELECT -> WHERE, ORDER BY, GROUP BY (집계함수에 사용시 HAVING)
--     INSERT, UPDATE, DELETE
-- DCL
--     COMMIT, ROLLBACK, GRANT, REVOKE


-- DDL 
CREATE DATABASE multi; 
USE multi;

CREATE TABLE students(
    id int,
    names varchar(100),
    phone char(13)
    address varchar(1000),
    job varchar(100)
);

INSERT INTO students
VALUES (1, 'hong-gd', '010-1111-1111', 'seoul', 'ai');

INSERT INTO students(id, name, phone)
VALUES (2, 'kim-sd', '02-222-2222');

SELECT * FROM students;

-- DCL
SET autocommit = 0;
COMMIT;

UPDATE students
SET phone = '010-2222-2222', address = "suwon", job = 'engineer'
WHERE id = 2;


DELETE FROM students
WHERE id = 1;

ROLLBACK;  -- 가장 마지막 COMMIT 한 상태로 돌아가라


USE mysql
GRANT all privileges on *.* to 'root'@'localhost' WITH GRANT OPTION;

-- % : 어디서든 접근 가능
CREATE user 'root'@'%' identified BY '자신의 비밀번호';
GRANT all privileges on *.* to 'root'@'%' WITH GRANT OPTION;

flush privileges;
COMMIT;



-- 현재 근무하고있는 직원들의 전체 신상 명세 출력
-- SELECT * FROM employees;
-- SELECT * FROM dept_emp

USE employees;

SELECT * 
FROM employees emp INNER JOIN dept_emp de 
ON emp.emp_no = de.emp_no
LIMIT 100;

SELECT * 
FROM employees emp INNER JOIN dept_emp de 
ON emp.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01'
LIMIT 100;

-- 현재 근무하고있는 직원들의 이름(first_name)과 부서(dept_no) 출력
SELECT first_name, dept_no
FROM employees INNER JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
LIMIT 100;


-- 전체 직원들의 이름과 직업 출력
SELECT first_name, title
FROM employees emp INNER JOIN titles tt 
ON emp.emp_no = tt.emp_no
LIMIT 100;

SELECT first_name, title
FROM employees emp JOIN titles tt
ON emp.emp_no = tt.emp_no
LIMIT 100;

-- using을 사용하면 전체 column에서 emp_no 가 한개만 생성
SELECT *
FROM employees JOIN titles USING(emp_no)
LIMIT 100;

-- NATURAL JOIN : 테이블간의 연결될 수 있는 같은 이름의 column 1개만 있을 경우 사용
SELECT * 
FROM employees emp NATURAL JOIN titles tt
LIMIT 100;


SELECT count(*)
FROM employees JOIN titles USING(emp_no);

-- JOIN의 조건을 주지않을 경우 A와 B의 모든 경우의 수가 다 join 됨 (카테시안 곱)
SELECT count(*)
FROM employees JOIN titles;

SELECT count(*)
FROM employees CROSS JOIN titles;

-- 실습 | 현재 근무하고 있는 (9999-01-01)직원들의 이름과 월급 출력
SELECT first_name, salary
FROM employees emp JOIN salaries sal
ON emp.emp_no = sal.emp_no
WHERE sal.to_date = '9999-01-01'
LIMIT 100;

SELECT first_name, salary
FROM employees INNER JOIN salaries USING(emp_no)
WHERE salaries.to_date = '9999-01-01'
LIMIT 100;

SELECT first_name, salary
FROM employees NATURAL JOIN salaries
WHERE to_date = '9999-01-01'
LIMIT 100;


-- 실습 | 부서 이름과 관리자 이름을 출력
SELECT dept_name, first_name
FROM departments NATURAL JOIN dept_manager NATURAL JOIN employees
LIMIT 100;

SELECT dept_name, first_name
FROM departments JOIN dept_manager ON departments.dept_no = dept_manager.dept_no 
NATURAL JOIN employees 
LIMIT 100;

-- 현재 관리자 
-- (INNER JOIN & ON 사용)
SELECT dept_name, first_name
FROM departments d JOIN dept_manager dm ON d.dept_no = dm.dept_no 
JOIN employees e ON dm.emp_no = e.emp_no
WHERE dm.to_date = '9999-01-01';

-- (USING 사용)
SELECT dept_name, first_name
FROM departments JOIN dept_manager USING(dept_no)
JOIN employees USING(emp_no)
WHERE to_date = '9999-01-01';

-- (NATURAL JOIN 사용)
SELECT dept_name, first_name
FROM departments NATURAL JOIN dept_manager
NATURAL JOIN employees
WHERE to_date = '9999-01-01';

-- ============================================== --

USE multi;
CREATE table join_a(
    aa int,
    ab char(3)
);
CREATE table join_b(
    bb int,
    ab char(3)
);

INSERT INTO join_a
VALUES(1, 'aaa');

INSERT INTO join_a
VALUES(2, 'bbb');

INSERT INTO join_a
VALUES(3, 'ccc');

INSERT INTO join_b
VALUES(4, 'aaa');

INSERT INTO join_b
VALUES(5, 'bbb');

INSERT INTO join_b
VALUES(6, 'ccc');

INSERT INTO join_a
VALUES(7,'ddd');

INSERT INTO join_b
VALUES(8,'eee');

SELECT * 
FROM join_a INNER JOIN join_b USING(ab);

SELECT *
FROM join_a inner join join_b 
ON join_a.ab = join_b.ab;

-- left outer
SELECT * 
FROM join_a LEFT JOIN join_b USING(ab);

-- right outer
SELECT * 
FROM join_a RIGHT JOIN join_b USING(ab);


-- SUB QUERY 
USE employees;

-- last_name이 Haraldson 인 사원의 월급 출력
SELECT salary
FROM salaries
WHERE emp_no in
    (SELECT emp_no
    FROM employees
    WHERE last_name = 'Haraldson');