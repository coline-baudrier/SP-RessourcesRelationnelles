-- Création de la base de données
CREATE DATABASE IF NOT EXISTS ressources_relationnelles;
USE ressources_relationnelles;

-- Table Utilisateur
CREATE TABLE Utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255),
    mot_de_passe VARCHAR(255),
    nom VARCHAR(255),
    prenom VARCHAR(255),
    date_inscription DATETIME,
    compte_actif BOOLEAN,
    date_derniere_connexion DATETIME,
    role VARCHAR(255)
);

-- Table Catégorie
CREATE TABLE Categorie (
    id_categorie INT AUTO_INCREMENT PRIMARY KEY,
    nom_categorie VARCHAR(255),
    description VARCHAR(255),
    date_creation DATETIME,
    actif BOOLEAN
);

-- Table TypeRessource
CREATE TABLE TypeRessource (
    id_type_ressource INT AUTO_INCREMENT PRIMARY KEY,
    nom_type VARCHAR(255),
    description VARCHAR(255)
);

-- Table TypeRelation
CREATE TABLE TypeRelation (
    id_type_relation INT AUTO_INCREMENT PRIMARY KEY,
    nom_relation VARCHAR(255),
    description VARCHAR(255)
);

-- Table Ressource
CREATE TABLE Ressource (
    id_ressource INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255),
    description VARCHAR(255),
    contenu TEXT,
    date_creation DATETIME,
    date_derniere_modification DATETIME,
    id_createur INT,
    statut VARCHAR(255),
    visibilite VARCHAR(255),
    id_type_ressource INT,
    id_categorie INT
);

-- Table de liaison RessourceTypeRelation
CREATE TABLE RessourceTypeRelation (
    id_ressource INT,
    id_type_relation INT,
    PRIMARY KEY (id_ressource, id_type_relation)
);

-- Table Commentaire
CREATE TABLE Commentaire (
    id_commentaire INT AUTO_INCREMENT PRIMARY KEY,
    contenu TEXT,
    date_creation DATETIME,
    id_utilisateur INT,
    id_ressource INT,
    id_commentaire_parent INT,
    statut_moderation VARCHAR(255)
);

-- Table InteractionRessource
CREATE TABLE InteractionRessource (
    id_interaction INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT,
    id_ressource INT,
    type_interaction VARCHAR(255),
    date_interaction DATETIME,
    details VARCHAR(255)
);

-- Table StatistiqueRessource
CREATE TABLE StatistiqueRessource (
    id_statistique INT AUTO_INCREMENT PRIMARY KEY,
    id_ressource INT,
    type_statistique VARCHAR(255),
    date_enregistrement DATETIME,
    compte INT,
    details VARCHAR(255)
);

-- Insertion des utilisateurs
INSERT INTO Utilisateur (email, mot_de_passe, nom, prenom, date_inscription, compte_actif, role) VALUES
('admin@relation.fr', 'admin123', 'Martin', 'Sophie', '2023-01-15 09:00:00', TRUE, 'super_admin'),
('modo@relation.fr', 'modo123', 'Dupont', 'Pierre', '2023-01-20 10:30:00', TRUE, 'moderateur'),
('jean.dupont@mail.com', 'jean123', 'Dupont', 'Jean', '2023-02-05 14:15:00', TRUE, 'citoyen'),
('marie.durand@mail.com', 'marie123', 'Durand', 'Marie', '2023-02-10 16:45:00', TRUE, 'citoyen'),
('paul.leroy@mail.com', 'paul123', 'Leroy', 'Paul', '2023-03-01 11:20:00', FALSE, 'citoyen');

-- Insertion des catégories
INSERT INTO Categorie (nom_categorie, description, date_creation, actif) VALUES
('Famille', 'Relations familiales et parentales', '2023-01-10 00:00:00', TRUE),
('Couple', 'Conseils pour la vie de couple', '2023-01-10 00:00:00', TRUE),
('Amitié', 'Entretenir et renforcer les amitiés', '2023-01-10 00:00:00', TRUE),
('Professionnel', 'Relations en milieu professionnel', '2023-01-10 00:00:00', TRUE),
('Social', 'Relations sociales et communautaires', '2023-01-10 00:00:00', FALSE);

