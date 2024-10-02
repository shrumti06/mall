select * from customer;
select * from product;
select * from sales;
--- IN CONDITION---replace of or to get multiple value--
--in or condition we do --select * from customer where city='abc' or city ='saf';
--but in 'IN' conditon 
select * from customer where city in('Philadelphia','Seattle');
--between--like age is between 20 nd 30
--alternate of where age >=20 and age<=30;
select * from customer where age between 20 and 30;
select * from customer where age not  between 20 and 30;
select * from sales where ship_date between '2015-04-01' and '2016-04-01';
--like condition is use for pattern matching using wildcard means eg. starting with a letter--
--A% MEANS START WITH A FIR KUCH BHI AA SKTA HAI EG ABCD
--%A MEANS A K PHLLE KUCH BHI OR KITNE BHI AA SKTE H EG CDSA
--A%B MEANS START WITH A AND END WITH B
--AB_C MEANS STARING START WITH AB THEN THERE IS ONE MORE CHAR THEN C--
select * from customer where customer_name like 'K%';
select * from customer where customer_name like '%Miller%';
--to find --name where firstname consist 4 char and after that any no of char--
select * from customer where customer_name like '____ %';
--jinka naam s se start nhi hota--
select * from customer where customer_name not like 'S%';
--\ MEANING if we want to % symbole 
select * from customer where customer_name like 'G\%';
--select customer_name , age from customer where age between 20 and 30 and customer_name  like '_____ %';
-- order by use for sort--asc ,desc
--if not provide asc dsc auotmatically give aesc
select * from customer where age >20 order by age;
select * from customer where age >20 order by age desc;
--phle city asc me arrange hongi then customer_name desc se--
select * from customer order by city asc ,customer_name desc;
--we can also use column no --
select * from customer where age >20 order by 2 desc;
---limit--limit the number of rows 
select customer_name from customer order by customer_name limit 5;
--oldest customer--
select customer_name , age from customer order  by age desc limit 8;
select * from sales where discount>0 order by discount desc limit 10;
--AS use to assign alias to column --2nd name to column or table--serial no me space hai islie "" use kiya--
select customer_id as "Serial Number" , customer_name as name, age as customer_age from customer;

--aggregate function---count
SELECt * from sales;
select count(*) from sales;
select count(order_line) as "number of product orderd" , count(distinct order_id) as "no of orders"
from sales where customer_id='CG-12520';

--sum
select sum(profit) as "total profit" from sales;
select sum(quantity) as "total quantity" from sales where product_id='FUR-TA-10000577';
--avg
select avg(age) as "avg age " from customer; 
--avg commission
select avg(sales*0.10) as "avg commission" from sales;
--min nd max
select max(age) from customer;
select min(sales) as "min sales 2015june" from sales where order_date between '2015-06-01' and '2015-06-30';
select max(sales) as "max sales 2015june" from sales where order_date between '2015-06-01' and '2015-06-30';
-- group by clause--select statment to group the results by one or more column--
select region , count(customer_id) as customer_count from  customer group by region;
select product_id , sum(quantity) as quantity_sold from sales group by product_id order by quantity_sold desc; 
-------------------------------------------------------------------------
select product_id ,max(sales) as max_sales,
min(sales) as min_sales,
avg(sales) as avg_sales,
sum(sales) as total_sales,
count(sales) as NO_of_sales
from sales 
group by product_id
order by total_sales
limit 10;
-------------having----for agrigate funtion
select region,count(customer_id) as customer_count from customer
group by region
having count(customer_id)>200;
-------------------------------------------------------
--case---similar to if else 
select customer_name,age,
case when age<30 then 'YOUNG'
when age>60 then 'OLD'
else 'MIDDLE AGE'
end as age_catagory
from customer;

-----------------------------------------
--JOIN TABLE USING SAME COLUMN--
--table for year 2015--
create table sales__2015 as select * from sales where ship_date between '2015-01-01' and '2015-12-31';
select count(*) from sales__2015;
select * from sales__2015;
select count(distinct customer_id) from sales__2015;
---customer age between 20 and 60---
create table customer_20_60 as select * from customer where age between 20 and 60;
select count (*) from customer_20_60;
-----------------------------------------------------------------------------
---------gives intersaction of the table-------------------------------------
select
   a.order_line,
   a.product_id,
   a.customer_id,
   a.sales,
   b.customer_name,
   b.age
   from sales__2015 as a 
   inner join customer_20_60 as b
   on a.customer_id=b.customer_id
   order by customer_id;
