import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  String? id;
  String? itemName;
  double? price;
  int? quantity;
  bool isBought;

  ShoppingItem({
    this.id,
    this.itemName,
    this.price,
    this.quantity,
    this.isBought = false,
  });

  // From Firestore
  factory ShoppingItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ShoppingItem(
      id: doc.id,
      itemName: data['itemName'],
      price: data['price'],
      quantity: data['quantity'],
      isBought: data['isBought'] ?? false,
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'isBought': isBought,
    };
  }
}
