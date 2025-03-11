-- table de fait FaitsVentesCommerciale
BEGIN;

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

COMMIT;


-- table de fait FaitsNombreVentes

BEGIN;

TRUNCATE TABLE FaitsNombreVentes;

INSERT INTO FaitsNombreVentes (periode, total_ventes)
SELECT
    DATE_TRUNC('month', date_commande)::DATE AS periode,
    COUNT(*) AS total_ventes
FROM commande
GROUP BY DATE_TRUNC('month', date_commande)
ORDER BY periode;

COMMIT;

-- table de fait FaitsTotalClients

BEGIN;

-- Nettoyage préalable
TRUNCATE TABLE FaitsTotalClients;

-- Insertion du nombre total de clients à la date actuelle
INSERT INTO FaitsTotalClients (date_reference, total_clients)
SELECT
    CURRENT_DATE AS date_reference,
    COUNT(*) AS total_clients
FROM Client
WHERE actif = TRUE;  -- seulement les clients actifs

COMMIT;
