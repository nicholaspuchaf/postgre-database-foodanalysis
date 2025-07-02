WITH
-- Total de fertilizantes por país e ano
Fertilizer_total AS (
  SELECT
    id_area,
    year,
    SUM(value) AS total_fert
  FROM public."Fertilizer_production"
  GROUP BY id_area, year
),
-- Total de produção de alimentos por país e ano (apenas toneladas válidas)
Production_total AS (
  SELECT
    id_area,
    year,
    SUM(value) AS total_prod
  FROM public."Production"
  WHERE unit = 't'
    AND value IS NOT NULL
    AND value <> 'NaN'
  GROUP BY id_area, year
),
-- Cálculo da razão (produção / fertilizante) por país e ano
Ratio AS (
  SELECT
    p.id_area,
    p.year,
    p.total_prod::double precision / f.total_fert::double precision AS ratio
  FROM Production_total p
  JOIN Fertilizer_total f
    ON p.id_area = f.id_area
   AND p.year    = f.year
  WHERE f.total_fert <> 0
)
SELECT
  a.country,
  r.id_area,
  -- aqui já calculamos o coeficiente angular da série (ratio vs year)
  regr_slope(r.ratio, r.year) AS slope
FROM Ratio r
JOIN public."Area" a
  ON a.id_area = r.id_area
GROUP BY
  a.country,
  r.id_area
ORDER BY
  slope;
