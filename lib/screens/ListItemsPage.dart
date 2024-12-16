import 'package:flutter/material.dart';
import '../controllers/FirestoreService.dart';
import '../models/Item.dart';

class ListItemsPage extends StatefulWidget {
  final String listId;

  const ListItemsPage({Key? key, required this.listId}) : super(key: key);

  @override
  State<ListItemsPage> createState() => _ListItemsPageState();
}

class _ListItemsPageState extends State<ListItemsPage> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _addItem() {
    final itemName = _itemNameController.text;
    final quantity = int.tryParse(_quantityController.text) ?? 1;

    if (itemName.isNotEmpty) {
      final newItem = ShoppingItem(
        itemName: itemName,
        quantity: quantity,
      );

      _firestoreService.addShoppingItem(widget.listId, newItem);
      _itemNameController.clear();
      _quantityController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List Items'),
      ),
      body: Column(
        children: [
          // Champ pour ajouter un article
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemNameController,
                    decoration: const InputDecoration(
                      hintText: "Item Name",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Quantity",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          // Liste des articles
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
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.itemName ?? "Unnamed Item"),
                      subtitle: Text("Quantity: ${item.quantity ?? 1}"),
                      trailing: Checkbox(
                        value: item.isBought,
                        onChanged: (value) {
                          _firestoreService.updateShoppingItem(
                            widget.listId,
                            item.id!,
                            value ?? false,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
