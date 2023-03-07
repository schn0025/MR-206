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






