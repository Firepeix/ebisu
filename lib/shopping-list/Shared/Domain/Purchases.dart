import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';

class Purchases {
  final List<Purchase> _value = [];
  late Purchase _summary;
  late PurchaseTotal _projection;

  Purchases() {
    _summarize();
    _project();
  }

  void _summarize() {
    if (_value.isEmpty) {
      _summary = Purchase(PurchaseTotal(0));
      _summary.commit(Purchase(PurchaseTotal(0)));
      return;
    }

    _summary = _value.reduce((value, element) => value + element);
  }

  void _project() {
    var total = PurchaseTotal(0);
    _value.forEach((element) {
      total += element.wasBought ? element.purchased!.total : element.total;
    });

    _projection = total;
  }

  IntValueObject get total => _summary.total;

  IntValueObject get purchasedTotal => _summary.purchased!.total;
}