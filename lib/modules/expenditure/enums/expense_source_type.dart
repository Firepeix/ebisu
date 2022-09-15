import 'package:ebisu/shared/utils/matcher.dart';

enum ExpenseSourceType {
  USER("Amigo"),
  ESTABLISHMENT("Estabelecimento"),
  UNKNOWN("Desconhecido");

  final String title;

  const ExpenseSourceType(this.title);
}

extension ExpenseSourceTypeImpl on ExpenseSourceType {
  ExpenseSourceType from(String value) {
    return Matcher.matchWhen(value, {
      "USER": ExpenseSourceType.USER,
      "ESTABLISHMENT": ExpenseSourceType.ESTABLISHMENT,
    }, base: ExpenseSourceType.UNKNOWN);
  }
}