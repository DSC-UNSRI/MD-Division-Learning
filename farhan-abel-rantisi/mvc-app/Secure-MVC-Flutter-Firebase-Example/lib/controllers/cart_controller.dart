import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

class CartController {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('cart');

  Future<void> addItem(CartItem item) async {
    await _cartCollection.doc(item.id).set({
      'id': item.id,
      'name': item.name,
      'quantity': item.quantity,
      'createdAt': item.createdAt.toIso8601String(),
      'updatedAt': item.updatedAt.toIso8601String(),
      'createdBy': item.createdBy,
    });
  }

  Future<void> updateItem(CartItem item) async {
    await _cartCollection.doc(item.id).update({
      'name': item.name,
      'quantity': item.quantity,
      'updatedAt': item.updatedAt.toIso8601String(),
      'createdBy': item.createdBy,
    });
  }

  Future<void> deleteItem(String id) async {
    await _cartCollection.doc(id).delete();
  }

  Stream<List<CartItem>> getItems() {
    return _cartCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartItem.fromMap(data);
      }).toList();
    });
  }
}
