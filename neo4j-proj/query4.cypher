// Selecionamos os gases do efeito estufa que são mais prejudiciais, e os fertilizantes cujas producoes emitem mais desses gases
// Os gases são : Emissions (CO2), Emissions (CO2eq) from N2O (AR5), Emissions (N2O), Indirect emissions (N2O)
// Os fertilizantes são : Nutrient nitrogen N
// Nao vamos analisar os fertilizantes a base de Potassio e Fosforo, porque eles emitem bem pouco gas estufa
// Producao de fertilizantes sao 3% de todos gas estufa produzido
// Vamos analisar quais paises mais emitiram Co2 e N20 no ano de 2021
// Vamos analisar quais paises mais produziram fertilizantes nesse mesmo ano de 2021
// Vamos cruzar esses paises, e averiguar a relacao entre maior producao desses gases e maior producao de fertilizantes
// No final vamos retornar os paises, bem como a quantidade emitidade de cada gas, e quantidade de cada fertilizante produzido

WITH "Nutrient nitrogen N (total)" as fertilizant,
 "Emissions (CO2)" as gas1, 
 "Emissions (CO2eq) from N2O (AR5)" as gas2,
 "Emissions (N2O)" as gas3,
 "Indirect emissions (N2O)" as gas4,
  2021 as year


CALL(fertilizant, year){
    MATCH (f:Fertilizer)
    WHERE f.name = fertilizant
    MATCH (f)-[p:FERTILIZER_PRODUCTION]-(area:Area)
    WHERE p.value IS NOT NULL AND p.year = year
    RETURN AVG(toInteger(p.value)) AS AVG_FERTILIZANT_PRODUCTION
}

CALL(gas1, year){
    MATCH (r:Residue)-[e:EMISSIONS]-(area:Area)
    WHERE e.value IS NOT NULL AND e.year = year AND e.gases = gas1
    RETURN AVG(toInteger(e.value)) AS AVG_GAS1_EMIT
}

CALL(gas2, year){
    MATCH (r:Residue)-[e:EMISSIONS]-(area:Area)
    WHERE e.value IS NOT NULL AND e.year = year AND e.gases = gas2
    RETURN AVG(toInteger(e.value)) AS AVG_GAS2_EMIT
}

CALL(gas3, year){
    MATCH (r:Residue)-[e:EMISSIONS]-(area:Area)
    WHERE e.value IS NOT NULL AND e.year = year AND e.gases = gas3
    RETURN AVG(toInteger(e.value)) AS AVG_GAS3_EMIT
}

CALL(gas1, gas2, gas3, fertilizant, AVG_FERTILIZANT_PRODUCTION, AVG_GAS1_EMIT, AVG_GAS2_EMIT, AVG_GAS3_EMIT, year){
  MATCH (f:Fertilizer)-[f_p:FERTILIZER_PRODUCTION]-(area:Area)
  WHERE f_p.value IS NOT NULL AND f_p.year = year 

  MATCH (area)-[emi1:EMISSIONS]-(r:Residue)
  WHERE emi1.year = year AND emi1.value IS NOT NULL AND emi1.gases = gas1 //AND emi1.value > AVG_GAS1_EMIT

  MATCH (area)-[emi2:EMISSIONS]-(r1:Residue)
  WHERE emi2.year = year AND emi2.value IS NOT NULL AND emi2.gases = gas2 //AND emi2.value > AVG_GAS2_EMIT

  MATCH (area)-[emi3:EMISSIONS]-(r2:Residue)
  WHERE emi3.year = year AND emi3.value IS NOT NULL AND emi3.gases = gas3 //AND emi3.value > AVG_GAS3_EMIT

  WITH area.country as country, AVG(toInteger(emi1.value)) as gas1_prod, AVG(toInteger(emi2.value)) as gas2_prod, AVG(toInteger(emi3.value)) as gas3_prod,
  AVG(toInteger(f_p.value)) as fert_prod

  WHERE fert_prod > AVG_FERTILIZANT_PRODUCTION 
  AND gas1_prod > AVG_GAS1_EMIT
  AND gas2_prod > AVG_GAS2_EMIT
  AND gas3_prod > AVG_GAS3_EMIT

  RETURN country, gas1_prod, gas2_prod, gas3_prod, fert_prod, year as years
}

// RETURN AVG_FERTILIZANT_PRODUCTION, AVG_GAS1_EMIT, AVG_GAS2_EMIT, AVG_GAS3_EMIT

RETURN DISTINCT country, gas1_prod, gas2_prod, gas3_prod, fert_prod, years
ORDER BY country