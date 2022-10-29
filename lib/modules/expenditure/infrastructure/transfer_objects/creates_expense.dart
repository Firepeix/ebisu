import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';

abstract class CreatesExpense {
  String getName();
  int getAmount();
  DateTime getDate();
  ExpenseType getType();
  ExpenseSourceModel? getBeneficiary();
  ExpenseSourceModel? getSource();
  CardModel? getCard();
  int? getCurrentInstallment();
  int? getTotalInstallments();
}