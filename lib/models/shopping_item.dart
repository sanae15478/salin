import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  String? id;
  String? itemName;
  String? category;
  int? quantity;
  bool isBought;

  ShoppingItem({
    this.id,
    this.itemName,
    this.category,
    this.quantity,
    this.isBought = false,
  });

  // From Firestore
  factory ShoppingItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ShoppingItem(
      id: doc.id,
      itemName: data['itemName'],
      category: data['category'],
      quantity: data['quantity'],
      isBought: data['isBought'] ?? false,
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'category': category,
      'quantity': quantity,
      'isBought': isBought,
    };
  }
}
