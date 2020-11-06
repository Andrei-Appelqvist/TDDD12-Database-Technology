/*
Lab 1 report Andrei Moga andmo435, Victor Fager vicfa748
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP VIEW IF EXISTS jbitemlessview CASCADE;
DROP VIEW IF EXISTS jbtotaldebit CASCADE;
DROP VIEW IF EXISTS jbtotaldebit2 CASCADE;
DROP VIEW IF EXISTS jbsale_supply CASCADE;

/* Have the source scripts in the file so it is easy to recreate!*/
SOURCE company_schema.sql;
SOURCE company_data.sql;


/*
Question 1: List all employees, i.e. all tuples in the jbemployeerelation.
*/
select * from jbemployee;

/*
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
25 rows in set (0.01 sec)
*/


/*
Question 2: List the name of all departments in alphabetical order. Note: by “name” we mean the name attribute for all tuples in the jbdept relation.
*/
select * from jbdept order by name asc;
/*
+----+------------------+-------+-------+---------+
| id | name             | store | floor | manager |
+----+------------------+-------+-------+---------+
|  1 | Bargain          |     5 |     0 |      37 |
| 35 | Book             |     5 |     1 |      55 |
| 10 | Candy            |     5 |     1 |      13 |
| 73 | Children's       |     5 |     1 |      10 |
| 43 | Children's       |     8 |     2 |      32 |
| 19 | Furniture        |     7 |     4 |      26 |
| 99 | Giftwrap         |     5 |     1 |      98 |
| 14 | Jewelry          |     8 |     1 |      33 |
| 47 | Junior Miss      |     7 |     2 |     129 |
| 65 | Junior's         |     7 |     3 |      37 |
| 26 | Linens           |     7 |     3 |     157 |
| 20 | Major Appliances |     7 |     4 |      26 |
| 58 | Men's            |     7 |     2 |     129 |
| 60 | Sportswear       |     5 |     1 |      10 |
| 34 | Stationary       |     5 |     1 |      33 |
| 49 | Toys             |     8 |     2 |      35 |
| 63 | Women's          |     7 |     3 |      32 |
| 70 | Women's          |     5 |     1 |      10 |
| 28 | Women's          |     8 |     2 |      32 |
+----+------------------+-------+-------+---------+
19 rows in set (0.01 sec)
*/

/*
Question 3: What parts are not in store, i.e. qoh=0? (qoh= Quantity On Hand).
*/
select * from jbparts where qoh=0;
/*
+----+-------------------+-------+--------+------+
| id | name              | color | weight | qoh  |
+----+-------------------+-------+--------+------+
| 11 | card reader       | gray  |    327 |    0 |
| 12 | card punch        | gray  |    427 |    0 |
| 13 | paper tape reader | black |    107 |    0 |
| 14 | paper tape punch  | black |    147 |    0 |
+----+-------------------+-------+--------+------+
4 rows in set (0.01 sec)
*/

