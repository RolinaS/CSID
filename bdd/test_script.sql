-- Script de test pour identifier l'erreur

-- Vérification de l'existence de la table
SELECT EXISTS (
   SELECT FROM information_schema.tables 
   WHERE table_schema = 'public'
   AND table_name = 'faitsventespargroupe'
);

-- Vérification de la structure de la table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'faitsventespargroupe';

-- Vérification de la structure de la table Client
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'client';

-- Vérification de la structure de la table Commande
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'commande';

-- Test simple de jointure
SELECT c.ordre_client, cl.code_client
FROM commande c
JOIN client cl ON c.ordre_client = cl.code_client
LIMIT 5;

-- Test d'agrégation simple
SELECT cl.groupe_client, COUNT(*) 
FROM client cl
GROUP BY cl.groupe_client;

-- Test de la requête problématique sans insertion
SELECT
    cl.groupe_client,
    SUM(c.montant) AS total_ventes
FROM commande c
JOIN client cl ON c.ordre_client = cl.code_client
GROUP BY cl.groupe_client
ORDER BY cl.groupe_client;
