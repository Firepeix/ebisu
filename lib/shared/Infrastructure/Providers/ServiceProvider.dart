import 'package:ebisu/shared/Infrastructure/Providers/ModelServiceProvider.dart';

abstract class ServiceProvider {
  void register ();
}

class ServiceContainer {
  static void register () {
    ModelServiceProvider().register();
  }
}

abstract class ModelServiceProviderInterface {
  void registerModels();
}