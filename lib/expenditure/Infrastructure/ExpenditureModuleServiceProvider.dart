import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureService.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureServiceInterface.dart';

import 'Repositories/ExpenditureRepository.dart';

class ExpenditureModuleServiceProvider {
  static ExpenditureRepositoryInterface expenditureRepository () => ExpenditureRepository();
  static ExpenditureServiceInterface expenditureService () => ExpenditureService();
}