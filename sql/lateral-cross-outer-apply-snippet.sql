/*
  LATERAL inline views, CROSS APPLY and OUTER APPLY joins
  https://github.com/jurden21/oracle-snippets
  https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/SELECT.html
*/

-- drop table employees purge;
-- drop table departments purge;

create table departments (department_id number, department_name varchar2(100));
insert into departments values (1, 'department 1');
insert into departments values (2, 'department 2');
insert into departments values (3, 'department 3');
insert into departments values (4, 'department 4');

create table employees (employee_id number, employee_name varchar2(100), salary number, department_id number);
insert into employees values ( 1, 'employee 01', 9000, 2);
insert into employees values ( 2, 'employee 02', 6000, 3);
insert into employees values ( 3, 'employee 03', 6000, 3);
insert into employees values ( 4, 'employee 04', 8000, 2);
insert into employees values ( 5, 'employee 05', 6000, 3);
insert into employees values ( 6, 'employee 06', 8000, 3);
insert into employees values ( 7, 'employee 07', 8000, 1);
insert into employees values ( 8, 'employee 08', 5000, 2);
insert into employees values ( 9, 'employee 09', 5000, 1);
insert into employees values (10, 'employee 10', 6000, 3);
insert into employees values (11, 'employee 11', 7000, 2);
insert into employees values (12, 'employee 12', 6000, 3);
insert into employees values (13, 'employee 13', 5000, 2);
insert into employees values (14, 'employee 14', 7000, 1);

-- CROSS JOIN

select d.department_name, e.employee_name
from departments d
     cross join employees e
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name
from departments d
     inner join employees e on true
order by d.department_name, e.employee_name;

-- CROSS JOIN LATERAL = CROSS APPLY

select d.department_name, e.employee_name
from departments d
     cross join lateral (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name
from departments d
     cross apply (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name
from departments d
     inner join employees e on e.department_id = d.department_id and e.salary >= 7000
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name, e.salary
from departments d
     cross join lateral (
         select e.employee_name, e.salary
         from employees e
         where e.department_id = d.department_id
         order by e.salary desc
         fetch first 3 rows only) e
order by d.department_name, e.salary desc;

-- INNER JOIN & INNER JOIN LATERAL

select d.department_name, e.employee_name
from departments d
     inner join employees e on e.department_id = d.department_id and e.salary >= 7000
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name
from departments d
     inner join (select e.employee_name, e.department_id from employees e where e.salary >= 7000) e on d.department_id = e.department_id
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name
from departments d
     inner join lateral (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e on 1 = 1
order by d.department_name, e.employee_name;

-- LEFT JOIN & OUTER APPLY

select d.department_name, e.employee_name
from departments d 
     left join employees e on e.department_id = d.department_id and e.salary >= 7000
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name
from departments d 
     left join (select e.employee_name, e.department_id from employees e where e.salary >= 7000) e on d.department_id = e.department_id
order by d.department_name, e.employee_name;

select d.department_name, e.employee_name
from departments d
     outer apply (select e.employee_name from employees e where e.salary >= 7000 and e.department_id = d.department_id) e
order by d.department_name, e.employee_name;
