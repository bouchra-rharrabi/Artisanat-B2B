-- Initialisation de la base de données artisanat_b2b
CREATE DATABASE IF NOT EXISTS artisanat_b2b;
USE artisanat_b2b;

-- Suppression des tables existantes pour repartir à zéro
DROP TABLE IF EXISTS LigneCommande;
DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS LignePanier;
DROP TABLE IF EXISTS Panier;
DROP TABLE IF EXISTS HistoriqueConsultation;
DROP TABLE IF EXISTS ImageProduit;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Utilisateur;

-- 1. Table Utilisateur
CREATE TABLE Utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom_complet VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'ARTISAN', 'ENTREPRISE') NOT NULL,
    telephone VARCHAR(50),
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    nom_boutique VARCHAR(255) NULL,
    raison_sociale VARCHAR(255) NULL,
    adresse_unique TEXT NULL
);

-- 2. Table Categorie
CREATE TABLE Categorie (
    id_categorie INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description TEXT
);

-- 3. Table Produit
CREATE TABLE Produit (
    id_produit INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description TEXT,
    prix_unitaire DECIMAL(10, 2) NOT NULL,
    quantite_stock INT NOT NULL DEFAULT 0,
    id_artisan INT NOT NULL,
    id_categorie INT NOT NULL,
    FOREIGN KEY (id_artisan) REFERENCES Utilisateur(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_categorie) REFERENCES Categorie(id_categorie) ON DELETE RESTRICT
);

-- 4. Table ImageProduit
CREATE TABLE ImageProduit (
    id_image INT AUTO_INCREMENT PRIMARY KEY,
    url_image VARCHAR(255) NOT NULL,
    id_produit INT NOT NULL,
    FOREIGN KEY (id_produit) REFERENCES Produit(id_produit) ON DELETE CASCADE
);

-- 5. Table Panier
CREATE TABLE Panier (
    id_panier INT AUTO_INCREMENT PRIMARY KEY,
    date_mise_a_jour DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_entreprise INT NOT NULL UNIQUE,
    FOREIGN KEY (id_entreprise) REFERENCES Utilisateur(id_utilisateur) ON DELETE CASCADE
);

-- 6. Table LignePanier
CREATE TABLE LignePanier (
    id_ligne_panier INT AUTO_INCREMENT PRIMARY KEY,
    quantite INT NOT NULL DEFAULT 1,
    id_panier INT NOT NULL,
    id_produit INT NOT NULL,
    FOREIGN KEY (id_panier) REFERENCES Panier(id_panier) ON DELETE CASCADE,
    FOREIGN KEY (id_produit) REFERENCES Produit(id_produit) ON DELETE CASCADE
);

-- 7. Table Commande
CREATE TABLE Commande (
    id_commande INT AUTO_INCREMENT PRIMARY KEY,
    numero_suivi VARCHAR(50) NOT NULL UNIQUE,
    date_commande DATETIME DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('EN_ATTENTE', 'VALIDEE', 'EXPEDIEE', 'ANNULEE') DEFAULT 'EN_ATTENTE',
    montant_total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    chemin_facture_pdf VARCHAR(255),
    id_entreprise INT NOT NULL,
    FOREIGN KEY (id_entreprise) REFERENCES Utilisateur(id_utilisateur) ON DELETE RESTRICT
);

-- 8. Table LigneCommande
CREATE TABLE LigneCommande (
    id_ligne_commande INT AUTO_INCREMENT PRIMARY KEY,
    quantite INT NOT NULL,
    prix_unitaire_applique DECIMAL(10, 2) NOT NULL,
    id_commande INT NOT NULL,
    id_produit INT NOT NULL,
    FOREIGN KEY (id_commande) REFERENCES Commande(id_commande) ON DELETE CASCADE,
    FOREIGN KEY (id_produit) REFERENCES Produit(id_produit) ON DELETE NO ACTION
);

-- 9. Table HistoriqueConsultation
CREATE TABLE HistoriqueConsultation (
    id_historique INT AUTO_INCREMENT PRIMARY KEY,
    date_vue DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_entreprise INT NOT NULL,
    id_produit INT NOT NULL,
    FOREIGN KEY (id_entreprise) REFERENCES Utilisateur(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_produit) REFERENCES Produit(id_produit) ON DELETE CASCADE
);
