import {
  Box,
  Paper,
  Typography,
  Switch,
  FormControlLabel,
  TextField,
  Button,
  Divider,
  Grid,
} from '@mui/material';

function Settings() {
  return (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <Paper sx={{ p: 3 }}>
          <Typography variant="h6" color="primary" gutterBottom>
            General Settings
          </Typography>
          <Box sx={{ mt: 2 }}>
            <FormControlLabel
              control={<Switch defaultChecked />}
              label="Enable Notifications"
            />
          </Box>
          <Box sx={{ mt: 2 }}>
            <FormControlLabel
              control={<Switch defaultChecked />}
              label="Dark Mode"
            />
          </Box>
        </Paper>
      </Grid>

      <Grid item xs={12}>
        <Paper sx={{ p: 3 }}>
          <Typography variant="h6" color="primary" gutterBottom>
            Profile Settings
          </Typography>
          <Box sx={{ mt: 2 }}>
            <TextField
              fullWidth
              label="Display Name"
              defaultValue="Admin User"
              sx={{ mb: 2 }}
            />
            <TextField
              fullWidth
              label="Email"
              type="email"
              defaultValue="admin@example.com"
              sx={{ mb: 2 }}
            />
            <Button variant="contained" color="primary">
              Update Profile
            </Button>
          </Box>
        </Paper>
      </Grid>

      <Grid item xs={12}>
        <Paper sx={{ p: 3 }}>
          <Typography variant="h6" color="primary" gutterBottom>
            Security Settings
          </Typography>
          <Box sx={{ mt: 2 }}>
            <TextField
              fullWidth
              label="Current Password"
              type="password"
              sx={{ mb: 2 }}
            />
            <TextField
              fullWidth
              label="New Password"
              type="password"
              sx={{ mb: 2 }}
            />
            <TextField
              fullWidth
              label="Confirm New Password"
              type="password"
              sx={{ mb: 2 }}
            />
            <Button variant="contained" color="primary">
              Change Password
            </Button>
          </Box>
        </Paper>
      </Grid>
    </Grid>
  );
}

export default Settings;
