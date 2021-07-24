

import 'package:ebisu/expenditure/Domain/Expenditure.dart';

abstract class ExpenditureRepositoryInterface {
  Map<int, String> getExpenditureTypes();
  Future<void> insert(Expenditure expenditure);
  bool isSetup();
}