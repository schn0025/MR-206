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
      
-- b) sous-requêtes avec IN
SELECT DISTINCT cli.nom || ' ' || cli.prnm AS "Client",
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

-- b) sous-requête avec EXISTS