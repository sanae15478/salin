import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Item.dart';

class ShoppingItemController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all shopping items from Firestore (only for the current user)
  Stream<List<ShoppingItem>> getItems() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return _firestore
        .collection('shoppingItems')
        .where('userId', isEqualTo: currentUserId) // Only fetch items for the current user
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingItem.fromFirestore(doc))
        .toList());
  }

  Future<void> addItem(ShoppingItem item) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId != null) {
        item.userId = currentUserId; // Set the userId to the authenticated user's ID
        await _firestore.collection('shoppingItems').add(item.toMap());
      } else {
        print("User is not authenticated.");
      }
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