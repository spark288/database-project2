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
WHERE norm_rank <= 10
;
