-- Analise da producao e da area utlizada para obter alimentos basicos por pais, ]
-- neste caso foram analisados galinhas, ovos, batatas e arroz
WITH prod AS (
	SELECT a.country,
	ROUND(SUM(CASE WHEN f.name = 'Chickens' THEN p.value ELSE 0 END)::numeric, 2) AS chickens,
	ROUND(SUM(CASE WHEN f.name = 'Eggs Primary' THEN p.value ELSE 0 END)::numeric, 2) AS eggs,
	ROUND(SUM(CASE WHEN f.name = 'Potatoes' THEN p.value ELSE 0 END)::numeric, 2) AS potatoes,
	ROUND(SUM(CASE WHEN f.name = 'Rice' THEN p.value ELSE 0 END)::numeric, 2) AS rice
	FROM
	"Production" p
	JOIN "Area" a ON p.id_area = a.id_area
	JOIN "Food" f ON p.id_food = f.id_food
	WHERE f.name IN ('Chickens','Eggs Primary', 'Potatoes', 'Rice')
	GROUP BY a.country
),
area_har AS (
	SELECT a.country,
	ROUND(SUM(CASE WHEN f.name = 'Chickens' THEN p.value ELSE 0 END)::numeric, 2) AS area_chickens,
	ROUND(SUM(CASE WHEN f.name = 'Eggs Primary' THEN p.value ELSE 0 END)::numeric, 2) AS area_eggs,
	ROUND(SUM(CASE WHEN f.name = 'Potatoes' THEN p.value ELSE 0 END)::numeric, 2) AS area_potatoes,
	ROUND(SUM(CASE WHEN f.name = 'Rice' THEN p.value ELSE 0 END)::numeric, 2) AS area_rice
	FROM
	"Area_harvest" p
	JOIN "Area" a ON p.id_area = a.id_area
	JOIN "Food" f ON p.id_food = f.id_food
	WHERE f.name IN ('Chickens','Eggs Primary', 'Potatoes', 'Rice')
	GROUP BY a.country
),

fert_use AS (
	SELECT a.country,
	ROUND(SUM(p.value)::numeric,2) AS total
	FROM
	"Use_per_area" p
	JOIN "Area" a ON p.id_area = a.id_area
	GROUP BY a.country
)
	SELECT
		prod.country,
		prod.chickens,
		area_har.area_chickens,
		prod.eggs,
		area_har.area_eggs,
		prod.potatoes,
		area_har.area_potatoes,
		prod.rice,
		area_har.area_rice,
		fert_use.total as total_fertilizer
	FROM prod
	JOIN fert_use ON prod.country = fert_use.country
	JOIN area_har ON prod.country = area_har.country
	ORDER BY prod.country



