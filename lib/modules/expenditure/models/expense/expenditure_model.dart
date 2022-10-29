import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';

class ExpenseModel implements CreatesExpense {
  final String id;
  final String name;
  final int amount;
  final DateTime date;
  final ExpenseType type;
  final CardModel? card;
  final ExpenseSourceModel? source;
  final ExpenseSourceModel? beneficiary;
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

  @override
  int getAmount() => amount;

  @override
  ExpenseSourceModel? getBeneficiary() => beneficiary;

  @override
  CardModel? getCard() => card;

  @override
  int? getCurrentInstallment() => installments?.currentInstallment;

  @override
  DateTime getDate() => date;

  @override
  String getName() => name;

  @override
  ExpenseSourceModel? getSource() => source;

  @override
  int? getTotalInstallments() => installments?.totalInstallments;

  @override
  ExpenseType getType() => type;
}

class ExpenseInstallments {
  int currentInstallment;
  int? totalInstallments;

  String get summary {
    if (totalInstallments == null) {
      return "$currentInstallment";
    }
    return '$currentInstallment/$totalInstallments';
  }

  ExpenseInstallments(this.currentInstallment, this.totalInstallments);
}
