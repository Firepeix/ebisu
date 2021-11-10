import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';

abstract class ShoppingListColdStorageRepositoryInterface {
  Future<ShoppingList> getShoppingList(String sheetName, {ShoppingList? mergeWith});
}

abstract class ShoppingListRepositoryInterface {
  Future<void> store(ShoppingList list);
  Future<List<ShoppingList>> getShoppingLists();
  Future<ShoppingList> find(dynamic id);
  Future<void> update(ShoppingList list);
  Future<void> updatePurchase(Purchase purchase, ShoppingList list);
}

enum ShoppingListSyncType {
  pull,
  push
}