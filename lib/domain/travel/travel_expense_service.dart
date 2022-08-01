import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/domain/travel/travel_expense_repository.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:injectable/injectable.dart';

abstract class TravelExpenseServiceInterface {
  Future<void> createTravelExpenseDay(DateTime date, Money budget);
  Future<List<TravelDay>> getDays();
  Future<void> removeDay(TravelDay day);
  Future<void> saveSheet(TravelDay day);

  Future<void> createTravelExpense(TravelDay day, String description, Money amount);
  Future<List<TravelExpense>> getExpenses(TravelDay day);
  Future<void> removeExpense(TravelExpense expense);

}

@Injectable(as: TravelExpenseServiceInterface)
class TravelExpenseService implements TravelExpenseServiceInterface {
  final TravelExpenseRepositoryInterface _repository;
  final ExceptionHandlerServiceInterface _exceptionHandler;

  TravelExpenseService(this._repository, this._exceptionHandler);

  @override
  Future<void> createTravelExpenseDay(DateTime date, Money budget) async {
    await _repository.insert(TravelDay(date, budget));
  }

  @override
  Future<List<TravelDay>> getDays() async {
    return await _repository.getDays();
  }

  @override
  Future<void> createTravelExpense(TravelDay day, String description, Money amount) async {
    return _repository.insertExpense(TravelExpense(description, amount, day.id));
  }

  @override
  Future<List<TravelExpense>> getExpenses(TravelDay day) async {
    return await _repository.getExpenses(day);
  }

  @override
  Future<void> removeDay(TravelDay day) async {
    return await _repository.removeDay(day);
  }

  @override
  Future<void> removeExpense(TravelExpense expense) async {
    return await _repository.removeExpense(expense);
  }

  @override
  Future<void> saveSheet(TravelDay day)  async {
    await _exceptionHandler.wrapAsync(() async => await _repository.saveSheet(day));
  }
}