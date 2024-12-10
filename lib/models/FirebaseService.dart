import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shopping_item.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Migrate list from Firebase to Local Storage (if syncing is needed)
  Future<void> migrateListToFirebase(String listName, List<ShoppingItem> items) async {
    User? user = _auth.currentUser;
    if (user != null) {
      List<Map<String, dynamic>> itemsMap = items.map((item) => item.toMap()).toList();
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('shopping_lists')
          .doc(listName)
          .set({
        'items': itemsMap,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Fetch the shopping list from Firebase (if syncing required)
  Future<List<ShoppingItem>> fetchShoppingListFromFirebase(String listName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('shopping_lists')
          .doc(listName)
          .get();

      if (snapshot.exists) {
        List<dynamic> items = snapshot['items'];
        return items.map((item) => ShoppingItem.fromMap(Map<String, dynamic>.from(item))).toList();
      }
    }
    return [];
  }

  // Generate shareable link for the list
  String generateShareableLink(String listName) {
    User? user = _auth.currentUser;
    if (user != null) {
      return 'https://yourapp.com/list/${user.uid}/$listName';
    }
    return '';
  }


  // Fetch the shopping list names for the current user
  Future<List<String>> fetchShoppingLists(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('shopping_lists')
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();  // Return the list names
    } catch (e) {
      print("Error fetching shopping lists: $e");
      return [];
    }
  }

  // Fetch items for a specific shopping list
  Future<List<ShoppingItem>> fetchShoppingListItems(String userId, String listName) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('shopping_lists')
          .doc(listName)
          .get();

      if (snapshot.exists) {
        List<dynamic> items = snapshot['items'];
        return items.map((item) => ShoppingItem.fromMap(Map<String, dynamic>.from(item))).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching shopping list items: $e");
      return [];
    }
  }


}
