// notification_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
}

// Singleton Notification Service
class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init({required String userId}) async {
    await Firebase.initializeApp();

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Local Notifications initialization
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('Notification clicked: ${response.payload}');
      // TODO: navigate to cart page if needed
    });

    // Request permissions
    await _requestPermission(userId);

    // Foreground notification listener
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
  }

  Future<void> _requestPermission(String userId) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      if (token != null) {
        print('FCM Token: $token');

        // Save token to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('device_tokens')
            .doc(token)
            .set({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Subscribe to personal topic
        await messaging.subscribeToTopic('user_$userId');
      }
    }
  }

  void _onMessageHandler(RemoteMessage message) {
    print('Foreground message received: ${message.notification?.title}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'cart_channel',
            'Cart Updates',
            channelDescription: 'Notification for cart updates',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: 'cart_update',
      );
    }
  }
}
