import 'package:flutter/material.dart';

import '../controllers/ItemController.dart';
import '../models/Item.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ShoppingItemController _controller = ShoppingItemController();

  // To hold the input fields for adding a new item
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Function to open the AlertDialog for adding a new item
  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String itemName = _itemNameController.text;
                final double price =
                    double.tryParse(_priceController.text) ?? 0.0;
                final int quantity =
                    int.tryParse(_quantityController.text) ?? 0;

                // Create a new ShoppingItem and add it to Firestore
                if (itemName.isNotEmpty) {
                  final item = ShoppingItem(
                    itemName: itemName,
                    price: price,
                    quantity: quantity,
                    isBought: false,
                  );
                  _controller.addItem(item);

                  // Clear the input fields
                  _itemNameController.clear();
                  _priceController.clear();
                  _quantityController.clear();

                  // Close the dialog
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add Item'),
            ),
          ],
        );
      },
    );
  }

  // Widget for displaying the shopping list
  Widget _buildShoppingList(List<ShoppingItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          title: Text(item.itemName ?? 'Unnamed Item'),
          subtitle: Text('Price: \$${item.price}, Quantity: ${item.quantity}'),
          trailing: Checkbox(
            value: item.isBought,
            onChanged: (bool? value) {
              setState(() {
                item.isBought = value ?? false;
                _controller.updateItem(item); // Update the Firestore item
              });
            },
          ),
          onLongPress: () {
            _controller.deleteItem(item.id ?? ''); // Delete the item from Firestore
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: StreamBuilder<List<ShoppingItem>>(
        stream: _controller.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found.'));
          }

          final items = snapshot.data!;

          return _buildShoppingList(items);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog, // Show dialog to add item
        child: Icon(Icons.add),
      ),
    );
  }
}
