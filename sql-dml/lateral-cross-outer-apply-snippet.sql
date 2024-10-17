/*
  LATERAL inline views, CROSS APPLY and OUTER APPLY joins
  https://github.com/jurden21/oracle-snippets
  https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/SELECT.html
*/

drop table employees purge;
drop table departments purge;

create table departments (department_id number, department_name varchar2(100));
insert into departments values (1, 'DEPARTMENT 1');
insert into departments values (2, 'DEPARTMENT 2');
insert into departments values (3, 'DEPARTMENT 3');
insert into departments values (4, 'DEPARTMENT 4');
commit;

create table employees (employee_id number, employee_name varchar2(100), salary number, department_id number);
insert into employees values ( 1, 'EMPLOYEE 01', 9000, 2);
insert into employees values ( 2, 'EMPLOYEE 02', 6000, 3);
insert into employees values ( 3, 'EMPLOYEE 03', 6000, 3);
insert into employees values ( 4, 'EMPLOYEE 04', 8000, 2);
insert into employees values ( 5, 'EMPLOYEE 05', 6000, 3);
insert into employees values ( 6, 'EMPLOYEE 06', 8000, 3);
insert into employees values ( 7, 'EMPLOYEE 07', 8000, 1);
insert into employees values ( 8, 'EMPLOYEE 08', 5000, 2);
insert into employees values ( 9, 'EMPLOYEE 09', 5000, 1);
insert into employees values (10, 'EMPLOYEE 10', 6000, 3);
insert into employees values (11, 'EMPLOYEE 11', 7000, 2);
insert into employees values (12, 'EMPLOYEE 12', 6000, 3);
insert into employees values (13, 'EMPLOYEE 13', 5000, 2);
insert into employees values (14, 'EMPLOYEE 14', 7000, 1);
commit;

-- CROSS JOIN LATERAL
select d.department_name, e.employee_name
from departments d
     cross join lateral (select e.employee_name from employees e where e.department_id = d.department_id) e
order by 1, 2;

select d.department_name, e.employee_name
from departments d
     cross join lateral (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e
order by 1, 2;

-- INNER JOIN LATERAL
select d.department_name, e.employee_name
from departments d
     inner join lateral (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e on e.department_id = d.department_id
order by 1, 2;

-- CROSS APPLY
select d.department_name, e.employee_name
from departments d
     cross apply (select e.employee_name from employees e where e.department_id = d.department_id) e
order by 1, 2;

select d.department_name, e.employee_name
from departments d
     cross apply (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e
order by 1, 2;

-- OUTER APPLY
select d.department_name, e.employee_name
from departments d
     outer apply (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e
order by 1, 2;

select d.department_name, e.employee_name
from departments d
     outer apply (select e.employee_name from employees e where e.salary >= 9000 and e.department_id = d.department_id) e
order by 1, 2;
