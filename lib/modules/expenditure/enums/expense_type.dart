import 'package:ebisu/shared/utils/matcher.dart';

enum ExpenseType {
  CREDIT,
  DEBIT,
  UNKNOWN
}

extension ExpenseTypeImpl on ExpenseType {
  ExpenseType from(String value) {
    return Matcher.matchWhen(value, {
      "CREDIT": ExpenseType.CREDIT,
      "DEBIT": ExpenseType.DEBIT,
    }, base: ExpenseType.UNKNOWN);
  }
}