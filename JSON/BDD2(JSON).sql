-- BDD2 est la version complète de la base de donnée 
-- qui est mise à jour le format JSON pour quelques attributs


------------------CREATIONS DE TABLES------------------------
CREATE TABLE Oeuvre (
    code INTEGER PRIMARY KEY,
    titre VARCHAR NOT NULL,
    annee_creation INTEGER,
    hauteur INTEGER NOT NULL,
    largeur INTEGER NOT NULL,
    epaisseur INTEGER,
    type_oeuvre VARCHAR,
    CHECK (type_oeuvre = 'peinture' OR type_oeuvre = 'sculpture' OR type_oeuvre = 'photographie'),
    CHECK (((type_oeuvre = 'peinture' OR type_oeuvre = 'photographie') AND epaisseur IS NULL)
       OR (type_oeuvre = 'sculpture' AND epaisseur IS NOT NULL))
);

CREATE TABLE Auteur (
    id INTEGER PRIMARY KEY,
    nom VARCHAR NOT NULL,
    prenom VARCHAR NOT NULL,
    date_naissance DATE
);

CREATE TABLE Creer (
    auteur_id INTEGER REFERENCES Auteur(id),
    code_oeuvre INTEGER REFERENCES Oeuvre(code),
    PRIMARY KEY (auteur_id, code_oeuvre)
);

CREATE TABLE Prestataire (
    raison_sociale VARCHAR PRIMARY KEY
);

CREATE TABLE Restauration2 (
    numero INTEGER PRIMARY KEY,
    type_restaurer VARCHAR,
    date_restaurer DATE,
    montant INTEGER
);

CREATE TABLE Restauration1 (
    code_oeuvre INTEGER REFERENCES Oeuvre(code),
    prestataire VARCHAR REFERENCES Prestataire(raison_sociale),
    numero INTEGER NOT NULL REFERENCES Restauration2(numero),
    PRIMARY KEY (code_oeuvre, prestataire)
);

CREATE TABLE Musee_exterieur (
    nom VARCHAR PRIMARY KEY,
    adresse VARCHAR
);


CREATE TABLE Exposition_permanente (
    numero INTEGER PRIMARY KEY,
    nom VARCHAR NOT NULL
);

CREATE TABLE Exposition_temporaire (
    numero INTEGER PRIMARY KEY,
    nom VARCHAR NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    CHECK (DATE(date_debut) <= DATE(date_fin))
);

CREATE TABLE Oeuvre_acquise (
    code_oeuvre INTEGER REFERENCES Oeuvre(code),
    prix_acquisition INTEGER,
    numero_expo INTEGER NOT NULL REFERENCES Exposition_permanente(numero),
    PRIMARY KEY (code_oeuvre)
);

CREATE TABLE Oeuvre_empruntee(
    code_oeuvre INTEGER REFERENCES Oeuvre(code),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    musee_exterieur VARCHAR NOT NULL REFERENCES Musee_exterieur(nom),
    numero_expo INTEGER NOT NULL REFERENCES Exposition_temporaire(numero),
    PRIMARY KEY (code_oeuvre),
    CHECK (DATE(date_debut) <= DATE(date_fin))
);

CREATE TABLE Pret (
    code_oeuvre INTEGER REFERENCES Oeuvre_acquise(code_oeuvre),
    musee_exterieur VARCHAR REFERENCES musee_exterieur(nom),
    date_debut DATE  NOT NULL,
    date_fin DATE NOT NULL,
    PRIMARY KEY (code_oeuvre, musee_exterieur),
    CHECK (DATE(date_debut) <= DATE(date_fin))
);

CREATE TABLE Guide (
    id INTEGER PRIMARY KEY,
    nom VARCHAR NOT NULL,
    prenom VARCHAR NOT NULL,
    adresse JSON,
    date_embauche DATE
);

CREATE TABLE Guide_expo_tmp (
    id_guide INTEGER REFERENCES Guide(id),
    numero_expo INTEGER REFERENCES Exposition_temporaire(numero),
    PRIMARY KEY (id_guide, numero_expo)
);

CREATE TABLE Creneau (
    numero_expo INTEGER REFERENCES Exposition_permanente(numero),
    id_guide INTEGER REFERENCES Guide(id),
    jour VARCHAR,
    CHECK (jour = 'dim' OR jour = 'lun' OR jour = 'mar' OR jour = 'mer' OR jour = 'jeu' OR jour = 'ven' OR jour = 'sam'),
    heure_debut JSON NOT NULL,
    heure_fin JSON NOT NULL,
    PRIMARY KEY (numero_expo, id_guide)
);

