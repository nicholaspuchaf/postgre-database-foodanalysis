# postgre-database-foodanalysis

Projeto de MC536 realizado com o Professor Breno Bernard

Grupo: Nicholas Pucharelli Fontanini RA 253769
       Bruno Jambeiro Mesquita RA 260382


# Como utilizar o banco Neo4j para este projeto:

- Primeiro exportamos todas as tabelas do projeto em postgre sql para arquivos CSV por meio dos seguintes comandos executados na pqsl do Postgre

COPY (SELECT * FROM "Production") TO '{your_folder}/csv/Production.csv' WITH CSV header;

COPY (SELECT * FROM "Area_harvest") TO '{your_folder}/csv/Area_harvest.csv' WITH CSV header;

COPY (SELECT * FROM "Food") TO '{your_folder}/csv/Food.csv' WITH CSV header;

COPY (SELECT * FROM "Animals") TO '{your_folder}/csv/Animals.csv' WITH CSV header;

COPY (SELECT * FROM "Stocks") TO '{your_folder}/csv/Stocks.csv' WITH CSV header;

COPY (SELECT * FROM "Fertilizers") TO '{your_folder}/csv/Fertilizers.csv' WITH CSV header;

COPY (SELECT * FROM "Agriculture_use") TO '{your_folder}/csv/Agriculture_use.csv' WITH CSV header;

COPY (SELECT * FROM "Use_per_area") TO '{your_folder}/csv/Use_per_area.csv' WITH CSV header;

COPY (SELECT * FROM "Fertilizer_production") TO '{your_folder}/csv/Fertilizer_production.csv' WITH CSV header;

COPY (SELECT * FROM "Residue") TO '{your_folder}/csv/Residue.csv' WITH CSV header;


Por fim fizemos um JOIN que junta as tabelas Emissions e Gases para quen não seja necessário criar uma relação tripla no grafo,
o que cairia em ter que criar mais de 2mi de Nodes.

COPY (SELECT * FROM "Emissions" JOIN "Gases" on "Emissions".id_gases = "Gases".id_gases ) TO '{your_folder}/csv/Production.csv' WITH CSV header;

- No neo4j, considerando ele instalado localmente e já criado um database vazio.

Depois disso tem que copiar todos esses arquivos para o local /var/lib/neo4j/imports, porque o neo4j por questão de segurança recomenda apenas poder 
importar arquivos csv desta pasta import.

Por fim instalar as dependencias de requirements.txt e rodar o notebook. Irá realizar a inserção de todos os Nodes e Relationships no banco neo4j
rodando localmente.
