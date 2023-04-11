--a)
-- creation de la table competition

CREATE TABLE COMPETITION
(
    CDCOMPET    CHAR(5)         PRIMARY KEY,
    LIBCOMPET   VARCHAR2(50)    NOT NULL,
    DATECOMPET  DATE            DEFAULT TRUNC SYSDATE,
    PARCOURS    NUMBER          CONSTRAINT val_parcour_incorect CHECK(PARCOURS in (1,2),
    INDMAX      NUMBER          CONSTRAINT val_indmax_incorect CHECK(0<=INDMAX<=36),
    DROITSINSC  NUMBER(8,2)
);

-- b)