CREATE TABLE Salle_expo (
    numero INTEGER PRIMARY KEY,
    capacite_max INTEGER
);

CREATE TABLE Reservation_salle (
    numero_expo INTEGER REFERENCES Exposition_temporaire(numero),
    salle INTEGER REFERENCES Salle_expo(numero),
    PRIMARY KEY (numero_expo, salle)
);

CREATE TABLE Panneau_explicatif (
    numero INTEGER PRIMARY KEY,
    texte TEXT,
    numero_expo INTEGER NOT NULL REFERENCES Exposition_temporaire(numero),
    salle INTEGER NOT NULL REFERENCES Salle_expo(numero)
);

--------------------- AJOUT DE VALEURS --------------------------

--Oeuvres
INSERT INTO Oeuvre VALUES ('1','La Joconde','1519','77','53',NULL,'peinture');
INSERT INTO Oeuvre VALUES ('2','Saint Apolline','1636','134','67',NULL,'peinture');
INSERT INTO Oeuvre VALUES ('3','Portrait de Francis George Hare','1789','107','93',NULL,'peinture');
INSERT INTO Oeuvre VALUES ('4','Fontaine de Diane','1560','211','258','134','sculpture');
INSERT INTO Oeuvre VALUES ('5','Buste de princesse','1468','44','44','24','sculpture');
INSERT INTO Oeuvre VALUES ('6','Annonciation','1480','98','217',NULL,'peinture');
INSERT INTO Oeuvre VALUES ('7','Les danses à Bali','1954','30','50',NULL,'photographie');
INSERT INTO Oeuvre VALUES ('8','Portrait de Miss Mary Pelham','1757','80','52',NULL,'peinture');
INSERT INTO Oeuvre VALUES ('9','Capitaine Robert Orme','1756','239','147',NULL,'peinture');
INSERT INTO Oeuvre VALUES ('10','The Steerage','1915','45','45',NULL,'photographie');
INSERT INTO Oeuvre VALUES ('11','Starving Child and Vulture','1993','30','45',NULL,'photographie');

-- Auteurs
INSERT INTO Auteur VALUES ('1','De Vinci','Léonard','1452-04-15');
INSERT INTO Auteur VALUES ('2','Zurbaran','Francisco','1598-11-7');
INSERT INTO Auteur VALUES ('3','Reynolds','Joshua','1723-07-17');
INSERT INTO Auteur VALUES ('4','Goujon','Jean',NULL);
INSERT INTO Auteur VALUES ('5','Laurana','Francesco',NULL);
INSERT INTO Auteur VALUES ('6','Cartier-Bresson', 'Henri','1908-08-22');
INSERT INTO Auteur VALUES ('7','Stieglitz','Alfred','1874-01-01');
INSERT INTO Auteur VALUES ('8','Carter','Kevin','1960-09-13');


-- Créer
INSERT INTO Creer VALUES ('1','1');
INSERT INTO Creer VALUES ('1','6');
INSERT INTO Creer VALUES ('2','2');
INSERT INTO Creer VALUES ('3','3');
INSERT INTO Creer VALUES ('3','8');
INSERT INTO Creer VALUES ('3','9');
INSERT INTO Creer VALUES ('4','4');
INSERT INTO Creer VALUES ('5','5');
INSERT INTO Creer VALUES ('6','7');
INSERT INTO Creer VALUES ('7','10');
INSERT INTO Creer VALUES ('8','11');

-- Musées extérieurs
INSERT INTO Musee_exterieur VALUES ('Galerie des Offices de Florence','Florence-Italy');
INSERT INTO Musee_exterieur VALUES ('Dallas Museum of Art','Texas-États-Unis');
INSERT INTO Musee_exterieur VALUES ('National Gallery','Londres-Royaume-Uni');
INSERT INTO Musee_exterieur VALUES ('Galerie de New York','Etats-Unis');

-- Expositions permanentes
INSERT INTO Exposition_permanente VALUES ('1','Exposition de Peintures');
INSERT INTO Exposition_permanente VALUES ('2','Exposition de Sculptures');
INSERT INTO Exposition_permanente VALUES ('3','Exposition de Photographies');

