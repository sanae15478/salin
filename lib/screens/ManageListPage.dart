import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageListPage extends StatefulWidget {
  final String listId;
  final String listName;

  const ManageListPage({Key? key, required this.listId, required this.listName})
      : super(key: key);

  @override
  State<ManageListPage> createState() => _ManageListPageState();
}

class _ManageListPageState extends State<ManageListPage> {
  final CollectionReference _itemsCollection =
  FirebaseFirestore.instance.collection('shoppingItems');

  final TextEditingController _itemNameController = TextEditingController();

  Future<void> _addItem(String itemName) async {
    await _itemsCollection.add({
      'listId': widget.listId,
      'itemName': itemName,
      'isBought': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un article"),
          content: TextField(
            controller: _itemNameController,
            decoration: const InputDecoration(hintText: "Nom de l'article"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                final itemName = _itemNameController.text.trim();
                if (itemName.isNotEmpty) {
                  _addItem(itemName);
                  _itemNameController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _itemsCollection
            .where('listId', isEqualTo: widget.listId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data?.docs ?? [];

          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? const Center(
                  child: Text(
                    "Aucun article. Ajoutez-en un nouveau !",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final itemName = item['itemName'];
                    final isBought = item['isBought'];

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          itemName,
                          style: TextStyle(
                            decoration: isBought
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: Checkbox(
                          value: isBought,
                          onChanged: (bool? value) {
                            item.reference.update({'isBought': value});
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _showAddItemDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("Ajouter un article"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
