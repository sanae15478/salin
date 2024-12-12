import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  String? id;
  String? itemName;
  double? price;
  int? quantity;
  String? unit;  // New field for units like "g", "kg", "L"
  bool isBought;
  String? userId;  // New field to store the user ID

  ShoppingItem({
    this.id,
    this.itemName,
    this.price,
    this.quantity,
    this.unit,  // Adding unit to the constructor
    this.isBought = false,
    this.userId,  // Initialize userId
  });

  // From Firestore
  factory ShoppingItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ShoppingItem(
      id: doc.id,
      itemName: data['itemName'],
      price: data['price'],
      quantity: data['quantity'],
      unit: data['unit'],  // Map unit field from Firestore
      isBought: data['isBought'] ?? false,
      userId: data['userId'],  // Map userId field from Firestore
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'unit': unit,  // Include unit in the map
      'isBought': isBought,
      'userId': userId,  // Include userId in the map
    };
  }
}
