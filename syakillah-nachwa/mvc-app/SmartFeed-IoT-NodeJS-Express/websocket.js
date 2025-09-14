require('./config/dotenv');
const { db } = require('./config/firebase');
const WebSocket = require('ws');

const API_KEY = process.env.API_KEY || 'secret_api_key';

function setupWebSocket(server) {
  const wss = new WebSocket.Server({ server });

  const wsListeners = new Map();

  wss.on('connection', (ws, req) => {
    const url = new URL(req.url, `http://${req.headers.host}`);
    const apiKeyQuery = url.searchParams.get('x-api-key');
    const apiKeyHeader = req.headers['x-api-key'];
    const apiKey = apiKeyQuery || apiKeyHeader;

    if (apiKey !== API_KEY) {
      ws.close(4001, 'Unauthorized');
      console.log('API key received:', apiKey);
      console.log('Full req.url:', req.url);
      return;
    }

    ws.on('message', async (message) => {
      let parsed;
      try {
        parsed = JSON.parse(message);
      } catch {
        return;
      }
      if (parsed.event === 'subscribeHistories' && typeof parsed.data === 'string') {
        const deviceId = parsed.data;
        if (wsListeners.has(ws)) {
          const { historiesUnsub, scheduleUnsub } = wsListeners.get(ws);
          if (historiesUnsub) historiesUnsub();
          if (scheduleUnsub) scheduleUnsub();
        }
        const historiesUnsub = db.collection('devices').doc(deviceId)
          .collection('histories')
          .orderBy('triggeredAt', 'desc')
          .limit(1)
          .onSnapshot(snapshot => {
            snapshot.docChanges().forEach(change => {
              if (change.type === 'added') {
                ws.send(JSON.stringify({
                  event: 'newHistory',
                  data: { id: change.doc.id, ...change.doc.data() }
                }));
              }
            });
          });
        let lastDeviceData = null;
        const deviceUnsub = db.collection('devices').doc(deviceId)
          .onSnapshot(doc => {
            if (!doc.exists) return;
            const data = doc.data();
            if (JSON.stringify(data) !== JSON.stringify(lastDeviceData)) {
              lastDeviceData = data;
              ws.send(JSON.stringify({
                event: 'device',
                data: { id: doc.id, ...data }
              }));
            }
          });

        wsListeners.set(ws, { historiesUnsub, deviceUnsub });
      }
    });

    ws.on('close', () => {
      if (wsListeners.has(ws)) {
        const { historiesUnsub, deviceUnsub } = wsListeners.get(ws);
        if (historiesUnsub) historiesUnsub();
        if (deviceUnsub) deviceUnsub();
        wsListeners.delete(ws);
      }
    });
  });
}

module.exports = { setupWebSocket };