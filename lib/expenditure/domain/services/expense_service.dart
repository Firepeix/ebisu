import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/expenditure/models/expense/expenditure_model.dart';

abstract class ExpenseServiceInterface {
  ExpenseModel createExpenditure(ExpenditureBuilder builder);
  Future<List<ExpenseModel>> getCurrentExpenses();
}

abstract class ExpenditureBuilder {
  String get name;
  int  get type;
  int  get amount;
  String? get cardType;
  int? get expenditureType;
  int? get currentInstallment;
  int? get installmentTotal;
}

class ExpenseService implements ExpenseServiceInterface {
  final ExceptionHandlerServiceInterface _exceptionHandler;
  ExpensePurchaseService(this._repository, this._exceptionHandler);

  @override
  ExpenseModel createExpenditure(ExpenditureBuilder builder) {
    return Expenditure(
      name: ExpenditureName(builder.name),
      amount: ExpenditureAmount(builder.amount),
      type: CardClass.values[builder.type],
      cardType: builder.cardType != null ? CardType(builder.cardType!) : null,
      expenditureType: builder.expenditureType != null ? ExpenditureType.values[builder.expenditureType!] : null,
      installments: builder.currentInstallment != null ? ExpenditureInstallments(currentInstallment: builder.currentInstallment!, totalInstallments: builder.installmentTotal!) : null,
    );
  }

  @override
  Future<List<ExpenseModel>> getCurrentExpenses() async {
    return await _exceptionHandler.wrapAsync(() async => await _repository.getPurchaseCreditSummary());
  }
}