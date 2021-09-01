import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';

class Purchases {
  final List<Purchase> _value = [
    Purchase('Cebola', Amount(249, 1185, AmountType.WEIGHT)),
    Purchase('Mussarela', Amount(5500, 450, AmountType.WEIGHT)),
    Purchase('Molho Barbecue', Amount(1679, 1, AmountType.UNIT)),
    Purchase('Danete', Amount(899, 2, AmountType.UNIT)),
  ];
  late Purchase _summary;
  late PurchaseTotal _projection;

  Purchases() {
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
}