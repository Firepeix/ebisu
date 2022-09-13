import 'package:ebisu/card/models/card.dart';
import 'package:ebisu/expenditure/domain/expense_source.dart';
import 'package:ebisu/expenditure/enums/expense_type.dart';

class ExpenseModel {
  final String id;
  final String name;
  final int amount;
  final DateTime date;
  final ExpenseType type;
  final ExpenseCard? card;
  final ExpenseSource? source;
  final ExpenseSource? beneficiary;
  final ExpenseInstallments? installments;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.date,
    this.card,
    this.source,
    this.beneficiary,
    this.installments,
  });

  bool isInstallmentBased() {
    return installments != null;
  }
}

class ExpenseInstallments {
  int currentInstallment;
  int? totalInstallments;

  String get summary => '$currentInstallment/$totalInstallments';

  ExpenseInstallments(this.currentInstallment, this.totalInstallments);
}
