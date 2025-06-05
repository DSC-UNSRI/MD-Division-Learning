import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk mendapatkan UID user
import 'package:flutter/foundation.dart';
import 'package:testing/models/cart_item.dart';

class CartController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper untuk mendapatkan path koleksi cart user saat ini
  CollectionReference<Map<String, dynamic>>? _currentUserCartCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      if (kDebugMode) print("User not logged in to access cart.");
      return null;
    }
    return _firestore.collection('users').doc(user.uid).collection('cartItems');
  }

  Future<void> addItem(CartItem item) async {
    final collectionRef = _currentUserCartCollection();
    if (collectionRef == null) return;

    // Update item dengan userId dan timestamps
    final itemWithMeta = CartItem(
      id: item.id,
      name: item.name,
      quantity: item.quantity,
      userId: _auth.currentUser!.uid,
      createdAt: null,
      updatedAt: null,
    );

    // Jika id item belum ada (item baru), biarkan Firestore men-generate ID
    // Jika id sudah ada (misalnya dari produk), gunakan itu.
    // Untuk contoh ini, kita asumsikan ID item (misalnya dari produk) sudah ada.
    // Jika tidak, Anda bisa menggunakan collectionRef.add(itemWithMeta.toMap());
    // dan kemudian dapatkan ID dari DocumentReference yang dikembalikan.

    // Jika ID dari item adalah yang akan menjadi ID dokumen:
    await collectionRef.doc(item.id).set(itemWithMeta.toMap());
  }

  Future<void> updateItem(CartItem item) async {
    final collectionRef = _currentUserCartCollection();
    if (collectionRef == null) return;

    await collectionRef.doc(item.id).update({
      'name': item.name,
      'quantity': item.quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteItem(String itemId) async {
    final collectionRef = _currentUserCartCollection();
    if (collectionRef == null) return;
    await collectionRef.doc(itemId).delete();
  }

  Stream<List<CartItem>> getItems() {
    final collectionRef = _currentUserCartCollection();
    if (collectionRef == null) {
      return Stream.value([]);
    }
    return collectionRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(
              // ignore: unnecessary_cast
              doc.data() as Map<String, dynamic>,
              doc.id))
          .toList();
    });
  }
}
