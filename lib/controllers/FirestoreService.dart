import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salin/models/shopping_item.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For getting the current user

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
  }*/

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

  Future<void> addShoppingItem(String listName, ShoppingItem item) async {
    String userId = FirebaseAuth.instance.currentUser!.uid; // Get current user ID

    // Add the shopping item to Firestore with the userId in shopping_lists
    await _db.collection('shopping_lists')
        .doc(listName)
        .collection('items')
        .add({
      ...item.toMap(),
      'userId': userId, // Add userId to each item
    });

    // Optionally, you can add userId to the shopping list itself (not individual items)
    await _db.collection('shopping_lists').doc(listName).set({
      'userId': userId, // Add userId to the shopping list document
    }, SetOptions(merge: true));
  }
}