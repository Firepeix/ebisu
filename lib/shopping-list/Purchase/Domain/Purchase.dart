import 'package:ebisu/shared/Domain/ValueObjects.dart';

class Purchase {
  final PurchaseTotal _total;

  Purchase? _purchase;

  Purchase? get purchased => _purchase;

  Purchase(this._total);

  PurchaseTotal get total => _total;

  void commit(Purchase purchase) {
    _purchase = purchase;
  }

  Purchase operator +(Purchase? other) {
    Purchase result;
    if (other != null) {
      result = Purchase(other._total + _total);
      if (other._purchase != null || _purchase != null) {
        result.commit(other._purchase! + _purchase);
      }
      return result;
    }

    result = Purchase(_total);
    if(_purchase != null) {
      result.commit(_purchase!);
    }
    return result;
  }
}

class PurchaseTotal extends IntValueObject{
  PurchaseTotal(int value) : super(value);

  @override
  PurchaseTotal operator +(covariant other) => PurchaseTotal(other.value + value);

  @override
  PurchaseTotal operator -(covariant other) => PurchaseTotal((value - other.value).toInt());
}