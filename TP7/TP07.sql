-- exercice 1
-- a)

CREATE TABLE PARTICIPATION (cdcompet, cdmemb, dateregltcompet)
AS (SELECT *
    FROM MINIGOLF.PARTICIPER);
    
-- b)
-- On peux voir qu'il manque des contrainte