----------- CREATION DES TABLES --------------------

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
    adresse VARCHAR,
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
    heure_debut INTEGER NOT NULL,
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
INSERT INTO Guide VALUES ('1','Nguyen','Uyen','6B Rue Winston Churchill','2018-03-09');
INSERT INTO Guide VALUES ('2','Rabaud','Vincent','50 Rue de Londres','2015-04-19');
INSERT INTO Guide VALUES ('3','Hugh','Jackman','123 Rue de Paris','2019-01-05');
INSERT INTO Guide VALUES ('4','Taylor','Swift','52 Boulevard Victor Hugo','2018-04-03');

-- Guides d'expositions temporaires
INSERT INTO Guide_expo_tmp VALUES ('1','2');
INSERT INTO Guide_expo_tmp VALUES ('3','1');
INSERT INTO Guide_expo_tmp VALUES ('2','2');

-- Créneaux
INSERT INTO Creneau VALUES ('1','4','lun','9');
INSERT INTO Creneau VALUES ('2','1','mer','14');
INSERT INTO Creneau VALUES ('3','2','jeu','10');
INSERT INTO Creneau VALUES ('2','3','mar','15');
INSERT INTO Creneau VALUES ('1','2','lun','15');

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

-------------------------- VUES -------------------------------

-- Liste des peintures acquises par le Louvre
CREATE VIEW v_Peintures_Acquises 
AS SELECT O.titre, O.annee_creation, O.hauteur, O.largeur, OA.prix_acquisition
FROM Oeuvre O INNER JOIN Oeuvre_acquise OA ON O.code = OA.code_oeuvre
WHERE O.type_oeuvre = 'peinture'; 

-- Liste des photographies acquises par le Louvre
CREATE VIEW v_Photographies_Acquises 
AS SELECT O.titre, O.annee_creation, O.hauteur, O.largeur, OA.prix_acquisition
FROM Oeuvre O INNER JOIN Oeuvre_acquise OA ON O.code = OA.code_oeuvre
WHERE O.type_oeuvre = 'photographie'; 

-- Liste des sculptures acquises par le Louvre
CREATE VIEW v_Sculptures_Acquises 
AS SELECT O.titre, O.annee_creation, O.hauteur, O.largeur, O.epaisseur, OA.prix_acquisition
FROM Oeuvre O INNER JOIN Oeuvre_acquise OA ON O.code = OA.code_oeuvre
WHERE O.type_oeuvre = 'sculpture'; 

-- Liste des restaurations des oeuvres :
CREATE VIEW v_Restaurations_Oeuvres 
AS SELECT O.titre, R1.prestataire, R2.date_restaurer, R2.montant
FROM Oeuvre O, Restauration1 R1, Restauration2 R2
WHERE O.code = R1.code_oeuvre
AND R1.numero = R2.numero;

-- Liste des oeuvres exposées dans l'exposition permanente nommée "Exposition de Peintures" :
CREATE VIEW v_Oeuvres_Expo_permanente_de_Peintures (titre_oeuvre)
AS SELECT O.titre 
FROM Oeuvre O, Exposition_permanente EP, Oeuvre_acquise OA
WHERE O.code = OA.code_oeuvre
AND EP.numero = OA.numero_expo
AND EP.nom = 'Exposition de Peintures';

-- Liste des oeuvres exposées dans l'exposition temporaire nommée "Exposition de Photographies du Monde" :
CREATE VIEW v_Oeuvres_Expo_temporaire_de_Photographies_du_Monde (titre_oeuvre, musee_exterieur)
AS SELECT O.titre, OE.musee_exterieur 
FROM Oeuvre O, Exposition_temporaire ET, Oeuvre_empruntee OE
WHERE O.code = OE.code_oeuvre
AND ET.numero = OE.numero_expo
AND ET.nom = 'Exposition de Photographies du Monde';

-- Liste des oeuvres acquises par Louvre qui sont empruntées par des musées extérieurs :
CREATE VIEW v_Pret (titre_oeuvre, musee_exterieur, date_debut, date_fin)
AS SELECT O.titre, P.musee_exterieur, P.date_debut, P.date_fin
FROM Oeuvre O, Pret P
WHERE O.code = P.code_oeuvre;

-- Liste des guides et leurs créneaux pour les expositions permanentes.
CREATE VIEW v_Guides_Expos_Permanentes (nom_guide, prenom_guide, exposition, jour, heure_debut, heure_fin)
AS SELECT G.nom, G.prenom, EP.nom, C.jour, C.heure_debut, C.heure_debut+2
FROM Creneau C, Guide G, Exposition_permanente EP
WHERE C.numero_expo = EP.numero
AND G.id = C.id_guide;

-- Le prix moyen d'acquisition des oeuvre d'une exposition :
CREATE VIEW v_Prix_Acquisition_Moyen (numero_ep, exposition, nombre_oeuvres, prix_acquisition_moyen)
AS SELECT OA.numero_expo, EP.nom, COUNT(OA.numero_expo), AVG(OA.prix_acquisition)
FROM Exposition_permanente EP, Oeuvre_acquise OA
WHERE EP.numero = OA.numero_expo
GROUP BY OA.numero_expo, EP.nom;

-- Le nombre d'expositions effectués par chaque guide :
CREATE VIEW v_Nombre_Creaneaux_Guide (nom_guide, prenom_guide, nombre_creneaux)
AS SELECT G.nom, G.prenom, Count(C.numero_expo)
FROM Guide G, Creneau C
WHERE G.id = C.id_guide
GROUP BY C.id_guide, G.nom, G.prenom;



----------------- GESTION DE DROITS DES UTILISATEURS -------------------------

-- Il y a 3 types d'utilisateurs : Admin, Guide (Employés du Louvre), Public (visiteurs)

CREATE USER Admin;
GRANT ALL PRIVILEGES ON * TO Admin;

CREATE USER Guides;
GRANT SELECT ON Guide, Creneau, Guide_expo_tmp TO Guides;

GRANT SELECT ON Oeuvre, Auteur, Creer, Oeuvre_acquise, Oeuvre_empruntee, Exposition_permanente,
Exposition_temporaire, Salle_expo, Panneau_explicatif TO Public;

