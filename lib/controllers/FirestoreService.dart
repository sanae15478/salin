import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Item.dart'; // Import du modèle ShoppingItem

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Créer une nouvelle liste d'articles
  Future<void> createShoppingList(String listName) async {
    await _db.collection('shopping_lists').add({'name': listName});
  }

  // Récupérer les listes disponibles
  Stream<List<DocumentSnapshot>> getShoppingLists() {
    return _db.collection('shopping_lists').snapshots().map((snapshot) {
      return snapshot.docs;
    });
  }

  // Ajouter un nouvel article dans une liste
  Future<void> addShoppingItem(String listId, ShoppingItem item) async {
    await _db
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .add(item.toMap());
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
  Future<void> updateShoppingItem(
      String listId, String itemId, bool isBought) async {
    await _db
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({'isBought': isBought});
  }
}
