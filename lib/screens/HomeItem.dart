import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controllers/FirestoreService.dart';
import 'ListItemsPage.dart';

class HomeItem extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _firestoreService.getShoppingLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading lists"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No lists available"));
          }

          final lists = snapshot.data!;
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return ListTile(
                title: Text(list['name'] ?? "Unnamed List"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListItemsPage(listId: list.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Créer une nouvelle liste
          createAlertDialog(context).then((newShoppingListName) {
            // Add new shopping list to Firestore
            _firestoreService.createShoppingList(newShoppingListName);
          });

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<String> createAlertDialog(BuildContext context) async {
  String shoppingListName = '';
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("New Shopping List Name"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                shoppingListName = value;
              },
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(shoppingListName);
            },
          ),
        ],
      );
    },
  );
}
