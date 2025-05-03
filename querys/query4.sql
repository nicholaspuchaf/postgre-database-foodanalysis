-- Coeficiente angular da razão (total de alimentos/fertilizantes), por páis ao longo do tempo
-- analisa quais paises estão aumentando cada vez mais o uso de fertilizantes por kg de alimento.

with Fertilizer_total_year as (
    Select id_area, sum(value) as total, year
    From public."Fertilizer_production"
    group by id_area, year
),

Production_Total_year as(
    Select id_area, sum(value) as total, year
    From public."Production"
where unit = 't' and value IS NOT NULL AND value != 'NaN'
    GROUP BY id_area, year
),
-- SELECT * FROM Production_Total_year
-- SELECT * FROM Fertilizer_total_year
-- SELECT 
-- id_area,
-- Production_Total_year.year,
--     CASE 
--         WHEN LAG(year, 1) OVER (PARTITION BY id_area ORDER BY year) = year - 1 and LAG(total, 1) OVER (PARTITION BY id_area ORDER BY year) != 0.0
--         THEN  total / (LAG(total, 1) OVER (PARTITION BY id_area ORDER BY year))
--         ELSE NULL 
--     END AS ratio
-- FROM 
--     Production_Total_year
-- ORDER BY 
--     id_area;
F as (SELECT 
    COALESCE(Fertilizer_total_year.id_area, Production_Total_year.id_area) AS id_area,
    Production_Total_year.total /Fertilizer_total_year.total  AS ratio,
Production_Total_year.year as year
FROM 
    Production_Total_year
INNER JOIN 
    Fertilizer_total_year
ON 
   Fertilizer_total_year.id_area = Production_Total_year.id_area and Production_Total_year.year = Fertilizer_total_year.year
where Fertilizer_total_year.total != 0.0
),

F2 as (Select id_area, regr_slope(ratio, year) as slope 
from F 
Group by id_area 
)

Select Area.country, Area.id_area, F2.slope
From F2
Inner join
public."Area" as Area
ON 
Area.id_area = F2.id_Area
Order by slope