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

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners for the dialog
          ),
          backgroundColor: Colors.white, // Background color of the dialog
          title: Row(
            children: [
              Icon(Icons.add_circle, color: Colors.pinkAccent[100], size: 30), // Icon in title
              SizedBox(width: 10), // Space between the icon and the title text
              Text(
                'Add New Item',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Item Name TextField
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.shopping_cart, color: Colors.teal), // Icon inside TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Price TextField
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (DH)',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.teal), // Icon inside TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              // Quantity TextField
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.numbers, color: Colors.teal), // Icon inside TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              // DropdownButton for Units
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
                    child: Row(
                      children: [
                        Icon(Icons.layers, color: Colors.teal), // Icon inside DropdownItem
                        SizedBox(width: 10),
                        Text(unit),
                      ],
                    ),
                  );
                }).toList(),
                isExpanded: true,

              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Row(
                children: [
                  Icon(Icons.cancel, color: Colors.grey), // Icon for Cancel action
                  SizedBox(width: 5),
                  Text('Cancel', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            // Add Item Button
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
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green), // Icon for Add action
                  SizedBox(width: 5),
                  Text('Add Item', style: TextStyle(color: Colors.green)),
                ],
              ),
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

  // Widget for displaying the shopping list with styled checkboxes and icons
  Widget _buildShoppingList(List<ShoppingItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white, // Soft background color for each item
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 3),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(
              item.isBought ? Icons.ac_unit_sharp : Icons.radio_button_unchecked,
              color: item.isBought ? Colors.cyan[100] : Colors.grey,
              size: 30.0,
            ),
            title: Text(
              item.itemName ?? 'Unnamed Item',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold, // Bold text for item name
                color: Colors.black87, // Soft black color for text
              ),
            ),
            subtitle: Text(
              'Price: ${item.price} DH, Quantity: ${item.quantity} ${item.unit}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal, // Lighter text for price and quantity
                color: Colors.black54, // Softer gray color for subtitle
              ),
            ),
            trailing: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Checkbox(
                key: ValueKey<bool>(item.isBought),
                value: item.isBought,
                onChanged: (bool? value) {
                  setState(() {
                    item.isBought = value ?? false;
                    _controller.updateItem(item); // Update the Firestore item
                  });
                },
              ),
            ),
            onTap: () {
              // Open the dialog to update the item
              _showUpdateItemDialog(item);
            },
            onLongPress: () {
              // Delete the item from Firestore
              _controller.deleteItem(item.id ?? '');
            },
          ),
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
        title: const Text(
          'Salin List',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          // Profile Icon added in AppBar
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black26),
            onPressed: () {
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
          backgroundColor: Colors.deepPurple[100],
          onPressed: _showAddItemDialog,
          tooltip: 'Create new item',
          child: const Text(
            'Create new item',
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
