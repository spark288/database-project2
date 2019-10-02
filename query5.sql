CREATE OR REPLACE VIEW Main AS(SELECT Sales.Store, Sales.Dept, Date_part('month', Sales.weekdate) as month, Date_part('year', weekdate) as year, weeklysales
FROM Sales
ORDER BY store, dept, month, year);

CREATE OR REPLACE VIEW view1 AS (SELECT store, COUNT(DISTINCT dept) FROM Main GROUP BY store, year);
CREATE OR REPLACE VIEW view2 AS (SELECT store, dept, COUNT(DISTINCT month) AS count_month, year FROM Main GROUP BY store, dept, year HAVING COUNT(DISTINCT month) = 12);
CREATE OR REPLACE VIEW view3 AS (SELECT store, COUNT(DISTINCT dept) AS count_dept, year FROM view2 GROUP BY store, year);

SELECT view1.store FROM view1 INNER JOIN view3 ON view1.Store = view3.Store WHERE view1.count= view3.count_dept;

DROP VIEW view3;
DROP VIEW view2;
DROP VIEW view1;
DROP VIEW Main;
