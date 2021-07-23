import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';

import 'Repositories/ExpenditureRepository.dart';

class ExpenditureModuleServiceProvider {
  static ExpenditureRepositoryInterface expenditureRepository () => ExpenditureRepository();
}