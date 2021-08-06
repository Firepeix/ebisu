import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:gsheets/gsheets.dart';


class GoogleSheetExpenditureRepository extends GoogleSheetsRepository {

  Future<void> insert(Expenditure expenditure) async {
    if (expenditure.type.index == CardClass.DEBIT.index) {
      await _insertDebitExpenditure(expenditure);
      return Future.value();
    }
    await _insertCreditExpenditure(expenditure);
    return Future.value();
  }

  Future<void> _insertDebitExpenditure(Expenditure expenditure) async {
    final sheet = await getSheet(CardClass.DEBIT);
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
    final sheet = await getSheet(CardClass.CREDIT);
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
    final sheet = await getSheet(CardClass.CREDIT);
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
    final sheet = await getSheet(CardClass.CREDIT);
    final row = [
      expenditure.name.value,
      expenditure.amount.toMoney(),
      expenditure.cardType!.value
    ];
    await sheet.values.appendRow(row, fromColumn: CreditColumns.SUBSCRIPTION_PURCHASE_LABEL.index);
    return Future.value();
  }

  Future<List<Expenditure>> getCurrentExpenditures() async {
    final expenditures = await _getDebitExpenditures();
    expenditures.addAll(await _getCreditExpenditures());
    return expenditures;
  }

  Future<List<Expenditure>> _getDebitExpenditures() async {
    final sheet = await getSheet(CardClass.DEBIT);
    final cells = await sheet.cells.allRows(fromRow: 2, fromColumn: DebitColumns.TO_PAY_LABEL.index, length: 2);
    return cells.toList().map((List<Cell> cell) {
      final label = cell[0];
      final amount = (double.parse(cell[1].value) * 100).toInt();
      return Expenditure(name: ExpenditureName(label.value), type: CardClass.DEBIT, amount: ExpenditureAmount(amount));
    }).toList();
  }

  Future<List<Expenditure>> _getCreditExpenditures() async {
    return [];
    /*final expenditures = [];
    final types = [CardClass.DEBIT, CardClass.CREDIT];
    final sheet = await getSheet(CardClass.CREDIT);
    final cells = await sheet.cells.allRows(fromRow: 3, fromColumn: 1, length: CARD_COLUMNS.LABEL.index);
    return cells.toList().map((cell) => cell[0].value).toList();
    return [];*/
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