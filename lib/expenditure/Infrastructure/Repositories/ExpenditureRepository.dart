import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';


class GoogleSheetExpenditureRepository extends GoogleSheetsRepository implements ExpenditureRepositoryInterface{

  /*Future<void> _setSheets (String credentials) async {

    // update cell at 'B2' by inserting string 'new'
    await sheet.values.insertValue('new', column: 2, row: 2);
    // prints 'new'
    print(await sheet.values.value(column: 2, row: 2));
    // get cell at 'B2' as Cell object
    final cell = await sheet.cells.cell(column: 2, row: 2);
    // prints 'new'
    print(cell.value);
    // update cell at 'B2' by inserting 'new2'
    await cell.post('new2');
    // prints 'new2'
    print(cell.value);
    // also prints 'new2'
    print(await sheet.values.value(column: 2, row: 2));

    // insert list in row #1
    final firstRow = ['index', 'letter', 'number', 'label'];
    await sheet.values.insertRow(1, firstRow);
    // prints [index, letter, number, label]
    print(await sheet.values.row(1));

    // insert list in column 'A', starting from row #2
    final firstColumn = ['0', '1', '2', '3', '4'];
    await sheet.values.insertColumn(1, firstColumn, fromRow: 2);
    // prints [0, 1, 2, 3, 4, 5]
    print(await sheet.values.column(1, fromRow: 2));

    // insert list into column named 'letter'
    final secondColumn = ['a', 'b', 'c', 'd', 'e'];
    await sheet.values.insertColumnByKey('letter', secondColumn);
    // prints [a, b, c, d, e, f]
    print(await sheet.values.columnByKey('letter'));

    // insert map values into column 'C' mapping their keys to column 'A'
    // order of map entries does not matter
    final thirdColumn = {
    '0': '1',
    '1': '2',
    '2': '3',
    '3': '4',
    '4': '5',
    };
    await sheet.values.map.insertColumn(3, thirdColumn, mapTo: 1);
    // prints {index: number, 0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6}
    print(await sheet.values.map.column(3));

    // insert map values into column named 'label' mapping their keys to column
    // named 'letter'
    // order of map entries does not matter
    final fourthColumn = {
    'a': 'a1',
    'b': 'b2',
    'c': 'c3',
    'd': 'd4',
    'e': 'e5',
    };
    await sheet.values.map.insertColumnByKey(
    'label',
    fourthColumn,
    mapTo: 'letter',
    );
    // prints {a: a1, b: b2, c: c3, d: d4, e: e5, f: f6}
    print(await sheet.values.map.columnByKey('label', mapTo: 'letter'));

    // appends map values as new row at the end mapping their keys to row #1
    // order of map entries does not matter
    final secondRow = {
    'index': '5',
    'letter': 'f',
    'number': '6',
    'label': 'f6',
    };
    await sheet.values.map.appendRow(secondRow);
    // prints {index: 5, letter: f, number: 6, label: f6}
    print(await sheet.values.map.lastRow());

    // get first row as List of Cell objects
    final cellsRow = await sheet.cells.row(1);
    // update each cell's value by adding char '_' at the beginning
    cellsRow.forEach((cell) => cell.value = '_${cell.value}');
    // actually updating sheets cells
    await sheet.cells.insert(cellsRow);
    // prints [_index, _letter, _number, _label]
    print(await sheet.values.row(1));
  }*/

  @override
  Future<void> insert(Expenditure expenditure) async {
    if (expenditure.type.index == CardClass.DEBIT.index) {
      await _insertDebitExpenditure(expenditure);
      return Future.value();
    }
    await _insertCreditExpenditure(expenditure);
    return Future.value();
  }

  Future<void> _insertDebitExpenditure(Expenditure expenditure) async {
    final sheet = await getSheet(debitSheetName);
    await sheet.values.appendRow([expenditure.name.value, expenditure.amount.toMoney()], fromColumn: DebitColumns.TO_PAY_LABEL.index);
    return Future.value();
  }

  Future<void> _insertCreditExpenditure(Expenditure expenditure) async {
    final expenditureMap = {
      ExpenditureType.UNICA: _insertSinglePurchaseCreditExpenditure,
      ExpenditureType.PARCELADA: _insertInstallmentPurchaseCreditExpenditure,
      ExpenditureType.ASSINATURA: _insertSubscriptionPurchaseCreditExpenditure,
    }[expenditure.expenditureType];

    await expenditureMap!(expenditure);

    return Future.value();
  }

  Future<void> _insertSinglePurchaseCreditExpenditure(Expenditure expenditure) async {
    final sheet = await getSheet(creditSheetName);
    final row = [
      expenditure.name.value,
      expenditure.amount.toMoney(),
      0,
      expenditure.amount.toMoney() * -1,
      expenditure.cardType!.value
    ];
    await sheet.values.appendRow(row, fromColumn: CreditColumns.SINGLE_PURCHASE_LABEL.index);
    return Future.value();
  }

  Future<void> _insertInstallmentPurchaseCreditExpenditure(Expenditure expenditure) async {
    final sheet = await getSheet(creditSheetName);
    final row = [
      expenditure.name.value,
      expenditure.amount.toMoney(),
      0,
      expenditure.amount.toMoney() * -1,
      expenditure.cardType!.value,
      expenditure.installments!.summary
    ];
    await sheet.values.appendRow(row, fromColumn: CreditColumns.INSTALLMENT_PURCHASE_LABEL.index);
    return Future.value();
  }

  Future<void> _insertSubscriptionPurchaseCreditExpenditure(Expenditure expenditure) async {
    final sheet = await getSheet(creditSheetName);
    final row = [
      expenditure.name.value,
      expenditure.amount.toMoney(),
      expenditure.cardType!.value
    ];
    await sheet.values.appendRow(row, fromColumn: CreditColumns.SUBSCRIPTION_PURCHASE_LABEL.index);
    return Future.value();
  }
}

enum DebitColumns {
  EMPTY,
  PAYED_LABEL,
  PAYED_AMOUNT,
  TO_PAY_LABEL,
  TO_PAY_AMOUNT
}

enum CreditColumns {
  EMPTY,
  CARD_SUMMARY_LABEL,
  CARD_SUMMARY_SPENT,
  CARD_SUMMARY_BUDGET,
  CARD_SUMMARY_DIFFERENCE,
  SINGLE_PURCHASE_LABEL,
  SINGLE_PURCHASE_AMOUNT,
  SINGLE_PURCHASE_BUDGET,
  SINGLE_PURCHASE_DIFFERENCE,
  SINGLE_PURCHASE_TYPE,
  INSTALLMENT_PURCHASE_LABEL,
  INSTALLMENT_PURCHASE_AMOUNT,
  INSTALLMENT_PURCHASE_BUDGET,
  INSTALLMENT_PURCHASE_DIFFERENCE,
  INSTALLMENT_PURCHASE_TYPE,
  INSTALLMENT_PURCHASE_TOTAL_INSTALLMENT,
  SUBSCRIPTION_PURCHASE_LABEL,
  SUBSCRIPTION_PURCHASE_AMOUNT,
  SUBSCRIPTION_PURCHASE_TYPE,
}