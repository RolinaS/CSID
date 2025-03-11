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
    id_vendeur SERIAL PRIMARY KEY,         -- Identifiant unique auto-incrémenté
    groupe_vendeur INT NOT NULL,           -- Groupe du vendeur
    langue VARCHAR(5) DEFAULT 'FR',        -- Langue préférée du vendeur
    nom VARCHAR(100) NOT NULL,             -- Nom du vendeur
    objectif DECIMAL(15,2) DEFAULT 0,      -- Objectif de vente du vendeur
    matricule INT NOT NULL DEFAULT 0,      -- Matricule du vendeur
    email VARCHAR(255) DEFAULT 'non fourni' -- Email du vendeur
);

-- Table Dimension : Client
CREATE TABLE Client (
    id_client SERIAL PRIMARY KEY,             -- Identifiant unique auto-incrémenté
    code_client VARCHAR(20) UNIQUE NOT NULL,  -- Code client issu du système source
    nom VARCHAR(100) NOT NULL,                -- Nom du client
    id_pays VARCHAR(10) REFERENCES Pays(id_pays),  -- Pays du client (clé étrangère vers Pays)
    groupe_client VARCHAR(50) NOT NULL CHECK (groupe_client IN ('Particulier', 'Entreprise', 'Grand compte')),
    code_postal VARCHAR(10),                   -- Code postal du client
    localite VARCHAR(100),                     -- Localité géographique du client
    code_branche VARCHAR(10),                  -- Code de branche (activité du client)
    devise VARCHAR(5) DEFAULT 'EUR',           -- Devise utilisée par le client (par défaut EUR)
    actif BOOLEAN DEFAULT TRUE                 -- Indique si le client est actif ou non
);

-- Table Dimension : Commande
CREATE TABLE Commande (
    id_commande SERIAL PRIMARY KEY,  -- Clé primaire auto-incrémentée
    code_commande VARCHAR(20) UNIQUE NOT NULL,  -- Numéro de commande unique
    ordre_client VARCHAR(20),  -- Référence de l'ordre client
    montant DECIMAL(10,2) NOT NULL,  -- Valeur nette de la commande
    devise VARCHAR(5) DEFAULT 'EUR',  -- Devise utilisée pour la commande
    date_document DATE NOT NULL,  -- Date du document de commande
    date_commande DATE NOT NULL,  -- Date effective de la commande
    motif_commande TEXT  -- Motif de la commande (optionnel)
);


-- Table de Faits : Vente
CREATE TABLE Vente (
    code_vente VARCHAR(20) NOT NULL,       -- Identifiant unique de la vente
    poste INT NOT NULL,                    -- Poste de vente
    code_article VARCHAR(50) NOT NULL,     -- Code de l'article vendu
    article_saisi VARCHAR(50) NOT NULL,    -- Référence saisie de l'article
    type_poste VARCHAR(10) NOT NULL,       -- Type de poste (ex: ZTXO)
    code_facturation VARCHAR(10),          -- Code de facturation
    devise VARCHAR(5) DEFAULT 'EUR',       -- Devise utilisée pour la vente
    valeur_nette DECIMAL(15,2) DEFAULT 0,  -- Valeur nette de la vente
    date_modification DATE NOT NULL,       -- Date de la dernière modification
    centre_profit VARCHAR(10),             -- Centre de profit associé
    PRIMARY KEY (code_vente, poste)        -- Clé primaire composite
);

-- Table de Faits : Total des ventes par vendeur (par an)
CREATE TABLE FaitsVentesCommerciale (
    id_fait SERIAL PRIMARY KEY,
    id_vendeur INT REFERENCES Vendeur(id_vendeur),
    annee INT NOT NULL,
    total_ventes DECIMAL(15,2) NOT NULL
);

-- Table de Faits : Nombre total de ventes sur une période donnée
CREATE TABLE FaitsNombreVentes (
    id_fait SERIAL PRIMARY KEY,
    periode DATE NOT NULL,
    total_ventes INT NOT NULL
);

-- Table de Faits : Répartition des ventes par pays
CREATE TABLE FaitsVentesParPays (
    id_fait SERIAL PRIMARY KEY,
    id_pays INT REFERENCES Pays(id_pays),
    total_ventes DECIMAL(15,2) NOT NULL
);

-- Table de Faits : Répartition des ventes par groupe de clients
CREATE TABLE FaitsVentesParGroupe (
    id_fait SERIAL PRIMARY KEY,
    groupe_client VARCHAR(100) NOT NULL CHECK (groupe_client IN ('Particulier', 'Entreprise', 'Grand compte')),
    total_ventes DECIMAL(15,2) NOT NULL
);

-- Table de Faits : Nombre total de clients (base de données)
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
CREATE INDEX idx_vendeur_annee ON FaitsVentesCommerciale(id_vendeur, annee);
CREATE INDEX idx_periode ON FaitsNombreVentes(periode);
CREATE INDEX idx_pays ON FaitsVentesParPays(id_pays);
CREATE INDEX idx_groupe_client ON FaitsVentesParGroupe(groupe_client);
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

-- Insertion de ventes
INSERT INTO Vente (id_commande, id_client, id_vendeur, montant, produit, quantite, date_vente) VALUES 
(1, 1, 1, 200.00, 'Ordinateur portable', 1, '2024-01-15'),
(2, 2, 2, 5000.00, 'Serveur HP', 2, '2024-02-20'),
(3, 3, 3, 12000.00, 'Infrastructure Cloud', 1, '2024-03-05');

-- Calcul des faits : Total des ventes par vendeur (exemple d'agrégation)
INSERT INTO FaitsVentesCommerciale (id_vendeur, annee, total_ventes)
SELECT id_vendeur, EXTRACT(YEAR FROM date_vente), SUM(montant)
FROM Vente
GROUP BY id_vendeur, EXTRACT(YEAR FROM date_vente);

-- Calcul des faits : Nombre total de ventes par période (exemple d'agrégation)
INSERT INTO FaitsNombreVentes (periode, total_ventes)
SELECT date_vente, COUNT(*)
FROM Vente
GROUP BY date_vente;

-- Calcul des faits : Répartition des ventes par pays
INSERT INTO FaitsVentesParPays (id_pays, total_ventes)
SELECT c.id_pays, SUM(v.montant)
FROM Vente v
JOIN Client c ON v.id_client = c.id_client
GROUP BY c.id_pays;

-- Calcul des faits : Répartition des ventes par groupe de clients
INSERT INTO FaitsVentesParGroupe (groupe_client, total_ventes)
SELECT c.groupe_client, SUM(v.montant)
FROM Vente v
JOIN Client c ON v.id_client = c.id_client
GROUP BY c.groupe_client;

-- Calcul des faits : Nombre total de clients
INSERT INTO FaitsTotalClients (date_reference, total_clients)
VALUES (CURRENT_DATE, (SELECT COUNT(*) FROM Client));

-- Calcul des faits : Cycle de vie des clients
INSERT INTO FaitsCycleVieClients (id_client, date_premiere_commande, date_derniere_commande)
SELECT v.id_client, MIN(v.date_vente), MAX(v.date_vente)
FROM Vente v
GROUP BY v.id_client;

-- Vérification des données insérées
SELECT * FROM Vente;
SELECT * FROM FaitsVentesCommerciale;
SELECT * FROM FaitsVentesParPays;
SELECT * FROM FaitsVentesParGroupe;
SELECT * FROM FaitsTotalClients;
SELECT * FROM FaitsCycleVieClients;
