import 'package:flutter/material.dart';
import 'package:testing/controllers/auth_controller.dart';
import 'package:testing/controllers/profile_controller.dart';
import 'package:testing/views/auth/login_view.dart';
import 'package:testing/views/profile/profile_view.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';
import 'cart_item_view.dart';

class CartView extends StatelessWidget {
  final CartController _cartController = CartController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final AuthController _authController = AuthController();
  final ProfileController _profileController = ProfileController();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = _authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 32),
            onPressed: () async {
              final profile = await _profileController.fetchProfile();
              if (context.mounted && profile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileView(user: profile),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(),
                  ),
                );
              }
            },
          ),
          SizedBox(width: 12),
        ],
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: _cartController.getItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Your cart is empty!", style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Icon(Icons.shopping_bag,
                        color: Theme.of(context).primaryColorDark),
                  ),
                  title: Text(item.name,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: item.userId == currentUser?.uid
                      ? Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CartItemView(item: item),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _cartController.deleteItem(item.id),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isEmpty ||
                  _quantityController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }

              final user = _authController.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You must be logged in')),
                );
                return;
              }

              final item = CartItem(
                id: DateTime.now().toString(),
                name: _nameController.text,
                quantity: int.parse(_quantityController.text),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                userId: user.uid,
              );

              _cartController.addItem(item);
              Navigator.pop(context);

              _nameController.clear();
              _quantityController.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item added to cart')),
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