-----------------------------------------------------------------------------
select
     a.order_line,
	 a.product_id,
	 a.customer_id,
	 a.sales,
	 b.customer_name,
	 b.age
	 from sales__2015 as a
	 left join customer_20_60 as b
	 on 
	 a.customer_id=b.customer_id
	 order by customer_id;
--------------------------------------------------------------------------------------------
select
     a.order_line,
	 a.product_id,
	 b.customer_id,
	 a.sales,
	 b.customer_name,
	 b.age
	 from sales__2015 as a
	 right join customer_20_60 as b
	 on 
	 a.customer_id=b.customer_id
	 order by customer_id;
-------------------------------------------------------------------------------------------
select
     a.order_line,
	 a.product_id,
	 a.customer_id,
	 a.sales,
	 b.customer_name,
	 b.customer_id,
	 b.age
	 from sales__2015 as a
	 full join customer_20_60 as b
	 on 
	 a.customer_id=b.customer_id
	 order by a.customer_id,b.customer_id;
-----------------------------------------------------------------------------------------------
	 --------cross join --------------------A X B
	 create table month_values (mm integer);
	 create table year_values (yyy integer);
	 insert into month_values values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)
,(12);
insert into year_values values (2011),(2012),(2013),(2014),(2015),(2016);

select a.yyy , b.mm
from year_values as a ,month_values as b
order by a.yyy,b.mm;
-----------------------------------------------------------------------------------------
-----combining query/result----------------------
--intersect-- gives result which are present in both the output--
--except--- remove common customer in give 1st table 
---union ---combine all result
-------------------------------------------------------------------------------------------
select customer_id from sales__2015
intersect 
select customer_id from customer_20_60
----------------------------------------------------------------------------------------
select customer_id from sales__2015
except
select customer_id from customer_20_60
order by customer_id;
------------------------------------------------------------------
select customer_id from sales__2015
union
select customer_id from customer_20_60
order by customer_id;
-------------------------------------------------------------------------------------------------------
select * from sales where customer_id in
(select customer_id from customer where age =22) order by customer_id limit 5;
---------------------------------------------------------------------------------------------------------
/* we want to find quantity sold for each product
1.product table har product id 
2.sales tabel has details of quantity sold
3.join them in a single quesry using subquery */
select
a.product_id,
a.product_name,
a.category,
b.quantity
from product as a 
left join(select product_id,
		  sum(quantity) as quantity  from sales group by product_id) as b
on a.product_id=b.product_id
order by b.quantity desc;

------------------------------------------------------------------------------------------------------

select customer_id ,order_line,
(select customer_name from customer where customer.customer_id=sales.customer_id)
from sales
order by customer_id;
------------------------------------------------------------------------------------------------------------
-----view-----
create view logistic as select 
a.order_line,
a.order_id,
b.customer_name,
b.state,
b.country
from sales as a
left join customer as b
on a.customer_id=b.customer_id
order by order_line;
---------------------------------------------------------------------
select * from logistic;
------------------------------------------------------------------------------------------
--if view already exist in database we can use create or replace view ---------
drop view logistic;
-------------------------------------------------------------------------------------------
---index in database is like index in book easy to find the records------------------
---simple index=single column
---composite index=more then 1 index --
create index mon_idx
on month_values(MM);
---------------------------------------------------------------------------------------------
-------drop index----
drop index mon_idx;
-----------------------------------------------------------------------------------------------------
-----------------------string function -------------------------------------------
---length function returns the lenght of the specified string,expressed as the no of characters
select customer_name,length(customer_name) as characters from customer where length(customer_name)>10 ;
---------upper and lower 
select upper('kirtan');
select lower('kirtan');
-------------------------------------------------------------------------------------------------
---replace suntion replace all occurence  of specific string----case senitive
select customer_name,country,replace(country,'United States','US')as country_name from customer;
--------------------------------------------------------------------------------------------------
----trim ,ltrim,rtrim----------------------------------------------------
--trim--remove all specified char either from the begning or from end 
--ltrim--remove from left side
--rtrime--remove from right side 

