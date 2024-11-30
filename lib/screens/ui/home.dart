import 'package:flutter/material.dart';

import 'list_item.dart';

class Home extends StatefulWidget {
  final List<String> shoppingLists;
  final Function addNewShoppingList;
  final Function openShoppingList;
  const Home({
    super.key,
    required this.shoppingLists,
    required this.addNewShoppingList,
    required this.openShoppingList,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.orange,
        backgroundColor: Colors.white,
        title: const Text('Shopping list'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 130.0),
          child: ListView.builder(
              itemCount: widget.shoppingLists.length,
              itemBuilder: (BuildContext context, int index) {
                return ListItem(
                  item: widget.shoppingLists[index],
                  onTap: () {
                    widget.openShoppingList(widget.shoppingLists[index]);
                  },
                );
              }),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 35.0),
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(247, 99, 60, 1.0),
          onPressed: () {
            createAlertDialog(context).then((newShoppingListName) {
              widget.addNewShoppingList(newShoppingListName);
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
