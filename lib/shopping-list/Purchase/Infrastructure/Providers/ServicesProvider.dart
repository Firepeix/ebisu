import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ServiceProvider.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Pages/PurchasePage.dart';

class PurchasePageServiceProvider extends PageServiceProvider {
  Map<String, AbstractPage> pages = {
    '/shopping-list/purchases/purchase': PurchasePage()
  };
}