import 'package:ebisu/shared/Domain/ValueObjects.dart';

class Purchase {
  PurchaseTotal _total = PurchaseTotal(0);
  final String _name;
  final Amount _amount;
  dynamic shoppingListId;

  Purchase? _purchase;


  Purchase(this._name, this._amount) {
    _compute();
  }

  Purchase.fromJson(Map<String, dynamic> json) :
        _name = json['name'],
        _amount = Amount.fromJson(json['amount']) {
    _compute();
    if (json['purchase'] != null) {
      _purchase = Purchase.fromJson(json['purchase']);
    }
  }

  Purchase? get purchased => _purchase;

  PurchaseTotal get total => _total;

  PurchaseTotal get boughtTotal => _purchase != null ? _purchase!._total :_total;

  bool get wasBought => _purchase != null;

  String get name => _name;

  Amount get amount => _amount;

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
        final committed = other._purchase != null ? other._purchase! + _purchase : _purchase;
        result.commit(committed!);
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

  Map<String, dynamic> toJson () => {
    "name": _name,
    "amount": _amount.toJson(),
    "purchase": wasBought ? _purchase!.toJson() : null
  };
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

  Amount.fromJson(Map<String, dynamic> json) :
        _value = json['value'],
        _quantity = json['quantity'],
        _type = AmountType.values[json['type']]
  ;

  PurchaseTotal calculate() => _type == AmountType.UNIT ? _calculateUnitValue() : _calculateWeightValue();

  PurchaseTotal _calculateUnitValue () => PurchaseTotal(_quantity * _value);

  PurchaseTotal _calculateWeightValue () => PurchaseTotal(((_quantity * _value) / 1000).floor());

  String get description => _type == AmountType.UNIT ? '$_quantity Unidade${_quantity > 1 ? 's': ''}' : '${_quantity}g';

  IntValueObject get value => IntValueObject(_value);

  IntValueObject get quantity => IntValueObject(_quantity);

  AmountType get type => type;

  Map<String, dynamic> toJson () => {
    "value": _value,
    "quantity": _quantity,
    "type": _type.index
  };
}

enum AmountType {
  UNIT,
  WEIGHT
}
