// Ve quais paises, entre os anos de 2018 e 2020, tiveram um maior crescimento do uso de fertilizantes do que do uso de comida.


WITH 2018 AS y1, 2020 AS y2
     //0.1 AS minFertGrowth, 0.05 AS maxProdGrowth

MATCH (a:Area)

// pull both fertilizer relationships in one go
MATCH (f:Fertilizer)-[use1:USE_PER_AREA]->(a)<-[use2:USE_PER_AREA]-(f)
WHERE use1.year = y1 AND use2.year = y2
  AND use1.value IS NOT NULL AND use2.value IS NOT NULL

// pull both production relationships
MATCH (fd:Food)-[prod1:PRODUCTION]->(a)<-[prod2:PRODUCTION]-(fd)
WHERE prod1.year = y1 AND prod2.year = y2
  AND prod1.value IS NOT NULL AND prod2.value IS NOT NULL

//RETURN prod1, prod2, use1, use2

// // // do the math
WITH a,
     (use2.value - use1.value)/use1.value AS fertGrowth,
     (prod2.value - prod1.value)/prod1.value AS prodGrowth,
     fd,
     f
WHERE fertGrowth > prodGrowth

RETURN a.country as Place, fertGrowth, prodGrowth, fd.name as Food_name, f.name as Fertilizer_name
