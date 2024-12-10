import 'dart:convert';

class ShoppingItem {
  String? itemName;
  String? category;
  int? quantity;
  bool isBought;

  ShoppingItem({ this.itemName,  this.category,  this.quantity,this.isBought = false,});

  // Serialize to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'category': category,
      'quantity': quantity,
    };
  }

  // Deserialize from Map (Firebase)
  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      itemName: map['itemName'],
      category: map['category'],
      quantity: map['quantity'],
    );
  }

  // Convert to JSON for local storage
  String toJson() => json.encode(toMap());

  // Deserialize from JSON (local storage)
  factory ShoppingItem.fromJson(String jsonStr) => ShoppingItem.fromMap(json.decode(jsonStr));
}
