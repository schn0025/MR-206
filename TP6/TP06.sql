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

