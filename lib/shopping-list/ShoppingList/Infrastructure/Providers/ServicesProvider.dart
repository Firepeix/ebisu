import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ServiceProvider.dart';
import 'package:ebisu/shopping-list/Application/ShoppingListCommands.dart';
import 'package:ebisu/shopping-list/ShoppingList/Infrastructure/Persistence/Models/ShoppingListModels.dart';
import 'package:ebisu/shopping-list/ShoppingList/UI/Pages/ShoppingListsPage.dart';
import 'package:hive/hive.dart';

class ShoppingListPageServiceProvider extends PageServiceProvider {
  Map<String, AbstractPage> pages = {
    '/shopping-list': ShoppingListsPage(),
    '/shopping-list/create': CreateShoppingListsPage(),
    '/shopping-list/purchases': ShoppingListPage()
  };
}

class ShoppingListBindServiceProvider implements BusServiceProviderInterface {
  static Map<String, Function> bus = {
    (CreateShoppingListCommand).toString(): () => getIt<CreateShoppingListCommandHandler>(),
    (GetShoppingListCommand).toString(): () => getIt<GetShoppingListCommandHandler>(),
    (SyncShoppingListCommand).toString(): () => getIt<SyncShoppingListCommandHandler>(),
    (UpdatePurchaseOnListCommand).toString(): () => getIt<UpdatePurchaseOnListCommandHandler>(),

  };
}

class ShoppingListModuleServiceProvider implements ModelServiceProviderInterface {
  void registerModels () {
    Hive.registerAdapter(ShoppingListHiveModelAdapter());
  }
}