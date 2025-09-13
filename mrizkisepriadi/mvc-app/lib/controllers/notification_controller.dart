import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final CollectionReference _tokenCollection =
      FirebaseFirestore.instance.collection('users');

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (kDebugMode) {
        debugPrint('🚀 Starting notification initialization...');
      }

      await _requestPermissions();
      await _initializeLocalNotifications();
      await _setupMessageHandlers();
      await _saveFCMToken();
      await _subscribeToTopic();

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('✅ Notification controller initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error initializing notifications: $e');
      }
      rethrow;
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      if (kDebugMode) {
        debugPrint('📱 Requesting notification permissions...');
      }

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      if (kDebugMode) {
        debugPrint('Permission status: ${settings.authorizationStatus}');
      }

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        throw Exception('Notification permissions denied');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error requesting permissions: $e');
      }
      rethrow;
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    try {
      if (kDebugMode) {
        debugPrint('🔔 Initializing local notifications...');
      }

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      // Create notification channel for Android
      if (Platform.isAndroid) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'cart_channel',
          'Cart Updates',
          description: 'Notifications for cart item changes',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        );

        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _localNotifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        if (androidImplementation != null) {
          await androidImplementation.createNotificationChannel(channel);
        }
      }

      if (kDebugMode) {
        debugPrint('✅ Local notifications initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error initializing local notifications: $e');
      }
      rethrow;
    }
  }

  static Future<void> _setupMessageHandlers() async {
    try {
      if (kDebugMode) {
        debugPrint('📨 Setting up message handlers...');
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Handle initial message when app is opened from terminated state
      final RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      if (kDebugMode) {
        debugPrint('✅ Message handlers set up');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error setting up message handlers: $e');
      }
      rethrow;
    }
  }

  static Future<void> _subscribeToTopic() async {
    try {
      await _messaging.subscribeToTopic('cart_updates');
      if (kDebugMode) {
        debugPrint('✅ Subscribed to cart_updates topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error subscribing to topic: $e');
      }
      // Don't rethrow here as topic subscription is not critical
    }
  }

  static Future<void> _saveFCMToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (kDebugMode) {
          debugPrint('⚠️ No authenticated user, skipping token save');
        }
        return;
      }

      final token = await _messaging.getToken();
      if (token == null) {
        if (kDebugMode) {
          debugPrint('❌ Failed to get FCM token');
        }
        return;
      }

      await _tokenCollection
          .doc(user.uid)
          .collection('device_tokens')
          .doc(token)
          .set({
        'token': token,
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'createdAt': FieldValue.serverTimestamp(),
        'lastUsed': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        debugPrint('✅ FCM Token saved successfully');
        debugPrint('Token: $token');
        debugPrint('Path: users/${user.uid}/device_tokens/$token');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error saving FCM token: $e');
      }
      // Don't rethrow here as token saving is not critical for basic functionality
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      if (kDebugMode) {
        debugPrint('🔔 Foreground message received!');
        debugPrint('Message ID: ${message.messageId}');
        debugPrint('Title: ${message.notification?.title}');
        debugPrint('Body: ${message.notification?.body}');
        debugPrint('Data: ${message.data}');
      }

      await _showLocalNotification(message);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error handling foreground message: $e');
      }
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'cart_channel',
        'Cart Updates',
        channelDescription: 'Notifications for cart item changes',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'Cart Update',
        message.notification?.body ?? 'Your cart has been updated',
        platformChannelSpecifics,
        payload: jsonEncode(message.data),
      );

      if (kDebugMode) {
        debugPrint('✅ Local notification shown');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error showing local notification: $e');
      }
    }
  }

  static void _onNotificationResponse(NotificationResponse response) {
    try {
      if (kDebugMode) {
        debugPrint('👆 Notification tapped: ${response.payload}');
      }

      if (response.payload != null && response.payload!.isNotEmpty) {
        final data = jsonDecode(response.payload!);
        _navigateBasedOnNotification(data);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error handling notification response: $e');
      }
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    try {
      if (kDebugMode) {
        debugPrint('👆 FCM Notification tapped!');
        debugPrint('Message ID: ${message.messageId}');
        debugPrint('Data: ${message.data}');
      }
      _navigateBasedOnNotification(message.data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error handling notification tap: $e');
      }
    }
  }

  static void _navigateBasedOnNotification(Map<String, dynamic> data) {
    if (kDebugMode) {
      debugPrint('🧭 Navigation triggered with data: $data');
    }
    // TODO: Implement navigation logic based on notification data
  }

  static Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting FCM token: $e');
      }
      return null;
    }
  }

  static void listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        debugPrint('🔄 FCM Token refreshed: $newToken');
      }
      _saveFCMToken();
    });
  }

  static Future<void> showTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'cart_channel',
        'Cart Updates',
        channelDescription: 'Test notification',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        'Test Notification',
        'This is a test notification to verify local notifications work',
        platformChannelSpecifics,
      );

      if (kDebugMode) {
        debugPrint('✅ Test notification shown');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error showing test notification: $e');
      }
      rethrow;
    }
  }

  static Future<void> reinitialize() async {
    _isInitialized = false;
    await initialize();
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  // await Firebase.initializeApp();

  if (kDebugMode) {
    debugPrint('🔔 Background message received!');
    debugPrint('Message ID: ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');
  }
}
