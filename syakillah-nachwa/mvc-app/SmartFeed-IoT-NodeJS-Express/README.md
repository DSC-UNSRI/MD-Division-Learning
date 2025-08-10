# SmartFeed Express

Back-End of SmartFeed.

---

## Features

- **Automatic Feed Level Monitoring:**  
  Distance sensor (HC-SR04) measures feed level, data sent to Firestore.
- **Automatic & Manual Feeding:**  
  Servo motor is controlled automatically (by schedule) or manually (via app/ESP32).
- **Real-Time Notifications:**  
  Notifications sent to users via FCM when feed is low.
- **Flutter App Integration:**  
  Flutter app reads status, feed level, and notifications from Firestore.
- **Node.js Simulator:**  
  Simulates ESP32 device for end-to-end testing.

---

## Workspace Structure

```
.env
.env.example
.gitignore
index.js
package.json
websocket.js
config/
  dotenv.js
  firebase.js
listeners/
  deviceListener.js
middleware/
  authMiddleware.js
misc/
  simulator.js
routes/
  deviceRoutes.js
secrets/
  serviceAccountKey.json
```

---

## Installation

1. **Clone the repository & install dependencies**
   ```sh
   npm install
   ```

2. **Set up configuration files**
   - Copy `.env.example` to `.env` and adjust the values.
   - Place your `serviceAccountKey.json` from Firebase Console in the `secrets/` folder.

3. **Firestore Structure**
   - Follow the Firestore collection structure as required by SmartFeed (see documentation above).

---

## `.env` Configuration

Example `.env`:
```
DEVICE_ID=smartfeed_01
SERVER_URL=http://localhost:3000
API_KEY=your_api_key
AUTO_FEED_INTERVAL_MS=60000
```

---

## Running the Server

```sh
node index.js
```

The server will run on port 3000.

---

## Running the Simulator (ESP32 Mock)

```sh
node misc/simulator.js
```

The simulator will:
- Activate a real-time listener for the device.
- Connect to the WebSocket server using the API key (as a query param).
- Subscribe to device histories and receive:
  - All existing histories (`allHistories` event).
  - New feeding commands in real-time (`newHistory` event).
  - Device data updates (`device` event).
- Periodically report feed level (auto-feed).
- Update feed level after manual feeding.

---

## API Endpoints

All endpoints require the header:  
`x-api-key: <API_KEY>`

- **GET** `/api/devices/:deviceId/latest-feed`  
  Get the latest feeding command.

- **POST** `/api/devices/:deviceId/feed-level`  
  Update feed level after feeding.

- **POST** `/api/devices/:deviceId/histories`  
  Add a feeding entry (manual/auto).

- **POST** `/api/devices/:deviceId/notify`  
  Send notification to user (usually handled automatically by the server).

- **POST** `/api/devices/:deviceId/listen`  
  Activate real-time listener for the device (call once per device).

- **PATCH** `/api/devices/:deviceId/histories/:historyId/feed-level`  
  Update the feed level of a specific history entry.

---

## WebSocket

- **Endpoint:**  
  `ws://localhost:3000/?x-api-key=<API_KEY>`
- **Auth:**  
  Pass the API key as a query parameter (`x-api-key`) or as a header.
- **Events:**  
  - Send:  
    ```json
    { "event": "subscribeHistories", "data": "<deviceId>" }
    ```
    to subscribe to device histories.
  - Receive:
    - `allHistories`: All existing histories for the device.
    - `newHistory`: New feeding command in real-time.
    - `device`: Device data updates in real-time.
    - `error`: Error messages.

---

## Security

- All endpoints and WebSocket connections are protected by API Key (`x-api-key`).
- Do not commit your `.env` and `serviceAccountKey.json` files to public repositories.

---

## Development & Testing

- Modular: all logic is separated into folders (`config/`, `middleware/`, `listeners/`, `routes/`, `misc/`).
- The simulator can be used for end-to-end testing without physical hardware.

---