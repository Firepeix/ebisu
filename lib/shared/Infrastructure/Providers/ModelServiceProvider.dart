import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ServiceProvider.dart';
import 'package:ebisu/shopping-list/ShoppingList/Infrastructure/Providers/ServicesProvider.dart';

class ModelServiceProvider extends ServiceProvider {
  static List<ModelServiceProviderInterface> services = [
    ExpenditureModuleServiceProvider(),
    ShoppingListModuleServiceProvider()
  ];

  @override
  void register() {
    services.forEach((ModelServiceProviderInterface service) => service.registerModels());
  }
}
