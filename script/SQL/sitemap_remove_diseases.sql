-- SELECT CONCAT('http://nectarmutation.org/main/search/disease/',t1.disease)
SELECT CONCAT('Disallow: /main/search/disease/',t1.disease)
FROM UNIPROT.`DistinctDiseases` t1
JOIN UNIPROT_DEVEL.`DistinctDiseases` t2 ON t1.`disease_abr`=t2.`disease_abr`
WHERE t1.`disease`!=t2.`disease`
