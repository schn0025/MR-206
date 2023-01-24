/*
Schneider Arthur
MR206
TP1
*/
-- Exercices 1
SELECT cdctg, intctg
FROM LOCVEC.categorie;

-- Exercices 2
SELECT nom ||' '|| prnm AS "Client"
FROM LOCVEC.client
WHERE upper(localite) LIKE '%REIMS%'
ORDER BY nom;

SELECT marque AS "Marque",
       tpmdl  AS "Type Model",
       imtrcl AS "Immatriculation",
       kmactl AS "Kilométrage actuel"
FROM LOCVEC.vehicule v JOIN
     LOCVEC.modele m ON v.cdmdl = m.cdmdl
WHERE kmactl > 90000;

--Exercices 3