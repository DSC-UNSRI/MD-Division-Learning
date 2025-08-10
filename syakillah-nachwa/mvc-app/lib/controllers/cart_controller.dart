// lib/controllers/cart_controller.dart - FIXED VERSION
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../services/notification_service.dart';

class CartController {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('cart');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();

  // Initialize notification service dan cart listener
  Future<void> subscribeToNotifications() async {
    await _notificationService.initialize();
    await initializeCartListener();
  }

  // Initialize cart listener untuk real-time notifications
  Future<void> initializeCartListener() async {
    try {
      final String? currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return;

      if (kDebugMode) print("🎧 Starting cart listener...");

      _cartCollection.snapshots().listen((QuerySnapshot snapshot) {
        for (var change in snapshot.docChanges) {
          final Map<String, dynamic>? data = change.doc.data() as Map<String, dynamic>?;
          if (data == null) continue;

          final String itemUserId = data['userId'] ?? '';
          final String itemName = data['name'] ?? 'Unknown Item';

          // Jangan tampilkan notifikasi untuk perubahan sendiri
          if (itemUserId == currentUserId) continue;

          // Show notification berdasarkan type perubahan
          switch (change.type) {
            case DocumentChangeType.added:
              _showCartNotification(
                title: 'Cart Item Added',
                body: '$itemName has been added to cart',
              );
              break;
            case DocumentChangeType.modified:
              _showCartNotification(
                title: 'Cart Item Updated',
                body: '$itemName has been updated',
              );
              break;
            case DocumentChangeType.removed:
              _showCartNotification(
                title: 'Cart Item Removed',
                body: '$itemName has been removed from cart',
              );
              break;
          }
        }
      });

      if (kDebugMode) print("✅ Cart listener initialized");
    } catch (e) {
      if (kDebugMode) print("❌ Error initializing cart listener: $e");
    }
  }

  // Show notification untuk cart changes
  void _showCartNotification({required String title, required String body}) {
    _notificationService.showLocalNotification(
      title: title,
      body: body,
      payload: 'cart_update',
    );
  }

  // Cleanup notifications saat logout
  Future<void> unsubscribeFromNotifications() async {
    await _notificationService.cleanup();
  }

  // Method untuk test notification
  Future<void> sendTestNotification() async {
    await _notificationService.sendTestNotification();
  }

  // Method yang sudah ada sebelumnya...
  Future<void> addItem(CartItem item) async {
    final String? userId = _auth.currentUser?.uid;
    if (userId == null) return;
    
    item.userId = userId;
    
    final int now = DateTime.now().millisecondsSinceEpoch;
    item.createdAt = now;
    item.updatedAt = now;
    
    if (kDebugMode) {
      print('Adding item with metadata:');
      print('userId: $userId');
      print('createdAt: ${DateTime.fromMillisecondsSinceEpoch(item.createdAt)}');
    }
    
    await _cartCollection.doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(CartItem item) async {
    final String? userId = _auth.currentUser?.uid;
    if (userId == null) return;
    
    final DocumentSnapshot docSnapshot = await _cartCollection.doc(item.id).get();
    if (docSnapshot.exists) {
      final Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      if (data['userId'] == userId) {
        if (data['createdAt'] != null) {
          item.createdAt = data['createdAt'];
        }
        item.updatedAt = DateTime.now().millisecondsSinceEpoch;
        
        if (kDebugMode) {
          print('Updating item:');
          print('createdAt: ${DateTime.fromMillisecondsSinceEpoch(item.createdAt)}');
          print('updatedAt: ${DateTime.fromMillisecondsSinceEpoch(item.updatedAt)}');
        }
        
        await _cartCollection.doc(item.id).update(item.toMap());
      } else {
        if (kDebugMode) print('Cannot update item: not the owner');
      }
    }
  }

  Future<void> deleteItem(String id) async {
    final String? userId = _auth.currentUser?.uid;
    if (userId == null) return;
    
    final DocumentSnapshot docSnapshot = await _cartCollection.doc(id).get();
    if (docSnapshot.exists) {
      final Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      if (data['userId'] == userId) {
        await _cartCollection.doc(id).delete();
        if (kDebugMode) print('Item deleted successfully');
      } else {
        if (kDebugMode) print('Cannot delete item: not the owner');
      }
    }
  }

  Stream<List<CartItem>> getAllItems() {
    return _cartCollection
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<CartItem>> getUserItems() {
    final String? userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);
    
    return _cartCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  bool isItemOwner(CartItem item) {
    final String? userId = _auth.currentUser?.uid;
    return userId != null && item.userId == userId;
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<String> getUserName(String userId) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (userDoc.exists && userDoc.data() != null) {
        final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Unknown User';
      }
      return 'Unknown User';
    } catch (e) {
      if (kDebugMode) print('Error getting username: $e');
      return 'Unknown User';
    }
  }
}

// Form Controller tetap sama
class FormController {
  static String? validateEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}