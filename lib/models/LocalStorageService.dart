import 'package:shared_preferences/shared_preferences.dart';
import 'shopping_item.dart';

class LocalStorageService {
  // Check if it's the first time the user is using the app
  Future<bool> isFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // If it's the first time, set it to false so it doesn't run again
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }

    return isFirstTime;
  }

  // Save shopping list locally
  Future<void> saveListLocally(String listName, List<ShoppingItem> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemsJson = items.map((item) => item.toJson()).toList();
    prefs.setStringList(listName, itemsJson);
  }

  // Get shopping list from local storage
  Future<List<ShoppingItem>> getListLocally(String listName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemsJson = prefs.getStringList(listName);
    if (itemsJson == null) return [];
    return itemsJson.map((item) => ShoppingItem.fromJson(item)).toList();
  }

  // Clear all locally stored data (useful when logging out or resetting)
  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Clears all preferences, including 'isFirstTime' flag
  }
}
