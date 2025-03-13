-- Script pour réinitialiser toute transaction en cours
ROLLBACK;

-- Vérifier la structure des tables impliquées
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'commande';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'client';

-- Vérifier si les données correspondent entre les tables
SELECT COUNT(*) 
FROM commande c
LEFT JOIN client cl ON c.ordre_client = cl.code_client
WHERE cl.code_client IS NULL;

-- Tester la requête problématique sans insertion
SELECT
    cl.groupe_client,
    SUM(c.montant) AS total_ventes
FROM commande c
JOIN client cl ON c.ordre_client = cl.code_client
GROUP BY cl.groupe_client
ORDER BY cl.groupe_client;
