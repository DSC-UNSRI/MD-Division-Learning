import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../controllers/cart_controller.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class CartItemView extends StatefulWidget {
  final CartItem item;

  CartItemView({super.key, required this.item});

  @override
  State<CartItemView> createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  final CartController _cartController = CartController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _isOwner = false;

  String _formatTimestamp(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM d, yyyy HH:mm').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item.name;
    _quantityController.text = widget.item.quantity.toString();
    
    final currentUserId = _cartController.getCurrentUserId();
    _isOwner = currentUserId != null && widget.item.userId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isOwner ? 'Edit Item' : 'View Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Details',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.shopping_cart),
                        ),
                        enabled: _isOwner,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: _isOwner,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metadata',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.blue),
                        title: Text('Added by'),
                        subtitle: Text(_isOwner ? 'You' : 'Another user'),
                        dense: true,
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.green),
                        title: Text('Created at'),
                        subtitle: Text(_formatTimestamp(widget.item.createdAt)),
                        dense: true,
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.update, color: Colors.orange),
                        title: Text('Last updated'),
                        subtitle: Text(_formatTimestamp(widget.item.updatedAt)),
                        dense: true,
                      ),
                      if (widget.item.createdAt != widget.item.updatedAt) 
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.orange[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange[700], size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'This item has been modified since it was created',
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              if (_isOwner)
                ElevatedButton.icon(
                  onPressed: () {
                    try {
                      final updatedItem = CartItem(
                        id: widget.item.id,
                        name: _nameController.text,
                        quantity: int.parse(_quantityController.text),
                        userId: widget.item.userId,
                        createdAt: widget.item.createdAt,
                        // updatedAt will be set in the controller
                      );
                      _cartController.updateItem(updatedItem);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid quantity')),
                      );
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: Colors.grey),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You cannot edit this item as it was added by another user',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}