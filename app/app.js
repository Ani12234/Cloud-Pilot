const express = require('express');
const os = require('os');
const app = express();
const port = process.env.PORT || 3000;

let requestCount = 0;
const startTime = new Date();

app.get('/', (req, res) => {
  requestCount++;
  res.json({
    status: "healthy",
    message: "Welcome to TerraForge Containerized App!",
    hostname: os.hostname(),
    platform: os.platform(),
    uptime: `${Math.floor((new Date() - startTime) / 1000)} seconds`,
    request_count: requestCount,
    environment: process.env.NODE_ENV || "production",
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({ status: "UP", timestamp: new Date().toISOString() });
});

app.listen(port, () => {
  console.log(`TerraForge app listening on port ${port}`);
});
