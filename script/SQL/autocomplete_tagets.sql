SELECT "<Autocompletions>"
UNION
SELECT CONCAT(' <Autocompletion term=\"',hgnc,'\" TYPE=\"1\"/>') FROM NECTAR.DistinctGenes
-- UNION
-- SELECT CONCAT(' <Autocompletion term=\"',disease,'\" TYPE=\"1\"/>') FROM UNIPROT.`DistinctDiseases`
UNION
SELECT "</Autocompletions>"
