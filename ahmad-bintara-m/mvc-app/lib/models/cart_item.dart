class CartItem {
  String id;
  String name;
  int quantity;

  CartItem({required this.id, required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'quantity': quantity};
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}
