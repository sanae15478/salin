import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salin/screens/share_list_page.dart';
import '../constants/colors.dart';
import '../controllers/FirestoreService.dart';
import 'ListItemsPage.dart';
import 'authentification/profile.dart';


class HomeItem extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomeItem({Key? key}) : super(key: key);

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
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15.0),
                  title: Text(list['name'] ?? "Unnamed List"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Plus Icon for the SharePage navigation
                      IconButton(
                        icon: Icon(Icons.account_circle_rounded, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShareListPage(listId: list.id,listName: list["name"],), // Assuming you have a SharePage
                            ),
                          );
                        },
                      ),
                      // Arrow Icon (>)
                      Icon(Icons.arrow_forward, color: Colors.black38),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListItemsPage(listId: list.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 35.0),
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple[100],
          onPressed: () {
            // Create a new shopping list
            createAlertDialog(context).then((newShoppingListName) {
              // Add new shopping list to Firestore
              _firestoreService.createShoppingList(newShoppingListName);
            });
          },
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
