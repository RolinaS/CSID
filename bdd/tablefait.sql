-- D'abord, annuler toute transaction en cours qui pourrait bloquer les commandes
ROLLBACK;

-- Script pour les tables de faits
-- Chaque table est traitée dans un fichier séparé pour éviter les problèmes de transaction

-- ===== TABLE 1: FaitsVentesCommerciale =====

-- Annuler toute transaction en cours
ROLLBACK;

-- Vérifier si la table existe
DO $$
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitsventescommerciale') THEN
        -- Nettoyage préventif
        TRUNCATE TABLE FaitsVentesCommerciale;
        
        -- Alimentation avec données agrégées (vendeur, année, total ventes)
        INSERT INTO FaitsVentesCommerciale (id_vendeur, annee, total_ventes)
        SELECT
            v.id_vendeur,
            EXTRACT(YEAR FROM c.date_commande)::INT AS annee,
            SUM(c.montant) AS total_ventes
        FROM commande c
        INNER JOIN vendeur v ON c.id_vendeur = v.id_vendeur
        GROUP BY v.id_vendeur, annee
        ORDER BY v.id_vendeur, annee;
        
        RAISE NOTICE 'Table FaitsVentesCommerciale mise à jour avec succès';
    ELSE
        RAISE NOTICE 'La table FaitsVentesCommerciale n''existe pas';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du traitement de FaitsVentesCommerciale: %', SQLERRM;
END;
$$;

-- ===== TABLE 2: FaitsNombreVentes =====

-- Annuler toute transaction en cours
ROLLBACK;

DO $$
BEGIN
    -- Vérifier si la table existe
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitsnombreventes') THEN
        -- Nettoyage préalable
        TRUNCATE TABLE FaitsNombreVentes;
        
        -- Insertion des données
        INSERT INTO FaitsNombreVentes (periode, total_ventes)
        SELECT
            DATE_TRUNC('month', date_commande)::DATE AS periode,
            COUNT(*) AS total_ventes
        FROM commande
        GROUP BY DATE_TRUNC('month', date_commande)
        ORDER BY periode;
        
        RAISE NOTICE 'Table FaitsNombreVentes mise à jour avec succès';
    ELSE
        RAISE NOTICE 'La table FaitsNombreVentes n''existe pas';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du traitement de FaitsNombreVentes: %', SQLERRM;
END;
$$;

-- ===== TABLE 3: FaitsTotalClients =====

-- Annuler toute transaction en cours
ROLLBACK;

DO $$
BEGIN
    -- Vérifier si la table existe
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitstotalclients') THEN
        -- Nettoyage préalable
        TRUNCATE TABLE FaitsTotalClients;
        
        -- Insertion du nombre total de clients à la date actuelle
        INSERT INTO FaitsTotalClients (date_reference, total_clients)
        SELECT
            CURRENT_DATE AS date_reference,
            COUNT(*) AS total_clients
        FROM Client
        WHERE actif = TRUE;  -- seulement les clients actifs
        
        RAISE NOTICE 'Table FaitsTotalClients mise à jour avec succès';
    ELSE
        RAISE NOTICE 'La table FaitsTotalClients n''existe pas';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du traitement de FaitsTotalClients: %', SQLERRM;
END;
$$;

-- ===== TABLE 4: FaitsVentesParGroupe =====

-- Annuler toute transaction en cours
ROLLBACK;

-- Vérifier d'abord si la table existe, sinon la créer
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitsventespargroupe') THEN
        CREATE TABLE FaitsVentesParGroupe (
            id_fait SERIAL PRIMARY KEY,
            groupe_client VARCHAR(100) NOT NULL,
            total_ventes NUMERIC(15, 2) NOT NULL
        );
        RAISE NOTICE 'Table FaitsVentesParGroupe créée';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors de la création de FaitsVentesParGroupe: %', SQLERRM;
END;
$$;

