class CartItem {
  String id;
  String name;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;

  CartItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.createdAt,
      required this.updatedAt,
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }
}
