import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';

abstract class ShoppingListColdStorageRepositoryInterface {
  Future<ShoppingList> getShoppingList(String sheetName);
}

abstract class ShoppingListRepositoryInterface {
  Future<void> store(ShoppingList list);
  Future<List<ShoppingList>> getShoppingLists();
}