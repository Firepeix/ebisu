import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/shared/exceptions/result.dart';

abstract class TravelGateway {
  Future<AnyResult<void>> insert(TravelDay travelDay);
  Future<AnyResult<List<TravelDay>>> getDays();
  Future<void> removeDay(TravelDay day);
  Future<void> saveSheet(TravelDay day);

  Future<void> insertExpense(TravelExpense expense);
  Future<List<TravelExpense>> getExpenses(TravelDay day);
  Future<void> removeExpense(TravelExpense expense);
}