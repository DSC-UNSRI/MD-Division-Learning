import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart'; // Pastikan path ini benar

class CartController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _cartCollection => _firestore.collection('cart');

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> addItem(CartItem item) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception("Pengguna tidak login. Tidak dapat menambahkan item.");
    }

    if (item.userId != userId) {
      throw Exception("UserID pada item tidak sesuai dengan pengguna saat ini.");
    }

    Map<String, dynamic> dataToSet = item.toMap();
    dataToSet['createdAt'] = FieldValue.serverTimestamp();
    dataToSet['updatedAt'] = FieldValue.serverTimestamp();

    await _cartCollection.doc(item.id).set(dataToSet);
  }

  Future<void> updateItem(CartItem item) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception("Pengguna tidak login. Tidak dapat memperbarui item.");
    }

    if (item.userId != userId) {
      throw Exception(
          "Tidak diizinkan memperbarui item milik pengguna lain.");
    }

    Map<String, dynamic> dataToUpdate = item.toMap();
    dataToUpdate.remove('createdAt'); 
    dataToUpdate.remove('userId'); 
    dataToUpdate['updatedAt'] = FieldValue.serverTimestamp();

    await _cartCollection.doc(item.id).update(dataToUpdate);
  }

  Future<void> deleteItem(String itemId) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception("Pengguna tidak login. Tidak dapat menghapus item.");
    }

    await _cartCollection.doc(itemId).delete();
  }

  Future<void> deleteCartItemWithOwnershipCheck(String itemId, String itemOwnerId) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception("Pengguna tidak login.");
    }
    if (userId != itemOwnerId) {
      throw Exception("Anda tidak diizinkan untuk menghapus item ini.");
    }

    await _cartCollection.doc(itemId).delete();
  }

  Stream<List<CartItem>> getItems() {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.error(
          Exception("Pengguna tidak login untuk mengambil item keranjang."));
          
    }

    return _cartCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
             return CartItem.fromMap(data!, doc.id);
          }).whereType<CartItem>().toList();
        });
  }
}