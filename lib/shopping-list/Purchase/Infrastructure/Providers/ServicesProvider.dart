import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ServiceProvider.dart';
import 'package:ebisu/shopping-list/Purchase/Application/PurchaseCommands.dart';
import 'package:ebisu/shopping-list/Purchase/Infrastructure/Persistence/Models/PurchaseModel.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Pages/PurchasePage.dart';
import 'package:hive/hive.dart';

class PurchasePageServiceProvider extends PageServiceProvider {
  Map<String, AbstractPage> pages = {
    '/shopping-list/purchases/purchase': PurchasePage(),
    '/shopping-list/purchases/purchase/create': CreatePurchasePage(),
  };
}

class PurchaseBindServiceProvider implements BusServiceProviderInterface {
  static Map<String, Function> bus = {
    (CommitPurchaseCommand).toString(): () => getIt<CommitPurchaseCommandHandler>(),
  };
}

class PurchaseModelServiceProvider implements ModelServiceProviderInterface {
  void registerModels () {
    Hive.registerAdapter(PurchaseHiveModelAdapter());
  }
}