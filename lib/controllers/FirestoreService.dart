import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';
import '../models/Item.dart';  // Import the ShoppingItem model
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth to get the current user's ID
import 'package:async/async.dart';
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to get the current user's ID (UID)
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Créer une nouvelle liste d'articles
  Future<void> createShoppingList(String listName) async {
    String? userId = getCurrentUserId();
    if (userId != null) {
      // Create a shopping list and add the user's ID
      await _db.collection('shopping_lists').add({
        'name': listName,
        'userId': userId,  // Store the user ID with the list
        'dateCreated': Timestamp.now(),  // Add a date field for list creation
      });
    } else {
      print("No user is logged in");
    }
  }

  // Récupérer les listes disponibles (including lists where the user is the owner)
  /*
  Stream<List<DocumentSnapshot>> getShoppingLists() {
    String? userId = getCurrentUserId();
    if (userId != null) {
      // Filter to only show lists that belong to the current user
      return _db
          .collection('shopping_lists')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    } else {
      return Stream.value([]);  // Return an empty stream if no user is logged in
    }
  }*/

  Stream<List<DocumentSnapshot>> getShoppingLists() {
    String? userId = getCurrentUserId();
    String? userEmail = FirebaseAuth.instance.currentUser?.email?.toLowerCase();


    if (userId != null && userEmail != null) {
      final userListsStream = FirebaseFirestore.instance
          .collection('shopping_lists')
          .where('userId', isEqualTo: userId)
          .snapshots();

      final sharedListsStream = FirebaseFirestore.instance
          .collection('shopping_lists')
          .where('sharedWith', arrayContains: userEmail)
          .snapshots();

      // Merge both streams
      return StreamGroup.merge([userListsStream, sharedListsStream]).map((event) {
        final allDocs = <String, DocumentSnapshot>{};
        for (var doc in event.docs) {
          allDocs[doc.id] = doc;
        }
        return allDocs.values.toList();
      });
    } else {
      return Stream.value([]);
    }
  }



  // Ajouter un nouvel article dans une liste (include user ID)
  Future<void> addShoppingItem(String listId, ShoppingItem item) async {
    String? userId = getCurrentUserId();
    if (userId != null) {
      // Add the user ID to the item data
      item.userId = userId;
      await _db
          .collection('shopping_lists')
          .doc(listId)
          .collection('items')
          .add(item.toMap());
    } else {
      print("No user is logged in");
    }
  }

  // Récupérer les articles d'une liste
  Stream<List<ShoppingItem>> getItems(String listId) {
    return _db
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingItem.fromFirestore(doc))
        .toList());
  }

  // Mettre à jour un article
  Future<void> updateShoppingItem(String listId, String itemId, bool isBought) async {
    await _db
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({'isBought': isBought});
  }

  // Méthode pour générer un lien de partage unique
  Future<String> generateShareLink(String listId, Map<String, dynamic> listData) async {
    try {
      await _db.collection('shared_lists').doc(listId).set(listData);
      String shareLink = "https://votreapp.com/share?listId=$listId";  // URL fictive
      return shareLink;
    } catch (e) {
      print("Erreur lors de la génération du lien : $e");
      throw Exception("Impossible de générer le lien de partage.");
    }
  }
}
