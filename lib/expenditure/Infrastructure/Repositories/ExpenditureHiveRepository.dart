import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/ExpenditureSummary.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/Persistence/ExpenditureModel.dart';
import 'package:ebisu/expenditure/Infrastructure/Repositories/ExpenditureRepository.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ExpenditureRepositoryInterface)
class ExpenditureHiveRepository extends GoogleSheetExpenditureRepository implements ExpenditureRepositoryInterface
{
  static const EXPENDITURE_BOX = 'expenditures';
  static const SUMMARY_BOX = 'summary';

  Future<Box> _getBox() async {
    return await Hive.openBox<ExpenditureHiveModel>(EXPENDITURE_BOX);
  }

  Future<Box> _getSummaryBox() async {
    return await Hive.openBox(SUMMARY_BOX);
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


  @override
  Future<List<ExpenditureSummary>> getCreditExpenditureSummaries (bool cacheLess) async {
    List<ExpenditureSummary> summaries = [];
    if (false) {
      summaries = await super.getCurrentCreditExpenditureSummaries();
      await _saveSummaryHive(summaries);
      return summaries;
    }
    summaries = await _getCreditExpenditureSummariesFromBox();
    return summaries;
  }

  Future<void> _saveSummaryHive(List<ExpenditureSummary> summaries) async {
    final box = await _getSummaryBox();
    await box.clear();
    summaries.forEach((summary) async => await box.add([summary.title, summary.spentAmount, summary.budgetAmount]));
  }

  Future<List<ExpenditureSummary>> _getCreditExpenditureSummariesFromBox() async {
    final box = await _getSummaryBox();
    final List<ExpenditureSummary> summaries = [];
    box.values.cast<List<Object?>>().forEach((summary) => summaries.add(toExpenditureSummary(values: summary, amountTransform: (value) => value)));
    return summaries;
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