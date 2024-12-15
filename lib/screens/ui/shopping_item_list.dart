import 'package:flutter/material.dart';
import 'package:salin/models/shopping_item.dart';

import '../../controllers/FirestoreService.dart';

class ShoppingItemList extends StatelessWidget {
  final ShoppingItem item;
  final String listName;

   ShoppingItemList({
    super.key,
    required this.item,
    required this.listName,
  });

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
        top: 5,
        left: 10,
        right: 10,
      ),
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: item.isBought,
                activeColor: const Color.fromRGBO(240, 234, 253, 1.0),
                checkColor: const Color.fromRGBO(130, 83, 233, 1.0),
                onChanged: (bool? value) {
                  if (value != null) {
                    _firestoreService.updateShoppingItem(
                        listName, item.id!, value);
                  }
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.itemName!,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: item.isBought ? Colors.grey : Colors.black,
                      decoration: item.isBought
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: Colors.grey,
                      decorationThickness: 2.0,
                    ),
                  ),
                ),
              ),
              Text(
                item.quantity!.toString(),
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
