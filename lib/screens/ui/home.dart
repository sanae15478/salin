import 'package:flutter/material.dart';
import 'package:salin/screens/ui/shopping_item_list.dart';
import 'package:salin/screens/ui/shopping_list.dart';

import 'package:salin/models/shopping_item.dart';

import '../../controllers/FirestoreService.dart';
import '../authentification/profile.dart';

class Home extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.orange,
        backgroundColor: Colors.white,
        title: const Text('Shopping list'),
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
        stream: _firestoreService.getShoppingItems('myShoppingList'), // Replace 'myShoppingList' with the actual list name
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          final shoppingItems = snapshot.data!;

          return ListView.builder(
            itemCount: shoppingItems.length,
            itemBuilder: (context, index) {
              final item = shoppingItems[index];
              return ShoppingItemList(
                item: item,
                listName: 'myShoppingList', // Replace with dynamic list name
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 35.0),
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(247, 99, 60, 1.0),
          onPressed: () {
            createAlertDialog(context).then((newShoppingListName) {
              // Add new shopping list to Firestore
            });
          },
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
