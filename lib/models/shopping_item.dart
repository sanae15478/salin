class ShoppingItem {
  String? itemName;
  String? category;
  int? quantity;
  bool isBought;

  ShoppingItem({
    this.itemName,
    this.category,
    this.quantity,
    this.isBought = false,
  });
}
