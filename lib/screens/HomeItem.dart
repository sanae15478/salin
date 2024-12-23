import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salin/screens/share_list_page.dart';
import '../constants/colors.dart';
import '../controllers/FirestoreService.dart';
import 'ListItemsPage.dart';
import 'authentification/profile.dart';

class HomeItem extends StatefulWidget {
  const HomeItem({Key? key}) : super(key: key);

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  final FirestoreService _firestoreService = FirestoreService();
  bool showOwnedLists = true;

  @override
  Widget build(BuildContext context) {
    // Get the current user's email
    final String userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    final String ownerFirstLetter = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : '';

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
          // Profile Icon replaced with the user's first letter
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0), // Add some right padding
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  ownerFirstLetter,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                radius: 20, // Adjusted size for better fit
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle Slider for owned vs shared lists
          SwitchListTile(
            title: const Text("Show Owned Lists"),
            value: showOwnedLists,
            onChanged: (value) {
              setState(() {
                showOwnedLists = value;
              });
            },
            secondary: Icon(
              showOwnedLists ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _firestoreService.getShoppingLists(showOwnedLists),
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
                    final List<String> sharedEmails = List<String>.from(
                        list['sharedWith'] is List
                            ? list['sharedWith']
                            : [list['sharedWith']] ?? []); // Ensure sharedWith is a list
                    final bool isOwner = list['userId'] == FirebaseAuth.instance.currentUser?.uid;
                    final String ownerFirstLetter = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : '';

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
                        subtitle: Row(
                          children: [
                            // Show icons for shared users and make them clickable to navigate to share page
                            ...sharedEmails.map((email) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: email.isNotEmpty?GestureDetector(
                                  onTap: () {
                                    // Navigate to the share page when an email icon is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShareListPage(
                                          listId: list.id,
                                          listName: list["name"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.deepPurple[100],
                                    child: Text(email.isNotEmpty ? email[0].toUpperCase() : ''),
                                    radius: 15,
                                  ),
                                ):Container(),
                              );
                            }).toList(),
                            // If the list is owned by the user, show their first letter in an avatar
                            if (isOwner)
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to the share page when owner icon is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShareListPage(
                                          listId: list.id,
                                          listName: list["name"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.teal[200],
                                    child: Text(ownerFirstLetter, style: TextStyle(color: Colors.white)),
                                    radius: 15,
                                  ),
                                ),
                              ),
                            // "+" profile icon to share the list
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to the share page when the + icon is tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShareListPage(
                                        listId: list.id,
                                        listName: list["name"],
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.pink[200],
                                  child: Icon(Icons.add_reaction, color: Colors.white, size: 18),
                                  radius: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListItemsPage(listId: list.id,listName: list["name"]),
                            ),
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
          tooltip: 'Create new List',
          child: const Text(
            'Create new List',
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
