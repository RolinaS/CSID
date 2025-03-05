import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

// Modèle pour les commandes par commercial
export const CommandesCommerciale = sequelize.define('FaitsCommandesCommerciale', {
  id_fait: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  id_vendeur: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  annee: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  total_commandes: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'FaitsCommandesCommerciale',
  timestamps: false
});

// Modèle pour le nombre total de commandes
export const NombreCommandes = sequelize.define('FaitsNombreCommandes', {
  id_fait: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  periode: {
    type: DataTypes.DATE,
    allowNull: false
  },
  total_commandes: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'FaitsNombreCommandes',
  timestamps: false
});

// Modèle pour la répartition des clients par pays
export const ClientsParPays = sequelize.define('FaitsClientsParPays', {
  id_fait: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  id_pays: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  total_clients: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'FaitsClientsParPays',
  timestamps: false
});

// Modèle pour la répartition des clients par groupe
export const ClientsParGroupe = sequelize.define('FaitsClientsParGroupe', {
  id_fait: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  groupe_client: {
    type: DataTypes.STRING,
    allowNull: false
  },
  total_clients: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'FaitsClientsParGroupe',
  timestamps: false
});

// Modèle pour le nombre total de clients
export const TotalClients = sequelize.define('FaitsTotalClients', {
  id_fait: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  date_reference: {
    type: DataTypes.DATE,
    allowNull: false
  },
  total_clients: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'FaitsTotalClients',
  timestamps: false
});

// Modèle pour le cycle de vie des clients
export const CycleVieClients = sequelize.define('FaitsCycleVieClients', {
  id_fait: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  id_client: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  date_premiere_commande: {
    type: DataTypes.DATE,
    allowNull: false
  },
  date_derniere_commande: {
    type: DataTypes.DATE,
    allowNull: false
  },
  duree_relation: {
    type: DataTypes.INTEGER
  }
}, {
  tableName: 'FaitsCycleVieClients',
  timestamps: false
});
