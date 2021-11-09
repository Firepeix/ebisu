import 'dart:convert';

import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';

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

  void updatePurchase (Purchase purchase) {
    final index = indexOf((element) => element.name == purchase.name);
    if (index != null) {
      _value[index] = purchase;
      commit();
    }
  }

  void applyListId (dynamic id) {
    _value.forEach((element) => element.shoppingListId = id);
  }

  int? indexOf (Function f) {
    final index = _value.indexWhere((element) => f(element));
    return index == -1 ? null : index;
  }

  String toJson() => jsonEncode(_value.map((e) => e.toJson()).toList());

  void populateFromJson(String json, dynamic shoppingListId) {
    final list = jsonDecode(json) as List;
    list.forEach((element) {
      element = element as Map<String, dynamic>;
      final purchase = Purchase.fromJson(element);
      purchase.shoppingListId = shoppingListId;
      _value.add(purchase);
    });
    commit();
  }
}