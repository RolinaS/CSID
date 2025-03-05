import { Op } from 'sequelize';
import { sequelize } from '../config/database.js';
import {
  CommandesCommerciale,
  NombreCommandes,
  ClientsParPays,
  ClientsParGroupe,
  TotalClients,
  CycleVieClients
} from '../models/KpiModels.js';
import { logger } from '../utils/logger.js';

export const kpiController = {
  // KPI: Commandes par commercial et par année
  async getCommandesParCommercial(req, res) {
    try {
      const { annee } = req.query;
      const whereClause = annee ? { annee } : {};
      
      const data = await CommandesCommerciale.findAll({
        where: whereClause,
        order: [['annee', 'ASC'], ['total_commandes', 'DESC']]
      });
      
      res.json(data);
    } catch (error) {
      logger.error('Error fetching commandes par commercial:', error);
      res.status(500).json({ error: 'Failed to fetch data' });
    }
  },

  // KPI: Evolution du nombre de commandes
  async getEvolutionCommandes(req, res) {
    try {
      const { debut, fin } = req.query;
      const whereClause = {};
      
      if (debut && fin) {
        whereClause.periode = {
          [Op.between]: [debut, fin]
        };
      }

      const data = await NombreCommandes.findAll({
        where: whereClause,
        order: [['periode', 'ASC']]
      });

      res.json(data);
    } catch (error) {
      logger.error('Error fetching evolution commandes:', error);
      res.status(500).json({ error: 'Failed to fetch data' });
    }
  },

  // KPI: Répartition des clients par pays
  async getClientsParPays(req, res) {
    try {
      const data = await ClientsParPays.findAll({
        order: [['total_clients', 'DESC']]
      });

      res.json(data);
    } catch (error) {
      logger.error('Error fetching clients par pays:', error);
      res.status(500).json({ error: 'Failed to fetch data' });
    }
  },

  // KPI: Répartition des clients par groupe
  async getClientsParGroupe(req, res) {
    try {
      const data = await ClientsParGroupe.findAll({
        order: [['total_clients', 'DESC']]
      });

      res.json(data);
    } catch (error) {
      logger.error('Error fetching clients par groupe:', error);
      res.status(500).json({ error: 'Failed to fetch data' });
    }
  },

  // KPI: Evolution du nombre total de clients
  async getEvolutionTotalClients(req, res) {
    try {
      const data = await TotalClients.findAll({
        order: [['date_reference', 'ASC']]
      });

      res.json(data);
    } catch (error) {
      logger.error('Error fetching evolution total clients:', error);
      res.status(500).json({ error: 'Failed to fetch data' });
    }
  },

  // KPI: Analyse du cycle de vie des clients
  async getCycleVieClients(req, res) {
    try {
      // Calculer des statistiques sur la durée de relation
      const stats = await CycleVieClients.findAll({
        attributes: [
          [sequelize.fn('MIN', sequelize.col('duree_relation')), 'min_duree'],
          [sequelize.fn('MAX', sequelize.col('duree_relation')), 'max_duree'],
          [sequelize.fn('AVG', sequelize.col('duree_relation')), 'avg_duree'],
          [sequelize.fn('COUNT', sequelize.col('id_client')), 'total_clients']
        ]
      });

      // Distribution par durée de relation
      const distribution = await CycleVieClients.findAll({
        attributes: [
          'duree_relation',
          [sequelize.fn('COUNT', sequelize.col('id_client')), 'nombre_clients']
        ],
        group: ['duree_relation'],
        order: [['duree_relation', 'ASC']]
      });

      res.json({
        statistiques: stats[0],
        distribution
      });
    } catch (error) {
      logger.error('Error fetching cycle vie clients:', error);
      res.status(500).json({ error: 'Failed to fetch data' });
    }
  },

  // Dashboard: Récupérer tous les KPIs principaux
  async getDashboardKPIs(req, res) {
    try {
      const [
        totalClientsActuels,
        repartitionGroupes,
        repartitionPays,
        evolutionRecente
      ] = await Promise.all([
        TotalClients.findOne({
          order: [['date_reference', 'DESC']]
        }),
        ClientsParGroupe.findAll(),
        ClientsParPays.findAll(),
        NombreCommandes.findAll({
          order: [['periode', 'DESC']],
          limit: 6
        })
      ]);

      res.json({
        totalClients: totalClientsActuels,
        repartitionGroupes,
        repartitionPays,
        evolutionRecente: evolutionRecente.reverse()
      });
    } catch (error) {
      logger.error('Error fetching dashboard KPIs:', error);
      res.status(500).json({ error: 'Failed to fetch dashboard data' });
    }
  }
};
