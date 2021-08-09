import 'package:ebisu/card/Domain/Card.dart';
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
      return expenditures.reversed.toList();
    }
    expenditures = await _getExpendituresFromBox();
    return expenditures.reversed.toList();
  }

  Future<List<Expenditure>> _getExpendituresFromBox() async {
    final box = await _getBox();
    final List<Expenditure> expenditures = [];
    box.values.forEach((expenditure) => expenditures.add(_fromModelToExpenditure(expenditure)));
    return expenditures;
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
        amount: expenditure.amount.value,
        cardType: expenditure.cardType != null ? expenditure.cardType!.value : null,
        expenditureType: expenditure.expenditureType != null ? expenditure.expenditureType!.index : null,
        currentInstallment: expenditure.installments != null ? expenditure.installments!.currentInstallment : null,
        totalInstallment: expenditure.installments != null ? expenditure.installments!.totalInstallments : null,
    );
  }

  Expenditure _fromModelToExpenditure (ExpenditureHiveModel expenditure) {
    return Expenditure(
        name: ExpenditureName(expenditure.name),
        type: CardClass.values[expenditure.type],
        amount: ExpenditureAmount(expenditure.amount),
        cardType: expenditure.cardType != null ? CardType(expenditure.cardType!) : null,
        expenditureType: expenditure.expenditureType != null ? ExpenditureType.values[expenditure.expenditureType!] : null,
        installments: expenditure.currentInstallment != null ? ExpenditureInstallments(currentInstallment: expenditure.currentInstallment!, totalInstallments: expenditure.totalInstallment!) : null,
    );
  }
}