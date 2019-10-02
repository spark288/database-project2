WITH
types(sum,type) AS
(SELECT sum(weeklysales) as typeSum, type
FROM sales INNER JOIN hw2.stores
ON sales.store = hw2.stores.store
GROUP BY type),
month(month, type, sum) AS
(SELECT Date_Part('month', sales.weekdate) AS month, type, sum(weeklysales) as sum
 FROM hw2.sales
 INNER JOIN hw2.stores ON hw2.sales.store=hw2.stores.store
 GROUP BY month,type
 ORDER BY type,month)
SELECT month.month as month, month.type as type, month.sum as sum, (month.sum)/(types.sum)*100 as contribution FROM types, month WHERE types.type=month.type;
