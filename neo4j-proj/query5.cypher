//Olha as comidas com maior rendimento por área em paises com uso de fertilizantes abaixo da média
//Visa achar quais paises e alimentos podem servir como um modelo de produção sustentaveil 

CALL(){
    MATCH (fer:Fertilizer)-[use:AGRICULTURE_USE]-(a:Area)
    WHERE NOT isNaN(use.value) AND use.value is NOT NULL
    RETURN AVG(use.value) as MediaFertil
}

CALL(){
    MATCH (fer:Fertilizer)-[use:AGRICULTURE_USE]-(a:Area)
    WHERE NOT isNaN(use.value) AND use.value is NOT NULL
    RETURN a, AVG(use.value) as MediaFertilPais
}


MATCH (f:Food)-[ar:AREA_HARVEST]->(a:Area)<-[pro:PRODUCTION]-(f)
WHERE ar.value IS NOT NULL 
  AND pro.value IS NOT NULL 
  AND pro.value > 0
  AND MediaFertilPais < MediaFertil

WITH
  a.country                AS country_name,
  f.name               AS food_name,
  sum(pro.value)       AS totalProd,
  sum(ar.value)        AS totalArea

// remove foods with no area or zero area
WHERE totalArea > 0

RETURN
    country_name,
  food_name,
  totalProd / totalArea AS eficiencia
ORDER BY eficiencia DESC