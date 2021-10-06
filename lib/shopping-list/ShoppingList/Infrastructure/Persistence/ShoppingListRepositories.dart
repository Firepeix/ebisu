import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Repositories/PurchaseRepositoriesInterfaces.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/Repositories/ShoppingListRepositoriesInterfaces.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/shopping-list/ShoppingList/Infrastructure/Persistence/Models/ShoppingListModels.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ShoppingListColdStorageRepositoryInterface)
class GoogleSheetShoppingListRepository extends GoogleSheetsRepository implements ShoppingListColdStorageRepositoryInterface {
  Future<ShoppingList> getShoppingList(String sheetName) async {
    final _sheet = await sheet(sheetName);
    final amount = await _findShoppingListTotalAmount(_sheet);
    final list = ShoppingList(sheetName, amount);
    final rows = await _sheet.values.allRows(fromRow: 8);
    _populateWithPurchases(list, rows);
    list.purchases.commit();
    return Future.value(list);
  }

  Future<ShoppingListInputAmount> _findShoppingListTotalAmount(Worksheet sheet) async {
    final value = await sheet.values.value(column: 2, row: 1);
    return Future.value(ShoppingListInputAmount(IntValueObject.integer(value)));
  }

  void _populateWithPurchases(ShoppingList list, List<List<String>> lines) {
    lines.forEach((line) {
      if (line[ListColumns.NAME.index] != "") {
        final purchase = _buildPurchase(line);
        if (line.length >= 6 && line[ListColumns.AMOUNT_VALUE.index + 4] != "0" && line[ListColumns.AMOUNT_VALUE.index + 4] != "") {
            purchase.commit(_buildPurchase(line, offset: 4));
        }
        list.purchases.add(purchase);
      }
    });
  }

  Purchase _buildPurchase(List<String> line, { int offset: 0 }) {
    final value = IntValueObject.integer(line[ListColumns.AMOUNT_VALUE.index + offset]);
    final originalQuantity = line[ListColumns.AMOUNT.index + offset];
    final quantity = IntValueObject.normal(originalQuantity.replaceAll("g", ""));
    final type = originalQuantity.endsWith("g") ? AmountType.WEIGHT : AmountType.UNIT;
    final amount = Amount(value, quantity, type);
    final name = line[ListColumns.NAME.index + offset] != "" ? line[ListColumns.NAME.index + offset] : line[0];
    return Purchase(name, amount);
  }
}

enum ListColumns {
  NAME,
  AMOUNT,
  AMOUNT_VALUE,
  TOTAL_VALUE,
}

@Singleton(as: ShoppingListRepositoryInterface)
class ShoppingListHiveRepository implements ShoppingListRepositoryInterface
{
  final PurchaseRepositoryInterface _repository;

  ShoppingListHiveRepository(this._repository);

  static const SHOPPING_LIST_BOX = 'shopping-lists';

  Future<Box> _getBox() async {
    return await Hive.openBox<ShoppingListHiveModel>(SHOPPING_LIST_BOX);
  }

/*  Future<List<Expenditure>> _getExpendituresFromBox() async {
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
  }*/

  Future<void> store(ShoppingList list) async {
    final box = await _getBox();
    final purchases = _repository.bulkStore(list.purchases);
    await box.add(
        ShoppingListHiveModel(list.name, list.input.value, HiveList(box))
    );
  }
}
/*

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
}*/