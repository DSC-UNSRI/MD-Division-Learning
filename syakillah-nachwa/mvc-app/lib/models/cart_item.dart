// lib/models/cart_item.dart - FIXED VERSION
class CartItem {
  String id;
  String name;
  int quantity;
  String userId;
  int createdAt;
  int updatedAt;

  CartItem({
    required this.id, 
    required this.name, 
    required this.quantity,
    required this.userId,
    int? createdAt,
    int? updatedAt,
  }) : 
    createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
    updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'name': name, 
      'quantity': quantity,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
  
  DateTime get createdDateTime => DateTime.fromMillisecondsSinceEpoch(createdAt);
  DateTime get updatedDateTime => DateTime.fromMillisecondsSinceEpoch(updatedAt);
  
  bool isOwnedBy(String? userId) {
    return userId != null && this.userId == userId;
  }
}