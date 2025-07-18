import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../controllers/cart_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemView extends StatelessWidget {
  final CartItem item;
  final CartController _cartController = CartController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  CartItemView({super.key, required this.item}) {
    _nameController.text = item.name;
    _quantityController.text = item.quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  final updatedItem = CartItem(
                    id: item.id,
                    name: _nameController.text,
                    quantity: int.parse(_quantityController.text),
                    userId: currentUser.uid, 
                    createdAt: item.createdAt, 
                    updatedAt: Timestamp.now(), 
                    createdByUserId: item.createdByUserId,
                  );
                  _cartController.updateItem(updatedItem);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You must be logged in to update items')),
                  );
                }
              },
              child: Text('Save'),
            ),

          ],
        ),
      ),
    );
  }
}
