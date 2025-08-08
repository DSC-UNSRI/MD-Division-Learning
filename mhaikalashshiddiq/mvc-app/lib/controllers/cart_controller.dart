import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../services/notification_service.dart';

class CartController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();

  // Get reference to cart collection
  CollectionReference get _cartCollection => _firestore.collection('cart');

  // Get current user ID or throw error if not authenticated
  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  // Add a new cart item with current user as owner
  Future<void> addItem(CartItem item) async {
    final userId = _currentUserId;
    final newItem = CartItem(
      id: item.id,
      name: item.name,
      quantity: item.quantity,
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _cartCollection.doc(item.id).set(newItem.toMap());
  }

  // Update an existing cart item if user is the owner
  Future<void> updateItem(CartItem item) async {
    final userId = _currentUserId;
    
    // Check if user is the owner
    final doc = await _cartCollection.doc(item.id).get();
    if (!doc.exists) {
      throw Exception('Item not found');
    }
    
    final data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != userId) {
      throw Exception('Not authorized to update this item');
    }
    
    // Update with new data but keep creation time and owner
    final updatedItem = CartItem(
      id: item.id,
      name: item.name,
      quantity: item.quantity,
      userId: data['userId'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.now(),
    );
    
    await _cartCollection.doc(item.id).update(updatedItem.toMap());
  }

  // Delete an item if user is the owner
  Future<void> deleteItem(String id) async {
    final userId = _currentUserId;
    
    // Check if user is the owner
    final doc = await _cartCollection.doc(id).get();
    if (!doc.exists) {
      throw Exception('Item not found');
    }
    
    final data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != userId) {
      throw Exception('Not authorized to delete this item');
    }
    
    await _cartCollection.doc(id).delete();
  }

  // Get all items (if authenticated)
  Stream<List<CartItem>> getItems() {
    try {
      final userId = _currentUserId;
      return _cartCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      // Return empty stream if not authenticated
      return Stream.value([]);
    }
  }

  // Get only items created by current user
  Stream<List<CartItem>> getUserItems() {
    try {
      final userId = _currentUserId;
      return _cartCollection
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      // Return empty stream if not authenticated
      return Stream.value([]);
    }
  }

  // Initialize cart listener for real-time updates
  void initializeCartListener() {
    try {
      final userId = _currentUserId;
      
      // Listen to all cart changes for notifications
      _cartCollection.snapshots().listen((snapshot) {
        for (var change in snapshot.docChanges) {
          _handleCartChange(change);
        }
      });
      
      print('Cart listener initialized for user: $userId');
    } catch (e) {
      print('Error initializing cart listener: $e');
    }
  }

  // Handle cart changes for notifications
  void _handleCartChange(DocumentChange change) {
    try {
      final data = change.doc.data() as Map<String, dynamic>?;
      if (data == null) return;
      
      final item = CartItem.fromMap(data);
      final currentUserId = _auth.currentUser?.uid;
      
      // Don't notify for own changes
      if (item.userId == currentUserId) return;
      
      String title = '';
      String body = '';
      
      switch (change.type) {
        case DocumentChangeType.added:
          title = 'New Cart Item Added';
          body = '${item.name} (${item.quantity}) was added to the cart';
          break;
        case DocumentChangeType.modified:
          title = 'Cart Item Updated';
          body = '${item.name} was updated in the cart';
          break;
        case DocumentChangeType.removed:
          title = 'Cart Item Removed';
          body = '${item.name} was removed from the cart';
          break;
      }
      
      // Show local notification for real-time updates
      _showCartUpdateNotification(title, body, item);
      
    } catch (e) {
      print('Error handling cart change: $e');
    }
  }

  // Show cart update notification
  void _showCartUpdateNotification(String title, String body, CartItem item) {
    _notificationService.showLocal(
      title,
      body,
      data: {
        'type': 'cart_update',
        'itemId': item.id,
        'name': item.name,
        'quantity': item.quantity,
      },
    );
  }

  // Get FCM token for current user
  Future<String?> getFCMToken() async {
    return await _notificationService.getToken();
  }

  // Subscribe to cart update notifications
  Future<void> subscribeToNotifications() async {
    await _notificationService.initializeForUser();
    // Also ensure token is saved and topics are subscribed after login
    initializeCartListener();
  }

  // Unsubscribe from notifications (call on logout)
  Future<void> unsubscribeFromNotifications() async {
    await _notificationService.unsubscribeFromTopics();
    await _notificationService.removeTokenFromFirestore();
  }
}
