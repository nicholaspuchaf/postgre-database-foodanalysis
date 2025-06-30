
// Está query realiza primeiro a média de todas produção de animais ruminantes no mundo no ano de 2021
// Depois realiza a média da quantidade de Emissão de Methano por paises no ano de 2021.
// Depois comparamos paises cumprem ambos critérios, de estarem produzindo mais animais ruminantes que a média do mundo e de estarem produzindo mais gás methano que o resto do mundo

WITH 2020 AS y1,
  ["Camels","Cattle","Goat","Sheep","Buffalo"] AS ruminants,
  'Emissions (CH4)' as methane

CALL(y1, ruminants){
    MATCH (ani:Animal)
    WHERE ani.name IN ruminants
    MATCH (ani)-[s:STOCKS ]-()
    WHERE s.value IS NOT NULL AND s.year = y1
    RETURN AVG(toInteger(s.value)) AS avg_ruminants
}

CALL(y1, methane){
    MATCH (met:Residue)
    MATCH (met)-[e:EMISSIONS]-(a:Area)
    WHERE e.gases = methane AND e.value IS NOT NULL AND e.year = y1
    RETURN AVG(toInteger(e.value)) AS AVG_METHANE
}

CALL(y1, ruminants, avg_ruminants, methane, AVG_METHANE){
    MATCH (ani:Animal)
    WHERE ani.name IN ruminants
    MATCH (ani)-[s:STOCKS]-(area:Area)-[e:EMISSIONS]-(r:Residue)
    WHERE s.value IS NOT NULL AND s.value > avg_ruminants AND s.year = y1
    AND e.gases = methane AND e.value > AVG_METHANE
    RETURN area.country as areaName
}


RETURN DISTINCT areaName