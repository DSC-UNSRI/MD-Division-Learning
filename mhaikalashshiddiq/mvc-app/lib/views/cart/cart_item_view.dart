import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../controllers/cart_controller.dart';

class CartItemView extends StatefulWidget {
  final CartItem item;

  const CartItemView({super.key, required this.item});

  @override
  State<CartItemView> createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  final CartController _cartController = CartController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item.name;
    _quantityController.text = widget.item.quantity.toString();
  }

  Future<void> _saveItem() async {
    if (_currentUser?.uid != widget.item.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are not authorized to edit this item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_nameController.text.isEmpty || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      int quantity = int.parse(_quantityController.text);
      if (quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quantity must be greater than 0'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });

      final updatedItem = CartItem(
        id: widget.item.id,
        name: _nameController.text,
        quantity: quantity,
        userId: widget.item.userId,
      );
      
      await _cartController.updateItem(updatedItem);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner = widget.item.userId == _currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOwner) ...[
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You can only view this item as it was created by another user',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Item Name',
                          prefixIcon: Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        enabled: isOwner,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: isOwner,
                      ),
                      const SizedBox(height: 24),
                      if (isOwner) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Save Changes'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                        title: Text('Created'),
                        subtitle: Text(
                          '${widget.item.createdAt.toLocal().toString().split('.')[0]}',
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.update, color: Colors.blue.shade700),
                        title: Text('Last Updated'),
                        subtitle: Text(
                          '${widget.item.updatedAt.toLocal().toString().split('.')[0]}',
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.blue.shade700),
                        title: Text('Owner'),
                        subtitle: Text(
                          isOwner ? 'You' : 'Another user',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