/*
Question 4: Which employees have a salary between 9000(included)and 10000(included)?
*/
select * from jbemployee where salary between 9000 and 10000;
/*
+-----+----------------+--------+---------+-----------+-----------+
| id  | name           | salary | manager | birthyear | startyear |
+-----+----------------+--------+---------+-----------+-----------+
|  13 | Edwards, Peter |   9000 |     199 |      1928 |      1958 |
|  32 | Smythe, Carol  |   9050 |     199 |      1929 |      1967 |
|  98 | Williams, Judy |   9000 |     199 |      1935 |      1969 |
| 129 | Thomas, Tom    |  10000 |     199 |      1941 |      1962 |
+-----+----------------+--------+---------+-----------+-----------+
4 rows in set (0.01 sec)
*/
/*
Question 5: What was the age of each employee when they started working (startyear)?
*/
select name, startyear-birthyear AS 'age when started' from jbemployee;
/*
+--------------------+------------------+
| name               | age when started |
+--------------------+------------------+
| Ross, Stanley      |               18 |
| Ross, Stuart       |                1 |
| Edwards, Peter     |               30 |
| Thompson, Bob      |               40 |
| Smythe, Carol      |               38 |
| Hayes, Evelyn      |               32 |
| Evans, Michael     |               22 |
| Raveen, Lemont     |               24 |
| James, Mary        |               49 |
| Williams, Judy     |               34 |
| Thomas, Tom        |               21 |
| Jones, Tim         |               20 |
| Bullock, J.D.      |                0 |
| Collins, Joanne    |               21 |
| Brunet, Paul C.    |               21 |
| Schmidt, Herman    |               20 |
| Iwano, Masahiro    |               26 |
| Smith, Paul        |               21 |
| Onstad, Richard    |               19 |
| Zugnoni, Arthur A. |               21 |
| Choy, Wanda        |               23 |
| Wallace, Maggie J. |               19 |
| Bailey, Chas M.    |               19 |
| Bono, Sonny        |               24 |
| Schwarz, Jason B.  |               15 |
+--------------------+------------------+
25 rows in set (0.01 sec)
*/
/*
Question 6: Which employees have a last name endingwith “son”?
*/
select * from jbemployee where name like '%son,%';
/*
+----+---------------+--------+---------+-----------+-----------+
| id | name          | salary | manager | birthyear | startyear |
+----+---------------+--------+---------+-----------+-----------+
| 26 | Thompson, Bob |  13000 |     199 |      1930 |      1970 |
+----+---------------+--------+---------+-----------+-----------+
1 row in set (0.00 sec)
*/
/*
Question 7: Which items (note items, not parts) have been delivered by a supplier called Fisher-Price? Formulate this query using a subquery in the where-clause?
*/
select * from jbitem where supplier in (select id from jbsupplier where name="Fisher-Price");
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
+-----+-----------------+------+-------+------+----------+
3 rows in set (0.01 sec)
*/

/*
Question 8: Formulate the same query as above, but without a subquery.
*/
select * from jbitem as I, jbsupplier as S where S.id = I.supplier and S.name = 'Fisher-Price';
/*
+-----+-----------------+------+-------+------+----------+----+--------------+------+
| id  | name            | dept | price | qoh  | supplier | id | name         | city |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
|  43 | Maze            |   49 |   325 |  200 |       89 | 89 | Fisher-Price |   21 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 | 89 | Fisher-Price |   21 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 | 89 | Fisher-Price |   21 |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
3 rows in set (0.01 sec)
*/

/*
Question 9: Show all cities that have suppliers located in them. Formulate this query using a subquery in the where-clause.
*/
select * from jbcity where id in (select city from jbsupplier);
/*
+-----+----------------+-------+
| id  | name           | state |
+-----+----------------+-------+
|  10 | Amherst        | Mass  |
|  21 | Boston         | Mass  |
| 100 | New York       | NY    |
| 106 | White Plains   | Neb   |
| 118 | Hickville      | Okla  |
| 303 | Atlanta        | Ga    |
| 537 | Madison        | Wisc  |
| 609 | Paxton         | Ill   |
| 752 | Dallas         | Tex   |
| 802 | Denver         | Colo  |
| 841 | Salt Lake City | Utah  |
| 900 | Los Angeles    | Calif |
| 921 | San Diego      | Calif |
| 941 | San Francisco  | Calif |
| 981 | Seattle        | Wash  |
+-----+----------------+-------+
15 rows in set (0.01 sec)
*/
/*
Question 10: What is the name and color of the parts that are heavier than a card reader? Formulate this query using a subquery in the where-clause. (The SQL query must not contain the weightas a constant.
*/
select name, color from jbparts where weight > (select weight from jbparts where name="card reader");
/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.01 sec)
*/

/*
Question 11: Formulate the same query as above, but without a subquery. (The query must not contain the weight as a constant.)
*/
select P.name, P.color from jbparts as P, jbparts as C where P.weight > C.weight and C.name="card reader";
/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.01 sec)
*/

