import 'package:ebisu/shared/Domain/ValueObjects.dart';

class Purchase {
  PurchaseTotal _total = PurchaseTotal(0);
  final String _name;
  final Amount _amount;

  Purchase? _purchase;

  Purchase? get purchased => _purchase;

  Purchase(this._name, this._amount) {
    _compute();
  }

  PurchaseTotal get total => _total;

  PurchaseTotal get boughtTotal => _purchase != null ? _purchase!._total :_total;

  void commit(Purchase purchase) {
    _purchase = purchase;
  }

  void _compute() {
    _total = _amount.calculate();
  }

  Purchase operator +(Purchase? other) {
    String name = _name;
    Purchase result;
    if (other != null) {
      name += ' - ${other._name}';
      result = Purchase(name, Amount(0, 0, AmountType.UNIT));
      result._total = other._total + _total;
      if (other._purchase != null || _purchase != null) {
        result.commit(other._purchase! + _purchase);
      }
      return result;
    }

    result = Purchase(name, _amount);
    result._total = _total;
    if(_purchase != null) {
      result.commit(_purchase!);
    }
    return result;
  }


  bool get wasBought => _purchase != null;

  String get name => _name;
}

class PurchaseTotal extends IntValueObject{
  PurchaseTotal(int value) : super(value);

  @override
  PurchaseTotal operator +(covariant other) => PurchaseTotal(other.value + value);

  @override
  PurchaseTotal operator -(covariant other) => PurchaseTotal((value - other.value).toInt());
}

class Amount {
  final int _value;
  final int _quantity;
  final AmountType _type;

  Amount(this._value, this._quantity, this._type);

  PurchaseTotal calculate() => _type == AmountType.UNIT ? _calculateUnitValue() : _calculateWeightValue();

  PurchaseTotal _calculateUnitValue () => PurchaseTotal(_quantity * _value);

  PurchaseTotal _calculateWeightValue () => PurchaseTotal(((_quantity * _value) / 1000).floor());
}

enum AmountType {
  UNIT,
  WEIGHT
}
