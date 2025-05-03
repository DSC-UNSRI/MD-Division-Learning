import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class CartController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}
