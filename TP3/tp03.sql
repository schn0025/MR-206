/*
Schneider Arthur
MR206
TP1
*/

-- R21
SELECT cli.cp AS "Code Postal",
       cli.localite AS "Localité",
       tp.intTpCtr AS "Type Contrat",
       count(cont.cdCtr) AS "Nb contrats"
FROM LOCVEC.contrat cont
     JOIN LOCVEC.typeContrat tp ON tp.cdTpCtr = cont.cdTpCtr
     JOIN LOCVEC.client cli ON cli.cdCli = cont.cdCli
WHERE cp like '51%'
      AND upper(tp.intTpCtr) like '%FORFAIT%'
GROUP BY cli.cp,cli.localite,tp.intTpCtr
ORDER BY 2,3;

-- R22
SELECT nom || ' ' || prnm AS "Employé",
       count(cont.cdCtr) AS "Nb Contrats"
FROM LOCVEC.employe emp
     left JOIN LOCVEC.contrat cont ON emp.cdEmp = cont.cdEmp
WHERE upper(qualif) like '%COMMERCIAL%'
GROUP BY nom, prnm;

-- R23
SELECT intCtg AS "Catégorie",
       marque || '-' || tpMdl AS "Modèle",
       count(cdVhc) AS "nb Véhicules",
       ROUND(AVG(kmActl)) AS "Nb moyen de km"
FROM LOCVEC.vehicule v
     JOIN LOCVEC.modele m ON m.cdMdl = v.cdMdl
     JOIN LOCVEC.categorie cat ON cat.cdctg = m.cdCtg
GROUP BY intCtg, marque, tpMdl
HAVING count(cdVhc) >= 2
ORDER BY 4;

-- R24 
SELECT marque || '-' || tpMdl AS "Modèle",
       imTrcl AS "Immatriculation",
       ROUND(AVG(kmActl)) AS "Nb moyen de km"
FROM LOCVEC.vehicule v
     JOIN LOCVEC.modele m ON m.cdMdl = v.cdMdl
     JOIN LOCVEC.contrat cont ON v.cdVhc = cont.cdVhc
     JOIN LOCVEC.categorie cat ON cat.cdctg = m.cdCtg
WHERE upper(intCtg) like '%MONOSPACE%'
HAVING ROUND(AVG(kmRtr - kmDpt)) > 1000
GROUP BY marque,tpMdl,imTrcl
ORDER BY 3;

-- R25
SELECT marque || '-' || tpMdl AS "Modèle",
       imTrcl AS "Immat",
       count(cdCtr) AS "Nb. Contrats",
       sum(datRtr - datDpt) AS "Nb Jours",
       round(AVG(datRtr - datDpt)) AS "Moy.Jours",
       count(kmRtr - kmDpt) AS "Nb Km",
       round(AVG(kmRtr - kmDpt)) AS "Moy. km"
FROM LOCVEC.contrat cont
     JOIN LOCVEC.vehicule v ON v.cdVhc = cont.cdVhc
     JOIN LOCVEC.modele m ON m.cdMdl = v.cdMdl
WHERE upper(marque) in ('OPEL', 'RENAULT')
HAVING count(cdCtr) > 2
       AND sum(datRtr - datDpt) >= 10
GROUP BY marque, tpMdl, imTrcl;

-- R26
-- a)
SELECT max(count(cdCtr)) AS "Nb. Max de Contrats"
FROM LOCVEC.contrat
GROUP BY cdVhc;

-- b)
SELECT marque || '-' || tpMdl AS "Modèle",
       imTrcl AS "Immatriculation"
FROM LOCVEC.vehicule v
     JOIN LOCVEC.contrat c ON c.cdVhc = v.cdVhc
     JOIN LOCVEC.modele m ON v.cdMdl = m.cdMdl
GROUP BY marque,tpMdl, imTrcl
HAVING  count(cdCtr) = (SELECT max(count(cdCtr)) AS "Nb. Max de Contrats"
                            FROM LOCVEC.contrat
                            GROUP BY cdVhc);
                            
-- R27
SELECT cli.nom || ' ' || cli.prnm AS "Client",
       count(cdCtr) AS "Nb Contrats"
FROM LOCVEC.client cli
    JOIN LOCVEC.contrat co ON cli.cdCli = co.cdCli
HAVING count(cdCtr) > (SELECT AVG(count(cdCtr))
                       FROM LOCVEC.client cli
                           JOIN LOCVEC.contrat co ON cli.cdCli = co.cdCli
                        GROUP BY cli.cdCli)
GROUP BY cli.nom, cli.prnm;

-- R28
-- a) le nombre de catégories de type 1
SELECT count(cdCtg) AS "nb. Catg"
FROM LOCVEC.categorie
WHERE tpVhc = '1';

-- b)
SELECT m.marque AS "Marque",
       count(c.cdCtg) AS "nb. Catg"
FROM LOCVEC.modele m
     JOIN LOCVEC.categorie c ON c.cdCtg = m.cdCtg
WHERE c.tpVhc = '1'
GROUP BY m.marque
ORDER BY 2 desc,1;

-- c)
SELECT m.marque AS "Marque"
FROM LOCVEC.modele m
     JOIN LOCVEC.categorie c ON c.cdCtg = m.cdCtg
WHERE c.tpVhc = '1'
GROUP BY m.marque
HAVING count(c.cdCtg) = (SELECT count(cdCtg)

                        FROM LOCVEC.categorie
                        WHERE tpVhc = '1');

-- R29
SELECT cli.nom || ' ' || cli.prnm AS "Client"
FROM LOCVEC.client cli
     JOIN LOCVEC.contrat cont ON cont.cdCli = cli.cdCli
GROUP BY cli.nom, cli.prnm
HAVING count(distinct cdTpCtr) = (SELECT count(cdTpCtr)
                         FROM LOCVEC.typecontrat);
