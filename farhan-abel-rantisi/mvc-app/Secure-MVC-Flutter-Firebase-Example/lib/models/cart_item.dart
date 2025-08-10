import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    try {
      return CartItem(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        quantity: map['quantity'] ?? 0,
        createdAt: _toDateTime(map['createdAt']),
        updatedAt: _toDateTime(map['updatedAt']),
        createdBy: map['createdBy'] ?? '',
      );
    } catch (e, stackTrace) {
      print('Error parsing CartItem.fromMap: $e');
      print(stackTrace);
      throw Exception('Failed to parse CartItem');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else if (value is DateTime) {
      return value;
    } else {
      print('Unknown datetime format: $value');
      return DateTime.now(); // Fallback
    }
  }
}
