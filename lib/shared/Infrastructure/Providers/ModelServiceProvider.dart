import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ServiceProvider.dart';

class ModelServiceProvider extends ServiceProvider {
  static List<ModelServiceProviderInterface> services = [
    ExpenditureModuleServiceProvider()
  ];

  @override
  void register() {
    services.forEach((ModelServiceProviderInterface service) => service.registerModels());
  }
}
