

import 'package:firebase_auth/firebase_auth.dart';

import '../models/FirebaseService.dart';
import '../models/LocalStorageService.dart';
import '../models/shopping_item.dart';

class Controller {
  final LocalStorageService _localStorageService = LocalStorageService();
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get shopping list from local storage (or sync with Firebase if needed)
  Future<List<String>> getShoppingLists() async {
    bool isFirstTime = await _localStorageService.isFirstTimeUser();

    if (isFirstTime) {
      // If it's the first time, return local lists
      return ["Morning breakfast"];  // Default local list for first-time users
    } else {
      // If it's not the first time, check if user is logged in and sync if necessary
      return await _fetchShoppingLists();
    }
  }
  Future<List<ShoppingItem>> getListLocally(String listName) async {
    return await _localStorageService.getListLocally(listName);
  }
  // Fetch shopping lists from Firebase (if needed)
  Future<List<String>> _fetchShoppingLists() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Fetch shopping list names from Firebase Firestore
      var result = await _firebaseService.fetchShoppingLists(user.uid);
      return result;
    }
    return []; // Return empty list if user is not logged in
  }

  // Sync list with Firebase if the user chooses to log in and share
  Future<void> syncListToFirebase(String listName, List<ShoppingItem> items) async {
    await _firebaseService.migrateListToFirebase(listName, items);
    // Generate a link for sharing
    String shareableLink = _firebaseService.generateShareableLink(listName);
    print("Share this link: $shareableLink");
  }

  // Handle logout: Preserve local data and ensure Firebase doesn't overwrite it
  Future<void> logout() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Before logging out, we may want to optionally migrate the list to Firebase
      List<String> shoppingLists = await _fetchShoppingLists();

      // Preserve the local copy of the list and don't overwrite it
      for (String listName in shoppingLists) {
        List<ShoppingItem> items = await _firebaseService.fetchShoppingListItems(user.uid, listName);
        await _localStorageService.saveListLocally(listName, items);
      }

      // Logout the user
      await _auth.signOut();
    }
  }

}
