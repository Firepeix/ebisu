import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ModelServiceProvider.dart';
import 'package:ebisu/shopping-list/Purchase/Infrastructure/Providers/ServicesProvider.dart';
import 'package:ebisu/shopping-list/ShoppingList/Infrastructure/Providers/ServicesProvider.dart';
import 'package:injectable/injectable.dart';

import '../../Domain/Services/ExpcetionHandlerService.dart';

abstract class ServiceProvider {
  void register ();
}

abstract class PageServiceProvider {
  Map<String, AbstractPage> pages = {};
  bool hasPage(String name) => pages.containsKey(name);
  AbstractPage getPage (String name) => pages[name]!;
}

@singleton
class PageContainer {
  // ignore: unused
  ExceptionHandlerServiceInterface _dummy;

  PageContainer(this._dummy);

  List<PageServiceProvider?> _providers = [
    ShoppingListPageServiceProvider(),
    PurchasePageServiceProvider()
  ];

  bool hasPage(String name) {
    return _providers.firstWhere((provider) => provider!.hasPage(name), orElse: () => null) != null;
  }
  AbstractPage getPage (String name) {
    return _providers.firstWhere((provider) => provider!.hasPage(name))!.getPage(name);
  }
}

class ServiceContainer {
  static void register () {
    ModelServiceProvider().register();
  }
}

abstract class ModelServiceProviderInterface {
  void registerModels();
}