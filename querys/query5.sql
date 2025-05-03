-- Ver a correlação entre a quantidade de Gado e a emissão total de gases por país.
-- Útil para achar quais países poderiam servir de modelo para uma pecuária sustentável.

WITH TOTAL_STOCKS AS (
    SELECT id_area, SUM(value) as total_stocks, year
    FROM public."Stocks"

    GROUP BY id_area, year

),

TOTAL_EMISSIONS AS (
    SELECT id_area, SUM(value) as total_emissions, year
    FROM public."Emissions"
    GROUP BY id_area, year
),

F as (SELECT TOTAL_EMISSIONS.id_area, TOTAL_EMISSIONS.year, TOTAL_EMISSIONS.total_emissions,  TOTAL_STOCKS.total_stocks, TOTAL_STOCKS.year
From TOTAL_EMISSIONS
Inner join
TOTAL_STOCKS
ON 
TOTAL_STOCKS.id_area = TOTAL_EMISSIONS.id_area
AND TOTAL_STOCKS.year = TOTAL_EMISSIONS.year
WHERE TOTAL_STOCKS.total_stocks IS NOT NULL AND TOTAL_STOCKS.total_stocks != 'NaN'

),

B as (Select F.id_area, corr(total_stocks, total_emissions ) as correlation FROM F 
GROUP BY F.id_area
 )

Select B.id_area, a.country, B.correlation
FROM B 
Inner JOIN 
public."Area" as a
ON 
a.id_area = B.id_area
ORDER BY correlation


