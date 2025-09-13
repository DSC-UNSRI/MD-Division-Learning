# Firebase Cloud Messaging Setup Guide

## Prerequisites
1. Firebase project already set up with your Flutter app
2. `google-services.json` file already added to your Android project
3. `GoogleService-Info.plist` file already added to your iOS project (if using iOS)

## Firebase Console Configuration

### Step 1: Enable Cloud Messaging API
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to "APIs & Services" > "Library"
4. Search for "Firebase Cloud Messaging API"
5. Click on it and press "ENABLE"

### Step 2: Create Service Account Key (for Backend)
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to "IAM & Admin" > "Service Accounts"
4. Click "Create Service Account"
5. Name it "fcm-service-account" and give it a description
6. Click "Create and Continue"
7. Assign role: "Firebase Cloud Messaging API Admin"
8. Click "Continue" and then "Done"
9. Find your new service account in the list
10. Click on it, go to "Keys" tab
11. Click "Add Key" > "Create New Key"
12. Choose JSON format and download the file
13. **IMPORTANT**: Save this file securely - you'll need it for the backend service

### Step 3: Configure Firestore Security Rules
Add these rules to your Firestore to allow device token storage:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write their own cart items
    match /cart/{document} {
      allow read, write: if request.auth != null;
    }
    
    // Allow users to manage their own device tokens
    match /users/{userId}/device_tokens/{tokenId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow users to read their own user data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Step 4: Test FCM in Firebase Console
1. Go to Firebase Console > Your Project
2. Navigate to "Messaging" in the left sidebar
3. Click "Create your first campaign" or "New Campaign"
4. Choose "Firebase Notification messages"
5. Fill in:
   - **Notification title**: "Test Cart Notification"
   - **Notification text**: "This is a test message from your cart app"
6. Click "Next"
7. In "Target" section:
   - Choose "User segment"
   - Select "Users in last 7 days" (or create custom audience)
8. Click "Next"
9. In "Scheduling", choose "Now"
10. Click "Next"
11. In "Additional options":
    - **Android notification channel**: `cart_updates_channel`
    - **Sound**: Default
12. Click "Review" and then "Publish"

## Backend Service Setup

### Step 5: Clone and Setup Backend
```bash
# Clone the backend service
git clone https://github.com/mfazrinizar/SmartFeed-IoT-NodeJS-Express.git
cd SmartFeed-IoT-NodeJS-Express

# Install dependencies
npm install

# Create .env file with your Firebase credentials
cp .env.example .env
```

### Step 6: Configure Backend Environment
Edit the `.env` file and add:
```env
# Firebase Admin SDK
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=your-service-account-email
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYour private key here\n-----END PRIVATE KEY-----\n"

# Or use service account file path
GOOGLE_APPLICATION_CREDENTIALS=path/to/your/service-account-key.json
```

### Step 7: Run Backend Service
```bash
# Run the MVC index file
node index-mvc.js
```

The backend will automatically listen for changes in the `cart` collection and send push notifications.

## Flutter App Configuration

### Step 8: Update Dependencies
Your `pubspec.yaml` should include:
```yaml
dependencies:
  firebase_core: ^3.12.1
  firebase_auth: ^5.5.1
  cloud_firestore: ^5.6.5
  firebase_messaging: ^15.1.4
  flutter_local_notifications: ^18.0.1
```

### Step 9: Test the Implementation

1. **Run the Flutter app**:
   ```bash
   flutter run
   ```

2. **Test local notifications**:
   - Open the app
   - Tap the hamburger menu
   - Tap "Test Notification"
   - You should see a local notification

3. **Test FCM notifications**:
   - Make sure the backend service is running
   - Add/edit/delete cart items from another device or web interface
   - You should receive push notifications

4. **Test background notifications**:
   - Close the app (don't just minimize)
   - Use Firebase Console to send a test message
   - You should receive the notification even when app is closed

## Troubleshooting

### Common Issues:

1. **No notifications received**:
   - Check if permissions are granted
   - Verify FCM token is being saved to Firestore
   - Check device logs for errors

2. **Notifications only work in foreground**:
   - Verify background message handler is set up
   - Check Android manifest configuration

3. **Backend not sending notifications**:
   - Verify service account key is correct
   - Check backend logs for errors
   - Ensure cart collection name is exactly "cart"

### Debug Commands:
```bash
# Check Flutter logs
flutter logs

# Check Android logs
adb logcat | grep flutter

# Check if FCM token is generated
# Look for "FCM Token: " in the logs
```

## Important Notes

1. **Device Tokens**: Tokens are automatically saved to `users/{userId}/device_tokens/{tokenId}` in Firestore
2. **Topic Subscription**: App subscribes to both personal topic (`cart_updates_{userId}`) and general topic (`cart_updates`)
3. **Security**: Never commit service account keys to version control
4. **Testing**: Use Firebase Console messaging for initial testing
5. **Production**: Set up proper error handling and monitoring

## Data Structure in Firestore

```
users/
  {userId}/
    device_tokens/
      {tokenId}/
        - token: "actual_fcm_token"
        - createdAt: timestamp
        - platform: "android" | "ios"
        - appVersion: "1.0.0"

cart/
  {itemId}/
    - id: "item_id"
    - name: "Item Name"
    - quantity: 5
    - userId: "user_id"
    - createdAt: "2024-01-01T00:00:00.000Z"
    - updatedAt: "2024-01-01T00:00:00.000Z"
```

This setup provides complete push notification functionality for your MVC Cart Management Application with real-time updates both in foreground and background scenarios.
