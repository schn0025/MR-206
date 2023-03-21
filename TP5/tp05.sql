/*
Schneider Arthur
MR206
TP2
*/

-- R38
SELECT emp.nom || ' ' || emp.prnm AS "Employé"
FROM LOCVEC.employe emp
WHERE extract(YEAR FROM emp.datemb) = (SELECT extract(YEAR FROM sup.datemb)
                                     FROM LOCVEC.employe sup
                                     WHERE emp.cdsup = sup.cdemp);
                                     
-- R39
SELECT emp.qualif AS "Qualification",
       emp.nom || ' ' || emp.prnm AS "Employé",
       emp.salaire AS "Salaire"
FROM LOCVEC.employe emp
WHERE emp.salaire = (SELECT max(maxi.salaire)
                     FROM LOCVEC.employe maxi
                     WHERE maxi.qualif = emp.qualif)
order BY 3 DESC;

-- R40
-- a) jointure
SELECT distinct emp.nom || ' ' || emp.prnm AS "Employé",
       emp.qualif AS "Qualification"
FROM LOCVEC.employe emp
     JOIN LOCVEC.contrat cont ON cont.cdemp = emp.cdemp
WHERE emp.cdsx = '1';

-- b) sous-requête avec IN
SELECT emp.nom || ' ' || emp.prnm AS "Employé",
       emp.qualif AS "Qualification"
FROM LOCVEC.employe emp
WHERE emp.cdemp in (SELECT cdemp
                    FROM LOCVEC.contrat cont)
     AND emp.cdsx = '1';
-- c) sous-requête avec EXISTS
SELECT emp.nom || ' ' || emp.prnm AS "Employé",
       emp.qualif AS "Qualification"
FROM LOCVEC.employe emp
WHERE emp.cdsx = '1'
      AND EXISTS (SELECT NULL
                  FROM LOCVEC.contrat cont
                  WHERE emp.cdemp = cont.cdemp);
                  
-- R41
SELECT vhc.imtrcl AS "Immatriculation",
       round(MONTHS_BETWEEN(sysdate, vhc.datpmc)/12) || ' ' || 'ans' AS "Ancienneté",
       vhc.kmactl AS "Kilométrage"
FROM LOCVEC.vehicule vhc
WHERE EXISTS (SELECT NULL
              FROM LOCVEC.modele m
              WHERE upper(m.marque) in ('OPEL', 'RENAULT', 'PEUGEOT')
                    AND m.cdmdl = vhc.cdmdl)
      AND EXISTS (SELECT NULL
                  FROM LOCVEC.contrat cont
                  WHERE cont.cdvhc = vhc.cdvhc);
              
-- R42
SELECT mdl.marque AS "Modèle",
       cat.intctg AS "Catégorie"
FROM LOCVEC.modele mdl
     JOIN LOCVEC.categorie cat ON cat.cdctg = mdl.cdctg
WHERE NOT EXISTS (SELECT NULL
                  FROM LOCVEC.vehicule vhc
                  WHERE vhc.cdmdl = mdl.cdmdl);

-- R43
-- a) avec des jointures
SELECT DISTINCT cli.nom || ' ' || cli.prnm AS "Client",
       NVL(cli.prfs, 'SANS PROFESSION ') AS "Profession"
FROM LOCVEC.client cli
     JOIN LOCVEC.contrat cont ON cli.cdcli = cont.cdcli
     JOIN LOCVEC.vehicule vhc ON vhc.cdvhc = cont.cdvhc
     JOIN LOCVEC.modele m ON m.cdmdl = vhc.cdmdl
     JOIN LOCVEC.categorie cat ON cat.cdctg = m.cdctg
     JOIN LOCVEC.typeContrat tpCtr ON tpCtr.cdTpCtr = cont.cdTpCtr
WHERE upper(tpCtr.intTpCtr) = 'STANDARD JOUR + KM'
      AND upper(cat.intCtg) = 'STANDARD';
      
-- b) sous-requêtes avec 

SELECT cli.nom || ' ' || cli.prnm AS "Client",
       NVL(cli.prfs, 'SANS PROFESSION ') AS "Profession"
FROM LOCVEC.client cli
WHERE cli.cdcli IN (SELECT cdcli
                    FROM LOCVEC.contrat
                    WHERE cdVhc IN (SELECT cdvhc 
                                    FROM LOCVEC.vehicule
                                    WHERE cdmdl in (SELECT cdmdl
                                                    FROM LOCVEC.modele
                                                    WHERE cdctg IN (SELECT cdctg
                                                                    FROM LOCVEC.categorie
                                                                    WHERE upper(intCtg) = 'STANDARD')))
                    AND cdtpctr IN (SELECT cdtpctr
                                    FROM LOCVEC.typeContrat
                                    WHERE upper(intTpCtr) = 'STANDARD JOUR + KM'));

