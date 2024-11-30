import 'package:flutter/material.dart';

import '../../models/shopping_item.dart';


class ShoppingItemList extends StatefulWidget {
  final ShoppingItem item;

  const ShoppingItemList({
    super.key,
    required this.item,
  });

  @override
  State<ShoppingItemList> createState() => _ShoppingItemListState();
}

class _ShoppingItemListState extends State<ShoppingItemList> {
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
                value: widget.item.isBought,
                activeColor: const Color.fromRGBO(240, 234, 253, 1.0),
                checkColor: const Color.fromRGBO(130, 83, 233, 1.0),
                onChanged: (bool? value) {
                  setState(() {
                    widget.item.isBought = value!;
                  });
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.item.itemName!,
                    style: (widget.item.isBought)
                        ? const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey,
                            decorationThickness: 2.0)
                        : const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Text(
                widget.item.quantity!.toString(),
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
