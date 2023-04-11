--a)
-- creation de la table competition

CREATE TABLE COMPETITION
(
    CDCOMPET    CHAR(5)         PRIMARY KEY,
    LIBCOMPET   VARCHAR2(50)    NOT NULL,
    DATECOMPET  DATE            DEFAULT TRUNC(SYSDATE),
    PARCOURS    NUMBER          CONSTRAINT val_parcour_incorect CHECK(PARCOURS in (1,2)),
    INDMAX      NUMBER          CONSTRAINT val_indmax_incorect CHECK(0 <= INDMAX AND INDMAX <= 36),
    DROITSINSC  NUMBER(8,2)
);

-- b)
-- insertion dans la table competition
INSERT INTO COMPETITION
VALUES ('TEO1', 'Compet 1', to_date('03/04/2019','DD/MM/YYYY'),1 ,13, 17);

INSERT INTO COMPETITION
VALUES ('TEO2', 'Compet 2', to_date('05/04/2019','DD/MM/YYYY'),2 ,15, 18);

INSERT INTO COMPETITION
VALUES ('TEO3', 'Compet 3', to_date('10/04/2019','DD/MM/YYYY'),2 ,24, 25);

INSERT INTO COMPETITION 
VALUES ('TEO4', 'Compet 4', NULL ,2 ,25, 25);
/*
la date par default n'a pas ete utiliser

/*
INSERT INTO COMPETITION
VALUES ('TEO5', 'Compet 5', to_date('16/04/2019','DD/MM/YYYY'),1 ,45, 14);
il y a une erreur pour celle ci car indMax est sur a 36
*/

INSERT INTO COMPETITION (cdcompet, libcompet, parcours, indmax, droitsinsc)
VALUES ('TEO5', 'Compet 5' ,1 ,13, 17);

-- c)
-- insertion venent d'autre table
INSERT INTO COMPETITION
    SELECT *
    FROM MINIGOLF.COMPETITION;
    
-- d)
-- suppression d'éléments
DELETE 
    FROM COMPETITION
    WHERE upper(cdcompet) LIKE 'TE%';
    
-- e)
-- modification d'éléments
UPDATE COMPETITION
SET droitSinsc = droitSinsc * 1.01
WHERE parcours = 2;

-- Ex 3
-- a)
-- insertion de valeurs
INSERT INTO MONITEUR
VALUES ('M2', 'TORDUE', 'Paul', '20 rue Nationale', 'La NEUVILLETTE', 51100, 'M2', 1, 3);
-- L’intégrité référentielle n'est pas respectée

/* b)
L'erreur est du a la presance d'un elt dans la table qui ne respect pas la contrainte
*/
ALTER TABLE MONITEUR
ADD CONSTRAINT fk_responsable FOREIGN KEY(responsable) REFERENCES MONITEUR(cdmono);

-- c)
-- ajout de moniteur
INSERT INTO MONITEUR (cdmono, nom, prnm, adr, ville, cp, statut, ind)
VALUES ('M1', 'DUMAS', 'Arnaud', '13 Bd Gambetta', 'REIMS', 51100, 1, 3);

-- d)
-- ajout des valeur de personne qui ne sont pas de type 3
-- le select ne fonction pas car il y a plus de champ et en plus ils ne sont pas dans le même ordre 

INSERT INTO MEMBRE
    SELECT cdpers, nom, prnm, adr, ville, cp, tpmemb, nbcoursuivis, ind
    FROM MINIGOLF.PERSONNE
    WHERE tpmemb != 3;
    
-- e)
-- passage des nom en nom maj
UPDATE MEMBRE
SET nom = upper(nom);






