import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../controllers/ItemController.dart';
import '../models/Item.dart';
import 'authentification/profile.dart';


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

  String _selectedUnit = 'g';  // Default unit is grams (g)

  // List of units to choose from
  final List<String> _units = ['g', 'kg', 'L', 'qte'];

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
                decoration: InputDecoration(labelText: 'Price (DH)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _selectedUnit,
                onChanged: (String? newUnit) {
                  setState(() {
                    _selectedUnit = newUnit!;
                  });
                },
                items: _units.map<DropdownMenuItem<String>>((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
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
                    unit: _selectedUnit,  // Add selected unit
                    isBought: false,
                  );
                  _controller.addItem(item);

                  // Clear the input fields
                  _itemNameController.clear();
                  _priceController.clear();
                  _quantityController.clear();
                  setState(() {
                    _selectedUnit = 'g';  // Reset to default unit
                  });

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

  // Function to open the AlertDialog for updating an item
  void _showUpdateItemDialog(ShoppingItem item) {
    // Set initial values from the item
    _itemNameController.text = item.itemName ?? '';
    _priceController.text = item.price?.toString() ?? '';
    _quantityController.text = item.quantity?.toString() ?? '';
    _selectedUnit = item.unit ?? 'g';  // Set the selected unit

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Item'),
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
                decoration: InputDecoration(labelText: 'Price (DH)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _selectedUnit,
                onChanged: (String? newUnit) {
                  setState(() {
                    _selectedUnit = newUnit!;
                  });
                },
                items: _units.map<DropdownMenuItem<String>>((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
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

                // Update the item details in Firestore
                item.itemName = itemName;
                item.price = price;
                item.quantity = quantity;
                item.unit = _selectedUnit;  // Update the unit

                _controller.updateItem(item);

                // Clear the input fields
                _itemNameController.clear();
                _priceController.clear();
                _quantityController.clear();
                setState(() {
                  _selectedUnit = 'g';  // Reset to default unit
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Update Item'),
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
          subtitle: Text(
            'Price: ${item.price} DH, Quantity: ${item.quantity} ${item.unit}',
          ),
          trailing: Checkbox(
            value: item.isBought,
            onChanged: (bool? value) {
              setState(() {
                item.isBought = value ?? false;
                _controller.updateItem(item); // Update the Firestore item
              });
            },
          ),
          onTap: () {
            // Open the dialog to update the item
            _showUpdateItemDialog(item);
          },
          onLongPress: () {
            // Delete the item from Firestore
            _controller.deleteItem(item.id ?? '');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(

        backgroundColor: kBackgroundColor,
        title: const Text('Salin'),
        actions: [
          // Profile Icon added in AppBar
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black), // Profile icon
            onPressed: () {
              // Navigate to ProfileScreen when icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
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
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 35.0),
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(84, 25, 210, 1.0),
            onPressed: _showAddItemDialog,

          tooltip: 'Create new list',
          child: const Text(
            'Create new list',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
          ),
        ),
      ),



    );
  }
}