select trim(leading '@' from '@kirtangunjan@');
select trim(trailing '@' from '@kirtangunjan@');
select trim(both '@' from '@kirtangunjan@');
select rtrim('@kirtan@','@');
select ltrim('@kirtan@','@');
---------------------------------------------------------------------------------------------------
--concat--operate allows you to concatenate 2 or more strings togather---------

select customer_name,city||','||state||','||country as Address from customer;
---------------------------------------------------------------------------------------------------
---string function allow to extract a substring from a string--------------------
select * from customer;

select customer_id,customer_name,
substring(customer_id for 2) as cust_group
from customer where substring(customer_id for 2)='AB';
--------4th is postion of staring(ab-) starting nd 5 is no of char)
Select
customer_id ,
customer_name,
substring(customer_id fROM 4 for 5) as cust_number
from customer where substring(customer_id for 2)='AB';

select customer_id,substring(customer_id from 8 for length(customer_id) ) from customer;
----------------------------------------------------------------------------------------
select customer_id,
customer_name ,
substring(customer_id from 6 for 5)as cust_number
from customer where substring(customer_id for 2)='AB';     
----------------------------------------------------------------------------------------------
---4--start 3--end--
select customer_id,
customer_name ,
substring(customer_id from 4 for 3)as cust_number
from customer where substring(customer_id for 2)='AB';     
---------------------------------------------------------------------------------------------------
---string aggregator---
select * from sales;
select 
order_id,
string_agg(product_id,',')
from sales group by order_id;
---------------------------------------------------------------------------------------------------------
select * from product;
select product_id, string_agg(product_name,',') as product_nameee from product where sub_category='Chairs' or  sub_category='Tables' GROUP BY product_id;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------				
------------------------------------------maths function----------------------------------			
--ceil function returns the smallest int value that is greater than or equal to a number---			
--floor function returns the smallest int value that is less than or equal to a number---					
select ceil(3.3);				
select floor(3.3);				
select * from sales;
-----------------------------------------------------------------------------------------------------
select ceil(sales) as ciel,
floor(sales) as floor_value
from sales where discount>0;
------------------------------------------------------------------------------------------------------
----random--use to return random no between 0(included) nd 1(excluded)---
--a=10--b=20--
select random();
---random decimal between a range (a included and b excluded)
select random()*(20-10)+10;
---random int between a range (both boundaries included)
select floor(random()*(20-10+1))+10;
-----------------------------------------------------------------------------------------------------------				
--setseed  range 1.0 nd -1.0
---use to tskr same random no--ek seed set krdo agr whi random no wps chaiyee honge to seed wali likhdo--
select setseed(0.5);
 select random(); --0.985
 select random();--0.825
 select setseed(0.5);
 select random();--0.985
 select random();--0.825
---------------------------------------------------------------------------------------------				
--round use to round off value---- 			
select order_line,sales,order_id,round(sales) from sales order by sales desc;
-----------------------------------------------------------------------------------------------
----------------power---------------------------------------
select power(2,2);
select age,power(age,2) as "double age" from customer;		
---------------------------------------------------------------------------------------------
----------------date nd time function------------------------------------------------
--current_date -date
--current_time--time
--current_timestamp--current date nd time---------------
select current_date;
select current_time,current_time(1);
select current_time(1);
select current_timestamp;
---------------------------------------------------------------------------------------------
--age---return no of year ,month nd days--
select Age(current_date,'2003-05-06');
----------------------------------------------------------------------------------
select order_line,order_id,age(ship_date,order_date) as time_taken
from sales 
order by time_taken desc;
--------------------------------------------------------------------------------------------------
--extract--use fro extract part from date-----
select extract(day from current_date);
select order_date,ship_date, extract (epoch from ship_date)-extract(epoch from order_date) as sec_taken from sales;
-------------------------------------------------------------------------------------------------
------------------pattern matching-----
---in postgresql there are 3 methods for pattern matching-----
--like
--similar to statement 
-- ~(regular expression) --also called regex expression ---regular ex wildcards are diff then like 
---like matches on a whole string regex can match on part of starting also
--there are 2 wildcard in like --%,-
select customer_name from customer where customer_name like 'K%';
select customer_name from customer where customr_name like 'K_n%';
select customer_name from customer where customer_name like 'K\%';
select customer_name from customer where customer_name not like 'K%';
---------------like use for easy pattern matching---------------

