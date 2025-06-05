// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing/models/cart_item.dart';
import 'package:testing/controllers/cart_controller.dart';

class CartItemView extends StatefulWidget {
  final CartItem item;

  const CartItemView({super.key, required this.item});

  @override
  State<CartItemView> createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  final CartController _cartController = CartController();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController =
        TextEditingController(text: widget.item.quantity.toString());
  }

  Future<void> _saveItemChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final updatedItem = CartItem(
        id: widget.item.id,
        name: _nameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        userId: widget.item.userId,
        createdAt: widget.item.createdAt,
      );
      await _cartController.updateItem(updatedItem);

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item updated successfully!'),
            backgroundColor: Colors.green[700],
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cart Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Update Item Details',
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Modify the name or quantity of your cart item.',
                  style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Item Name Text Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'Enter item name',
                    prefixIcon: Icon(Icons.shopping_bag_outlined,
                        color: colorScheme.onSurfaceVariant),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Item name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Quantity Text Field
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter quantity',
                    prefixIcon: Icon(Icons.format_list_numbered,
                        color: colorScheme.onSurfaceVariant),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurface),
                  keyboardType:
                      TextInputType.number, // Hanya tampilkan keyboard angka
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly // Hanya izinkan input digit
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity cannot be empty';
                    }
                    final int? quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Please enter a valid quantity (must be > 0)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Save Changes Button
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: colorScheme.secondary))
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt_outlined, size: 20),
                        label: const Text('Save Changes'),
                        onPressed: _saveItemChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle:
                              textTheme.labelLarge?.copyWith(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
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
