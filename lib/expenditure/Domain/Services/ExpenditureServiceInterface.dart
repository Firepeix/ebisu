import '../Expenditure.dart';

abstract class ExpenditureServiceInterface {
  Expenditure createExpenditure(ExpenditureBuilder builder);
}

abstract class ExpenditureBuilder {
  String get name;
  int  get type;
  int  get amount;
  int? get cardType;
  int? get expenditureType;
  int? get currentInstallment;
  int? get installmentTotal;
}