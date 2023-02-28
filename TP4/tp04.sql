/*
Schneider Arthur
MR206
TP2
*/

-- R30
-- union
SELECT cli.nom || ' ' || cli.prnm AS "Client",
       cli.prfs AS "Profession"
FROM LOCVEC.client cli
WHERE cli.prfs like (SELECT prfs
                  FROM LOCVEC.client cli
                  WHERE cli.prnm || ' ' || cli.nom = 'Marcelle LECOMTE')             
UNION
SELECT cli.nom || ' ' || cli.prnm,
       cli.prfs
FROM LOCVEC.client cli
WHERE cli.prfs IS NULL
ORDER BY 1;

-- Jointures
SELECT cli.nom || ' ' || cli.prnm AS "Client",
       NVL(cli.prfs, '(null)') AS "Profession"
FROM LOCVEC.client cli
     left JOIN LOCVEC.client ml ON ml.prfs = cli.prfs
WHERE ml.prnm || ' ' || ml.nom = 'Marcelle LECOMTE'
      OR cli.prfs IS NULL
ORDER BY 1;

-- R31
SELECT e.nom || ' ' || e.prnm AS "Personne",
       e.datns AS "Date de Naissance",
       e.qualif AS "Profession",
       'Employe' AS "Statut"
FROM LOCVEC.employe e
WHERE TO_CHAR(e.datns, 'YYYY') < '1960'
UNION
SELECT cli.nom || ' ' || cli.prnm,
       cli.datns,
       cli.prfs,
       'client'
FROM LOCVEC.client cli
WHERE cli.datns < TO_DATE(1960, 'YYYY')
ORDER BY 3,2;

-- R32
SELECT m.marque || ' ' || m.tpmdl AS "Modèle",
       c.intctg AS "catégorie"
FROM LOCVEC.modele m
     JOIN LOCVEC.categorie c ON c.cdctg = m.cdctg
MINUS
SELECT m.marque || ' ' || m.tpmdl,
       c.intctg
FROM LOCVEC.modele m
     JOIN LOCVEC.categorie c ON c.cdctg = m.cdctg
     JOIN LOCVEC.vehicule v ON v.cdmdl = m.cdmdl;

-- R33
-- jointure
SELECT e.nom || ' ' || e.prnm AS "Employé"
FROM LOCVEC.employe e
     left JOIN LOCVEC.contrat c ON c.cdEmp = e.cdEmp
WHERE c.cdEmp IS NULL
      AND upper(e.qualif) = 'COMMERCIAL';
      
-- sous-requête
SELECT e.nom || ' ' || e.prnm AS "Employé"
FROM LOCVEC.employe e
WHERE upper(e.qualif) = 'COMMERCIAL'
      AND e.cdEmp NOT IN (SELECT cdEmp
                          FROM LOCVEC.contrat);

--Opérateur ensemblite
SELECT e.nom || ' ' || e.prnm AS "Employé"
FROM LOCVEC.employe e
WHERE upper(e.qualif) = 'COMMERCIAL'
MINUS
SELECT e.nom || ' ' || e.prnm AS "Employé"
FROM LOCVEC.employe e
     JOIN LOCVEC.contrat c ON c.cdEmp = e.cdEmp;
     
-- R34
SELECT qualif AS "Prefession"
FROM LOCVEC.employe
INTERSECT
SELECT prfs
FROM LOCVEC.client;

-- R35
SELECT tpc.intTpCtr AS "Type de contrat",
       'Tarif Base' AS "Type de prix",
       t.tarif_Base AS "Tarif"
FROM LOCVEC.Tarif t
     JOIN LOCVEC.typeContrat tpc ON tpc.cdTpCtr = t.cdTpCtr
WHERE t.cdCtg = 'A'
UNION
SELECT tpc.intTpCtr ,
       'Tarif km' ,
       t.tarif_km
FROM LOCVEC.Tarif t
     JOIN LOCVEC.typeContrat tpc ON tpc.cdTpCtr = t.cdTpCtr
WHERE t.cdCtg = 'A'
UNION
SELECT tpc.intTpCtr,
       'Tarif Option',
       t.tarif_CA + t.tarif_Arf + t.tarif_Atm 
FROM LOCVEC.Tarif t
     JOIN LOCVEC.typeContrat tpc ON tpc.cdTpCtr = t.cdTpCtr
WHERE t.cdCtg = 'A';

-- R36
-- avec jointure
SELECT m.marque || ' ' || m.tpMdl
FROM LOCVEC.modele m
     JOIN LOCVEC.modele ren ON ren.cdCtg = m.cdCtg
     JOIN LOCVEC.modele cli ON cli.cdCtg = m.cdCtg
WHERE upper(ren.marque) = 'RENAULT'
      AND upper(cli.tpMdl) = 'CLIO';
      
-- avec sous-requête
SELECT m.marque || ' ' || m.tpMdl
FROM LOCVEC.modele m
     JOIN LOCVEC.modele ren ON ren.cdCtg = m.cdCtg
     JOIN LOCVEC.modele cli ON cli.cdCtg = m.cdCtg
WHERE m.cdCtg in (SELECT cdCtg
                  FROM LOCVEC.modele
                  WHERE upper(ren.marque) = 'RENAULT')
      AND m.cdCtg in (SELECT cdCtg
                      FROM LOCVEC.modele
                      WHERE upper(cli.tpMdl) = 'CLIO');
      





