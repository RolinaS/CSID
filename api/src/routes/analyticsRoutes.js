import express from 'express';
// Importation des contrôleurs (à implémenter plus tard si nécessaire)
// import { getAnalytics } from '../controllers/analyticsController.js';

const router = express.Router();

/**
 * @route   GET /api/analytics
 * @desc    Get analytics data
 * @access  Private
 */
router.get('/', (req, res) => {
  // Pour l'instant, retournons des données fictives
  res.json({
    status: 'success',
    data: {
      totalUsers: 120,
      activeUsers: 85,
      newUsers: 12,
      userGrowth: 8.5,
      pageViews: 1250,
      sessions: 430,
      avgSessionDuration: '3m 45s',
      bounceRate: 32.5,
      topPages: [
        { page: '/dashboard', views: 450 },
        { page: '/analytics', views: 320 },
        { page: '/settings', views: 180 }
      ]
    }
  });
});

export default router;
