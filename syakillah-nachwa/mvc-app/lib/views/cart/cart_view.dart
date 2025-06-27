import 'package:flutter/material.dart';
import 'package:testing/controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';
import '../auth/login_view.dart';
import '../profile/profile_view.dart'; 
import 'cart_item_view.dart';
import 'package:intl/intl.dart';

class CartView extends StatelessWidget {
  final CartController _cartController = CartController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final AuthController _authController = AuthController();

  CartView({super.key});

  String _formatTimestamp(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM d, yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Cart'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final loggedOut = await _authController.logout();
                      if (context.mounted) {
                        if (loggedOut) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to log out'),
                            ),
                          );
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 16,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: _cartController.getAllItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in the cart'));
          }
          
          final items = snapshot.data!;
          final currentUserId = _cartController.getCurrentUserId();
          
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isOwner = currentUserId != null && item.userId == currentUserId;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ExpansionTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: isOwner 
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CartItemView(item: item),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _cartController.deleteItem(item.id),
                            ),
                          ],
                        )
                      : const Icon(Icons.keyboard_arrow_down),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                isOwner ? 'Added by you' : 'Added by another user',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: isOwner ? Colors.blue : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Created: ${_formatTimestamp(item.createdAt)}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.update, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Last updated: ${_formatTimestamp(item.updatedAt)}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          if (item.createdAt != item.updatedAt) 
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'This item has been modified since creation',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.clear();
          _quantityController.clear();
          
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty && 
                        _quantityController.text.isNotEmpty) {
                      try {
                        final quantity = int.parse(_quantityController.text);
                        final item = CartItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text,
                          quantity: quantity,
                          userId: _authController.getCurrentUserId() ?? '',
                        );
                        _cartController.addItem(item);
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid quantity')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}