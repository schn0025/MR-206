/*
Schneider Arthur
MR206
TP2
*/
-- R11

SELECT count(cdEmp) AS "Nb employés",
       count(datDpt) AS "Nb Partis",
       count(cdEmp) - count(datDpt) AS "Nb présents",
       count(datEmb) AS "Nb Titulaires",
       count(DISTINCT qualif) AS "Nb qualifs"
FROM LOCVEC.employe;

-- R12
SELECT sum(salaire) AS "Somme salaire",
       round(AVG(salaire),2) AS "Moyenne salaire",
       max(salaire) AS "Salaire Max"
FROM LOCVEC.employe
WHERE datEmb is not null;

-- R13
SELECT max(salaire) AS "Salaire Maxi"
FROM LOCVEC.employe;

-- R14
SELECT nom || '-' || prnm AS "Employé le mieux payé",
       qualif AS "Qualification",
       salaire AS "SALAIRE"
FROM LOCVEC.employe
WHERE salaire = (SELECT max(salaire)
                 FROM LOCVEC.employe);

-- R15
SELECT m.marque || ' ' || m.tpMdl AS "Modèle",
       imTrcl AS "Immatriculation"
FROM LOCVEC.vehicule v
     JOIN LOCVEC.modele m ON m.cdMdl = v.cdMdl
WHERE TO_CHAR(datPmc, 'YYYY') = '2005' 
      AND kmActl = (SELECT max(kmActl)
                    From locvec.vehicule
                    where TO_CHAR(datPmc, 'YYYY') = '2005' );
                    
-- R16
SELECT cli.nom || ' ' || cli.prnm AS "client",
       intTpCtr AS "Type contrat",
       marque || ' ' || tpMdl AS "Modèle",
       imTrcl AS "Immatriculation",
       kmRtr - kmDpt AS "Nb km parcourus"
FROM LOCVEC.contrat cont
     JOIN LOCVEC.vehicule v ON v.cdVhc = cont.cdVhc
     JOIN LOCVEC.modele mo ON v.cdMdl = mo.cdMdl
     JOIN LOCVEC.client cli ON cli.cdCli = cont.cdCli
     JOIN LOCVEC.typeContrat tpCont ON cont.cdTpCtr = tpCont.cdTpCtr
WHERE upper(intTpCtr) LIKE '%SEMAINE%'
      AND (kmRtr - kmDpt)= (SELECT max(kmRtr - kmDpt)
                            FROM LOCVEC.contrat cont
                                 JOIN LOCVEC.typeContrat tpCont ON cont.cdTpCtr = tpCont.cdTpCtr
                            WHERE upper(intTpCtr) LIKE '%SEMAINE%');
                            
-- R17
SELECT qualif AS "Qualification",
       count(cdEmp) AS "Nb Employés",
       round(avg(salaire),-2) AS "Salaire Moyen"
FROM LOCVEC.employe
GROUP BY qualif;

--R18
SELECT e.nom || '-' || e.prnm AS "Employé",
       intTpCtr AS "Type contrat",
       count(intTpCtr) AS "Nb Contrats"
FROM LOCVEC.employe e
     JOIN LOCVEC.contrat cont ON e.cdEmp = cont.cdEmp
     JOIN LOCVEC.typeContrat tpCont ON cont.cdTpCtr = tpCont.cdTpCtr
GROUP BY e.nom || '-' || e.prnm, intTpCtr
ORDER BY 1, 3 DESC;

-- R19
SELECT cat.intCtg AS "Catégorie",
       decode(cat.tpvhc,'1', 'Tourisme', '2', 'Utilitaire', '3', 'Exception') AS "Type",
       count(cdMdl) AS "Nb Modèles"
FROM LOCVEC.categorie cat
     JOIN LOCVEC.modele mod ON mod.cdCtg = cat.cdCtg
WHERE marque in ('OPEL', 'PEUGEOT', 'RENAULT')
GROUP BY cat.intCtg, decode(cat.tpvhc,'1', 'Tourisme', '2', 'Utilitaire', '3', 'Exception')
ORDER BY 3 DESC;


