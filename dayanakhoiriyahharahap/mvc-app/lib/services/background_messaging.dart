// services/background_messaging.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// REVISED: Handler disederhanakan
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔧 Handling a background message: ${message.messageId}");

  // CATATAN:
  // Anda TIDAK PERLU menampilkan notifikasi lokal di sini jika pesan dari
  // backend sudah berisi blok "notification". Sistem akan menampilkannya
  // secara otomatis.
  //
  // Fungsi ini lebih berguna untuk:
  // 1. Menjalankan tugas background (mis: update data lokal).
  // 2. Menampilkan notifikasi dari "data-only message" (pesan tanpa blok "notification").
}