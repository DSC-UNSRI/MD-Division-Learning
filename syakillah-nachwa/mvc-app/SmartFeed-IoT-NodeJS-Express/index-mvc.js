require('./config/dotenv');
const { listenCarts } = require('./listeners/cartListener');

listenCarts();

console.log('Cart listener started...');