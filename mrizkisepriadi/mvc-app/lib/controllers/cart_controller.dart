import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class CartController {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('cart');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _currentUser => _auth.currentUser;

  Future<void> addItem(CartItem item) async {
    if (_currentUser == null) return;

    final newItem = CartItem(
      id: item.id,
      name: item.name,
      quantity: item.quantity,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: _currentUser!.uid,
    );

    await _cartCollection.doc(newItem.id).set(newItem.toMap());
  }

  Future<void> updateItem(String itemId, String name, int newQuantity) async {
    if (_currentUser == null) return;

    final doc = await _cartCollection.doc(itemId).get();
    if (!doc.exists || doc['userId'] != _currentUser!.uid) return;

    await _cartCollection.doc(itemId).update({
      'name': name,
      'quantity': newQuantity,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteItem(String itemId) async {
    if (_currentUser == null) return;

    final doc = await _cartCollection.doc(itemId).get();
    if (!doc.exists || doc['userId'] != _currentUser!.uid) return;

    await _cartCollection.doc(itemId).delete();
  }

  Stream<List<CartItem>> getItems() {
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
