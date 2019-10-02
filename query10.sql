CREATE OR REPLACE VIEW Main AS (
SELECT store_a.yr, store_a.qtr, store_a.asales, store_b.bsales
FROM (SELECT yr, qtr, sum AS asales
	FROM (
		SELECT yr ,CASE WHEN monthsale <= 3 THEN '1' WHEN monthsale <= 6 THEN '2'  WHEN monthsale <= 9 THEN '3' WHEN monthsale <= 12 THEN '4' END AS qtr, type, sum(weeklysales)
		FROM (SELECT DATE_PART('year', weekDate) AS yr, DATE_PART('month', weekDate) AS monthsale, type, weeklysales
				FROM (SELECT *
					FROM (sales INNER JOIN hw2.stores ON sales.store = hw2.stores.store)
				) AS t1
			)AS t2
		GROUP BY yr, qtr, type
		ORDER BY yr, qtr
		) AS t3
	WHERE type = 'A') store_a

INNER JOIN

(SELECT yr, qtr, sum AS bsales
	FROM (SELECT yr ,CASE WHEN monthsale <= 3 THEN '1' WHEN monthsale <= 6 THEN '2'  WHEN monthsale <= 9 THEN '3' WHEN monthsale <= 12 THEN '4' END AS qtr, type, sum(weeklysales)
		FROM (SELECT DATE_PART('year', weekDate) AS yr, DATE_PART('month', weekDate) AS monthsale, type, weeklysales
				FROM (SELECT *
					FROM (sales INNER JOIN hw2.stores ON sales.store = hw2.stores.store)
				) AS t1b
			)AS t2b
		GROUP BY yr, qtr, type
		ORDER BY yr, qtr
	) AS t3b
	WHERE type = 'B') store_b
ON store_a.yr = store_b.yr AND store_a.qtr = store_b.qtr);

SELECT * FROM Main UNION ALL SELECT Main.yr, null as qtr, sum(Main.asales) AS asales, sum(Main.bsales) AS bsales FROM Main GROUP BY yr ORDER BY yr, qtr;

DROP VIEW Main;
