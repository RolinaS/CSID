import { Grid, Paper, Typography } from '@mui/material';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const data = [
  { name: 'Mon', users: 4000, sessions: 2400 },
  { name: 'Tue', users: 3000, sessions: 1398 },
  { name: 'Wed', users: 2000, sessions: 9800 },
  { name: 'Thu', users: 2780, sessions: 3908 },
  { name: 'Fri', users: 1890, sessions: 4800 },
  { name: 'Sat', users: 2390, sessions: 3800 },
  { name: 'Sun', users: 3490, sessions: 4300 },
];

function Analytics() {
  return (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <Paper sx={{ p: 2, display: 'flex', flexDirection: 'column' }}>
          <Typography component="h2" variant="h6" color="primary" gutterBottom>
            Analytics Overview
          </Typography>
          <ResponsiveContainer width="100%" height={400}>
            <LineChart
              data={data}
              margin={{
                top: 16,
                right: 16,
                bottom: 0,
                left: 24,
              }}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="users" stroke="#8884d8" />
              <Line type="monotone" dataKey="sessions" stroke="#82ca9d" />
            </LineChart>
          </ResponsiveContainer>
        </Paper>
      </Grid>

      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2, display: 'flex', flexDirection: 'column' }}>
          <Typography component="h2" variant="h6" color="primary" gutterBottom>
            Key Metrics
          </Typography>
          <Typography variant="body1" paragraph>
            • Total Users: 15,678
          </Typography>
          <Typography variant="body1" paragraph>
            • Active Sessions: 2,456
          </Typography>
          <Typography variant="body1">
            • Average Session Duration: 15m 30s
          </Typography>
        </Paper>
      </Grid>

      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2, display: 'flex', flexDirection: 'column' }}>
          <Typography component="h2" variant="h6" color="primary" gutterBottom>
            Performance Insights
          </Typography>
          <Typography variant="body1" paragraph>
            • Peak Usage Time: 2:00 PM - 4:00 PM
          </Typography>
          <Typography variant="body1" paragraph>
            • Most Active Region: Europe
          </Typography>
          <Typography variant="body1">
            • Top Platform: Chrome Desktop
          </Typography>
        </Paper>
      </Grid>
    </Grid>
  );
}

export default Analytics;
