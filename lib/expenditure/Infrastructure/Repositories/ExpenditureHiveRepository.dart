import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/Repositories/ExpenditureRepository.dart';
import 'package:ebisu/src/UI/Expenditures/Form/ExpenditureForm.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ExpenditureRepositoryInterface)
class ExpenditureHiveRepository extends GoogleSheetExpenditureRepository implements ExpenditureRepositoryInterface
{
  static const EXPENDITURE_BOX = 'expenditures';

  Future<Box> _getBox() async {
    return await Hive.openBox<ExpenditureModel>(EXPENDITURE_BOX);
  }

  @override
  Future<List<Expenditure>> getExpenditures() async {
    final box = await _getBox();
    final expenditures = box.values;
    return [];
  }
}