-- Création de la base de données
CREATE DATABASE kpi_ventes;
\c kpi_ventes;

-- Table Dimension : Pays
CREATE TABLE Pays (
    id_pays SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

-- Table Dimension : Vendeur (Commercial)
CREATE TABLE Vendeur (
    id_vendeur SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    id_pays INT REFERENCES Pays(id_pays)
);

-- Table Dimension : Client
CREATE TABLE Client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    id_pays INT REFERENCES Pays(id_pays),
    groupe_client VARCHAR(100) NOT NULL CHECK (groupe_client IN ('Particulier', 'Entreprise', 'Grand compte'))
);

-- Table Dimension : Commande
CREATE TABLE Commande (
    id_commande SERIAL PRIMARY KEY,
    id_client INT REFERENCES Client(id_client),
    id_vendeur INT REFERENCES Vendeur(id_vendeur),
    montant DECIMAL(10,2) NOT NULL,
    date_commande DATE NOT NULL
);

-- Table de Faits : Nombre total de commandes par commerciale (par an)
CREATE TABLE FaitsCommandesCommerciale (
    id_fait SERIAL PRIMARY KEY,
    id_vendeur INT REFERENCES Vendeur(id_vendeur),
    annee INT NOT NULL,
    total_commandes INT NOT NULL
);

-- Table de Faits : Nombre total de commandes passées sur une période donnée
CREATE TABLE FaitsNombreCommandes (
    id_fait SERIAL PRIMARY KEY,
    periode DATE NOT NULL,
    total_commandes INT NOT NULL
);

-- Table de Faits : Répartition des clients par pays
CREATE TABLE FaitsClientsParPays (
    id_fait SERIAL PRIMARY KEY,
    id_pays INT REFERENCES Pays(id_pays),
    total_clients INT NOT NULL
);

-- Table de Faits : Répartition des clients par groupe (Particulier, Entreprise, Grand compte)
CREATE TABLE FaitsClientsParGroupe (
    id_fait SERIAL PRIMARY KEY,
    groupe_client VARCHAR(100) NOT NULL CHECK (groupe_client IN ('Particulier', 'Entreprise', 'Grand compte')),
    total_clients INT NOT NULL
);

-- Table de Faits : Nombre total de clients (taille de la base de données)
CREATE TABLE FaitsTotalClients (
    id_fait SERIAL PRIMARY KEY,
    date_reference DATE NOT NULL,
    total_clients INT NOT NULL
);

-- Table de Faits : Cycle de vie des clients
CREATE TABLE FaitsCycleVieClients (
    id_fait SERIAL PRIMARY KEY,
    id_client INT REFERENCES Client(id_client),
    date_premiere_commande DATE NOT NULL,
    date_derniere_commande DATE NOT NULL,
    duree_relation INT GENERATED ALWAYS AS (DATE_PART('year', date_derniere_commande) - DATE_PART('year', date_premiere_commande)) STORED
);

-- Index pour optimiser les performances des requêtes
CREATE INDEX idx_vendeur_annee ON FaitsCommandesCommerciale(id_vendeur, annee);
CREATE INDEX idx_periode ON FaitsNombreCommandes(periode);
CREATE INDEX idx_pays ON FaitsClientsParPays(id_pays);
CREATE INDEX idx_groupe_client ON FaitsClientsParGroupe(groupe_client);
CREATE INDEX idx_client ON FaitsCycleVieClients(id_client);

-- Création de quelques données fictives pour tester
INSERT INTO Pays (nom) VALUES ('France'), ('Allemagne'), ('Espagne');

INSERT INTO Vendeur (nom, id_pays) VALUES 
('Jean Dupont', 1), 
('Anna Müller', 2), 
('Carlos García', 3);

INSERT INTO Client (nom, id_pays, groupe_client) VALUES 
('Alice Martin', 1, 'Particulier'),
('Entreprises XYZ', 2, 'Entreprise'),
('Grands Comptes SAS', 3, 'Grand compte');

INSERT INTO Commande (id_client, id_vendeur, montant, date_commande) VALUES 
(1, 1, 200.00, '2024-01-15'),
(2, 2, 5000.00, '2024-02-20'),
(3, 3, 12000.00, '2024-03-05');
