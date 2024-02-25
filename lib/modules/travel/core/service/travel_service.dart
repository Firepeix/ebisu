import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/modules/travel/core/gateway/travel_gateway.dart';
import 'package:ebisu/modules/travel/core/usecase/create_travel_usecase.dart';
import 'package:ebisu/modules/travel/core/usecase/get_travel_usecase.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';

abstract class TravelExpenseServiceInterface {
  Future<AnyResult<void>> createTravelExpenseDay(DateTime date, Money budget);
  Future<AnyResult<List<TravelDay>>> getDays();
  Future<void> removeDay(TravelDay day);
  Future<void> saveSheet(TravelDay day);

  Future<void> createTravelExpense(TravelDay day, String description, Money amount);
  Future<List<TravelExpense>> getExpenses(TravelDay day);
  Future<void> removeExpense(TravelExpense expense);

}

@Injectable(as: TravelExpenseServiceInterface)
class TravelExpenseService implements TravelExpenseServiceInterface {
  final TravelGateway _gateway;
  final GetTravelUseCase _getTravelUseCase;
  final CreateTravelUseCase _createTravelUseCase;
  final ExceptionHandlerServiceInterface _exceptionHandler;

  TravelExpenseService(this._gateway, this._exceptionHandler, this._getTravelUseCase, this._createTravelUseCase);

  @override
  Future<AnyResult<void>> createTravelExpenseDay(DateTime date, Money budget) async {
    return await _createTravelUseCase.createDay(date, budget);
  }

  @override
  Future<AnyResult<List<TravelDay>>> getDays() async {
    return await _getTravelUseCase.getDays();
  }

  @override
  Future<void> createTravelExpense(TravelDay day, String description, Money amount) async {
    return _gateway.insertExpense(TravelExpense(description: description, amount: amount, travelDayId: day.id));
  }

  @override
  Future<List<TravelExpense>> getExpenses(TravelDay day) async {
    return await _gateway.getExpenses(day);
  }

  @override
  Future<void> removeDay(TravelDay day) async {
    return await _gateway.removeDay(day);
  }

  @override
  Future<void> removeExpense(TravelExpense expense) async {
    return await _gateway.removeExpense(expense);
  }

  @override
  Future<void> saveSheet(TravelDay day)  async {
    await _exceptionHandler.wrapAsync(() async => await _gateway.saveSheet(day));
  }
}