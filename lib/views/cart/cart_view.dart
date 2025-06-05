// lib/views/cart/cart_view.dart
// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing/controllers/auth_controller.dart';
import 'package:testing/views/profile/profile_view.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';
import '../auth/login_view.dart';
import 'cart_item_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController _cartController = CartController();
  final AuthController _authController = AuthController();

  Future<void> _logout() async {
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text('Confirm Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Text('Are you sure you want to log out?',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Logout',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true && mounted) {
      final loggedOut = await _authController.logout();
      if (mounted) {
        if (loggedOut) {
          // Tidak perlu SnackBar di sini karena langsung navigasi
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to log out. Please try again.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  void _showAddItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text('Add New Item',
              style: TextStyle(color: colorScheme.onSurface)),
          content: Form(
            key: dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'e.g., Flutter Book',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    prefixIcon: Icon(Icons.shopping_bag_outlined,
                        color: colorScheme.onSurfaceVariant),
                  ),
                  style: TextStyle(color: colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Item name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'e.g., 1',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    prefixIcon: Icon(Icons.format_list_numbered,
                        color: colorScheme.onSurfaceVariant),
                  ),
                  style: TextStyle(color: colorScheme.onSurface),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity cannot be empty';
                    }
                    final int? quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Enter a valid quantity (must be > 0)';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(color: colorScheme.secondary)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
              onPressed: () {
                if (dialogFormKey.currentState!.validate()) {
                  final newItemId = FirebaseFirestore.instance
                      .collection('temp')
                      .doc()
                      .id; // Generate ID
                  final item = CartItem(
                    id: newItemId,
                    name: nameController.text.trim(),
                    quantity: int.parse(quantityController.text.trim()),
                  );
                  _cartController.addItem(item);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Item'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteItem(String itemId, String itemName) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text('Confirm Deletion',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Text('Are you sure you want to delete "$itemName"?',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                _cartController.deleteItem(itemId);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'My Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: _cartController.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: colorScheme.secondary));
          }
          if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: colorScheme.error, size: 60),
                  const SizedBox(height: 16),
                  Text('Failed to load cart items.',
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(),
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.error),
                      textAlign: TextAlign.center),
                ],
              ),
            ));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart_outlined,
                        size: 80,
                        color: colorScheme.onSurface.withOpacity(0.5)),
                    const SizedBox(height: 20),
                    Text(
                      'Your Cart is Empty',
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Looks like you haven\'t added anything to your cart yet.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart_rounded),
                      label: const Text('Start Shopping'),
                      onPressed: _showAddItemDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          final items = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                color: colorScheme.surfaceVariant.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      child: Text(
                        item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(item.name,
                        style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface)),
                    subtitle: Text('Quantity: ${item.quantity}',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined,
                              color: colorScheme.primary),
                          tooltip: 'Edit Item',
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
                          icon: Icon(Icons.delete_outline_rounded,
                              color: colorScheme.error),
                          tooltip: 'Delete Item',
                          onPressed: () =>
                              _confirmDeleteItem(item.id, item.name),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 0),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        tooltip: 'Add New Item',
        icon: const Icon(Icons.add_shopping_cart_rounded),
        label: const Text('Add Item'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}
