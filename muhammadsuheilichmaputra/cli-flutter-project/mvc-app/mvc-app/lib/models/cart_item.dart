import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String id;
  String name; 
  int quantity;
  String userId;
  final Timestamp createdAt;
  Timestamp updatedAt;
  final String createdByUserId;
   

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdByUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'userId': userId, 
      'createdAt': createdAt, 
      'updatedAt': updatedAt, 
      'createdByUserId': createdByUserId,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, [String? documentId]) {
    return CartItem(
      id: map['id'] as String? ?? documentId ?? '',
      name: map['name'] as String? ?? map['productName'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      userId: map['userId'] as String? ?? '',
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: map['updatedAt'] as Timestamp,
      createdByUserId: map['createdByUserId'] as String? ?? map['userId'] as String? ?? '',
    );
  }
}