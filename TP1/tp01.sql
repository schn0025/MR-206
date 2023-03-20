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
       TO_char(datctr, 'YYYY') AS "Année Contrat",
       decode(e.cdsx, 1, 'Monsieur',2 ,'Madame') || ' ' || cli.nom AS "Client",
       cli.localite AS "Localité"
FROM LOCVEC.client cli 
    JOIN LOCVEC.contrat cont ON cli.cdcli = cont.cdcli
    JOIN LOCVEC.employe e    ON e.cdEmp = cont.cdEmp
WHERE upper(localite) not like 'REIMS%' AND e.cdsx = 2 and to_char(datctr, 'MM') = '11';

--R2
SELECT nom ||' '|| prnm AS "Client",
      marque || '-' || tpmdl AS "Modèle",
      imtrcl AS "Immatriculation"
FROM LOCVEC.client cli 
    JOIN LOCVEC.contrat c  ON c.cdcli = cli.cdcli
    JOIN LOCVEC.vehicule v ON c.cdvhc = v.cdvhc
    JOIN LOCVEC.modele m   ON m.cdmdl = v.cdmdl
WHERE to_char(datctr, 'MM/YYYY') = '09/2018'
    AND months_between(SYSDATE, datprms) > 120
ORDER BY 2,1;

--R3
--a
SELECT marque|| '-' || tpMdl AS "Modèle",
       imtrcl AS "Immatriculation",
       to_char(datPmc, 'YYYY') AS "Année Mise en circulation"
FROM LOCVEC.vehicule v
     JOIN LOCVEC.modele m ON m.cdMdl = v.cdMdl
     JOIN LOCVEC.categorie c ON c.cdCtg = m.cdCtg
WHERE upper(intCtg) = 'STANDARD'
ORDER BY 3;

--b
SELECT marque|| '-' || tpMdl AS "Modèle",
       imtrcl AS "Immatriculation",
       to_char(datPmc, 'YYYY') AS "Année Mise en circulation"
FROM LOCVEC.vehicule v
     JOIN LOCVEC.modele m ON m.cdMdl = v.cdMdl
WHERE m.cdCtg IN (SELECT cdCtg
                 FROM LOCVEC.categorie
                 WHERE upper(intCtg) = 'STANDARD')
ORDER BY 3;

--R4
-- a
SELECT DISTINCT nom ||' '|| prnm AS "Client",
       DECODE(SUBSTR(CP,1,2),51,'Marne','Autre')AS "departement"
FROM LOCVEC.client cli
     JOIN LOCVEC.contrat c ON c.cdCli = cli.cdCli
     JOIN LOCVEC.typeContrat tp ON tp.cdtpCtr = c.cdTpCtr
WHERE months_between(sysdate,datNs)/12 BETWEEN 50 AND 60
AND upper(intTpCtr) LIKE '%FORFAITAIRE%';

--b
SELECT DISTINCT nom ||' '|| prnm AS "Client",
       DECODE(SUBSTR(CP,1,2),51,'Marne','Autre')AS "departement"
FROM LOCVEC.client cli
     JOIN LOCVEC.contrat c ON c.cdCli = cli.cdCli
WHERE months_between(sysdate,datNs)/12 BETWEEN 50 AND 60
      AND c.cdTpCtr IN ( SELECT cdtpCtr
                         FROM LOCVEC.typeContrat
                         WHERE upper(intTpCtr) LIKE '%FORFAITAIRE%');
                         
-- R5
--a)
SELECT DISTINCT imtrcl AS "Immatriculation",
       months_between(sysdate,datPmc ) AS "Ancienneté",
       kmActl AS "kilométrage"
FROM LOCVEC.vehicule v
     JOIN LOCVEC.modele m  ON m.cdMdl = v.cdMdl 
     JOIN LOCVEC.Contrat c ON c.cdVhc = v.cdVhc
WHERE marque IN ('OPEL', 'RENAULT', 'PEUGEOT');

--b)
SELECT DISTINCT imtrcl AS "Immatriculation",
       months_between(sysdate,datPmc ) AS "Ancienneté",
       kmActl AS "kilométrage"
FROM LOCVEC.vehicule v     
     JOIN LOCVEC.Contrat c ON c.cdVhc = v.cdVhc
WHERE cdMdl IN (SELECT cdMdl
                FROM LOCVEC.modele 
                WHERE marque IN ('OPEL', 'RENAULT', 'PEUGEOT'));
                
--R6
-- je ne sais plus comment faire ajoutre un promptre pour le lefte join.
SELECT intctg AS "Catégorie",
       NVL2(marque ,marque || '-' || tpMdl ,'Pas de model')  AS "Modèle"
FROM LOCVEC.categorie cat
     left JOIN LOCVEC.modele m ON m.cdCtg = cat.cdCtg
WHERE tpvhc = 2;

-- R7
-- a)
SELECT nom ||' '|| prnm AS "Client"
FROM LOCVEC.client cli
     left JOIN LOCVEC.contrat c ON c.cdCli = cli.cdCli
WHERE cdEmp is NULL;
     
-- b)
SELECT nom ||' '|| prnm AS "Client"
FROM LOCVEC.client cli
WHERE cdCli not in (SELECT cdCli
                    FROM LOCVEC.contrat);
                    
-- R8
-- a)
SELECT marque || '-' || tpMdl AS "Modèle",
       intctg AS "Catégorie"
FROM LOCVEC.categorie cat
     JOIN LOCVEC.modele m ON m.cdCtg = cat.cdCtg
     left JOIN LOCVEC.vehicule v ON m.cdMdl = v.cdMdl
WHERE cdVhc is NULL;

-- b)
SELECT marque || '-' || tpMdl AS "Modèle",
       intctg AS "Catégorie"
FROM LOCVEC.categorie cat
     JOIN LOCVEC.modele m ON m.cdCtg = cat.cdCtg
WHERE cdMdl not in (SELECT cdMdl
                    FROM LOCVEC.vehicule);

-- R9
SELECT e.nom ||' '|| e.prnm AS "Employé",
       e.qualif AS "Qualif Employé",
       sup.nom || ' ' || sup.prnm AS "Supérieur",
       sup.qualif AS "Qualif Supérieur"
FROM LOCVEC.employe e
     JOIN LOCVEC.employe sup ON sup.cdEmp = e.cdSup
ORDER BY 2,1;

-- R10
SELECT e.nom ||' '|| e.prnm AS "Employé",
       e.qualif AS "Qualif Employé",
       nvl2(sup.nom, sup.nom || ' ' || sup.prnm, '***') AS "Supérieur",
       nvl(sup.qualif,nvl2(e.datdpt,'Ancien Employe','Directeur de l’agence')) AS "Qualif Supérieur"
FROM LOCVEC.employe e
     left JOIN LOCVEC.employe sup ON sup.cdEmp = e.cdSup;









