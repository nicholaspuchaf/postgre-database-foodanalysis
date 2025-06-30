// Selecionamos os alimentos mais consumidos pelos brasileiros de acordo com o IBGE (Arroz, feijao e cafe)
// Vamos analisar quais anos o Brasil produziu esse alimentos mais que na media
// E se nesses mesmos anos eles utilizou mais fertilizantes que a media de uso dos anos
// No final retornamos, os anos em que a producao desses alimentos foi maior que a media do historico do Brasil
// E retornamos tambem qual foi a produção desses alimentos em cada ano, e tambem o uso de fertilizantes por alimento

WITH "Rice" as name1, "Beans, dry" as name2, "Coffee, green" as name3

CALL(name1){
    MATCH (f:Food)
    WHERE f.name = name1
    MATCH (f)-[p:PRODUCTION]-(area:Area)
    WHERE p.value IS NOT NULL AND area.country = "Brazil"
    RETURN AVG(toInteger(p.value)) AS AVG_BRAZIL_RICE
}

CALL(name2){
    MATCH (f:Food)
    WHERE f.name = name2
    MATCH (f)-[p:PRODUCTION]-(area:Area)
    WHERE p.value IS NOT NULL AND area.country = "Brazil"
    RETURN AVG(toInteger(p.value)) AS AVG_BRAZIL_BEANS
}

CALL(name3){
    MATCH (f:Food)
    WHERE f.name = name3
    MATCH (f)-[p:PRODUCTION]-(area:Area)
    WHERE p.value IS NOT NULL AND area.country = "Brazil"
    RETURN AVG(toInteger(p.value)) AS AVG_BRAZIL_COFFEE
}

CALL(){
    MATCH (fert:Fertilizer)-[u:USE_PER_AREA]-(area:Area)
    WHERE u.value IS NOT NULL AND area.country = "Brazil"
    RETURN AVG(toInteger(u.value)) AS AVG_FERTILIZER_BRAZIL
}


CALL(name1, name2, name3, AVG_BRAZIL_RICE, AVG_FERTILIZER_BRAZIL, AVG_BRAZIL_BEANS, AVG_BRAZIL_COFFEE){
    MATCH (f1:Food)
    WHERE f1.name = name1
    MATCH (f1)-[p:PRODUCTION]-(area:Area)-[u:USE_PER_AREA]-(fert:Fertilizer)
    WHERE area.country = "Brazil" AND p.value IS NOT NULL AND p.value >  AVG_BRAZIL_RICE  AND p.year = u.year AND u.value > AVG_FERTILIZER_BRAZIL
    
    MATCH (f2:Food)
    WHERE f2.name = name2
    MATCH (f2)-[p2:PRODUCTION]-(area)-[u2:USE_PER_AREA]-()
    WHERE area.country = "Brazil" AND p2.value IS NOT NULL AND p2.value >  AVG_BRAZIL_BEANS  AND p2.year = u2.year AND u2.value > AVG_FERTILIZER_BRAZIL
    AND p.year = p2.year
    
    
    MATCH (f3:Food)
    WHERE f3.name = name3
    MATCH (f3)-[p3:PRODUCTION]-(area)-[u3:USE_PER_AREA]-()
    WHERE area.country = "Brazil" AND p3.value IS NOT NULL AND p3.value >  AVG_BRAZIL_BEANS  AND p3.year = u3.year AND u3.value > AVG_FERTILIZER_BRAZIL
    AND p.year = p3.year
    
    WITH p.year as anos, p.value as rice_prod, p2.value as beans_prod,
    p3.value as coffee_prod, AVG(toInteger(u.value)) as fert_rice, AVG(toInteger(u2.value)) as fert_beans, AVG(toInteger(u3.value)) as fert_coffee
    
    RETURN anos, rice_prod, beans_prod, coffee_prod, fert_rice, fert_beans, fert_coffee
}


RETURN DISTINCT anos, rice_prod, beans_prod, coffee_prod, fert_rice, fert_beans, fert_coffee
ORDER BY anos