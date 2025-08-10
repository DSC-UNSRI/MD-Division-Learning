// lib/services/notification_service.dart - FIXED VERSION
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Handler untuk background messages - WAJIB di level top/global
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("🔔 Background message received: ${message.messageId}");
    print("📱 Background message data: ${message.data}");
    print("📋 Background message notification: ${message.notification?.title}");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Channel untuk Android
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'cart_updates_channel',
    'Cart Updates',
    description: 'Notifications for cart item changes',
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );

  // Initialize semua notification services
  Future<void> initialize() async {
    if (kDebugMode) print("🚀 Initializing Notification Service...");
    
    try {
      // 1. Request permission
      await _requestPermission();
      
      // 2. Initialize local notifications
      await _initializeLocalNotifications();
      
      // 3. Setup FCM handlers
      await _setupFCM();
      
      // 4. Get and save FCM token
      await _saveFCMToken();
      
      // 5. Subscribe to topics
      await _subscribeToTopics();
      
      if (kDebugMode) print("✅ Notification Service initialized successfully!");
      
    } catch (e) {
      if (kDebugMode) print("❌ Error initializing notifications: $e");
    }
  }

  // Request notification permissions
  Future<void> _requestPermission() async {
    final NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('🔐 User granted permission: ${settings.authorizationStatus}');
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    // Android settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS settings
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  // Setup FCM message handlers
  Future<void> _setupFCM() async {
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  // Handle foreground messages dengan local notifications
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print("🔔 Foreground message received: ${message.messageId}");
      print("📱 Message data: ${message.data}");
    }

    final RemoteNotification? notification = message.notification;
    if (notification != null) {
      await showLocalNotification(
        title: notification.title ?? 'Cart Update',
        body: notification.body ?? 'Your cart has been updated',
        payload: message.data.toString(),
      );
    }
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print("🔔 Notification tapped: ${message.messageId}");
      print("📱 Message data: ${message.data}");
    }
    // Navigate to cart screen atau handle action lainnya
  }

  // Show local notification - PUBLIC METHOD
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'cart_updates_channel',
      'Cart Updates',
      channelDescription: 'Notifications for cart item changes',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print("🔔 Local notification tapped: ${response.payload}");
    }
    // Handle navigation atau action lainnya
  }

  // Save FCM token to Firestore
  Future<void> _saveFCMToken() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      final String? token = await _firebaseMessaging.getToken();
      if (token == null) return;

      if (kDebugMode) print("🔑 FCM Token: $token");

      // Save token ke Firestore di path: users/{userId}/device_tokens/{tokenId}
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('device_tokens')
          .doc(token)
          .set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': defaultTargetPlatform.toString(),
        'appVersion': '1.0.0',
      });

      if (kDebugMode) print("✅ FCM Token saved to Firestore");

    } catch (e) {
      if (kDebugMode) print("❌ Error saving FCM token: $e");
    }
  }

  // Subscribe to topics
  Future<void> _subscribeToTopics() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      // Subscribe ke personal topic
      await _firebaseMessaging.subscribeToTopic('cart_updates_${user.uid}');
      
      // Subscribe ke general topic
      await _firebaseMessaging.subscribeToTopic('cart_updates');
      
      if (kDebugMode) print("✅ Subscribed to notification topics");
      
    } catch (e) {
      if (kDebugMode) print("❌ Error subscribing to topics: $e");
    }
  }

  // Unsubscribe from topics (untuk logout)
  Future<void> unsubscribeFromTopics() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      // Unsubscribe dari personal topic
      await _firebaseMessaging.unsubscribeFromTopic('cart_updates_${user.uid}');
      
      // Unsubscribe dari general topic
      await _firebaseMessaging.unsubscribeFromTopic('cart_updates');
      
      if (kDebugMode) print("✅ Unsubscribed from notification topics");
      
    } catch (e) {
      if (kDebugMode) print("❌ Error unsubscribing from topics: $e");
    }
  }

  // Method untuk test notification - PUBLIC METHOD
  Future<void> sendTestNotification() async {
    await showLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification from your cart app!',
      payload: 'test_payload',
    );
  }

  // Clean up saat user logout
  Future<void> cleanup() async {
    await unsubscribeFromTopics();
    if (kDebugMode) print("🧹 Notification service cleaned up");
  }
}