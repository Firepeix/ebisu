import '../Expenditure.dart';

abstract class ExpenditureServiceInterface {
  Expenditure createExpenditure(ExpenditureBuilder builder);
}

abstract class ExpenditureBuilder {
  String get name;
  int  get type;
  int  get amount;
  String? get cardType;
  int? get expenditureType;
  int? get currentInstallment;
  int? get installmentTotal;
}