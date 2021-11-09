import 'package:ebisu/shopping-list/Purchase/UI/Components/Purchase.dart';
import 'package:injectable/injectable.dart';

import '../Purchase.dart';

abstract class PurchaseServiceInterface {
  void commitPurchase(Purchase purchase, PurchaseBuilder builder);
}
@Singleton(as: PurchaseServiceInterface)
class PurchaseService implements PurchaseServiceInterface {
  @override
  void commitPurchase(Purchase purchase, PurchaseBuilder builder) {
    purchase.commit(Purchase(
      builder.name,
      Amount(
        builder.amount,
        builder.quantity,
        builder.type
      )
    ));
  }
}