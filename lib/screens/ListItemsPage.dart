import 'package:flutter/material.dart';
import '../controllers/FirestoreService.dart';
import '../models/Item.dart';
import '../constants/colors.dart'; // If you have a custom colors file, else skip this import.

class ListItemsPage extends StatefulWidget {
  final String listId;
  final String listName;

  const ListItemsPage({Key? key, required this.listId, required this.listName}) : super(key: key);

  @override
  State<ListItemsPage> createState() => _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedUnit = 'g';  // Default unit is grams (g)

  // List of units to choose from
  final List<String> _units = ['g', 'kg', 'L', 'qte'];

  // Method to add an item to Firestore
  void _addItem() {
    final itemName = _itemNameController.text;
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final price = double.tryParse(_priceController.text) ?? 0;
    final unit = _selectedUnit;

    if (itemName.isNotEmpty) {
      final newItem = ShoppingItem(
        itemName: itemName,
        quantity: quantity,
        price: price,
        unit: unit,
        isBought: false,
      );

      _firestoreService.addShoppingItem(widget.listId, newItem);
      _itemNameController.clear();
      _quantityController.clear();
      _priceController.clear();
    }
  }

  // Method to show the item creation dialog
  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    hintText: "Item Name",
                    prefixIcon: Icon(Icons.shopping_cart, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Quantity",
                    prefixIcon: Icon(Icons.numbers, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Price in DH",
                    prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add Item'),
              onPressed: () {
                _addItem();
                Navigator.of(context).pop(); // Close the dialog after adding the item
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor, // Assuming you have a background color constant
      appBar: AppBar(
        backgroundColor: kBackgroundColor, // Match the HomePage AppBar
        title: Text(
          widget.listName, // Ensure the list name is correctly passed to the AppBar
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black26),
            onPressed: () {
              // Navigate to profile or any screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ShoppingItem>>(
              stream: _firestoreService.getItems(widget.listId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading items"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No items available"));
                }

                final items = snapshot.data!;
                double totalPrice = 0.0;

                // Calculate total price
                for (var item in items) {
                  totalPrice += item.price ?? 0.0;
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                item.isBought ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: item.isBought ? Colors.green : Colors.grey,
                              ),
                              title: Text(
                                item.itemName ?? "Unnamed Item",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Quantity: ${item.quantity ?? 1}, Unit: ${item.unit ?? ''}',
                                style: TextStyle(color: Colors.black54),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${item.price?.toStringAsFixed(2) ?? '0.00'} DH',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                    value: item.isBought,
                                    onChanged: (value) {
                                      _firestoreService.updateShoppingItem(
                                        widget.listId,
                                        item.id!,
                                        value ?? false,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Handle tap action, like editing the item
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Price:',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${totalPrice.toStringAsFixed(2)} DH', // Format total price
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
