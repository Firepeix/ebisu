import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/Persistence/ExpenditureModel.dart';
import 'package:ebisu/expenditure/Infrastructure/Repositories/ExpenditureRepository.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ExpenditureRepositoryInterface)
class ExpenditureHiveRepository extends GoogleSheetExpenditureRepository implements ExpenditureRepositoryInterface
{
  static const EXPENDITURE_BOX = 'expenditures';

  Future<Box> _getBox() async {
    return await Hive.openBox<ExpenditureHiveModel>(EXPENDITURE_BOX);
  }

  @override
  Future<List<Expenditure>> getExpenditures(bool cacheLess) async {
    List<Expenditure> expenditures = [];
    if (cacheLess) {
      expenditures = await super.getCurrentExpenditures();
      await _saveExpendituresHive(expenditures);
      return expenditures;
    }
    final box = await _getBox();
    return [];
    //final expenditures = box.values;
  }

  Future<void> _saveExpendituresHive(List<Expenditure> expenditures) async {
    final box = await _getBox();
    await box.clear();
    expenditures.forEach((Expenditure expenditure) async => await box.add(_fromExpenditureToModel(expenditure)));
  }

  ExpenditureHiveModel _fromExpenditureToModel (Expenditure expenditure) {
    return ExpenditureHiveModel(
        name: expenditure.name.value,
        type: expenditure.type.index,
        amount: expenditure.amount.value
    );
  }
}