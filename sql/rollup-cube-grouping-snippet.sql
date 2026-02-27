/*
  GROUPING SETS, ROLLUP, and CUBE snippet
  https://github.com/jurden21/oracle-snippets
  https://docs.oracle.com/en/database/oracle/oracle-database/26/sqlrf/SELECT.html#GUID-CFA006CA-6FF1-4972-821E-6996142A51C6__I2182483
*/

-- drop table sales purge;

create table sales (region varchar2(50), category varchar2(50), sales_year number, amount number);

insert into sales values ('North', 'Electronics', 2023, 1000);
insert into sales values ('North', 'Electronics', 2024, 1200);
insert into sales values ('North', 'Furniture', 2023, 800);
insert into sales values ('South', 'Electronics', 2023, 1500);
insert into sales values ('South', 'Furniture', 2024, 2000);
insert into sales values ('West', 'Electronics', 2024, 900);

select * from sales;

-- ROLLUP creates subtotal rows at increasing levels of aggregation, from the most detailed to
-- the grand total. The order of columns in ROLLUP matters.
-- Result: (region, category), (region), (grand total)
select
    region,
    category,
    sum(amount) as total_sales
from
    sales
group by
    rollup(region, category)
order by
    region,
    category;

-- CUBE generates subtotals for all possible combinations of the specified columns. It is useful
-- for cross-tabular reports.
-- Result: (region, category), (region), (category), (grand total)
select
    region,
    category,
    sum(amount) as total_sales
from
    sales
group by
    cube(region, category)
order by
    region,
    category;

-- GROUPING SETS allows you to define specific levels of aggregation, without generating all
-- possible combinations. Only the specified sets will be included in the output.
-- Result: (region, category) and (category) only
select
    region,
    category,
    sum(amount) as total_sales
from
    sales
group by
    grouping sets ((region, category), (category))
order by
    region,
    category;

-- The GROUPING function returns 1 if the column value in the row is a subtotal created by an
-- aggregate operator (ROLLUP, CUBE, etc.), and 0 otherwise.
-- This helps distinguish between NULL values in data and NULLs representing subtotals.
select
    region,
    category, 
    grouping(region) as grp_region,
    grouping(category) as grp_category,
    sum(amount) as total_sales
from 
    sales
group by 
    rollup(region, category)
order by 
    region,
    category;
