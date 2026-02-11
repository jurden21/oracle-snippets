/*
  INSERT ALL/FIRST snippet
  https://github.com/jurden21/oracle-snippets
  https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/INSERT.html
*/

-- drop table src_table1 purge;
-- drop table src_table2 purge;
-- drop table trg_table1 purge;
-- drop table trg_table2 purge;
-- drop table trg_table3 purge;
-- drop table trg_table4 purge;

create table trg_table1 (id number, text varchar2(100));
create table trg_table2 (id number, text varchar2(100));
create table trg_table3 (id number, text varchar2(100));
create table trg_table4 (id number, column_id number, text varchar2(100));
create table src_table1 as select level as id, 'text' || level as text from dual connect by level <= 10;
create table src_table2 as select level as id, 'text1-' || level as text1, 'text2-' || level as text2, 'text3-' || level as text3 from dual connect by level <= 10;

-- Unconditional INSERT ALL

truncate table trg_table1;
truncate table trg_table2;
truncate table trg_table3;

insert all
    into trg_table1 (id, text) values (id, text)
    into trg_table2 (id, text) values (id, text)
    into trg_table3 (id, text) values (id, text)
select id, text 
from src_table1;    

select * from src_table1;
select * from trg_table1;
select * from trg_table2;
select * from trg_table3;

-- Unconditional INSERT ALL pivot/split each record

truncate table trg_table1;
truncate table trg_table2;
truncate table trg_table3;

insert all
    into trg_table4 (id, column_id, text) values (id, 1, text1)
    into trg_table4 (id, column_id, text) values (id, 2, text2)
    into trg_table4 (id, column_id, text) values (id, 3, text3)
select id, text1, text2, text3
from src_table2;

select * from src_table2;
select * from trg_table4;

-- Conditional INSERT ALL

truncate table trg_table1;
truncate table trg_table2;
truncate table trg_table3;

insert all
    when id between 1 and 3 then
        into trg_table1 (id, text) values (id, text || ' with id between 1 and 3')
    when id between 4 and 6 then  
        into trg_table2 (id, text) values (id, text || ' with id between 4 and 6')
    when id between 7 and 9 then
        into trg_table2 (id, text) values (id, text || ' with id between 7 and 9')
        into trg_table3 (id, text) values (id, text || ' with id between 7 and 9')
    when 1 = 1 then
        into trg_table3 (id, text) values (id, text || ' with 1 = 1')
select id, text 
from src_table1;    

select * from src_table1;
select * from trg_table1;
select * from trg_table2;
select * from trg_table3;

-- INSERT FIRST

truncate table trg_table1;
truncate table trg_table2;
truncate table trg_table3;

insert first
    when id <= 3 then
        into trg_table1 (id, text) values (id, text || ' with id <= 3')
    when id <= 6 then  
        into trg_table2 (id, text) values (id, text || ' with id <= 6')
    when id <= 9 then
        into trg_table2 (id, text) values (id, text || ' with id <= 9')
        into trg_table3 (id, text) values (id, text || ' with id <= 9')
    else
        into trg_table3 (id, text) values (id, text || ' with else')
select id, text 
from src_table1;    

select * from src_table1;
select * from trg_table1;
select * from trg_table2;
select * from trg_table3;