------regex wildcards
--| (or operator)
--\s--use for space 
--* --repeatation 0 or more times
--+--repeat either one time or more time (replicate same rule)
--?
--{m(any no eg 3)}--repeat 3 times 
--{m,2}
--{m,n}
--^,$--^ use to mention start of string ,$ use for end of the string
--[char]--character set 
--~*--case insensitive
--starting from a 
select customer_name from customer where customer_name~*'^a+[a-z\s]+$';
--first name start with a or b or c or d 
select customer_name from customer where customer_name~*'^(a|b|c|d)+[a-z\s]+$';
--frist nd last name are exactly of 4 char nd name start with either a,b,c,d
select customer_name from customer where customer_name~*'(a|b|c|d)[a-z]{3}\s[a-z]{4}$';
--find valid email ids 
create table users(id serial primary key, name character varying);

insert into users (name) VALUES ('Alex'), ('Jon Snow'), ('Christopher'), ('Arya'),('Sandip Debnath'), ('Lakshmi'),('alex@gmail.com'),('@sandip5004'), ('lakshmi@gmail.com');

select * from users where name~*'[a-z0-9\.\-\_]+@[a-z0-9\-]+\.[a-z]{2,5}';
-------------------------------------------------------------------------------------------
-----------------------window function---------
--row_number()
--parition by ---its means grouping rows
--we need to create a list of top 3 customer with max orders from each other 
--steps to find 
--1.combine the customer table and order table
--2.add row no withing the state
--3.filter_row_number less then equal to 3--
select * from customer limit 10;--use customer_name ,id ,state
select * from sales limit 10;--use distinct order id each customer id has 
---
select a.*,
b.order_num,
b.total_sales,
b.total_quantity,
b.total_profit
from customer as a 
left join
(select customer_id, count( distinct order_id) as order_num,sum(sales) as total_sales,sum(quantity) as total_quantity,sum(profit) as total_profit from sales group by customer_id)
as b
on a.customer_id=b.customer_id; ---combined nd get desired columns
---creating a table of this data 
create table customer_order as (select a.*,
b.order_num,
b.total_sales,
b.total_quantity,
b.total_profit
from customer as a 
left join
(select customer_id, count( distinct order_id) as order_num,sum(sales) as total_sales,sum(quantity) as total_quantity,sum(profit) as total_profit from sales group by customer_id)
as b
on a.customer_id=b.customer_id);

select * from customer_order;
--provide row no to each cust on the basis of  their no of order in each state 
select customer_id,customer_name,
state,order_num,row_number() over (partition by state order by order_num desc) as row_n
from customer_order;

--top 3 customer-----------------------------------------------------------------------
select * from (select customer_id,customer_name,
state,order_num,row_number() over (partition by state order by order_num desc) as row_n
from customer_order) as a where a.row_n between 1 and 3 ;

---------rank----same value or tie on order rank will provide same value to tie value-------------
select * from (select customer_id,customer_name,
			  state,order_num ,rank() over (partition by state order by order_num desc) as  row_n
			  from customer_order) as a where a.row_n between 1 and 3 ;
--------------------------------------------------------------------------------------
--dense rank()
---not skip rank// 3 
select * from (select customer_id,customer_name,
			  state,order_num ,dense_rank() over (partition by state order by order_num desc) as  row_n
			  from customer_order) as a where a.row_n between 1 and 3 ;

-------------------------------------------------------------------------------------------------------
 -----ntile--devide into group in pair
 --top 20% of customer
  select * from (select customer_id,customer_name,
			  state,order_num ,ntile(5) over (partition by state order by order_num desc) as  ntile_group
			  from customer_order) as a where a.ntile_group=1 ;--
