import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shopping-list/Shared/Domain/Purchases.dart';

class ShoppingList {
  final String _name;
  final dynamic id;
  final ShoppingListInputAmount _inputAmount;
  final Purchases _purchases = Purchases();

  ShoppingList(this._name, this._inputAmount, {this.id});

  ShoppingListInputAmount get input => _inputAmount;
  String get name => _name;


  IntValueObject get totalBudgeted => _purchases.total;
  IntValueObject get totalPurchased => _purchases.purchasedTotal;
  IntValueObject get totalDifference => _purchases.total - _purchases.purchasedTotal;
  IntValueObject get projection => _inputAmount - _purchases.projection;

  Purchases get purchases => _purchases;
}

class ShoppingListInputAmount extends IntValueObject {
  ShoppingListInputAmount(int value) : super(value);
}

class ShoppingListId extends IdValueObject {
  ShoppingListId(String value) : super(value);
}

enum SHOPPING_LIST_TYPE {
  BLANK,
  SHEET
}

abstract class ShoppingListBuilder {
  String get name;
  int  get type;
  int  get amount;
}