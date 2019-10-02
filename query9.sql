CREATE OR REPLACE VIEW Main AS(
SELECT dept, normsales
FROM (
	SELECT *, rank() OVER (ORDER BY normsales DESC) AS norm_rank
	FROM (
		SELECT dept, SUM(t1.weeklysales/ t1.size) AS normsales
		FROM (
			SELECT *
			FROM sales INNER JOIN hw2.stores ON sales.store = stores.store
		) AS t1
		GROUP BY dept
	) AS t2
) AS t3
WHERE norm_rank <= 10);

CREATE OR REPLACE VIEW view1 AS(SELECT sales.dept as dept, DATE_PART('year', weekdate) AS yr, DATE_PART('month', weekdate) AS month, sales.weeklysales AS weeklysales
FROM Main INNER JOIN sales ON Main.dept = sales.dept);

CREATE OR REPLACE VIEW view2 AS(SELECT dept, yr, month, sum(weeklysales) AS monthsales FROM view1 GROUP BY dept, yr, month ORDER BY dept, yr, month);

SELECT dept, yr, month, monthsales, ROUND(((monthsales*100)/sum(monthsales) OVER (PARTITION BY dept)) ::numeric,2) AS contribution, CAST(SUM(monthsales) OVER (PARTITION BY dept ORDER BY dept, yr, month) AS DECIMAL(12,2)) AS cumulative_sales FROM view2 ORDER BY dept, yr, month;

DROP VIEW view2;
DROP VIEW view1;
DROP VIEW Main;
