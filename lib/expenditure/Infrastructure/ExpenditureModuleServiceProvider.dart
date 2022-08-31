import 'package:ebisu/expenditure/Infrastructure/Persistence/ExpenditureModel.dart';
import 'package:ebisu/expenditure/Infrastructure/Repositories/ExpenditureHiveRepository.dart';
import 'package:ebisu/expenditure/domain/repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/domain/services/ExpenditureService.dart';
import 'package:ebisu/shared/Infrastructure/Providers/ServiceProvider.dart';
import 'package:hive/hive.dart';

class ExpenditureModuleServiceProvider implements ModelServiceProviderInterface {
  static ExpenditureRepositoryInterface expenditureRepository () => ExpenditureHiveRepository();
  static ExpenditureServiceInterface expenditureService () => ExpenditureService();

  void registerModels () {
    Hive.registerAdapter(ExpenditureHiveModelAdapter());
  }
}