
import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/Purchase/Infrastructure/Persistence/Models/PurchaseModel.dart';

class Purchases {
  List<Purchase> _value = [];
  late Purchase _summary;
  late PurchaseTotal _projection;

  void commit() {
    _summarize();
    _project();
  }

  void _summarize() {
    if (_value.isEmpty) {
      _summary = Purchase('Sumario', Amount(0, 0, AmountType.UNIT));
      _summary.commit(Purchase('Sumario', Amount(0, 0, AmountType.UNIT)));
      return;
    }

    _summary = _value.reduce((value, element) => value + element);
    if (!_summary.wasBought) {
      _summary.commit(Purchase('Sumario', Amount(0, 0, AmountType.UNIT)));
    }
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

  bool get isNotEmpty => _value.isNotEmpty;
  
  bool get isEmpty => _value.isEmpty;

  int get length => _value.length;

  IntValueObject get projection => _projection;

  operator [](int index) => _value[index];

  void add (Purchase purchase) => _value.add(purchase);

  void each (void f(Purchase element)) => _value.forEach(f);

  Purchases filterByName (String query) {
    final filtered = Purchases();
    filtered._value = _value.where((purchase) => purchase.name.contains(new RegExp(query, caseSensitive: false))).toList();
    return filtered;
  }

  List<PurchaseHiveModel> toListModel () {
    return _value.map((p) {
      PurchaseHiveModel? boughtPurchase;
      if (p.wasBought) {
        final purchased = p.purchased;
        boughtPurchase = PurchaseHiveModel(purchased!.name, purchased.total.value, null, purchased.amount.value.value, purchased.amount.quantity.value, purchased.amount.type.index);
      }
      return PurchaseHiveModel(p.name, p.total.value, boughtPurchase, p.amount.value.value, p.amount.quantity.value, p.amount.type.index);
    }).toList();
  }
}