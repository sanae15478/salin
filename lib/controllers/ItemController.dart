import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Item.dart';


class ShoppingItemController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all shopping items from Firestore
  Stream<List<ShoppingItem>> getItems() {
    return _firestore
        .collection('shoppingItems')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingItem.fromFirestore(doc))
        .toList());
  }

  // Add a new shopping item to Firestore
  Future<void> addItem(ShoppingItem item) async {
    try {
      await _firestore.collection('shoppingItems').add(item.toMap());
    } catch (e) {
      print("Error adding item: $e");
    }
  }

  // Update an existing shopping item in Firestore
  Future<void> updateItem(ShoppingItem item) async {
    try {
      await _firestore
          .collection('shoppingItems')
          .doc(item.id)
          .update(item.toMap());
    } catch (e) {
      print("Error updating item: $e");
    }
  }

  // Delete a shopping item from Firestore
  Future<void> deleteItem(String itemId) async {
    try {
      await _firestore.collection('shoppingItems').doc(itemId).delete();
    } catch (e) {
      print("Error deleting item: $e");
    }
  }
}
