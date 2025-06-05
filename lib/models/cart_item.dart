import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String id;
  String name;
  int quantity;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? userId;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'userId': userId,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String documentId) {
    return CartItem(
      id: documentId,
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      createdAt: map['createdAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
      userId: map['userId'] as String?,
    );
  }
}
