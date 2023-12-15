import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';

class CreditExpensePurchaseSummaryModel {
  final CardModel card;
  final Money spent;
  final Money planned;
  final Money difference;
  final Money previousInstallmentSpent;

  CreditExpensePurchaseSummaryModel({
    required this.card,
    required this.spent,
    required this.planned,
    required this.difference,
    required this.previousInstallmentSpent
  });
}