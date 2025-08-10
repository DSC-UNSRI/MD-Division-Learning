const { admin, db } = require('../config/firebase');

const deviceListeners = {};

function setupDeviceListener(deviceId) {
  if (deviceListeners[deviceId]) return;

  deviceListeners[deviceId] = db.collection('devices').doc(deviceId)
    .onSnapshot(async (doc) => {
      if (!doc.exists) return;
      const data = doc.data();
      const { feedLevel, foodLevelThreshold } = data;

      if (typeof feedLevel === 'number' && typeof foodLevelThreshold === 'number' && feedLevel < foodLevelThreshold) {
        const title = feedLevel === 0 ? "0 Feed Level! Gimme food!" : "Low Feed Level";
        const message = (feedLevel === 0 ? "Stupid human! " : "") + `Feed level is below threshold: ${feedLevel}%. Refill immediately!`;
        const action = (feedLevel === 0 ? "zeroFeedAction" : "lowFeedAction");

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
            notification: { title, body: message },
            data: { action: action }
          });
        }
      }
    });
}

module.exports = { setupDeviceListener };