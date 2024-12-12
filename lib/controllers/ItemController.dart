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
  Stream<List<ShoppingItem>> getItemsToday() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // Get the current date (today)
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day); // Start of today
    DateTime endOfDay = startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1)); // End of today

    // Convert to Firestore Timestamps
    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    return _firestore
        .collection('shoppingItems')
        .where('userId', isEqualTo: currentUserId) // Only fetch items for the current user
        .where('dateAdded', isGreaterThanOrEqualTo: startTimestamp) // Only items added today
        .where('dateAdded', isLessThanOrEqualTo: endTimestamp) // Items added today until the end of the day
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingItem.fromFirestore(doc))
        .toList());
  }

  Stream<List<ShoppingItem>> getItemsForYesterday() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // Get the current date (today)
    DateTime now = DateTime.now();

    // Calculate the start and end of yesterday
    DateTime startOfYesterday = DateTime(now.year, now.month, now.day).subtract(Duration(days: 1)); // Start of yesterday
    DateTime endOfYesterday = startOfYesterday.add(Duration(hours: 23, minutes: 59, seconds: 59)); // End of yesterday

    // Convert to Firestore Timestamps
    Timestamp startTimestamp = Timestamp.fromDate(startOfYesterday);
    Timestamp endTimestamp = Timestamp.fromDate(endOfYesterday);

    return _firestore
        .collection('shoppingItems')
        .where('userId', isEqualTo: currentUserId) // Only fetch items for the current user
        .where('dateAdded', isGreaterThanOrEqualTo: startTimestamp) // Items added yesterday, after 00:00
        .where('dateAdded', isLessThanOrEqualTo: endTimestamp) // Items added yesterday, before 23:59
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingItem.fromFirestore(doc))
        .toList());
  }
  Stream<List<ShoppingItem>> getItemsForLastWeek() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // Get the current date (today)
    DateTime now = DateTime.now();

    // Calculate the start of the last week (7 days ago)
    DateTime startOfLastWeek = now.subtract(Duration(days: 7)); // 7 days ago from today

    // Convert to Firestore Timestamps
    Timestamp startTimestamp = Timestamp.fromDate(startOfLastWeek);
    Timestamp endTimestamp = Timestamp.fromDate(now); // End of the range is now (today)

    return _firestore
        .collection('shoppingItems')
        .where('userId', isEqualTo: currentUserId) // Only fetch items for the current user
        .where('dateAdded', isGreaterThanOrEqualTo: startTimestamp) // Items added in the last week
        .where('dateAdded', isLessThanOrEqualTo: endTimestamp) // Items added until today
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingItem.fromFirestore(doc))
        .toList());
  }
  Stream<List<ShoppingItem>> getItemsForLastTwoWeeks() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // Get the current date (today)
    DateTime now = DateTime.now();

    // Calculate the start of the last 2 weeks (14 days ago)
    DateTime startOfLastTwoWeeks = now.subtract(Duration(days: 14)); // 14 days ago from today

    // Convert to Firestore Timestamps
    Timestamp startTimestamp = Timestamp.fromDate(startOfLastTwoWeeks);
    Timestamp endTimestamp = Timestamp.fromDate(now); // End of the range is today

    return _firestore
        .collection('shoppingItems')
        .where('userId', isEqualTo: currentUserId) // Only fetch items for the current user
        .where('dateAdded', isGreaterThanOrEqualTo: startTimestamp) // Items added in the last 2 weeks
        .where('dateAdded', isLessThanOrEqualTo: endTimestamp) // Items added until today
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ShoppingItem.fromFirestore(doc))
        .toList());
  }
  Stream<List<ShoppingItem>> getItemsForLastMonth() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // Get the current date (today)
    DateTime now = DateTime.now();

    // Calculate the start of the last month (same day last month)
    DateTime startOfLastMonth = DateTime(now.year, now.month - 1, now.day); // Same day last month

    // Calculate the end of the last month (end of the last month)
    DateTime endOfLastMonth = DateTime(now.year, now.month, 0); // Last day of the previous month

    // Convert to Firestore Timestamps
    Timestamp startTimestamp = Timestamp.fromDate(startOfLastMonth);
    Timestamp endTimestamp = Timestamp.fromDate(endOfLastMonth); // End of last month

    return _firestore
        .collection('shoppingItems')
        .where('userId', isEqualTo: currentUserId) // Only fetch items for the current user
        .where('dateAdded', isGreaterThanOrEqualTo: startTimestamp) // Items added in the last month
        .where('dateAdded', isLessThanOrEqualTo: endTimestamp) // Items added in the last month (until the last day)
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
