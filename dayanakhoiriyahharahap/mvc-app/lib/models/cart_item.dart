import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String id;
  String name;
  int quantity;
  String ownerId;
  DateTime createdAt;
  DateTime updatedAt;

  CartItem({required this.id, required this.name, required this.quantity, required this.ownerId, required this.createdAt, required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'quantity': quantity, 'ownerId' : ownerId, 'createdAt': createdAt,
      'updatedAt': updatedAt};
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      ownerId: map['ownerId'],
      createdAt: map['createdAt'] != null && map['createdAt'] is Timestamp
    ? (map['createdAt'] as Timestamp).toDate()
    : DateTime.now(),
updatedAt: map['updatedAt'] != null && map['updatedAt'] is Timestamp
    ? (map['updatedAt'] as Timestamp).toDate()
    : DateTime.now(),
    );
  }

  CartItem copyWith({
  String? id,
  String? name,
  int? quantity,
  String? ownerId,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return CartItem(
    id: id ?? this.id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

}
