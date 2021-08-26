import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shopping-list/Shared/Domain/Purchases.dart';

class ShoppingList {
  final ShoppingListId? sheetId;
  final String _name;
  final ShoppingListInputAmount _inputAmount;
  final Purchases _purchases = Purchases();

  ShoppingList(this._name, this._inputAmount, { this.sheetId });

  ShoppingListInputAmount get input => _inputAmount;
  String get name => _name;


  IntValueObject get totalBudgeted => _purchases.total;
  IntValueObject get totalPurchased => _purchases.purchasedTotal;
  IntValueObject get totalDifference => _purchases.total - _purchases.purchasedTotal;
  IntValueObject get projection => _inputAmount - _purchases.purchasedTotal;
}

class ShoppingListInputAmount extends IntValueObject {
  ShoppingListInputAmount(int value) : super(value);
}

class ShoppingListId extends IdValueObject {
  ShoppingListId(String value) : super(value);
}