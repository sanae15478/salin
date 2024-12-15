import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../controllers/ItemController.dart';
import '../models/Item.dart';
import 'authentification/profile.dart';
import 'share_list_page.dart'; // Import pour la page de partage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ShoppingItemController _controller = ShoppingItemController();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _selectedUnit = 'g';

  final List<String> _units = ['g', 'kg', 'L', 'qte'];

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _itemNameController, decoration: InputDecoration(labelText: 'Item Name')),
              TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price')),
              TextField(controller: _quantityController, decoration: InputDecoration(labelText: 'Quantity')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final item = ShoppingItem(
                  itemName: _itemNameController.text,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                  quantity: int.tryParse(_quantityController.text) ?? 0,
                  unit: _selectedUnit,
                  isBought: false,
                );
                _controller.addItem(item);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShoppingList(List<ShoppingItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: Text(item.itemName ?? 'Unnamed Item'),
          subtitle: Text('Quantity: ${item.quantity ?? 1}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône pour partager la liste
              IconButton(
                icon: const Icon(Icons.person_add, color: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShareListPage(listName: item.itemName ?? 'Nouvelle Liste'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _controller.deleteItem(item.id!);
                },
              ),
            ],
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
          'Shopping List',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          // Icône de profil restaurée
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black26),
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
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found.'));
          }
          return _buildShoppingList(snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
