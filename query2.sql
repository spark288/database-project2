SELECT fuel_max.store
FROM (
	(SELECT *
	FROM (
		SELECT store, max(fuelprice) AS max_price
		FROM hw2.temporaldata
		GROUP BY store
	) AS fuel
	WHERE max_price < 4) AS fuel_max
	INNER JOIN
	(SELECT *
	FROM (
		SELECT store, max(unemploymentrate) AS max_emp
		FROM hw2.temporaldata
		GROUP BY store
	)AS emp
	WHERE max_emp > 10) AS emp_max
	ON fuel_max.store = emp_max.store
);
