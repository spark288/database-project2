CREATE TABLE Main(attribute VARCHAR(20), corsign char(1), corvalue float);

INSERT INTO Main VALUES ('Temperature', (SELECT case when val > 0 then '+' else '-' end
FROM (SELECT corr(hw2.temporaldata.Temperature,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate
AND Sales.Store = hw2.temporaldata.Store) as float(val)), (SELECT corr(hw2.temporaldata.Temperature,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate AND Sales.Store = hw2.temporaldata.Store));

INSERT INTO Main VALUES ('FuelPrice', (SELECT case when val > 0 then '+' else '-' end
FROM (SELECT corr(hw2.temporaldata.FuelPrice,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate
AND Sales.Store = hw2.temporaldata.Store) as float(val)), (SELECT corr(hw2.temporaldata.FuelPrice,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate AND Sales.Store = hw2.temporaldata.Store));

INSERT INTO Main VALUES ('CPI', (SELECT case when val > 0 then '+' else '-' end
FROM (SELECT corr(hw2.temporaldata.CPI,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate
AND Sales.Store = hw2.temporaldata.Store) as float(val)), (SELECT corr(hw2.temporaldata.CPI,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate AND Sales.Store = hw2.temporaldata.Store));


INSERT INTO Main VALUES ('UnemploymentRate', (SELECT case when val > 0 then '+' else '-' end
FROM (SELECT corr(hw2.temporaldata.UnemploymentRate,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate
AND Sales.Store = hw2.temporaldata.Store) as float(val)), (SELECT corr(hw2.temporaldata.UnemploymentRate,Sales.WeeklySales)
FROM Sales INNER JOIN hw2.temporaldata ON Sales.WeekDate = hw2.temporaldata.WeekDate AND Sales.Store = hw2.temporaldata.Store));

SELECT * FROM Main;
DROP TABLE Main;
