// routes/deviceRoutes.js
// This module defines the routes for device-related operations.

const express = require('express');
const router = express.Router();
const { admin, db } = require('../config/firebase');
const { setupDeviceListener } = require('../listeners/deviceListener');

// 1. Get latest feed command
router.get('/devices/:deviceId/latest-feed', async (req, res) => {
  const { deviceId } = req.params;
  const snapshot = await db.collection('devices').doc(deviceId)
    .collection('histories')
    .orderBy('triggeredAt', 'desc')
    .limit(1)
    .get();
  if (snapshot.empty) return res.json({});
  res.json(snapshot.docs[0].data());
});

// 2. Update feedLevel after feeding
router.post('/devices/:deviceId/feed-level', async (req, res) => {
  const { deviceId } = req.params;
  const { feedLevel, historyId } = req.body;
  await db.collection('devices').doc(deviceId).update({
    feedLevel,
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  if (historyId) {
    await db.collection('devices').doc(deviceId)
      .collection('histories').doc(historyId)
      .update({ feedLevel });
  }
  res.sendStatus(200);
});

// 3. Report sensor reading (create new history)
router.post('/devices/:deviceId/histories', async (req, res) => {
  const { deviceId } = req.params;
  const { feedLevel, feedAction } = req.body;
  const doc = await db.collection('devices').doc(deviceId)
    .collection('histories').add({
      feedLevel,
      feedAction,
      triggeredAt: admin.firestore.FieldValue.serverTimestamp()
    });
  res.json({ historyId: doc.id });
});

// 4. Trigger notification if feedLevel < threshold
router.post('/devices/:deviceId/notify', async (req, res) => {
  const { deviceId } = req.params;
  const { title, message } = req.body;
  await db.collection('devices').doc(deviceId)
    .collection('notifications').add({
      title,
      message,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
  const usersSnap = await db.collection('devices').doc(deviceId)
    .collection('users').where('notificationsEnabled', '==', true).get();
  const tokens = [];
  for (const userDoc of usersSnap.docs) {
    const userId = userDoc.id;
    const tokensSnap = await db.collection('users').doc(userId)
      .collection('device_tokens').get();
    tokensSnap.forEach(tokenDoc => tokens.push(tokenDoc.data().token));
  }
  if (tokens.length > 0) {
    await admin.messaging().sendEachForMulticast({
      tokens,
      notification: { title, body: message }
    });
  }
  res.sendStatus(200);
});

// 5. Activate real-time listener for a device
router.post('/devices/:deviceId/listen', (req, res) => {
  const { deviceId } = req.params;
  setupDeviceListener(deviceId);
  res.sendStatus(200);
});

// 6. Update feedLevel in history
router.patch('/devices/:deviceId/histories/:historyId/feed-level', async (req, res) => {
  const { deviceId, historyId } = req.params;
  const { feedLevel } = req.body;
  if (typeof feedLevel !== 'number') {
    return res.status(400).json({ error: 'feedLevel must be a number' });
  }
  await db.collection('devices').doc(deviceId)
    .collection('histories').doc(historyId)
    .update({ feedLevel });
  res.sendStatus(200);
});

module.exports = router;