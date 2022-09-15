import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';

abstract class CreatesExpense {
  String name();
  int amount();
  DateTime date();
  ExpenseType type();
  ExpenseSourceModel? beneficiary();
  ExpenseSourceModel? source();
  CardModel? card();
  int? currentInstallment();
  int? installmentTotal();
}