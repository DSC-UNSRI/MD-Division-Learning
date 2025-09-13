import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

class CartController {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('cart');

  Future<void> addItem(CartItem item) async {
    await _cartCollection.doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(CartItem item) async {
    await _cartCollection.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _cartCollection.doc(id).delete();
  }

  Stream<List<CartItem>> getItems() {
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
