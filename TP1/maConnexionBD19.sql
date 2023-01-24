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
--R1

SELECT e.nom ||' '|| e.prnm AS "Employé",
       TO_char(datctr, "YYYY") AS "Année Contrat",
       decode(cdsx,1,"Monsieur",2,"Madame")||' '||cli.nom AS "Client",
       cli.localite AS "Localité"
FROM LOCVEC.client cli 
    JOIN LOCVEC.contrat cont ON cli.cdcli = cont.cdcli,
    JOIN LOCVEC.employe e ON e.cdEmp = cont.cdEmp
WHERE upper(localite) not like 'REIMS%' AND e.cdex = 2 and to_char(datectr, "MM") = 11;