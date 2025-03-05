import { Grid, Paper, Typography, Box, Card, CardContent } from '@mui/material';
import { BarChart, Bar, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, ComposedChart } from 'recharts';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import PeopleIcon from '@mui/icons-material/People';
import AttachMoneyIcon from '@mui/icons-material/AttachMoney';

const monthlyData = [
  { name: 'Jan', value: 18, trend: 20 },
  { name: 'Feb', value: 32, trend: 25 },
  { name: 'Mar', value: 24, trend: 30 },
  { name: 'Apr', value: 40, trend: 35 },
  { name: 'May', value: 20, trend: 28 },
  { name: 'Jun', value: 35, trend: 32 },
  { name: 'Jul', value: 18, trend: 25 },
  { name: 'Aug', value: 25, trend: 22 },
  { name: 'Sep', value: 30, trend: 28 },
];

const StatCard = ({ title, value, icon, trend }) => (
  <Card sx={{ height: '100%' }}>
    <CardContent>
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
        <Box
          sx={{
            backgroundColor: 'primary.dark',
            borderRadius: 1,
            p: 1,
            mr: 2,
            display: 'flex',
          }}
        >
          {icon}
        </Box>
        <Box>
          <Typography variant="body2" color="text.secondary">
            {title}
          </Typography>
          <Typography variant="h4" component="div">
            {value}
          </Typography>
        </Box>
      </Box>
      <Typography
        variant="body2"
        sx={{
          color: trend >= 0 ? 'success.light' : 'error.light',
          display: 'flex',
          alignItems: 'center',
        }}
      >
        <TrendingUpIcon sx={{ mr: 0.5 }} />
        {trend}% from previous month
      </Typography>
    </CardContent>
  </Card>
);

function Dashboard() {
  return (
    <Box sx={{ py: 3 }}>
      <Typography variant="h4" sx={{ mb: 4 }}>
        Dashboard
      </Typography>

      <Grid container spacing={3}>
        {/* Stat Cards */}
        <Grid item xs={12} sm={6} md={4}>
          <StatCard
            title="Total Users"
            value="1,452"
            icon={<PeopleIcon />}
            trend={2.4}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4}>
          <StatCard
            title="Total Revenue"
            value="$38,452"
            icon={<AttachMoneyIcon />}
            trend={2.1}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4}>
          <StatCard
            title="Average Price"
            value="$15.4"
            icon={<TrendingUpIcon />}
            trend={2.4}
          />
        </Grid>

        {/* Revenue Chart */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Revenue Analytics
              </Typography>
              <Box sx={{ height: 400 }}>
                <ResponsiveContainer width="100%" height="100%">
                  <ComposedChart data={monthlyData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
                    <XAxis
                      dataKey="name"
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
                    <Bar
                      dataKey="value"
                      fill="#4dabf5"
                      radius={[4, 4, 0, 0]}
                    />
                    <Line
                      type="monotone"
                      dataKey="trend"
                      stroke="#4caf50"
                      strokeWidth={2}
                      dot={false}
                    />
                  </ComposedChart>
                </ResponsiveContainer>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Additional Stats */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Recent Activity Feed
              </Typography>
              <Box sx={{ mt: 2 }}>
                {['System update completed', 'New user registered', 'Database backup successful'].map((activity, index) => (
                  <Box
                    key={index}
                    sx={{
                      py: 1.5,
                      borderBottom: index !== 2 ? '1px solid rgba(255,255,255,0.1)' : 'none',
                    }}
                  >
                    <Typography variant="body2">{activity}</Typography>
                  </Box>
                ))}
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                System Status
              </Typography>
              <Box sx={{ mt: 2 }}>
                <Typography variant="body2" sx={{ mb: 1.5 }}>
                  CPU Usage: 45%
                </Typography>
                <Typography variant="body2" sx={{ mb: 1.5 }}>
                  Memory Usage: 62%
                </Typography>
                <Typography variant="body2">
                  Storage: 234GB / 512GB
                </Typography>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
}

export default Dashboard;
