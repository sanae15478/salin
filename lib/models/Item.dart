import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  String? id;
  String? itemName;
  double? price;
  int? quantity;
  String? unit;  // Field for units like "g", "kg", "L"
  bool isBought;
  String? userId;  // Field to store the user ID
  DateTime? dateAdded;  // New field for storing the date when the item was added

  ShoppingItem({
    this.id,
    this.itemName,
    this.price,
    this.quantity,
    this.unit,
    this.isBought = false,
    this.userId,
    DateTime? dateAdded,  // Optional parameter for dateAdded
  }) : dateAdded = dateAdded ?? DateTime.now();

  // From Firestore (converts Firestore document to ShoppingItem)
  factory ShoppingItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ShoppingItem(
      id: doc.id,
      itemName: data['itemName'],
      price: data['price'],
      quantity: data['quantity'],
      unit: data['unit'],
      isBought: data['isBought'] ?? false,
      userId: data['userId'],
      // Handling dateAdded
      dateAdded: data['dateAdded'] != null ? (data['dateAdded'] as Timestamp).toDate() : null, // Convert Timestamp to DateTime
    );
  }

  // To Firestore (converts ShoppingItem to a map for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'isBought': isBought,
      'userId': userId,
      'dateAdded': dateAdded != null ? Timestamp.fromDate(dateAdded!) : null,  // Store as Timestamp
    };
  }
}