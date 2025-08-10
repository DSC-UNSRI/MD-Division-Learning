import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _coreInitialized = false;
  bool _userInitialized = false;

  /// Initialize core messaging hooks (safe to call at app start)
  Future<void> initCore() async {
    if (_coreInitialized) return;
    try {
      await _initializeLocalNotifications();
      await _initializeFirebaseMessaging();
      _coreInitialized = true;
      print('Notification core initialized');
    } catch (e) {
      print('Error initializing notification core: $e');
    }
  }

  /// Initialize user-specific messaging (call after login)
  Future<void> initializeForUser() async {
    if (_userInitialized) return;
    try {
      await _requestPermissions();
      // Force a fresh token to avoid stale association across accounts
      try {
        await _firebaseMessaging.deleteToken();
      } catch (_) {}
      await _getAndSaveToken();
      await _subscribeToTopic();
      _userInitialized = true;
      print('Notification user bindings initialized');
    } catch (e) {
      print('Error initializing notification for user: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'cart_updates_channel',
        'Cart Updates',
        description: 'Notifications for cart item changes',
        importance: Importance.high,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle message when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle initial message when app is launched from notification
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Handle foreground messages by showing local notification
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    // Show notification for both notification and data-only messages
    await _showLocalNotification(message);
  }

  /// Handle when message is opened (app opened from notification)
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print('Message data: ${message.data}');
    
    // Here you can navigate to specific screens based on message data
    // For example, if the message contains cart item info, navigate to cart
    if (message.data.containsKey('type') && message.data['type'] == 'cart_update') {
      // Navigate to cart screen
      print('Navigating to cart screen...');
    }
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'cart_updates_channel',
      'Cart Updates',
      channelDescription: 'Notifications for cart item changes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final String title =
        message.notification?.title ?? message.data['title'] ?? 'Cart Update';
    final String body =
        message.notification?.body ?? message.data['body'] ?? 'Your cart has been updated';

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  /// Public helper to show local notification from app logic
  Future<void> showLocal(String title, String body, {Map<String, dynamic>? data}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'cart_updates_channel',
      'Cart Updates',
      channelDescription: 'Notifications for cart item changes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(data ?? {}),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped with payload: ${response.payload}');
    
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        print('Parsed notification data: $data');
        
        // Navigate based on notification data
        if (data['type'] == 'cart_update') {
          print('Navigating to cart screen from notification tap...');
        }
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  /// Get FCM token and save to Firestore
  Future<void> _getAndSaveToken() async {
    try {
      final String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        await _saveTokenToFirestore(token);
        
        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen(_saveTokenToFirestore);
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  /// Save FCM token to Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        print('No authenticated user, cannot save token');
        return;
      }

      final String userId = user.uid;
      final String tokenId = token; // use the raw token as document ID for backend compatibility
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('device_tokens')
          .doc(tokenId)
          .set({
        'token': token,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        'appVersion': '1.0.0',
      }, SetOptions(merge: true));

      // Mirror token in a global collection for backend compatibility
      await _firestore.collection('device_tokens').doc(tokenId).set({
        'token': token,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        'appVersion': '1.0.0',
      }, SetOptions(merge: true));

      // Optional secondary path alias if backend expects another name
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tokens')
          .doc(tokenId)
          .set({
        'token': token,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        'appVersion': '1.0.0',
      }, SetOptions(merge: true));

      print('FCM token saved to Firestore for user: $userId');
    } catch (e) {
      print('Error saving token to Firestore: $e');
    }
  }

  /// Subscribe to cart updates topic
  Future<void> _subscribeToTopic() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Subscribe to personal topic using user ID
        await _firebaseMessaging.subscribeToTopic('cart_updates_${user.uid}');
        print('Subscribed to personal cart updates topic');
        
        // Also subscribe to general cart updates
        await _firebaseMessaging.subscribeToTopic('cart_updates');
        print('Subscribed to general cart updates topic');

        // Extra general topics for broader compatibility
        try { await _firebaseMessaging.subscribeToTopic('cart'); } catch (_) {}
        try { await _firebaseMessaging.subscribeToTopic('cart_all'); } catch (_) {}
      }
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topics (call on logout)
  Future<void> unsubscribeFromTopics() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firebaseMessaging.unsubscribeFromTopic('cart_updates_${user.uid}');
        await _firebaseMessaging.unsubscribeFromTopic('cart_updates');
        print('Unsubscribed from cart update topics');
      }
    } catch (e) {
      print('Error unsubscribing from topics: $e');
    }
  }

  /// Send a test notification
  Future<void> sendTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'cart_updates_channel',
      'Cart Updates',
      channelDescription: 'Notifications for cart item changes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      0,
      'Test Notification',
      'This is a test notification from your cart app!',
      platformChannelSpecifics,
    );
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Remove device token from Firestore (call on logout)
  Future<void> removeTokenFromFirestore() async {
    try {
      final User? user = _auth.currentUser;
      final String? token = await _firebaseMessaging.getToken();
      
      if (user != null && token != null) {
        final String userId = user.uid;
        final String tokenId = token; // match save path
        
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('device_tokens')
            .doc(tokenId)
            .delete();

        // Remove mirrors
        try { await _firestore.collection('device_tokens').doc(tokenId).delete(); } catch (_) {}
        try { await _firestore.collection('users').doc(userId).collection('tokens').doc(tokenId).delete(); } catch (_) {}
        
        print('FCM token removed from Firestore');
      }
    } catch (e) {
      print('Error removing token from Firestore: $e');
    }
  }
}