-- c) sous-requête avec EXISTS
SELECT cli.nom || ' ' || cli.prnm AS "Client",
       NVL(cli.prfs, 'SANS PROFESSION ') AS "Profession"
       FROM LOCVEC.client cli
WHERE  EXISTS (SELECT NULL
                    FROM LOCVEC.contrat cont
                    WHERE cont.cdCli = cli.cdCli
                         AND EXISTS (SELECT NULL
                                     FROM LOCVEC.vehicule vhc
                                     WHERE cont.cdVhc = vhc.cdVhc
                                          AND EXISTS (SELECT NULL
                                                      FROM LOCVEC.modele m
                                                      WHERE m.cdMdl = vhc.cdMdl
                                                            AND EXISTS (SELECT NULL
                                                                        FROM LOCVEC.categorie ctg
                                                                        WHERE ctg.cdCtg = m.cdCtg
                                                                              AND upper(intCtg) = 'STANDARD')))
                    AND EXISTS (SELECT NULL
                                    FROM LOCVEC.typeContrat tpCtr
                                    WHERE tpCtr.cdTpCtr = cont.cdTpCtr
                                          AND upper(intTpCtr) = 'STANDARD JOUR + KM'));

-- R44)
SELECT cli.nom || ' ' || cli.prnm AS "Client"
FROM LOCVEC.client cli
WHERE NOT EXISTS (SELECT NULL
                  FROM LOCVEC.typecontrat tp
                  WHERE NOT EXISTS (SELECT NULL
                                    FROM LOCVEC.contrat cont
                                    WHERE cont.cdcli = cli.cdcli
                                          AND tp.cdtpctr = cont.cdtpctr));
                                          
-- R45)
SELECT level AS "Niveau",
       LPAD(' ',(level-1)*4) || nom || ' ' || prnm AS "Employé",
       qualif AS "Qualification"
FROM LOCVEC.employe
CONNECT BY PRIOR cdEmp =  cdSUP
START WITH cdSup is NULL;

-- R46)
SELECT level AS "Niveau",
       LPAD(' ',(level-1)*4) || nom || ' ' || prnm AS "Employé",
       qualif AS "Qualification"
FROM LOCVEC.employe
WHERE datdpt IS NULL
CONNECT BY PRIOR cdEmp =  cdSUP
START WITH cdSup is NULL;

-- R47) 
SELECT level AS "Niveau",
       LPAD(' ',(level-1)*4) || nom || ' ' || prnm AS "Employé",
       qualif AS "Qualification"
FROM LOCVEC.employe
WHERE datdpt IS NULL
CONNECT BY PRIOR cdEmp =  cdSUP
START WITH upper(qualif) = 'CHEF D''ATELIER';

-- R48)
SELECT level AS "Niveau",
       LPAD(' ',(level-1)*4) || nom || ' ' || prnm AS "Employé",
       qualif AS "Qualification"
FROM LOCVEC.employe
WHERE datdpt IS NULL
      AND cdSx = '2'
CONNECT BY PRIOR cdEmp = cdSUP
START WITH cdSup is NULL;

-- R49)
SELECT level AS "Niveau",
       LPAD(' ',(level-1)*4) || nom || ' ' || prnm AS "Employé",
       qualif AS "Qualification"
FROM LOCVEC.employe
WHERE datdpt IS NULL
      AND cdSup IS NOT NULL
      AND cdEmp NOT IN (SELECT cdEmp
                        FROM LOCVEC.employe
                        WHERE datdpt IS NULL
                        CONNECT BY PRIOR cdEmp =  cdSUP
                        START WITH upper(qualif) = 'CHEF D''ATELIER')
CONNECT BY PRIOR cdEmp =  cdSUP
START WITH cdSup is NULL;

-- R50)
SELECT Lpad(' ' ,4 * (Level - 1)) || nom AS "Employe",
       cdSup , 
       Prior nom "Nom Parent" ,
       Connect_By_Isleaf "Noeud" ,
       Connect_By_Root(nom) "Racine",
       Sys_Connect_By_Path(cdEmp ,':') "Chemin"
FROM LOCVEC.employe
Connect By Nocycle Prior cdEmp = cdSup
Start With cdSup IS NULL
Order Siblings By nom;
       





