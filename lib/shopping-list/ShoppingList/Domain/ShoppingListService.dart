import 'package:injectable/injectable.dart';

import 'ShoppingList.dart';

abstract class ShoppingListServiceInterface {
  Future<ShoppingList?> createShoppingList(ShoppingListBuilder builder);
}
@Singleton(as: ShoppingListServiceInterface)
class ShoppingListService implements ShoppingListServiceInterface {
  Future<ShoppingList?> createShoppingList(ShoppingListBuilder builder) {
    print("123");
    return Future.value(null);
  }
}