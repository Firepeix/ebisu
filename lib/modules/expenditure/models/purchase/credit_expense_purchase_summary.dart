import 'package:ebisu/modules/card/models/card.dart';

class CreditExpensePurchaseSummaryModel {
  final CardModel card;
  final int spent;
  final int planned;
  final int difference;
  final int previousInstallmentSpent;

  CreditExpensePurchaseSummaryModel({
    required this.card,
    required this.spent,
    required this.planned,
    required this.difference,
    required this.previousInstallmentSpent
  });
}