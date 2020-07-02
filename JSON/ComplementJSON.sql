-- Classe Guide

CREATE TABLE Guide (
    id INTEGER PRIMARY KEY,
    nom VARCHAR NOT NULL,
    prenom VARCHAR NOT NULL,
    adresse JSON,
    date_embauche DATE
);

INSERT INTO Guide 
VALUES (
    '1',
    'Nguyen',
    'Uyen',
    '{"numero":"6", "voie":"Winston Churchill", "code_postal":"60200", "ville":"Compiegne"}',
    '2018-03-09'
);

INSERT INTO Guide 
VALUES (
    '2',
    'Rabaud',
    'Vincent',
    '{"numero":"50", "voie":"Rue de Londres", "code_postal":"75008", "ville":"Paris"}',
    '2015-04-19'
);

INSERT INTO Guide 
VALUES (
    '3',
    'Hugh',
    'Jackman',
    '{"numero":"123", "voie":"Rue de Paris", "code_postal":"60200", "ville":"Compiegne"}',
    '2019-01-05'
);

INSERT INTO Guide 
VALUES (
    '4',
    'Taylor',
    'Swift',
    '{"numero":"52", "voie":"Boulevard Victor Hugo", "code_postal":"75000", "ville":"Paris"}',
    '2018-04-03'
);

-- Classe Creneau
CREATE TABLE Creneau (
    numero_expo INTEGER REFERENCES Exposition_permanente(numero),
    id_guide INTEGER REFERENCES Guide(id),
    jour VARCHAR,
    CHECK (jour = 'dim' OR jour = 'lun' OR jour = 'mar' OR jour = 'mer' OR jour = 'jeu' OR jour = 'ven' OR jour = 'sam'),
    heure_debut JSON NOT NULL,
    heure_fin JSON NOT NULL,
    PRIMARY KEY (numero_expo, id_guide)
);

INSERT INTO Creneau 
VALUES (
    '1',
    '4',
    'lun',
    '{"heure":"9", "minute":"30", "seconde":"00"}'
    '{"heure":"11", "minute":"30", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '2',
    '1',
    'mer',
    '{"heure":"8", "minute":"50", "seconde":"00"}'
    '{"heure":"10", "minute":"50", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '3',
    '2',
    'jeu',
    '{"heure":"13", "minute":"15", "seconde":"00"}'
    '{"heure":"15", "minute":"15", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '2',
    '3',
    'mar',
    '{"heure":"16", "minute":"20", "seconde":"00"}'
    '{"heure":"18", "minute":"20", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '1',
    '2',
    'lun',
    '{"heure":"9", "minute":"30", "seconde":"00"}'
    '{"heure":"11", "minute":"30", "seconde":"00"}'
);

CREATE VIEW v_Guides 
AS SELECT G.nom, G.prenom, adresse->>'numero' AS numéro_voie, adresse->>'voie' AS voie,
adresse->>'code_postal' AS code_postal, adresse->>'ville' AS ville
FROM Guide G;

-- Liste des guides et leurs créneaux pour les expositions permanentes.
CREATE VIEW v_Guides_Expos_Permanentes (nom_guide, prenom_guide, exposition, jour, heure_debut, minute_debut, seconde_debut)
AS SELECT G.nom, G.prenom, EP.nom, C.jour, C.heure_debut->>'heure', C.heure_debut->>'minute', C.heure_debut->>'seconde'
FROM Creneau C, Guide G, Exposition_permanente EP
WHERE C.numero_expo = EP.numero
AND G.id = C.id_guide;
