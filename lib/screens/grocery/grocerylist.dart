import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryListScreen extends StatelessWidget {
  final CollectionReference groceryItems =
      FirebaseFirestore.instance.collection('grocery_item');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grocery List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: groceryItems.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['name']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    groceryItems.doc(item.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController nameController =
                  TextEditingController();
              return AlertDialog(
                title: Text('Add Item'),
                content: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      groceryItems.add({'name': nameController.text});
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
