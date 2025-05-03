class CartItem {
  String id;
  String name;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;

  CartItem({
    required this.id, 
    required this.name, 
    required this.quantity,
    required this.userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }): 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'name': name, 
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
      userId: map['userId'] ?? '',
    );
  }
}
