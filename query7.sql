CREATE OR REPLACE VIEW Main AS (SELECT  Dept
FROM
(SELECT Sales.Store, Sales.Dept, SUM(Sales.WeeklySales) as sale
FROM Sales
GROUP BY Sales.Store, Sales.Dept) t1

INNER JOIN (SELECT Store, SUM(Sales.WeeklySales) AS total FROM Sales GROUP BY Sales.Store) t3
ON t1.Store = t3.Store
WHERE t1.sale >= 0.05*t3.total
GROUP BY t1.Dept
HAVING count(t1.Store) >= 3);

SELECT t2.dept, AVG(t2.sale/t3.total)
FROM (SELECT t1.store, t1.dept, t1.sale FROM Main INNER JOIN (SELECT Sales.Store, Sales.Dept, SUM(Sales.WeeklySales) as sale
FROM Sales
GROUP BY Sales.Store, Sales.Dept) as t1 ON Main.dept = t1.dept ORDER BY Main.dept, t1.store) t2

INNER JOIN (SELECT Store, SUM(Sales.WeeklySales) AS total FROM Sales GROUP BY Sales.Store) t3
ON t2.store = t3.store
GROUP BY t2.dept;

DROP VIEW Main;
