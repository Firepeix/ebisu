

import 'package:ebisu/expenditure/Domain/Expenditure.dart';

abstract class ExpenditureRepositoryInterface {
  static const CREDENTIALS_KEY = 'credentials-key';

  Future<void> insert(Expenditure expenditure);
  Future<bool> isSetup();
}