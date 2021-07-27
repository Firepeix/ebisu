

import 'package:ebisu/expenditure/Domain/Expenditure.dart';

abstract class ExpenditureRepositoryInterface {
  Future<void> insert(Expenditure expenditure);
}