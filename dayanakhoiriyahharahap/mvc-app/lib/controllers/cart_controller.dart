import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class CartController {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('cart');

  Future<void> addItem(CartItem item) async {
  final now = DateTime.now();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  final newItem = item.copyWith(
    ownerId: userId ?? 'unknown',
    createdAt: now,
    updatedAt: now,
  );

  await _cartCollection.doc(item.id).set(newItem.toMap());
}


  Future<void> updateItem(CartItem item) async {
  final updatedItem = item.copyWith(
    updatedAt: DateTime.now(),
  );

  await _cartCollection.doc(item.id).update(updatedItem.toMap());
}


  Future<void> deleteItem(String id) async {
    await _cartCollection.doc(id).delete();
  }

Stream<List<CartItem>> getItems() {
  return _cartCollection.snapshots().map((snapshot) {
  return snapshot.docs.map((doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      return CartItem.fromMap(data);
    } catch (e) {
      print('Error parsing doc: $e');
      return null; // or throw
    }
  }).whereType<CartItem>().toList();
});
}


}
