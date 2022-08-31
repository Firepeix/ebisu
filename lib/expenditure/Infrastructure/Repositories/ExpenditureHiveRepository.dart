import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/expenditure/Infrastructure/Persistence/ExpenditureModel.dart';
import 'package:ebisu/expenditure/Infrastructure/Repositories/ExpenditureRepository.dart';
import 'package:ebisu/expenditure/domain/Expenditure.dart';
import 'package:ebisu/expenditure/domain/ExpenditureSummary.dart';
import 'package:ebisu/expenditure/domain/repositories/ExpenditureRepositoryInterface.dart';
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

  Future<Box> _getSummaryBox(String type) async {
    return await Hive.openBox(SUMMARY_BOX + '-$type');
  }

  @override
  Future<List<Expenditure>> getExpenditures(bool cacheLess) async {
    if (!cacheLess) {
      return await _getExpendituresFromBox();
    }
    return await queryExpenditures();
  }

  Future<List<Expenditure>> queryExpenditures() async {
    final expenditures = await super.queryExpenditures();
    await _saveExpendituresHive(expenditures);
    return expenditures.reversed.toList();
  }

  Future<List<Expenditure>> _getExpendituresFromBox() async {
    final box = await _getBox();
    if (box.isNotEmpty) {
      final List<Expenditure> expenditures = [];
      box.values.forEach((expenditure) => expenditures.add(Expenditure(
        name: ExpenditureName(expenditure.name),
        type: CardClass.values[expenditure.type],
        amount: ExpenditureAmount(expenditure.amount),
        cardType: expenditure.cardType != null ? CardType(expenditure.cardType!) : null,
        expenditureType: expenditure.expenditureType != null ? ExpenditureType.values[expenditure.expenditureType!] : null,
        installments: expenditure.currentInstallment != null ? ExpenditureInstallments(currentInstallment: expenditure.currentInstallment!, totalInstallments: expenditure.totalInstallment!) : null,
      )));
      return expenditures.reversed.toList();
    }

    return await queryExpenditures();
  }

  Future<void> _saveExpendituresHive(List<Expenditure> expenditures) async {
    final box = await _getBox();
    await box.clear();
    expenditures.forEach((Expenditure expenditure) async => await box.add(
        ExpenditureHiveModel(
          name: expenditure.name.value,
          type: expenditure.type.index,
          amount: expenditure.amount.value,
          cardType: expenditure.cardType != null ? expenditure.cardType!.value : null,
          expenditureType: expenditure.expenditureType != null ? expenditure.expenditureType!.index : null,
          currentInstallment: expenditure.installments != null ? expenditure.installments!.currentInstallment : null,
          totalInstallment: expenditure.installments != null ? expenditure.installments!.totalInstallments : null,
        )
    ));
  }


  @override
  Future<List<ExpenditureSummary>> getCreditExpenditureSummaries (bool cacheLess) async {
    if (!cacheLess) {
      return await _getCreditExpenditureSummariesFromBox();
    }
    return await queryCreditExpenditureSummaries();
  }

  Future<List<ExpenditureSummary>> queryCreditExpenditureSummaries() async {
    final summaries = await super.queryCreditExpenditureSummaries();
    await _saveSummaryHive(summaries);
    return summaries;
  }

  Future<void> _saveSummaryHive(List<ExpenditureSummary> summaries) async {
    final box = await _getSummaryBox('CREDIT');
    await box.clear();
    summaries.forEach((summary) async => await box.add([summary.title, summary.spentAmount, summary.budgetAmount]));
  }

  Future<List<ExpenditureSummary>> _getCreditExpenditureSummariesFromBox() async {
    final box = await _getSummaryBox('CREDIT');
    if (box.isNotEmpty) {
      final List<ExpenditureSummary> summaries = [];
      box.values.cast<List<Object?>>().forEach((summary) => summaries.add(
          ExpenditureSummary(
              summary[0].toString(),
              ExpenditureSummaryBudget(int.parse(summary[2].toString())),
              ExpenditureSummarySpent(int.parse(summary[1].toString()))
      )));
      return summaries;
    }

    return await queryCreditExpenditureSummaries();
  }

  @override
  Future<DebitExpenditureSummary> getDebitExpenditureSummary (bool cacheLess) async {
    if (!cacheLess) {
      return await _getDebitExpenditureSummaryFromBox();
    }
    return await queryDebitExpenditureSummary();
  }

  Future<DebitExpenditureSummary> queryDebitExpenditureSummary () async {
    final summary = await super.queryDebitExpenditureSummary();
    await _saveDebitSummaryHive(summary);
    return summary;
  }

  Future<void> _saveDebitSummaryHive(DebitExpenditureSummary summary) async {
    final box = await _getSummaryBox('DEBIT');
    await box.clear();
    await box.put('summary', {
      'income': summary.income.value,
      'toPay': summary.toPay.value,
      'payed': summary.payed.value
    });
  }

  Future<DebitExpenditureSummary> _getDebitExpenditureSummaryFromBox() async {
    final box = await _getSummaryBox('DEBIT');
    final summaryModel = box.get('summary');
    if (summaryModel != null) {
      return DebitExpenditureSummary(
          ExpenditureIncome(summaryModel['income']),
          ExpenditureAmountToPay(summaryModel['toPay']),
          ExpenditureAmountPayed(summaryModel['payed'])
      );
    }

    return await queryDebitExpenditureSummary();
  }
}