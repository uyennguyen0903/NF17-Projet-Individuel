# NOTE DE CLARIFICATION

*Mise à jour : 06/06/2020*

**Projet : Gestion du musée du Louvre**

Le sujet de projet se trouve ici : [Projet 20](https://librecours.net/dawa/projets-2020-II/co/louvre.html)

## Contexte

Le musée du Louvre a besoin d'un système de gestion de ses oeuvres et expositions. Le but de ce projet est de modéliser et d'implémenter une base de données permettant de répondre 
au problème.

## Acteur

**Client de projet:** Chargé de TD VICTORINO Alessandro

**Chargé de projet:** NGUYEN Thi Thu Uyen

## Livrables

- README.md
- Note de clarification (NDC.md)
- Modèle conceptuel de données (MCD) : diagramme UML
- Modèle logique de données (MLD relationnel)
- Base de données (BDD)

## Objectifs du projet

La base de données doit permettre au musée du Louvre de faciliter :
- La gestion des oeuvres.
- La gestion des prêtes des ouvres entre le Louvre et des musées extérieurs (dans un sens ou l'autre).  
- La gestion des expositions du Louvre et des guides.
- Établir des statistiques sur les oeuvres, les prêtes, les expositions.

## La liste des objets gérés

**1. Oeuvre**

Une oeuvre qui est exposée au Louvre possède :
   - Code : entier (clé) 
   - Titre : varchar (non null)
   - Date de création : date
   - Hauteur : entier (non null)
   - Largeur : entier (non null)
   - Épaisseur : entier
   - Un type, qui peut être peinture, sculpture ou photographie

**Remarque :** Il faut tester l'attribut *épaisseur* : s'il est non null c'est une oeuvre de type *peinture* ou *photographie*, sinon c'est une oeuvre de type *sculpture*.

La classe Oeuvre est considère comme abstraite, elle est héritée par las classes "Oeuvre acquise par Louvre" et "Oeuvre empruntée à musée extérieur". Ce héritage est exclusif.

**2. Oeuvre acquise**

Une oeuvre acquise par Louvre possède :
   - Prix d'acquisition : entier (non null)

**3. Oeuvre empruntée**

Une oeuvre empruntée par Louvre à musée extérieur possède :
   - Date de début : date (non null)
   - Date de fin : date (non null)

**4. Auteur**

Un auteur d'une oeuvre possède :
   - Code d'identifiant : entier (clé)
   - Nom : varchar (non null)
   - Prénom : varchar (non null)
   - Date de naissance : date

**5. Prestataire**

Un prestataire possède :
   - Raison sociale : varchar (clé)

**6. Restauration**
 
Une restauration possède :
   - Numéro : entier (unique)
   - Type de restauration : varchar
   - Date : varchar
   - Montant de la prestation : entier

Cette classe est la classe d'association qui est ajoutée à la relation issue des classes "Oeuvre" et "Prestataire".

**7. Musée extérieur**

Un musée extérieur possède :
   - Nom : varchar (clé)
   - Adresse : varchar

**8. Prêt**

Un prêt possède :
   - Date de début : date
   - Date de fin : date

Cette classe est la classe d'association qui est ajoutée à la relation issue des classes "Oeuvre acquise" et "Musée extérieur".

**9. Exposition**

Une exposition possède :
   - Numéro : entier (clé)
   - Nom : varchar (non null)

La classe Exposition est considère comme abstraite, elle est héritée par las classes "Exposition permanente" et "Exposition temporaire". Ce héritage est exclusif.

**10. Exposition permanente**

Une exposition permanente possède :
   - Méthode : prix moyen d'acquisition des oeuvres de l'exposition

**11. Exposition temporaire**

Une exposition temporaire possède :
   - Date de début : date (non null)
   - Date de fin : date (non null)

**12. Panneau explicatif**

Un panneau explicatif possède :
   - Numéro : entier (clé)
   - Texte : texte 

**13. Salle**

Une salle dédiée à une exposition temporaire possède :
   - Numéro : entier (clé)
   - Capacité maximale de visiteurs simultanés : entier

**14. Guide**
 
Une guide possède :
   - Identifiant : int (clé)
   - Nom : varchar (non null)
   - Prénom : varchar (non null)
   - Adresse : varchar 
   - Date d'embauche : date 

**15. Créneau**

Un créneau possède :
   - Jour de la semaine
   - Heure de début : entier (>=8 et <=20)
   - Méthode : Heure de fin (= Heure de début + 2)

Cette classe est la classe d'association qui est ajoutée à la relation issue des classes "Exposition permanente" et "Guide".

## La liste des associations et classes d'association

### Associations

**1. Crée**

L'association Crée entre les classes Auteur et Oeuvre exprime que les auteurs créent des oeuvres.

Cardinalité 1..N : 1..N , un auteur doit créer au moins un oeuvre et une oeuvre peut être crée par au moins un auteur ou par plusieurs auteurs.

**2. Emprunte**

L'association Emprunter entre les classes Oeuvre acquise par louvre et Musée extérieur exprime que les musées extérieurs empruntent des oeuvres au Louvre.

Cardinalité 0..N : 0..N , un musée extérieur peut emprunter plusieurs oeuvres au Louvre (y compris zero) et une oeuvre du Louvre peut être empruntée par plusieurs musées extérieurs (si il n'y a aucun conflict entre les durées de prêts).

**3. Prêt**

L'association Prêt entre les classes Musée extérieur et Oeuvre empruntée exprime que les mussées extérieurs prêtent des oeuvres au Louvre.

Cardinalité 1..1 : 0..N , un musée extérieur peut prêter plusieurs oeuvres au Louvre (y compris zero) et une oeuvre est prêtée par un seul musée extérieur.

**4. Expose**

L'association Expose entre les classes Exposition permanente et Oeuvre acquise (resp. Exposition temporaire et Oeuvre empruntée) exprime que les expositions permanentes (resp. expositions temporaires) exposent des oeuvres acquise (resp. oeuvres empruntées).

Cardinalité 1..1 : 1..* , une exposition peut exposer une ou plusieurs oeuvres et une oeuvre est exposée dans une seule exposition.

**5. Affecte**

L'association Affecte entre les classes Guide et Exposition temporaire exprime que les guides sont affectées aux expositions temporaires.

Cardinalité 1..N : 0..N , une exposition temporaire a au moins un guide et un guide peut être affecté aucune exposition temporaire ou plusieurs.

**6. Est dédiée**

L'association Est dédiée entre les classes Exposition temporaire et Salle d'exposition exprime que salles sont dédiées aux expositions temporaires.

Cardinalité 1..N : 0..N , une exposition temporaire se situe à une ou plusieurs salles et une salle est dédiée à plusieurs expositions (y compris zero) si il n'y a aucun conflict entre les intervalles de temps d'expositions.

**7. Est composée**

L'association Est composée entre les classe Exposition temporaire et Panneau explicatif exprime que expositions temporaires sont composées de panneaux explicatifs.

Cardinalité 1..1 : 1..N , une exposition temporaire est composée de un ou plusieurs panneaux explicatifs, et un panneaux explicatif est dédiée à une seule exposition.

**8. Est situé**

L'association Est situé entre les classes Panneaux explicatifs et Salle d'exposition exprime que panneaux explicatifs sont situés dans salles d'exposition.

Cardinalité 0..N : 1..1 , un panneau explicatif est situé dans une seule salle et une salle peut avoir plusieurs panneaux explicatifs (y compris zero).

### Classes d'association

**1. Restauration**

La classe d'association Restauration est réservée à l'association 0..N : 0..N entre les classes Oeuvre et Prestataire pour but d'ajouter des propriétés d'une restauration d'une oeuvre.

Une oeuvre peut être restaurée plusieurs fois (y compris zero) et un prestataire peut restaurer plusieurs oeuvres (y compris zero).

**2. Prêt**

La classe d'association Prêt est réservée à l'association 0..N : 0..N entre les classe Oeuvre acquise et Musée extérieur pour but d'ajouter des propriétés un prête du Louvre à un musée extérieur.

Une oeuvre acquise par Louvre peut être prêtée par plusieurs musée extérieur (si il n'y a aucun conflict entre les durées de prêts) et un musée extérieur peut emprunter plusieurs oeuvres du Louvre.

**3. Créneau**

La classe d'association Prêt est réservée à l'association 1..N : 1..N entre les classe Exposition permanente et Guide pour but d'ajouter des propriétés d'un créneau.

Une exposition permanente a au moins un guide et un guide est affecté à au moins une exposition permanente.

## Liste des utilisateurs et des fonction que ces utilisateurs pourront effectuer

- Administrateur : Avoir les droits en lecture et écriture sur tous les tables.
- Employés du Louvre : Avoir les droits en lecture sur leurs créneaux de travaille, sur la liste des expositions qu'ils sont effectués.
- Visiteurs : Avoir les droites en lecture sur la liste des oeuvres, et sur la liste des expositions actuelles.

## Passage UML-Relationnel

**Choix des transformation des héritages en relationnel :**

Pour la transformation d'Oeuvre, il faut remarquer que :
   - Classe mère abstraite.
   - Héritage non complet => on exclut a priori l’héritage par la classe mère
   - Associations N:M sur la classe mère => L'héritage par les classes filles est exclu.

On choisirons alors l'héritage par référence.

Pour la transformation d'Exposition, il faut remarquer que :
   - Classe mère abstraite (sans association au niveau de la classe mère).
   - Héritage non complet (associations au niveau de classes fils) => on exclut a priori l’héritage par la classe mère.
   
On choisirons un héritage par les classes filles qui sera plus simple que la solution par référence.

## Prévenir de vues
- Liste des peintures acquises par le Louvre.
- Liste des photographies acquises par le Louvre.
- Liste des sculptures acquises par le Louvre.
- Liste des restaurations des oeuvres.
- Liste des oeuvres exposées dans une exposition temporaire/permanente.
- Liste des oeuvres acquises par Louvre qui sont empruntées par des musées extérieurs.
- Liste des guides et leurs créneaux pour les expositions permanentes.
- Le prix moyen d'acquisition des oeuvre d'une exposition.
- Le nombre de créneaux effectués par chaque guide.

*Les algèbres relationnels sont écrits dans MLD.txt*

## Complément JSON

1. Dans le modèle relationnel précédant, on a considéré que l'attribut *Adresse* de la classe Guide est de type chaîne de caractère. Cependant, on sait que pour un adresse, il contient le numéro, le nom de rue, le code postal et ainsi le nom de ville. Alors, on pourrais modéliser cet attribut au format JSON.

2. Pour la classe créneau, on a considéré que l'attribut *heure_debut, heure_fin* sont de type entier. C'est-à-dire que on a seulement compté heure et on a oublié minutes et secondes. Alors, on pourrais modéliser cet attribut au format JSON.

- *les changements CREATE TABLE, INSERT, CREATE VIEW pour ces deux classes sont stockées dans ComplementJSON.sql*
- *BDD2.sql est la version entière de la base de donnée qui est mise à jour le format JSON pour tous les attributs au-dessus*




