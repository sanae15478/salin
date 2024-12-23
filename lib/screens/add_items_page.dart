import 'package:flutter/material.dart';

class AddItemsPage extends StatelessWidget {
  final String listName;

  const AddItemsPage({Key? key, required this.listName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listName)),
      body: Center(child: Text("Add items to $listName")),
    );
  }
}
