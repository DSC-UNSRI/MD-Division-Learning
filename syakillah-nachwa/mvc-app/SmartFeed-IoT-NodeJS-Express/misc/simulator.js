require('../config/dotenv');
const axios = require('axios');
const WebSocket = require('ws');

const DEVICE_ID = process.env.DEVICE_ID || 'your_device_id';
const SERVER_URL = process.env.SERVER_URL || 'http://localhost:3000';
const WS_URL = SERVER_URL.replace(/^http/, 'ws');
const API_KEY = process.env.API_KEY || 'secret_api_key';
const AUTO_FEED_INTERVAL_MS = parseInt(process.env.AUTO_FEED_INTERVAL_MS, 10) || 60000;

// Axios instance with API key header
const axiosInstance = axios.create({
  headers: { 'x-api-key': API_KEY }
});

// Helper to activate real-time listener for this device
async function activateListener() {
  try {
    await axiosInstance.post(`${SERVER_URL}/api/devices/${DEVICE_ID}/listen`);
    console.log('Real-time listener activated for device:', DEVICE_ID);
  } catch (err) {
    console.error('Failed to activate listener:', err.message);
    process.exit(1);
  }
}

// Listen for feed commands and device updates via plain WebSocket
function setupWebSocket() {
  // Pass API key as a query parameter for authentication
  const ws = new WebSocket(`${WS_URL}/?x-api-key=${encodeURIComponent(API_KEY)}`);

  ws.on('open', () => {
    // Subscribe to histories for this device
    ws.send(JSON.stringify({
      event: 'subscribeHistories',
      data: DEVICE_ID
    }));
    console.log('WebSocket connected and subscribed to histories.');
  });

  ws.on('message', async (data) => {
    try {
      const msg = JSON.parse(data);
      if (msg.event === 'allHistories') {
        console.log('All histories:', msg.data);
      }
      if (msg.event === 'newHistory') {
        const history = msg.data;
        console.log('Received new feed command:', history);

        if (history.feedAction === 'manual') {
          // Simulate feeding process
          console.log('Feeding...');
          const newFeedLevel = Math.floor(Math.random() * 100);

          try {
            await axiosInstance.post(`${SERVER_URL}/api/devices/${DEVICE_ID}/feed-level`, {
              feedLevel: newFeedLevel,
              historyId: history.id
            });
            console.log('Feed level updated:', newFeedLevel);
          } catch (err) {
            console.error('Failed to update feed level:', err.message);
          }
        }
      }
      if (msg.event === 'device') {
        console.log('Device data update:', msg.data);
      }
      if (msg.event === 'error') {
        console.error('WebSocket error event:', msg.data);
      }
    } catch (err) {
      // Ignore non-JSON or unrelated messages
    }
  });

  ws.on('close', () => {
    console.log('WebSocket disconnected.');
  });

  ws.on('error', (err) => {
    console.error('WebSocket error:', err.message);
  });
}

// Simulate periodic feedLevel reporting (auto-feed)
function startAutoFeedSimulation() {
  setInterval(async () => {
    const feedLevel = Math.floor(Math.random() * 100);
    const feedAction = 'auto';
    try {
      const res = await axiosInstance.post(`${SERVER_URL}/api/devices/${DEVICE_ID}/histories`, {
        feedLevel,
        feedAction
      });
      console.log('Auto-feed reported:', { feedLevel, historyId: res.data.historyId });

      // Optionally, update device feedLevel to simulate sensor update
      await axiosInstance.post(`${SERVER_URL}/api/devices/${DEVICE_ID}/feed-level`, {
        feedLevel
      });
    } catch (err) {
      console.error('Auto-feed simulation failed:', err.message);
    }
  }, AUTO_FEED_INTERVAL_MS);
}

// Get latest feed command (manual/auto) at startup
async function getLatestFeed() {
  try {
    const res = await axiosInstance.get(`${SERVER_URL}/api/devices/${DEVICE_ID}/latest-feed`);
    console.log('Latest feed command:', res.data);
  } catch (err) {
    console.error('Failed to get latest feed command:', err.message);
  }
}

// Main simulation flow
(async () => {
  await activateListener();
  setupWebSocket();
  await getLatestFeed();
  startAutoFeedSimulation();
})();