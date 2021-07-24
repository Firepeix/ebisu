import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/shared/Domain/ValueObjects.dart';

class Expenditure {
  final ExpenditureName name;
  final CardClass type;
  final ExpenditureAmount amount;
  final CardType? cardType;
  final ExpenditureType? expenditureType;
  final ExpenditureInstallments? installments;

  String? get cardTypeLabel {
    final label = cardType.toString().split('.').elementAt(1);
    return label[0] + label.substring(1).toLowerCase();
  }

  Expenditure({
    required this.name,
    required this.type,
    required this.amount,
    this.cardType,
    this.expenditureType,
    this.installments,
  });
}

enum ExpenditureType {
  UNICA,
  ASSINATURA,
  PARCELADA
}

class ExpenditureName extends StringValueObject {
  ExpenditureName(String value) : super(value);
}

class ExpenditureAmount extends IntValueObject {
  ExpenditureAmount(int value) : super(value);

  double toMoney () {
    return value / 100;
  }
}

class ExpenditureInstallments {
  int currentInstallment;
  int totalInstallments;

  String get summary => '$currentInstallment/$totalInstallments';

  ExpenditureInstallments({required this.currentInstallment, required this.totalInstallments});
}
