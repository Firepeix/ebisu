import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/expenditure/domain/Expenditure.dart';
import 'package:ebisu/expenditure/domain/ExpenditureSummary.dart';
import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:flutter/cupertino.dart';
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

  @protected
  Future<List<Expenditure>> queryExpenditures() async {
    final expenditures = await _getDebitExpenditures();
    expenditures.addAll(await _getCreditExpenditures());
    return expenditures;
  }

  @protected
  Future<List<ExpenditureSummary>> queryCreditExpenditureSummaries() async {
    final sheet = await getSheet(CardClass.CREDIT);
    final cells = await sheet.values.allRows(fromRow: 3, fromColumn: 1, length: 4);
    return cells.map((values) => ExpenditureSummary(
            values[0].toString(),
            ExpenditureSummaryBudget(IntValueObject.integer(values[2])),
            ExpenditureSummarySpent(IntValueObject.integer(values[1])))
    ).toList();
  }

  @protected
  Future<DebitExpenditureSummary> queryDebitExpenditureSummary() async {
    final sheet = await getSheet(CardClass.DEBIT);
    final cells = await sheet.values.allRows(fromRow: 2, fromColumn: DebitColumns.SUMMARY_LABEL.index, length: 2);
    return DebitExpenditureSummary(
        ExpenditureIncome(IntValueObject.integer(cells[0][1])),
        ExpenditureAmountToPay(IntValueObject.integer(cells[1][1])),
        ExpenditureAmountPayed(IntValueObject.integer(cells[2][1]))
    );
  }

  Future<List<Expenditure>> _getDebitExpenditures() async {
    final sheet = await getSheet(CardClass.DEBIT);
    final values = await sheet.values.allRows(fromRow: 2, fromColumn: DebitColumns.PAYED_LABEL.index, length: 4);
    final List<Expenditure> payedExpenditures = [];
    final List<Expenditure> toPayExpenditures = [];
    values.where((element) => element.isNotEmpty).forEach((List<String> cell) {
      if (cell[DebitColumns.PAYED_LABEL.index] != '') {
        payedExpenditures.add(Expenditure(
            name: ExpenditureName(cell[DebitColumns.PAYED_LABEL.index - 1]),
            type: CardClass.DEBIT,
            amount: ExpenditureAmount(IntValueObject.integer(cell[DebitColumns.PAYED_AMOUNT.index - 1]))
        ));
      }

      if (cell.length == DebitColumns.TO_PAY_AMOUNT.index) {
        payedExpenditures.add(Expenditure(
            name: ExpenditureName(cell[DebitColumns.TO_PAY_LABEL.index - 1]),
            type: CardClass.DEBIT,
            amount: ExpenditureAmount(IntValueObject.integer(cell[DebitColumns.TO_PAY_AMOUNT.index - 1]))
        ));
      }
    });

    return [...toPayExpenditures, ...payedExpenditures];
  }

  Future<List<Expenditure>> _getCreditExpenditures() async {
    return _getCreditExpendituresCells();
  }

  Future<List<Expenditure>> _getCreditExpendituresCells() async {
    final sheet = await getSheet(CardClass.CREDIT);
    final cells = await sheet.cells.allRows(fromRow: 3, fromColumn: 1, length: 18);
    final List<Expenditure> expenditures = [];

    cells.forEach((List<Cell> rows) {
      if (rows.length >= CreditColumns.SINGLE_PURCHASE_TYPE.index) {
        final expenditureCell = rows.sublist(CreditColumns.SINGLE_PURCHASE_LABEL.index - 1, CreditColumns.SINGLE_PURCHASE_TYPE.index);
        if (expenditureCell[1].value != "") {
          expenditures.add(_fromListCell(expenditureCell, 4, ExpenditureType.UNICA));
        }
      }
      if (rows.length >= CreditColumns.INSTALLMENT_PURCHASE_TOTAL_INSTALLMENT.index) {
        final expenditureCell = rows.sublist(CreditColumns.INSTALLMENT_PURCHASE_LABEL.index - 1, CreditColumns.INSTALLMENT_PURCHASE_TOTAL_INSTALLMENT.index);
        if (expenditureCell[1].value != "") {
          expenditures.add(_fromListCell(expenditureCell, 4, ExpenditureType.PARCELADA));
        }
      }
      if (rows.length >= CreditColumns.SUBSCRIPTION_PURCHASE_TYPE.index) {
        final expenditureCell = rows.sublist(CreditColumns.SUBSCRIPTION_PURCHASE_LABEL.index - 1, CreditColumns.SUBSCRIPTION_PURCHASE_TYPE.index);
        if (expenditureCell[1].value != "") {
          expenditures.add(_fromListCell(expenditureCell, 2, ExpenditureType.ASSINATURA));
        }
      }
    });

    return expenditures;
  }

  Expenditure _fromListCell(List<Cell> cells, int typeCol, ExpenditureType type) {
    final amount = (double.parse(cells[1].value) * 100).toInt();
    ExpenditureInstallments? installments;
    if (type == ExpenditureType.PARCELADA) {
      final difference = cells[5].value.split('/');
      installments = ExpenditureInstallments(currentInstallment: int.parse(difference[0]), totalInstallments: int.parse(difference[1]));
    }
    return Expenditure(
        name: ExpenditureName(cells[0].value),
        type: CardClass.CREDIT,
        amount: ExpenditureAmount(amount),
        cardType: CardType(cells[typeCol].value),
        expenditureType: type,
        installments: installments
    );
  }
}

enum DebitColumns {
  EMPTY,
  PAYED_LABEL,
  PAYED_AMOUNT,
  TO_PAY_LABEL,
  TO_PAY_AMOUNT,
  TBD,
  TBD1,
  TBD2,
  TBD3,
  TBD4,
  TBD5,
  SUMMARY_LABEL,
  SUMMARY_AMOUNT,
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