-- Insertion des types de ressources
INSERT INTO TypeRessource (nom_type, description) VALUES
('Article', 'Contenu rédactionnel informatif'),
('Vidéo', 'Contenu vidéo pédagogique'),
('Fiche pratique', 'Document synthétique avec conseils'),
('Quiz', 'Questionnaire interactif'),
('Témoignage', 'Expérience personnelle partagée');

-- Insertion des types de relations
INSERT INTO TypeRelation (nom_relation, description) VALUES
('Parents-Enfants', 'Relation entre parents et enfants'),
('Conjoints', 'Relation au sein du couple'),
('Frères/Sœurs', 'Relations fraternelles'),
('Amis', 'Relations amicales'),
('Collègues', 'Relations professionnelles'),
('Voisins', 'Relations de voisinage');

-- Insertion des ressources
INSERT INTO Ressource (titre, description, contenu, date_creation, id_createur, statut, visibilite, id_type_ressource, id_categorie) VALUES
('10 conseils pour mieux communiquer en famille', 'Des astuces pour améliorer le dialogue familial', '1. Écoute active... 2. Parlez avec "je"...', '2023-02-15 14:00:00', 1, 'publie', 'public', 1, 1),
('Résoudre les conflits dans le couple', 'Méthodes pour gérer les désaccords', 'Les 5 étapes de la résolution de conflit...', '2023-02-20 16:30:00', 2, 'publie', 'public', 1, 2),
('Quiz: Quel ami êtes-vous?', 'Découvrez votre profil d\'ami', 'Question 1: Lorsqu\'un ami a un problème...', '2023-03-01 10:15:00', 3, 'publie', 'public', 4, 3),
('Mon expérience avec un collègue difficile', 'Témoignage sur une relation professionnelle tendue', 'J\'ai travaillé pendant 2 ans avec un collègue...', '2023-03-05 11:45:00', 4, 'en_attente', 'partage', 5, 4),
('Gérer la jalousie entre frères et sœurs', 'Conseils pour les parents', 'La jalousie est naturelle mais peut être gérée...', '2023-03-10 09:30:00', 1, 'publie', 'public', 3, 1);

-- Liaisons entre ressources et types de relations
INSERT INTO RessourceTypeRelation (id_ressource, id_type_relation) VALUES
(1, 1), (1, 3),  -- Conseils famille pour parents-enfants et frères/sœurs
(2, 2),          -- Conflits couple pour conjoints
(3, 4),          -- Quiz pour amis
(4, 5),          -- Témoignage pour collègues
(5, 1), (5, 3);  -- Jalousie pour parents-enfants et frères/sœurs

-- Insertion des commentaires
INSERT INTO Commentaire (contenu, date_creation, id_utilisateur, id_ressource, statut_moderation) VALUES
('Très utile, merci pour ces conseils!', '2023-02-16 10:00:00', 3, 1, 'approuve'),
('Je ne suis pas d\'accord avec le point 3', '2023-02-17 15:30:00', 4, 1, 'approuve'),
('Ce quiz m\'a beaucoup appris sur moi-même', '2023-03-02 12:45:00', 5, 3, 'approuve'),
('J\'ai vécu une situation similaire...', '2023-03-06 14:20:00', 3, 4, 'en_attente');

-- Réponses aux commentaires
INSERT INTO Commentaire (contenu, date_creation, id_utilisateur, id_ressource, id_commentaire_parent, statut_moderation) VALUES
('Pourriez-vous développer votre désaccord?', '2023-02-17 16:00:00', 1, 1, 2, 'approuve');

-- Insertion des interactions
INSERT INTO InteractionRessource (id_utilisateur, id_ressource, type_interaction, date_interaction) VALUES
(3, 1, 'favori', '2023-02-16 10:05:00'),
(4, 1, 'exploitee', '2023-02-17 15:35:00'),
(3, 3, 'favori', '2023-03-02 12:50:00'),
(5, 2, 'mise_de_cote', '2023-02-25 11:20:00');

-- Insertion des statistiques
INSERT INTO StatistiqueRessource (id_ressource, type_statistique, date_enregistrement, compte) VALUES
(1, 'consultation', '2023-02-16 00:00:00', 15),
(1, 'consultation', '2023-02-17 00:00:00', 23),
(2, 'consultation', '2023-02-21 00:00:00', 8),
(3, 'consultation', '2023-03-02 00:00:00', 42),
(1, 'partage', '2023-02-16 00:00:00', 5),
(3, 'partage', '2023-03-03 00:00:00', 12);