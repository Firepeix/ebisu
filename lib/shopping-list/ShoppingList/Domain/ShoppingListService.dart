import 'package:injectable/injectable.dart';

import 'ShoppingList.dart';

abstract class ShoppingListServiceInterface {
  Future<ShoppingList?> merge(ShoppingList mutable, ShoppingList truthSource);
}

@Singleton(as: ShoppingListServiceInterface)
class ShoppingListService implements ShoppingListServiceInterface {
  Future<ShoppingList?> merge(ShoppingList mutable, ShoppingList truthSource) {
    return Future.value(null);
  }
}