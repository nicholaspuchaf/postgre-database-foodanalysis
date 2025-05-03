-- Query para avaliar a relacao de producao total de alimentos, e tambem criacao total de animais por pais
-- e avaliar a relacao destes dados com a quantidade total de fertilizantes usado por pais
-- A analise eh sobre toda a producao nacional desde 1963
WITH prod AS (
	SELECT a.country,
	ROUND(SUM(p.value)::numeric,2) AS total,
	MAX(p.year) - MIN(p.year) AS time 
	FROM "Production" p
	JOIN "Area" a ON p.id_area = a.id_area
	GROUP BY a.country
	ORDER BY a.country DESC
),
agri AS (
	SELECT a.country, 
    ROUND(SUM(f.value)::numeric,2) AS totalFer 
	FROM "Agriculture_use" f
	JOIN "Area" a ON f.id_area = a.id_area
	GROUP BY a.country
	ORDER BY a.country DESC
),
stock AS (
	SELECT a.country, 
    ROUND(SUM(f.value)::numeric,2) AS total 
	FROM "Stocks" f
	JOIN "Area" a ON f.id_area = a.id_area
	GROUP BY a.country
	ORDER BY a.country DESC
)
	SELECT p.country AS country_name,
		   p.total AS total_food,
		   o.total as total_animals,
		   a.totalFer AS total_fertilizer,
		   p.time AS total_years,
		   p.total/a.totalFer AS food_fert,
		   (p.total+o.total)/a.totalFer AS food_animal_fert,
		   p.total/p.time AS mean_food_year,
		   a.totalFer/p.time AS mean_fert_year,
		   o.total/p.time AS mean_animal_year
		   FROM prod AS p
		   JOIN agri AS a ON p.country = a.country
		   JOIN stock AS o ON p.country = o.country
		   WHERE a.totalFer >= 2000
		   ORDER BY food_fert DESC