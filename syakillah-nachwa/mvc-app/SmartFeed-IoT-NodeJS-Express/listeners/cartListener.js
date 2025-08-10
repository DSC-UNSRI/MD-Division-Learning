const { admin, db } = require('../config/firebase');

function listenCarts() {
  db.collection('cart').onSnapshot(async (snapshot) => {
    snapshot.docChanges().forEach(async (change) => {
      const cartData = change.doc.data();
      const userId = cartData?.userId || change.doc?.userId; 

      let tokens = [];
      if (userId) {
        const tokensSnap = await db.collection('users').doc(userId)
          .collection('device_tokens').get();
        tokensSnap.forEach(tokenDoc => tokens.push(tokenDoc.data().token));
      }

      let title = '';
      let body = '';

      if (change.type === 'added') {
        title = 'New Cart Item Successfully Added';
        body = 'A new item was added to your cart.';
      } else if (change.type === 'modified') {
        title = 'Cart Item Modified';
        body = 'An item in your cart was updated.';
      } else if (change.type === 'removed') {
        title = 'Cart Item Deleted';
        body = 'An item was removed from your cart.';
      }

      if (tokens.length > 0 && title) {
        await admin.messaging().sendEachForMulticast({
          tokens,
          notification: { title, body }
        });
        console.log(`Notification sent for cart item (${change.type}):`, change.doc.id);
      }
    });
  });
}

module.exports = { listenCarts };