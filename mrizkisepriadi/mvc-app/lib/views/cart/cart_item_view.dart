import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../controllers/cart_controller.dart';

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
                onPressed: () {
                  _cartController.updateItem(
                    item.id,
                    _nameController.text,
                    int.parse(_quantityController.text),
                  );
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green)),
          ],
        ),
      ),
    );
  }
}