----------------------------------------------------------------------------------------------------------
                             ---Aggrigate window function---
--avg value for rows within the window frame
select customer_id,customer_name,state,total_sales as revenue,
avg(total_sales) over(partition by state) from customer_order;
----cust who are purchasing less then other cust
select * from (select customer_id,customer_name,state,total_sales as revenue,
avg(total_sales) over(partition by state) as avg_revenue from customer_order)
as a where a.revenue<a.avg_revenue;
-------------------------------------------------------------------------------------------------------------
----count
select customer_id,customer_name,state,
count(customer_id) over(partition by state) as cust_count from customer_order;
-------------------------------------------------------------------------------
-----------------------------sum-------------------   
select * from (select customer_id,customer_name,state,total_sales as revenue,
sum(total_sales) over(partition by state) as total_revenue from customer_order)
as a where a.revenue<a.total_revenue;
-----------------------------------------------------------------------------
-----------runing total-------------------------
create table order_rollup as select order_id,max(order_date) as order_date,max(customer_id) as customer_id,
sum(sales) as sales from sales group by order_id;

create table order_rollup_state as select a.*,b.state
from order_rollup as a
left join customer as b
on a.customer_id=b.customer_id;
---------------------------------
select * from order_rollup_state;
select *,sum(sales) over (partition by state),
sum(sales) over (partition by state order by sales) from order_rollup_state;
------------------------------------------------------------------------------------------
                            --lag--give previous value
							--lead --give future value
select order_id,order_date,customer_id,sales,state,
lag(sales,1) over (partition by customer_id order by order_date) as pvr_sales,
lag(order_id,1) over (partition by customer_id order by order_date) as pvs_order_id from order_rollup_state;

select order_id,order_date,customer_id,sales,state,
lead(sales,1) over (partition by customer_id order by order_date) as pvr_sales,
lead(order_id,1) over (partition by customer_id order by order_date) as pvs_order_id from order_rollup_state;

--------------------------------------------------------------------------------------------------------------
                        --coalesce function---      
create table emp_name(
	s_no int,
	first_name varchar(255),
	middle_name varchar(255),
	last_name varchar(255));
	
insert into emp_name (s_no,first_name,middle_name,last_name)
values(1,'poul','van','hung');
insert into emp_name (s_no,last_name)
values(2,'singh');

insert into emp_name (s_no,middle_name,last_name)
values(3,'ming','fung');

select* from emp_name;
select * ,coalesce(first_name,middle_name,last_name) as name_crr from emp_name;

-----------------------------------------------------------------------------------------------------
                         ----coversion function-----
--VALUE TO STRING
--9=value format mask rg--72.4==9.9
select sales,'total sales for thi order is'||to_char(sales,' $9999.99')as massege from sales;
--DATE TO STRING--

select order_date,to_char(order_date,'MM/DD/YYYY') from sales;
select order_date,to_char(order_date,'MONTH DD YYYY') from sales;

-----------------------STRING TO DATE-------

select to_date('2019/01/15','YYYY/MM/DD');
Select to_date('23122003','DDMMYYY');

---STRING TO NUMBER---
select to_number('234.432','9999.999');
select to_number('$234.432','L9999.999');

 -----------------------------------------------------------------------------------------------
                       -----create user statement creat a database
					   --that allows you to lig in the database--

create user kirtan with password 'Kirtan';
create user ritin with password 'Ritin' valid until 'infinity';

grant SELECT,INSERT,UPDATE ON product to kirtan;

revoke delete on product from kirtan;

revoke all on product from kirtan;
drop user kirtan;

--rename
alter kirtan renmae to mayuri;
--info of user
select * from pg_user;
--logied in user
select distinct * from pg_stat_activity;
----------------------------------------------------------------------
---table space allow database administration to define locations in the files system
--where the files where the files represent database object can  be store
create tablespace Newspace location 'c:\Program Files\PostgreSQL\10\data\storage';
create table first_table(test_column int)tablespace newspace;

---------------------------------------------------------------------------------------------
--delete all the rows
select * from customer_20_60;
truncate table customer_20_60;
-------------------------------------------------------------------------------------------------










 

  
  
  
  
  
