SELECT count(*)
FROM (
	SELECT sales.weekdate, sum(sales.weeklysales)
	FROM (
		hw2.holidays INNER JOIN Sales ON Sales.WeekDate = hw2.holidays.weekDate
	)
	WHERE isHoliday = 'False'
	GROUP BY sales.weekdate
	HAVING sum(weeklySales) > (	SELECT AVG(sum)
								FROM (
									SELECT SUM(sales.WeeklySales) AS sum
									FROM (Sales INNER JOIN hw2.holidays ON Sales.WeekDate = hw2.holidays.weekDate)
									WHERE hw2.holidays.IsHoliday = 'True'
									GROUP BY sales.weekdate
								) AS holiday)
	ORDER BY sales.weekdate
) AS num;