/*
Question 12: What is the average weight of black parts?
*/
select avg(weight) from jbparts where color="black";
/*
+-------------+
| avg(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0.00 sec)
*/
/*
Question 13:What is the total weight of all parts that each supplier in Massachusetts (“Mass”) has delivered? Retrieve the name and the total weight for each of these suppliers. Do not forget to take the quantity of delivered parts into account. Note that one row should be returned for each supplier.
*/
select jbsupplier.name, sum(jbparts.weight*jbsupply.quan)
from jbsupplier inner join jbcity on jbsupplier.city=jbcity.id
inner join jbsupply on jbsupplier.id = jbsupply.supplier
inner join jbparts on jbsupply.part = jbparts.id
where jbcity.state = "Mass"
group by jbsupplier.name;
/*
+--------------+-----------------------------------+
| name         | sum(jbparts.weight*jbsupply.quan) |
+--------------+-----------------------------------+
| DEC          |                              3120 |
| Fisher-Price |                           1135000 |
+--------------+-----------------------------------+
2 rows in set (0.00 sec)
*/

/*
Question 14:Create a new relation (a table),with the same attributes as the table items using the CREATE TABLE syntax where you define every attribute explicitly (i.e. not as a copy of another table). Then fill the table with all items that cost less than the average price for items. Remember to define primary and foreign keys in your table!
*/
CREATE TABLE jbitemless (
    id INT,
    name VARCHAR(20),
    dept INT NOT NULL,
    price INT,
    qoh INT UNSIGNED, 
    supplier INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(supplier) references jbsupplier(id),
    FOREIGN KEY(dept) references jbdept(id)
);

insert into jbitemless select * from jbitem where price < (select avg(price) from jbitem);
select * from jbitemless;

DROP TABLE IF EXISTS jbitemless CASCADE;
/*
Query OK, 14 rows affected (0.01 sec)
Records: 14  Duplicates: 0  Warnings: 0
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.01 sec)
*/


/*
Question 15: Create a view that contains the items that cost less than the average price for items.
*/
create view jbitemlessview as select * from jbitem where price < (select avg(price) from jbitem);
select * from jbitemlessview;
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/


/*
Question 16: What is the difference between a table and a view? One is static and the other is dynamic. Which is which and what do we mean by static respectively dynamic?

A regular table is static since it's saved on disk as an object with rows(data). A view is more of a select query with a name that pulls data from already existing tables or views and it's data is not necessarily saved on disk. This is why you would consider a view dynamic. A regular table can be modified with updates or inserts while views are read-only. Views will update automatically when one of its source tables are updated.
*/

/*
Question 17: Create a view that calculates the total cost of each debit, by considering price and quantity of each bought item. (To be used for charging customer accounts). The view should contain the sale identifier (debit) and total cost. Use only the implicit join notation, i.e. only use a where clause but not the keywords inner join, right join or left join,
*/
create view jbtotaldebit as
select S.debit, SUM(I.price * S.quantity) as total from jbsale as S, jbitem as I
where S.item = I.id
group by S.debit;

select * from jbtotaldebit;

/*
+--------+-------+
| debit  | total |
+--------+-------+
| 100581 |  2050 |
| 100582 |  1000 |
| 100586 | 13446 |
| 100592 |   650 |
| 100593 |   430 |
| 100594 |  3295 |
+--------+-------+
6 rows in set (0.04 sec)
*/


/*
Question 18: Do the same as in (17), using only the explicit join notation, i.e. using only left, right or inner joins but no join condition in a whereclause. Motivate why you use the join you do (left, right or inner), and why this is the correct one (unlike the others).
*/
create view jbtotaldebit2 as
select jbsale.debit, sum(jbitem.price * jbsale.quantity) as total
from jbsale left join jbitem on jbsale.item = jbitem.id
group by jbsale.debit;

select * from jbtotaldebit2;

/*
Both left and inner join should work nicely in this case since you cant have a sale with an item number that does not exist.
Right would give a couple of NULL rows since there are some items that are not present in the sales.

+--------+-------+
| debit  | total |
+--------+-------+
| 100581 |  2050 |
| 100582 |  1000 |
| 100586 | 13446 |
| 100592 |   650 |
| 100593 |   430 |
| 100594 |  3295 |
+--------+-------+
6 rows in set (0.01 sec)
*/

