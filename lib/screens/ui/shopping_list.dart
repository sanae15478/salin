import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salin/screens/ui/shopping_item_list.dart';

import '../../models/shopping_item.dart';


class ShoppingList extends StatefulWidget {
  final String title;
  final List<ShoppingItem>? shoppingLists;
  final Function addNewItem;
  final Function crossOfItem;
  final Function exitList;
  const ShoppingList({
    super.key,
    required this.title,
    required this.shoppingLists,
    required this.addNewItem,
    required this.crossOfItem,
    required this.exitList,
  });

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey,
          onPressed: () => widget.exitList('home'),
        ),
        surfaceTintColor: Colors.orange,
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 130.0),
          child: ListView.builder(
              itemCount: widget.shoppingLists!.length,
              itemBuilder: (BuildContext context, int index) {
                return ShoppingItemList(
                  item: widget.shoppingLists![index], listName: '',
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
            createAlertDialog(context).then((shoppingItem) {
              widget.addNewItem(shoppingItem);
            });
          },
          tooltip: 'Add Item',
          child: const Text(
            'Add Item',
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

Future<ShoppingItem> createAlertDialog(BuildContext context) async {
  ShoppingItem shoppingItem = ShoppingItem();
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Item to purchase"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Item Name"),
              onChanged: (itemName) {
                shoppingItem.itemName = itemName;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Category"),
              onChanged: (category) {
                shoppingItem.category = category;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              onChanged: (quantity) {
                shoppingItem.quantity = int.parse(quantity);
              },
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(shoppingItem);
            },
          ),
        ],
      );
    },
  );
}
