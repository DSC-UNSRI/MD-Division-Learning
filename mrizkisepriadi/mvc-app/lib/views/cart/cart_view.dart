import 'package:flutter/material.dart';
import 'package:testing/controllers/auth_controller.dart';
import 'package:testing/controllers/notification_controller.dart';
import 'package:testing/controllers/profile_controller.dart';
import 'package:testing/views/auth/login_view.dart';
import 'package:testing/views/profile/profile_view.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController _cartController = CartController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final AuthController _authController = AuthController();
  final ProfileController _profileController = ProfileController();

  String? _fcmToken;
  bool _notificationsInitialized = false;
  String _initializationStatus = 'Not started';

  @override
  void initState() {
    super.initState();
    print('🛒 CartView initialized');
    _checkAndInitializeNotifications();
  }

  Future<void> _checkAndInitializeNotifications() async {
    final user = _authController.currentUser;
    print('👤 Current user: ${user?.email ?? "No user"}');

    if (user != null) {
      await _initializeNotifications();
    } else {
      setState(() {
        _initializationStatus = 'No user logged in';
      });
    }
  }

  Future<void> _initializeNotifications() async {
    setState(() {
      _initializationStatus = 'Initializing...';
    });

    try {
      print('🔔 Starting notification initialization in CartView...');
      await NotificationController.initialize();

      final token = await NotificationController.getFCMToken();
      print('🎫 FCM Token retrieved: ${token?.substring(0, 20)}...');

      setState(() {
        _fcmToken = token;
        _notificationsInitialized = true;
        _initializationStatus = 'Initialized successfully';
      });

      NotificationController.listenToTokenRefresh();
      print('✅ Notification initialization completed in CartView');
    } catch (e) {
      print('❌ Error initializing notifications in CartView: $e');
      setState(() {
        _initializationStatus = 'Failed: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor:
            _notificationsInitialized ? Colors.green : Colors.orange,
        actions: [
          // Test notification button
          IconButton(
            icon: Icon(Icons.notifications_active),
            onPressed: _notificationsInitialized
                ? () async {
                    print('🧪 Testing notification...');
                    try {
                      await NotificationController.showTestNotification();
                      print('✅ Test notification sent');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Test notification sent!')),
                        );
                      }
                    } catch (e) {
                      print('❌ Test notification failed: $e');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Notifications not ready: $_initializationStatus'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
          ),
          // FCM Token info button
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Debug Info'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('User: ${currentUser?.email ?? "Not logged in"}'),
                        SizedBox(height: 8),
                        Text('Status: $_initializationStatus'),
                        SizedBox(height: 8),
                        Text('Notifications Ready: $_notificationsInitialized'),
                        SizedBox(height: 8),
                        Text('FCM Token:'),
                        SizedBox(height: 4),
                        SelectableText(_fcmToken ?? 'No token available'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _initializeNotifications();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            },
          ),
          // Profile button
          IconButton(
            icon: Icon(Icons.account_circle, size: 32),
            onPressed: () async {
              final profile = await _profileController.fetchProfile();
              if (context.mounted && profile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileView(user: profile)),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
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
                  SizedBox(height: 16),

                  // Status indicators
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                  _notificationsInitialized
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: _notificationsInitialized
                                      ? Colors.green
                                      : Colors.red),
                              SizedBox(width: 8),
                              Text('Notifications: $_initializationStatus'),
                            ],
                          ),
                          if (currentUser != null) ...[
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.blue),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text('User: ${currentUser.email}')),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _notificationsInitialized
                        ? () async {
                            try {
                              await NotificationController
                                  .showTestNotification();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Test notification sent!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        : () async {
                            await _initializeNotifications();
                          },
                    icon: Icon(_notificationsInitialized
                        ? Icons.notification_add
                        : Icons.refresh),
                    label: Text(_notificationsInitialized
                        ? 'Test Notification'
                        : 'Retry Init'),
                  ),
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
                    child: Text('${item.quantity}'),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(item.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Created: ${item.createdAt.toString().split(' ')[0]}'),
                  trailing: item.userId == _authController.currentUser?.uid
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showEditItemDialog(context, item),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete Item'),
                                    content: Text(
                                        'Are you sure you want to delete ${item.name}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _cartController.deleteItem(item.id);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
            onPressed: () {
              Navigator.pop(context);
              _nameController.clear();
              _quantityController.clear();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isEmpty ||
                  _quantityController.text.isEmpty) {
                return;
              }

              final user = _authController.currentUser;
              if (user == null) return;

              final item = CartItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
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
                SnackBar(content: Text('Item added to cart!')),
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, CartItem item) {
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
              if (_nameController.text.isEmpty ||
                  _quantityController.text.isEmpty) {
                return;
              }

              _cartController.updateItem(
                item.id,
                _nameController.text,
                int.parse(_quantityController.text),
              );

              Navigator.pop(context);
              _nameController.clear();
              _quantityController.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item updated!')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