/*
19)Oh no! An earthquake! a)Remove all suppliers in Los Angeles from the table jbsupplier. This will not work right away (you will receive error code 23000) which you will have to solve by deleting some other related tuples. However, do not delete more tuples from other tables than necessary and do not change the structure of the tables, i.e. do not remove foreign keys. Also, remember that you are only allowed to use “Los Angeles” as a constant in your queries, not “199” or “900”
*/

delete from jbsale
where jbsale.item in (select jbitem.id from jbitem, jbcity, jbsupplier where jbitem.supplier = jbsupplier.id and jbsupplier.city = jbcity.id and jbcity.name = "Los Angeles");

delete from jbitem
where jbitem.supplier in (select jbsupplier.id from jbsupplier, jbcity where jbsupplier.city = jbcity.id and jbcity.name = "Los Angeles");

delete from jbsupplier
where jbsupplier.city in (select jbcity.id from jbcity where jbcity.name = "Los Angeles");

select * from jbsupplier;
select * from jbitem;
select * from jbsale;
/*
+-----+--------------+------+
| id  | name         | city |
+-----+--------------+------+
|   5 | Amdahl       |  921 |
|  15 | White Stag   |  106 |
|  20 | Wormley      |  118 |
|  33 | Levi-Strauss |  941 |
|  42 | Whitman's    |  802 |
|  62 | Data General |  303 |
|  67 | Edger        |  841 |
|  89 | Fisher-Price |   21 |
| 122 | White Paper  |  981 |
| 125 | Playskool    |  752 |
| 213 | Cannon       |  303 |
| 241 | IBM          |  100 |
| 440 | Spooley      |  609 |
| 475 | DEC          |   10 |
| 999 | A E Neumann  |  537 |
+-----+--------------+------+
15 rows in set (0.00 sec)

+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
|  52 | Jacket          |   60 |  3295 |  300 |       15 |
| 101 | Slacks          |   63 |  1600 |  325 |       15 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 121 | Queen Sheet     |   26 |  1375 |  600 |      213 |
| 127 | Ski Jumpsuit    |   65 |  4350 |  125 |       15 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
| 301 | Boy's Jean Suit |   43 |  1250 |  500 |       33 |
+-----+-----------------+------+-------+------+----------+
18 rows in set (0.01 sec)

+--------+------+----------+
| debit  | item | quantity |
+--------+------+----------+
| 100581 |  118 |        5 |
| 100581 |  120 |        1 |
| 100586 |  106 |        2 |
| 100586 |  127 |        3 |
| 100592 |  258 |        1 |
| 100593 |   23 |        2 |
| 100594 |   52 |        1 |
+--------+------+----------+
7 rows in set (0.00 sec)


b) We traced all the foreign keys from supplier and deleted the corresponding rows. We started with the table furthest away in dependence to the supplier table, the one that did not have further tables dependent on it. We proceeded to remove the matching rows one table at the time until we reached the supplier. Then we were able to successfully remove the supplier. We deduced city id and supplier id using join conditions in the where clause.
*/


/*
20)An employee has tried to find out which suppliers that have delivered items that have been sold. He has created a view and a query that shows the number of items sold from a supplier. 
*/

-- We reloaded the database
SOURCE company_schema.sql;
SOURCE company_data.sql;

create view jbsale_supply(supplier, item, quantity) as
select jbsupplier.name, jbitem.name, jbsale.quantity from (jbsupplier inner join jbitem on jbsupplier.id = jbitem.supplier) left join jbsale on jbsale.item = jbitem.id;

SELECT supplier, sum(quantity) AS sum FROM jbsale_supply GROUP BY supplier;

/*
+--------------+------+
| supplier     | sum  |
+--------------+------+
| Cannon       |    6 |
| Fisher-Price | NULL |
| Koret        |    1 |
| Levi-Strauss |    1 |
| Playskool    |    2 |
| White Stag   |    4 |
| Whitman's    |    2 |
+--------------+------+
7 rows in set (0.01 sec)
*/
