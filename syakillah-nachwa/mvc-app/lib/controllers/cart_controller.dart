import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartController {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('cart');
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    
    final docSnapshot = await _cartCollection.doc(item.id).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
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
    
    final docSnapshot = await _cartCollection.doc(id).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
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
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
  Stream<List<CartItem>> getUserItems() {
    final String? userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);
    
    return _cartCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
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
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (userDoc.exists && userDoc.data()?['name'] != null) {
        return userDoc.data()!['name'];
      }
      return 'Unknown User';
    } catch (e) {
      if (kDebugMode) print('Error getting username: $e');
      return 'Unknown User';
    }
  }
}