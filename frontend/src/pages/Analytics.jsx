import { useState, useEffect } from 'react';
import { Grid, Paper, Typography, Box, CircularProgress } from '@mui/material';
import {
  LineChart, Line, BarChart, Bar, PieChart, Pie,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  Legend, Cell
} from 'recharts';
import { kpiService } from '../services/kpiService';

const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042'];

function Analytics() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [data, setData] = useState({
    commandesCommercial: [],
    evolutionCommandes: [],
    clientsPays: [],
    clientsGroupe: [],
    cycleVie: null
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const [
          commandesCommercial,
          evolutionCommandes,
          clientsPays,
          clientsGroupe,
          cycleVie
        ] = await Promise.all([
          kpiService.getCommandesParCommercial(),
          kpiService.getEvolutionCommandes(),
          kpiService.getClientsParPays(),
          kpiService.getClientsParGroupe(),
          kpiService.getCycleVieClients()
        ]);

        setData({
          commandesCommercial,
          evolutionCommandes,
          clientsPays,
          clientsGroupe,
          cycleVie
        });
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box sx={{ p: 3 }}>
        <Typography color="error">Error: {error}</Typography>
      </Box>
    );
  }

  return (
    <Grid container spacing={3}>
      {/* Évolution des commandes */}
      <Grid item xs={12} lg={8}>
        <Paper sx={{ p: 3, height: '400px' }}>
          <Typography variant="h6" gutterBottom>
            Évolution des Commandes
          </Typography>
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={data.evolutionCommandes}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis
                dataKey="periode"
                stroke="#9ca3af"
                tick={{ fill: '#9ca3af' }}
              />
              <YAxis stroke="#9ca3af" tick={{ fill: '#9ca3af' }} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#1f2937',
                  border: 'none',
                }}
              />
              <Legend />
              <Line
                type="monotone"
                dataKey="total_commandes"
                stroke="#4dabf5"
                strokeWidth={2}
                dot={false}
              />
            </LineChart>
          </ResponsiveContainer>
        </Paper>
      </Grid>

      {/* Répartition des clients par groupe */}
      <Grid item xs={12} lg={4}>
        <Paper sx={{ p: 3, height: '400px' }}>
          <Typography variant="h6" gutterBottom>
            Clients par Groupe
          </Typography>
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={data.clientsGroupe}
                dataKey="total_clients"
                nameKey="groupe_client"
                cx="50%"
                cy="50%"
                outerRadius={100}
                label
              >
                {data.clientsGroupe.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip
                contentStyle={{
                  backgroundColor: '#1f2937',
                  border: 'none',
                }}
              />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </Paper>
      </Grid>

      {/* Commandes par commercial */}
      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 3, height: '400px' }}>
          <Typography variant="h6" gutterBottom>
            Commandes par Commercial
          </Typography>
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data.commandesCommercial}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis
                dataKey="id_vendeur"
                stroke="#9ca3af"
                tick={{ fill: '#9ca3af' }}
              />
              <YAxis stroke="#9ca3af" tick={{ fill: '#9ca3af' }} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#1f2937',
                  border: 'none',
                }}
              />
              <Bar dataKey="total_commandes" fill="#4dabf5" />
            </BarChart>
          </ResponsiveContainer>
        </Paper>
      </Grid>

      {/* Cycle de vie des clients */}
      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 3, height: '400px' }}>
          <Typography variant="h6" gutterBottom>
            Cycle de Vie des Clients
          </Typography>
          {data.cycleVie && (
            <Box sx={{ mt: 2 }}>
              <Typography variant="body1">
                Durée moyenne de relation: {Math.round(data.cycleVie.statistiques.avg_duree)} ans
              </Typography>
              <Typography variant="body1">
                Durée maximale: {data.cycleVie.statistiques.max_duree} ans
              </Typography>
              <Typography variant="body1">
                Nombre total de clients: {data.cycleVie.statistiques.total_clients}
              </Typography>
              <ResponsiveContainer width="100%" height="70%">
                <BarChart data={data.cycleVie.distribution}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
                  <XAxis
                    dataKey="duree_relation"
                    stroke="#9ca3af"
                    tick={{ fill: '#9ca3af' }}
                  />
                  <YAxis stroke="#9ca3af" tick={{ fill: '#9ca3af' }} />
                  <Tooltip
                    contentStyle={{
                      backgroundColor: '#1f2937',
                      border: 'none',
                    }}
                  />
                  <Bar dataKey="nombre_clients" fill="#00C49F" />
                </BarChart>
              </ResponsiveContainer>
            </Box>
          )}
        </Paper>
      </Grid>
    </Grid>
  );
}

export default Analytics;
