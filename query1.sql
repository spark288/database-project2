SELECT store, sales
FROM (
	SELECT *, rank() OVER (ORDER BY t2.Sales) AS s_rank
	FROM (
		SELECT store, sum(weeklysales) AS Sales
		FROM (
			SELECT store, weeklysales
			FROM sales INNER JOIN hw2.holidays ON sales.weekdate = holidays.weekdate
			WHERE isHoliday = true
			) AS t
		GROUP BY store
		) AS t2
	) AS t3
WHERE s_rank = 1

UNION ALL

SELECT store, sales
FROM (
	SELECT *, rank() OVER (ORDER BY t2.Sales DESC) AS s_rank
	FROM (
		SELECT store, sum(weeklysales) AS Sales
		FROM (
			SELECT store, weeklysales
			FROM sales INNER JOIN hw2.holidays ON sales.weekdate = holidays.weekdate
			WHERE isHoliday = true
			) AS t
		GROUP BY store
		) AS t2
	) AS t3
WHERE s_rank = 1;
