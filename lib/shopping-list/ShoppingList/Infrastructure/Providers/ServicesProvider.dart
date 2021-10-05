import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ServiceProvider.dart';
import 'package:ebisu/shopping-list/Application/ShoppingListCommands.dart';
import 'package:ebisu/shopping-list/ShoppingList/UI/Pages/ShoppingListsPage.dart';

/*class ModelServiceProvider extends ServiceProvider {
  static List<ModelServiceProviderInterface> services = [
    ExpenditureModuleServiceProvider()
  ];

  @override
  void register() {
    services.forEach((ModelServiceProviderInterface service) => service.registerModels());
  }
}*/

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
  };
}