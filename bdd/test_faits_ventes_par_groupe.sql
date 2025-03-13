-- Script de test pour FaitsVentesParGroupe uniquement
-- Vérifier si la table existe
DO $$
BEGIN
    -- Vérifier si la table existe déjà
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'faitsventespargroupe') THEN
        -- Créer la table si elle n'existe pas
        CREATE TABLE FaitsVentesParGroupe (
            id_fait SERIAL PRIMARY KEY,
            groupe_client VARCHAR(100) NOT NULL,
            total_ventes NUMERIC(15, 2) NOT NULL
        );
        RAISE NOTICE 'Table FaitsVentesParGroupe créée';
    ELSE
        -- Nettoyage préalable si la table existe
        TRUNCATE TABLE FaitsVentesParGroupe;
        RAISE NOTICE 'Table FaitsVentesParGroupe vidée';
    END IF;
    
    -- Tester la requête sans insertion d'abord
    RAISE NOTICE 'Test de la requête...';
    
    -- Insertion des données
    INSERT INTO FaitsVentesParGroupe (groupe_client, total_ventes)
    SELECT
        cl.groupe_client,
        SUM(c.montant) AS total_ventes
    FROM commande c
    JOIN client cl ON c.ordre_client = cl.code_client
    GROUP BY cl.groupe_client
    ORDER BY cl.groupe_client;
    
    RAISE NOTICE 'Table FaitsVentesParGroupe mise à jour avec succès';
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erreur lors du traitement de FaitsVentesParGroupe: %', SQLERRM;
END;
$$;