-- Maintenant, vider et remplir la table
DO $$
BEGIN
    -- Nettoyage préalable
    TRUNCATE TABLE FaitsVentesParGroupe;
    
    -- Alimentation avec données agrégées (groupe client, total ventes)
    INSERT INTO FaitsVentesParGroupe (groupe_client, total_ventes)
    SELECT
        cl.groupe_client,
        SUM(c.montant) AS total_ventes
    FROM commande c
    INNER JOIN client cl ON c.ordre_client = cl.code_client
    GROUP BY cl.groupe_client
    ORDER BY cl.groupe_client;
    
    RAISE NOTICE 'Table FaitsVentesParGroupe mise à jour avec succès';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du remplissage de FaitsVentesParGroupe: %', SQLERRM;
END;
$$;

-- ===== TABLE 5: FaitsClientsParGroupe =====

-- Annuler toute transaction en cours
ROLLBACK;

-- Création de la table si elle n'existe pas
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitsclientspargroupe') THEN
        CREATE TABLE FaitsClientsParGroupe (
            id_fait SERIAL PRIMARY KEY,
            groupe_client VARCHAR(100) NOT NULL CHECK (groupe_client IN ('Particulier', 'Entreprise', 'Grand compte')),
            total_clients INT NOT NULL
        );
        RAISE NOTICE 'Table FaitsClientsParGroupe créée';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors de la création de FaitsClientsParGroupe: %', SQLERRM;
END;
$$;

-- Nettoyage et insertion des données
DO $$
BEGIN
    -- Nettoyage préalable
    TRUNCATE TABLE FaitsClientsParGroupe;
    
    -- Insertion du nombre de clients par groupe
    INSERT INTO FaitsClientsParGroupe (groupe_client, total_clients)
    SELECT
        groupe_client,
        COUNT(*) AS total_clients
    FROM Client
    WHERE actif = TRUE  -- seulement les clients actifs
    GROUP BY groupe_client
    ORDER BY groupe_client;
    
    RAISE NOTICE 'Table FaitsClientsParGroupe mise à jour avec succès';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du remplissage de FaitsClientsParGroupe: %', SQLERRM;
END;
$$;

-- ===== TABLE 6: FaitsClientParPays =====

-- Annuler toute transaction en cours
ROLLBACK;

-- Création de la table si elle n'existe pas
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitsclientparpays') THEN
        CREATE TABLE FaitsClientParPays (
            id_fait SERIAL PRIMARY KEY,
            id_pays INT REFERENCES Pays(id_pays),
            total_clients INT NOT NULL
        );
        RAISE NOTICE 'Table FaitsClientParPays créée';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors de la création de FaitsClientParPays: %', SQLERRM;
END;
$$;

-- Nettoyage et insertion des données
DO $$
BEGIN
    -- Nettoyage préalable
    TRUNCATE TABLE FaitsClientParPays;
    
    -- Insertion du nombre de clients par pays
    INSERT INTO FaitsClientParPays (id_pays, total_clients)
    SELECT
        p.id_pays,
        COUNT(*) AS total_clients
    FROM Client c
    JOIN Pays p ON c.id_pays = p.id_pays
    WHERE c.actif = TRUE
    GROUP BY p.id_pays
    ORDER BY p.id_pays;
    
    RAISE NOTICE 'Table FaitsClientParPays mise à jour avec succès';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du remplissage de FaitsClientParPays: %', SQLERRM;
END;
$$;

-- ===== TABLE 7: FaitsCycleVieClients =====

-- Annuler toute transaction en cours
ROLLBACK;

DO $$
BEGIN
    -- Vérifier si la table existe
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitscyclevieclients') THEN
        -- Nettoyage préalable
        TRUNCATE TABLE FaitsCycleVieClients;
        
        -- Insertion des données de cycle de vie des clients
        INSERT INTO FaitsCycleVieClients (id_client, date_premiere_commande, date_derniere_commande)
        SELECT
            cl.id_client,
            MIN(co.date_commande) AS date_premiere_commande,
            MAX(co.date_commande) AS date_derniere_commande
        FROM Client cl
        INNER JOIN Commande co ON cl.code_client = co.ordre_client
        GROUP BY cl.id_client
        HAVING COUNT(co.code_commande) > 0  -- seulement les clients ayant au moins une commande
        ORDER BY cl.id_client;
        
        RAISE NOTICE 'Table FaitsCycleVieClients mise à jour avec succès';
    ELSE
        RAISE NOTICE 'La table FaitsCycleVieClients n''existe pas';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du traitement de FaitsCycleVieClients: %', SQLERRM;
END;
$$;