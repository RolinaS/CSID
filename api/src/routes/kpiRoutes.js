import express from 'express';
import { kpiController } from '../controllers/kpiController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protection de toutes les routes KPI
router.use(authMiddleware);

// Routes pour les KPIs individuels
router.get('/commandes-commercial', kpiController.getCommandesParCommercial);
router.get('/evolution-commandes', kpiController.getEvolutionCommandes);
router.get('/clients-pays', kpiController.getClientsParPays);
router.get('/clients-groupe', kpiController.getClientsParGroupe);
router.get('/evolution-clients', kpiController.getEvolutionTotalClients);
router.get('/cycle-vie-clients', kpiController.getCycleVieClients);

// Route pour le dashboard (tous les KPIs principaux)
router.get('/dashboard', kpiController.getDashboardKPIs);

export default router;
