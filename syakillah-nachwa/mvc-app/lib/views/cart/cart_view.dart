// lib/views/cart/cart_view.dart - UPDATE bagian ini
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/cart_item.dart';
import '../auth/login_view.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController _cartController = CartController();
  final AuthController _authController = AuthController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Subscribe to notifications saat cart view dimuat
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _cartController.subscribeToNotifications();
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => _showUserProfileDialog(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Cart Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Test Notification'),
              onTap: () {
                _cartController.sendTestNotification();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Test notification sent!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _handleLogout(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Form untuk add item
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
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
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // List semua cart items
          Expanded(
            child: StreamBuilder<List<CartItem>>(
              stream: _cartController.getAllItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No items in cart'));
                }

                final items = snapshot.data!;
                items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isOwner = _cartController.isItemOwner(item);
                    
                    return FutureBuilder<String>(
                      future: _cartController.getUserName(item.userId),
                      builder: (context, userSnapshot) {
                        final userName = userSnapshot.data ?? 'Loading...';
                        
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          color: isOwner ? Colors.blue.shade50 : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(item.quantity.toString()),
                              backgroundColor: isOwner ? Colors.blue : Colors.grey,
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: isOwner ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('By: $userName'),
                                Text(
                                  'Updated: ${DateFormat('dd/MM/yyyy HH:mm').format(item.updatedDateTime)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: isOwner ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editItem(item),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteItem(item.id),
                                ),
                              ],
                            ) : null,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    if (_nameController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      final item = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        quantity: int.tryParse(_quantityController.text) ?? 1,
        userId: _cartController.getCurrentUserId() ?? '',
      );

      _cartController.addItem(item);
      _nameController.clear();
      _quantityController.clear();
    }
  }

  void _editItem(CartItem item) {
    _nameController.text = item.name;
    _quantityController.text = item.quantity.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
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
            onPressed: () {
              item.name = _nameController.text;
              item.quantity = int.tryParse(_quantityController.text) ?? item.quantity;
              _cartController.updateItem(item);
              _nameController.clear();
              _quantityController.clear();
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _cartController.deleteItem(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUserProfileDialog() async {
    final userData = await _authController.getCurrentUserData();
    if (userData != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('User Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${userData['name'] ?? 'N/A'}'),
              Text('Email: ${userData['email'] ?? 'N/A'}'),
              Text('Bio: ${userData['bio'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _handleLogout() async {
    // Cleanup notifications before logout
    await _cartController.unsubscribeFromNotifications();
    
    final success = await _authController.logout();
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}