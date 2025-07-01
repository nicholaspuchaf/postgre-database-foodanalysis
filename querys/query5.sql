WITH
-- Soma de cabeças de gado por país e ano
TOTAL_STOCKS AS (
  SELECT
    id_area,
    year,
    SUM(value)::double precision AS total_stocks
  FROM public."Stocks"
  WHERE value IS NOT NULL
    AND value <> 'NaN'
  GROUP BY id_area, year
),
-- Soma de emissões de gases por país e ano
TOTAL_EMISSIONS AS (
  SELECT
    id_area,
    year,
    SUM(value)::double precision AS total_emissions
  FROM public."Emissions"
  WHERE value IS NOT NULL
    AND value <> 'NaN'
  GROUP BY id_area, year
)
SELECT
  a.country,
  s.id_area,
  -- correlação entre o total de gado e emissões ao longo dos anos
  corr(s.total_stocks, e.total_emissions) AS correlation
FROM TOTAL_STOCKS s
JOIN TOTAL_EMISSIONS e
  ON s.id_area = e.id_area
 AND s.year    = e.year
JOIN public."Area" a
  ON a.id_area = s.id_area
GROUP BY
  a.country,
  s.id_area
ORDER BY
  correlation;
