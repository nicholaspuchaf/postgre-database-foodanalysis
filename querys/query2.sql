-- Query para avaliar a quantidade total de emissoes de gases poluentes emitidos pelos paises,
-- e tambem avaliar a relacao dessa emissao com a producao total de alimentos e da criacao total de animais por pais
WITH emi AS (
	SELECT a.country,
	ROUND(SUM(p.value * 1000)::numeric,2) AS total,
	MAX(p.year) - MIN(p.year) AS time 
	FROM "Emissions" p
	JOIN "Area" a ON p.id_area = a.id_area
	GROUP BY a.country
	ORDER BY a.country DESC
),
prod AS (
	SELECT a.country,
	ROUND(SUM(p.value)::numeric,2) AS total,
	MAX(p.year) - MIN(p.year) AS time 
	FROM "Production" p
	JOIN "Area" a ON p.id_area = a.id_area
	GROUP BY a.country
	ORDER BY a.country DESC
),
stock AS (
	SELECT a.country,
	ROUND(SUM(p.value)::numeric,2) AS total,
	MAX(p.year) - MIN(p.year) AS time 
	FROM "Stocks" p
	JOIN "Area" a ON p.id_area = a.id_area
	GROUP BY a.country
	ORDER BY a.country DESC
)
	SELECT 
		m.country AS country_name,
		m.total AS total_gas,
		p.total AS total_prod,
		s.total AS total_animals,
		m.total/(p.total+s.total) AS gas_per_food
	
	FROM emi m 
	JOIN prod p ON m.country = p.country
	JOIN stock s ON s.country = m.country
	ORDER BY gas_per_food
