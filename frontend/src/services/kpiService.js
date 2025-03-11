import axios from 'axios';

// Déterminer l'URL de l'API en fonction de l'environnement
// En développement dans Docker, utiliser l'URL du conteneur pour les requêtes côté serveur
// Pour les requêtes du navigateur, utiliser localhost
const isRunningInBrowser = typeof window !== 'undefined';
const API_URL = process.env.REACT_APP_API_URL || 
  (isRunningInBrowser ? 'http://localhost:8000/api' : 'http://api:8000/api');

// Configuration d'axios avec le token
const axiosInstance = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Intercepteur pour ajouter le token d'authentification
axiosInstance.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export const kpiService = {
  // Récupérer les KPIs du dashboard
  async getDashboardData() {
    const response = await axiosInstance.get('/kpi/dashboard');
    return response.data;
  },

  // Récupérer les commandes par commercial
  async getCommandesParCommercial(annee) {
    const response = await axiosInstance.get('/kpi/commandes-commercial', {
      params: { annee }
    });
    return response.data;
  },

  // Récupérer l'évolution des commandes
  async getEvolutionCommandes(debut, fin) {
    const response = await axiosInstance.get('/kpi/evolution-commandes', {
      params: { debut, fin }
    });
    return response.data;
  },

  // Récupérer la répartition des clients par pays
  async getClientsParPays() {
    const response = await axiosInstance.get('/kpi/clients-pays');
    return response.data;
  },

  // Récupérer la répartition des clients par groupe
  async getClientsParGroupe() {
    const response = await axiosInstance.get('/kpi/clients-groupe');
    return response.data;
  },

  // Récupérer l'évolution du nombre total de clients
  async getEvolutionClients() {
    const response = await axiosInstance.get('/kpi/evolution-clients');
    return response.data;
  },

  // Récupérer les données du cycle de vie des clients
  async getCycleVieClients() {
    const response = await axiosInstance.get('/kpi/cycle-vie-clients');
    return response.data;
  }
};
