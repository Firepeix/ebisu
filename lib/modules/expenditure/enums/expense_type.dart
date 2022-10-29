import 'package:ebisu/shared/utils/matcher.dart';

enum ExpenseType {
  CREDIT("Credito"),
  DEBIT("Debito"),
  UNKNOWN("Desconhecido");

  final String label;

  const ExpenseType(this.label);

  bool isDebit() {
    return this != ExpenseType.CREDIT;
  }

  ExpenseType from(String value) {
    return Matcher.matchWhen(value, {
      "CREDIT": ExpenseType.CREDIT,
      "DEBIT": ExpenseType.DEBIT,
    }, base: ExpenseType.UNKNOWN);
  }
}