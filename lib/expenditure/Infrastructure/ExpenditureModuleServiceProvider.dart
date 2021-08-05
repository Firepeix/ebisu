import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureService.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureServiceInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/Persistence/ExpenditureModel.dart';
import 'package:ebisu/expenditure/Infrastructure/Repositories/ExpenditureHiveRepository.dart';
import 'package:hive/hive.dart';

class ExpenditureModuleServiceProvider {
  static ExpenditureRepositoryInterface expenditureRepository () => ExpenditureHiveRepository();
  static ExpenditureServiceInterface expenditureService () => ExpenditureService();

  ExpenditureModuleServiceProvider() {
    _registerModels();
  }

  _registerModels () {
    Hive.registerAdapter(ExpenditureHiveModelAdapter());
  }
}