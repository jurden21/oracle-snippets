/*
  Merge Snippet
  https://github.com/jurden21/oracle-snippets
  https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/MERGE.html
*/

drop table trg_table purge;
drop table src_table purge;
create table trg_table (id number, trg_name varchar2(100), src_name varchar2(100));
insert into trg_table (id, trg_name) values (1, 'trg_name1');
insert into trg_table (id, trg_name) values (2, 'trg_name2');
insert into trg_table (id, trg_name) values (3, 'trg_name3');
insert into trg_table (id, trg_name) values (4, 'trg_name4');
insert into trg_table (id, trg_name) values (5, 'trg_name5');
commit;
select * from trg_table;
create table src_table (id number, src_name varchar2(100));
insert into src_table (id, src_name) values (1, 'src_name1');
insert into src_table (id, src_name) values (3, 'src_name3');
insert into src_table (id, src_name) values (5, 'src_name5');
insert into src_table (id, src_name) values (7, 'src_name7');
insert into src_table (id, src_name) values (9, 'src_name9');
commit;
select * from src_table;

-- MERGE
merge into trg_table t
using (select id, src_name from src_table) s
on (t.id = s.id)
when matched then
  update set t.src_name = s.src_name
  delete where t.id in (3, 4) -- 4 - not matched
when not matched then
  insert (id, src_name)
  values (s.id, s.src_name);
commit;    
select * from trg_table;