-- Expositions temporaire
INSERT INTO Exposition_temporaire VALUES ('1','Exposition de Peintures du Monde','2020-01-01','2020-03-09');
INSERT INTO Exposition_temporaire VALUES ('2','Exposition de Photographies du Monde','2019-01-26','2019-05-26');

-- Oeuvres acquises par Louvre
INSERT INTO Oeuvre_acquise VALUES ('1','450300000','1');
INSERT INTO Oeuvre_acquise VALUES ('2','1800000','1');
INSERT INTO Oeuvre_acquise VALUES ('3','1650000','1');
INSERT INTO Oeuvre_acquise VALUES ('4','5900000','2');
INSERT INTO Oeuvre_acquise VALUES ('5','3500000','2');
INSERT INTO Oeuvre_acquise VALUES ('7','805000','3');

-- Oeuvres empruntées aux musées extérieurs 
INSERT INTO Oeuvre_empruntee VALUES ('6','2020-02-01','2020-03-01','Galerie des Offices de Florence','1');
INSERT INTO Oeuvre_empruntee VALUES ('8','2020-01-05','2020-03-05','Dallas Museum of Art','1');
INSERT INTO Oeuvre_empruntee VALUES ('9','2020-03-03','2020-04-09','National Gallery','1');
INSERT INTO Oeuvre_empruntee VALUES ('10','2019-03-02','2019-05-05','Galerie de New York','2');
INSERT INTO Oeuvre_empruntee VALUES ('11','2019-02-02','2020-02-02','Galerie de New York','2');

-- Prêts
INSERT INTO Pret VALUES ('2','Dallas Museum of Art','2018-05-05','2019-05-05');
INSERT INTO Pret VALUES ('7','Galerie de New York','2020-01-01','2020-03-03');

-- Guides
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

-- Guides d'expositions temporaires
INSERT INTO Guide_expo_tmp VALUES ('1','2');
INSERT INTO Guide_expo_tmp VALUES ('3','1');
INSERT INTO Guide_expo_tmp VALUES ('2','2');

-- Créneaux

INSERT INTO Creneau 
VALUES (
    '1',
    '4',
    'lun',
    '{"heure":"9", "minute":"30", "seconde":"00"}',
    '{"heure":"11", "minute":"30", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '2',
    '1',
    'mer',
    '{"heure":"8", "minute":"50", "seconde":"00"}',
    '{"heure":"10", "minute":"50", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '3',
    '2',
    'jeu',
    '{"heure":"13", "minute":"15", "seconde":"00"}',
    '{"heure":"15", "minute":"15", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '2',
    '3',
    'mar',
    '{"heure":"16", "minute":"20", "seconde":"00"}',
    '{"heure":"18", "minute":"20", "seconde":"00"}'
);

INSERT INTO Creneau 
VALUES (
    '1',
    '2',
    'lun',
    '{"heure":"9", "minute":"30", "seconde":"00"}',
    '{"heure":"11", "minute":"30", "seconde":"00"}'
);
-- Salles d'exposition
INSERT INTO Salle_expo VALUES ('1','50');
INSERT INTO Salle_expo VALUES ('2','150');
INSERT INTO Salle_expo VALUES ('3','75');
INSERT INTO Salle_expo VALUES ('4','100');

-- Réservations de salles
INSERT INTO Reservation_salle VALUES ('1','2');
INSERT INTO Reservation_salle VALUES ('1','4');
INSERT INTO Reservation_salle VALUES ('2','3');

-- Panneaux explicatifs
INSERT INTO Panneau_explicatif VALUES ('1','Bienvenue à l_exposition temporaire','1','4');
INSERT INTO Panneau_explicatif VALUES ('2','Bienvenue à l_exposition temporaire','1','2');
INSERT INTO Panneau_explicatif VALUES ('3','Bienvenue à l_exposition temporaire','2','3');

-- Prestataires
INSERT INTO Prestataire VALUES ('Entreprise ABC');
INSERT INTO Prestataire VALUES ('Entreprise 123');

-- Restaurations 1
INSERT INTO Restauration2 VALUES ('1','xxx','2001-05-05','500000');
INSERT INTO Restauration2 VALUES ('2','yyy','2005-01-01','250000');

-- Restaurations 2
INSERT INTO Restauration1 VALUES ('1','Entreprise 123','1');
INSERT INTO Restauration1 VALUES ('4','Entreprise ABC','2');


-------------------------VUES----------------------------------
-- Liste des guides

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

