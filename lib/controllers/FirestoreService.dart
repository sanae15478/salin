import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salin/models/shopping_item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch shopping list items from Firestore
  Stream<List<ShoppingItem>> getShoppingItems(String listName) {
    return _db
        .collection('shopping_lists')
        .doc(listName)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ShoppingItem.fromFirestore(doc);
      }).toList();
    });
  }

  // Update shopping item (e.g., mark as bought)
  Future<void> updateShoppingItem(
      String listName, String itemId, bool isBought) async {
    await _db
        .collection('shopping_lists')
        .doc(listName)
        .collection('items')
        .doc(itemId)
        .update({'isBought': isBought});
  }

  // Add a new shopping item
  Future<void> addShoppingItem(String listName, ShoppingItem item) async {
    await _db
        .collection('shopping_lists')
        .doc(listName)
        .collection('items')
        .add(item.toMap());
  }
}
